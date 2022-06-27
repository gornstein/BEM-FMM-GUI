function processEField(app)

clc

constants.eps0        = 8.85418782e-012;  %   Dielectric permittivity of vacuum(~air)
constants.mu0         = 1.25663706e-006;  %   Magnetic permeability of vacuum(~air)

% Setting parallel pool params and creating parpool
numthreads = app.NumberOfThreadsForProcessingEditField.Value;
tempPool = gcp('nocreate'); %   See if a parallel pool already exists
if isempty(tempPool) || tempPool.NumWorkers ~= numthreads
    delete(gcp('nocreate'));
    parpool(numthreads);
end

% Assemble the model
model = bemfmm_assembleModel('tissue_index.txt');
model = bemfmm_computeModelIntegrals(model, 4);
model = bemfmm_assignDefaultModelConductivities(model, 0); % Kind of a placeholder

disp('Model Loaded and Assembled');

% Load and position the coil
coil = bemfmm_loadCoil_app('coil.mat','coilCAD.mat');

disp('Coil Loaded');
pause(0.4);

% Position and orient coil
transMatrix = [app.MatrixField11.Value, app.MatrixField12.Value, app.MatrixField13.Value, app.MatrixField14.Value;
    app.MatrixField21.Value, app.MatrixField22.Value, app.MatrixField23.Value, app.MatrixField24.Value;
    app.MatrixField31.Value, app.MatrixField32.Value, app.MatrixField33.Value, app.MatrixField34.Value;
    app.MatrixField41.Value, app.MatrixField42.Value, app.MatrixField43.Value, app.MatrixField44.Value];
coil = bemfmm_positionCoilT(coil, transMatrix);

disp('Coil Positioned');
pause(0.2);

% % Replaced by above positioning functioning
% coilOrigin = [app.MatrixField14.Value app.MatrixField24.Value app.MatrixField34.Value] *1e-2;  % Origin in meters
% coilAxis = [0 0 -1]*1e-3;     % Dimensionless vector describing coil tilt
% coilTheta = 0;                  % Angle in radians describing coil rotation about axis
% coil = bemfmm_positionCoil(coil, coilOrigin, coilAxis, coilTheta);

% Assign coil stimulus
coilCurrent = app.CoilCurrentEditField.Value;
% coilFreq    = 3000; % coil frequency in hz
coildIdt    = app.CoildIdtEditField.Value; % 2*pi*coilFreq*coilCurrent
coil = bemfmm_assignCoilStimulus(coil, coilCurrent, coildIdt);

disp('Coil Stimulus Assigned');
pause(0.2);

% Parameters for the solver
solverOptions.prec      = 1e-3;     % FMM precision
solverOptions.weight    = 1/2;      % Empirically-derived constant
solverOptions.maxIter   = app.MaximumIterationsEditField.Value;       % Maximum permitted GMRES iterations
solverOptions.relRes    = app.MinimumResidualEditField.Value;    % GMRES stop criterion
solution = bemfmm_chargeEngineBase(model, coil, constants, solverOptions);

disp('Finished running charge engine');
pause(0.4);

% Define observation surface 1: coil centerline
% parameters:
orig_temp = coil.origin; % named orig_temp to not confuse bem3_line_field_e
dirline   = -coil.centerlineDirection;
distance  = 0.1;                 % Distance (m) that the line should reach from the origin
numPoints = 10000;               % Number of points in the line
obs1 = bemfmm_makeObsLine_2(orig_temp, dirline, distance, numPoints);

disp('Finished making observation line');
pause(0.2);

% Set up options for observation point field evaluation
obsOptions.prec = 1e-3;
obsOptions.relativeIntegrationRadius = 5;

% Precompute coil fields
disp('Precomputing coil fields (observation line integrals)');
pause(0.2);
tic
obs1 = bemfmm_computeObsIntegrals(obs1, model, obsOptions);
disp(['Observation line integrals computed in ' num2str(toc) ' s']);

% Compute precise field at coil centerline
disp('Computing precise field at coil centerline');
pause(0.2);
tic
obs1 = bemfmm_computeObsField(obs1, coil, model, solution, constants, obsOptions);
disp(['Observation line fields computed in ' num2str(toc) 's']);

% % Placeholder: This will be wrapped into a plot method for the obs line
% figure;
% EMagLine_sec = vecnorm(obs1.FieldESecondary, 2, 2);
% plot(obs1.argline*1000, EMagLine_sec, '--b', 'LineWidth', 2);

disp(newline);

% Define observation surface 2: Plane
% Parameters for plane
% planeNormal  = [0 0 1];
% planeCenter  = [31 0 55.5]*1e-3;
% planeUp      = [0 1 0]; 
% planeHeight  = 40*1e-3;
% planeWidth   = 40*1e-3;
% pointDensity = 300/planeWidth;
[planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity] = observationSurfaceParamsApp(app);

% Make plane, compute neighbor integrals, compute E-field
disp('Making observation plane and computing integrals + fields');
pause(0.2);
obs2 = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity);
tic
obs2 = bemfmm_computeObsIntegrals(obs2, model, obsOptions);
disp(['Observation plane integrals evaluated in ' num2str(toc) ' seconds']);
tic
obs2 = bemfmm_computeObsField(obs2, coil, model, solution, constants, obsOptions);
disp(['Observation plane fields computed in ' num2str(toc) ' seconds']);

% Plot total E-field
temp = vecnorm(obs2.FieldESecondary+obs2.FieldEPrimary, 2, 2);
opts.ThresholdHigh = 120; opts.ThresholdLow = -10; opts.NumLevels = 40;
figure; hold on;
lims = bemplot_2D_planeField(obs2, temp, opts);
bemplot_2D_modelIntersections(model, obs2);
title('E-field (V/m), precomputed integrals');
axis 'equal';
xlim(lims.XLim);
ylim(lims.YLim);

pause;
end