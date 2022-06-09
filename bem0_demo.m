%% Placeholders for not-yet-rewritten stuff
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

model = bemfmm_assembleModel('tissue_index.txt');
model = bemfmm_computeModelIntegrals(model, 16);
model = bemfmm_assignDefaultModelConductivities(model, 0); % Kind of a placeholder

bem1_setup_coil;

coil.strcoil = strcoil;
coil.dIdt = dIdt;
constants.mu0 = mu0;

%% Another placeholder
bem2_charge_engine_2;
solution.c = c;

disp(newline);
pause(1);
%% Define observation surface 1: coil centerline
% parameters
orig_temp = [MoveX MoveY MoveZ]; % named orig_temp to not confuse bem3_line_field_e
% dirline                          (defined during bem1_setup_coil)
distance  = 0.1;                 % Distance (m) that the line should reach from the origin
numPoints = 10000;               % Number of points in the line
obs1 = bemfmm_makeObsLine_2(orig_temp, dirline, 0.1, 10000);

tic
obs1 = bemfmm_computeObsIntegrals(obs1, model, 5);
disp(['Observation line integrals computed in ' num2str(toc) ' s']);

% Compute precise field at coil centerline
tic
obs1 = bemfmm_computeObsField(obs1, coil, model, solution, constants);
disp(['Observation line fields computed in ' num2str(toc) 's']);

% Compare secondary field computed from new method versus secondary field
% computed from old method
bem3_line_field_e_sec;
hold on;
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
obs2 = bemfmm_computeObsIntegrals(obs2, model, 5);
disp(['Observation plane integrals evaluated in ' num2str(toc) ' seconds']);
tic
obs2 = bemfmm_computeObsField(obs2, coil, model, solution, constants);
disp(['Observation plane fields computed in ' num2str(toc) ' seconds']);

% Compare obs plane with result from YZ cross-section script
bem4_define_volume_fields_temp;
bem5_volume_YZ_sec;

% Placeholder - this will be wrapped into a plot method for the obs surface
temp = vecnorm(obs2.FieldESecondary, 2, 2);
th1 = 120; th2 = -10; levels = 40;
figure;
bemf2_graphics_vol_field(temp, th1, th2, levels, obs2.x, obs2.y);
title('E-field (V/m), precomputed integrals');
axis equal;

% Plot error
temp = vecnorm(obs2.FieldESecondary - Esec, 2, 2);
figure;
bemf2_graphics_vol_field(temp, 5, 0, levels, obs2.x, obs2.y);
title('Norm of absolute error between old and new obs surface fields');
axis equal;