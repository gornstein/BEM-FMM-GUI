clear all; close all; clc

bem0_initialize;

tic
numThreads = 20;            %   number of cores to be used
tempPool = gcp('nocreate'); %   See if a parallel pool already exists
if isempty(tempPool) || tempPool.NumWorkers ~= numThreads
    delete(gcp('nocreate'));
    parpool(numThreads);
end
disp(['Parallel pool started in ' num2str(toc) ' s']);

%% Assemble the model
model = bemfmm_assembleModel('tissue_index.txt');
model = bemfmm_computeModelIntegrals(model, 16);
model = bemfmm_assignDefaultModelConductivities(model, 0); % Kind of a placeholder

%% Load and position the coil
coil = bemfmm_loadCoil('someCoil.mat');

% Position and orient coil
coilOrigin = [42 0 79.5]*1e-3;  % Origin in meters
coilAxis = [0.45 0 1]*1e-3;     % Dimensionless vector describing coil tilt
coilTheta = 0;                  % Angle in radians describing coil rotation about axis
coil = bemfmm_positionCoil(coil, coilOrigin, coilAxis, coilTheta);

% Assign coil stimulus
coilCurrent = 5e3;                       % 5kA
coilFreq    = 3e3;                       % 3 kHz
coildIdt    = 2*pi*coilFreq*coilCurrent; % 9.4e7 A/s
coil = bemfmm_assignCoilStimulus(coil, coilCurrent, coildIdt);

%% Another placeholder
solverOptions.prec      = 1e-3;     % FMM precision
solverOptions.weight    = 1/2;      % Empirically-derived constant
solverOptions.maxIter   = 25;       % Maximum permitted GMRES iterations
solverOptions.relRes    = 1e-12;    % GMRES stop criterion
solution = bemfmm_chargeEngineBase(model, coil, constants, solverOptions);

disp('DONE');
pause(1);
%% Define observation surface 1: coil centerline
% parameters
orig_temp = coil.origin; % named orig_temp to not confuse bem3_line_field_e
dirline   = -coil.centerlineDirection;
distance  = 0.1;                 % Distance (m) that the line should reach from the origin
numPoints = 10000;               % Number of points in the line
obs1 = bemfmm_makeObsLine_2(orig_temp, dirline, 0.1, 10000);

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
pause;

%% Define observation surface 2: Plane
% Parameters for plane
planeNormal  = [1 0 0];
planeCenter  = [31 0 55.5]*1e-3;
planeUp      = [0 0 1]; 
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

% Placeholder - this will be wrapped into a plot method for the obs surface
temp = vecnorm(obs2.FieldESecondary+obs2.FieldEPrimary, 2, 2);
th1 = 120; th2 = -10; levels = 40;
figure;
bemf2_graphics_vol_field(temp, th1, th2, levels, obs2.x, obs2.y);
title('E-field (V/m), precomputed integrals');
axis equal;