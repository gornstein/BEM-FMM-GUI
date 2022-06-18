function processEField(app)

clc
tic
constants.eps0        = 8.85418782e-012;  %   Dielectric permittivity of vacuum(~air)
constants.mu0         = 1.25663706e-006;  %   Magnetic permeability of vacuum(~air)

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

% Load and position the coil
coil = bemfmm_loadCoil('someCoil.mat');

% Position and orient coil
transMatrix = [app.MatrixField11, app.MatrixField12, app.MatrixField13, app.MatrixField14;
    app.MatrixField21, app.MatrixField22, app.MatrixField23, app.MatrixField24;
    app.MatrixField31, app.MatrixField32, app.MatrixField33, app.MatrixField34;
    app.MatrixField41, app.MatrixField42, app.MatrixField43, app.MatrixField44];
coil = bemfmm_positionCoilT(app, transMatrix);

% % Replaced by above positioning functioning
% coilOrigin = [app.MatrixField14.Value app.MatrixField24.Value app.MatrixField34.Value] *1e-2;  % Origin in meters
% coilAxis = [0 0 -1]*1e-3;     % Dimensionless vector describing coil tilt
% coilTheta = 0;                  % Angle in radians describing coil rotation about axis
% coil = bemfmm_positionCoil(coil, coilOrigin, coilAxis, coilTheta);

% Assign coil stimulus
coilCurrent = app.CoilCurrentAmperesEditField.Value;
coilFreq    = 3000; % coil frequency in hz
coildIdt    = 2*pi*coilFreq*coilCurrent; % 9.4e7 A/s
coil = bemfmm_assignCoilStimulus(coil, coilCurrent, coildIdt);

% Another placeholder
solverOptions.prec      = 1e-3;     % FMM precision
solverOptions.weight    = 1/2;      % Empirically-derived constant
solverOptions.maxIter   = app.MaxiumumIterationsEditField.Value;       % Maximum permitted GMRES iterations
solverOptions.relRes    = app.MaximumResidualEditField.Value;    % GMRES stop criterion
solution = bemfmm_chargeEngineBase(model, coil, constants, solverOptions);

disp('DONE');
pause(1);
% Define observation surface 1: coil centerline
% parameters
orig_temp = coil.origin; % named orig_temp to not confuse bem3_line_field_e
dirline   = -coil.centerlineDirection;
distance  = 0.1;                 % Distance (m) that the line should reach from the origin
numPoints = 10000;               % Number of points in the line
obs1 = bemfmm_makeObsLine_2(orig_temp, dirline, distance, numPoints);

% Set up options for observation point field evaluation
obsOptions.prec = 1e-3;
obsOptions.relativeIntegrationRadius = 5;

% Precompute coil fields
tic
obs1 = bemfmm_computeObsIntegrals(obs1, model, obsOptions);
disp(['Observation line integrals computed in ' num2str(toc) ' s']);

% Compute precise field at coil centerline
tic
obs1 = bemfmm_computeObsField(obs1, coil, model, solution, constants, obsOptions);
disp(['Observation line fields computed in ' num2str(toc) 's']);

% Placeholder: This will be wrapped into a plot method for the obs line
figure;
EMagLine_sec = vecnorm(obs1.FieldESecondary, 2, 2);
plot(obs1.argline*1000, EMagLine_sec, '--b', 'LineWidth', 2);

disp(newline);
% pause;

% Define observation surface 2: Plane
% Parameters for plane
planeNormal  = [0 0 1];
planeCenter  = [31 0 55.5]*1e-3;
planeUp      = [0 1 0]; 
planeHeight  = 40*1e-3;
planeWidth   = 40*1e-3;
pointDensity = 300/planeWidth;

% Make plane, compute neighbor integrals, compute E-field
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

disp(['whole thing run in ' num2str(toc) ' s']);