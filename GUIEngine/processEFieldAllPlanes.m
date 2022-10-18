function processEFieldAllPlanes(app)

%   Requirements for new solver:
%   1. setup all default behavior
%       - assemble model, load coil
%   2. setup the outer coil loop
%       - position coil, assigning coil stimulus, run solver, solve for
%       planes, solve for surface field/populate app.EFieldSolutions
%   3. Display all required data to data displays

%%  SETUP DEFAULT BEHAVIOR

cla(app.SolverDisplay);

clc

constants.eps0        = 8.85418782e-012;  %   Dielectric permittivity of vacuum(~air)
constants.mu0         = 1.25663706e-006;  %   Magnetic permeability of vacuum(~air)

try
    % Setting parallel pool params and creating parpool
    if app.NumberOfThreadsForProcessingEditField.Value == -1
        numthreads = feature('NumCores');   % Detects number of physical cores
    elseif app.NumberOfThreadsForProcessingEditField.Value > 0
        numthreads = app.NumberOfThreadsForProcessingEditField.Value;
    else
        numthreads = feature('NumCores');   % If something goes wrong just use number of physical cores
    end
    tempPool = gcp('nocreate'); %   See if a parallel pool already exists
    if isempty(tempPool) || tempPool.NumWorkers ~= numthreads
        delete(gcp('nocreate'));
        parpool(numthreads);
    end

catch exception
    throwErrorPopup(app, exception.message, 'Error');
    return;
end

% Assemble the model
model = app.model;
model = bemfmm_computeModelIntegrals(model, 4);
model = bemfmm_assignDefaultModelConductivities(model, 0); % Kind of a placeholder

disp('Model Loaded and Assembled');

% Load the coil
baseCoil = bemfmm_loadCoil_app('coil.mat','coilCAD.mat');

disp('Coil Loaded');
pause(0.4);

% Parameters for the solver
solverOptions.prec      = 1e-3;     % FMM precision
solverOptions.weight    = 1/2;      % Empirically-derived constant
solverOptions.maxIter   = app.MaximumIterationsEditField.Value;       % Maximum permitted GMRES iterations
solverOptions.relRes    = app.MinimumResidualEditField.Value;    % GMRES stop criterion

app.solvedmatrices = app.matrices; % stores all coil positions at the time that the solver is run
app.solvedplanes = app.planes; % makes a copy of the planes being solved for


%%  COIL LOOP
for coilIndex = 1:length(app.matrices)

    % Position and orient coil
    transMatrix = app.matrices{coilIndex};
    transMatrix(1:3,4) = transMatrix(1:3,4)*1e-3;
    coil = bemfmm_positionCoilT(baseCoil, transMatrix);

    % Assign coil stimulus
    coilCurrent = app.CoilCurrentEditField.Value;
    % coilFreq    = 3000; % coil frequency in hz
    coildIdt    = app.CoildIdtEditField.Value; % 2*pi*coilFreq*coilCurrent
    coil = bemfmm_assignCoilStimulus(coil, coilCurrent, coildIdt);

    solution = bemfmm_chargeEngineBase(model, coil, constants, solverOptions);

    %% MATERS LATER
    % % Define observation surface 1: coil centerline
    % % parameters:
    % orig_temp = coil.origin; % named orig_temp to not confuse bem3_line_field_e
    % dirline   = coil.centerlineDirection;
    % distance  = 0.1;                 % Distance (m) that the line should reach from the origin
    % numPoints = 10000;               % Number of points in the line
    % obs1 = bemfmm_makeObsLine_2(orig_temp, dirline, distance, numPoints);

    % Set up options for observation point field evaluation
    obsOptions.prec = 1e-3;
    obsOptions.relativeIntegrationRadius = 5;

    %% Calculates planes
    if(~isempty(app.planes))
        [planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity, numberOfPlanes] = observationSurfaceParamsAll_app(app);

        app.EFieldModel = model;

        %% Loop here for planes
        for n = 1:numberOfPlanes

            % Make plane, compute neighbor integrals, compute E-field
            disp(['Making observation plane and computing integrals + fields. Pass ', num2str(n), ' of ', num2str(numberOfPlanes)]);
            pause(0.2);
            obs2 = bemfmm_makeObsPlaneAllPlanes(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity, n);

            % FORTRAN version of computeObsField, faster
            obs2 = bemfmm_computeObsField_oneshot(obs2, coil, model, solution, constants, obsOptions);

            % Store obs2 for each iteration
            app.EFieldObs2{coilIndex}{n} = obs2;

            % setup stuff for plots and store in app
            app.vecnormObs2{coilIndex}{n} = vecnorm(obs2.FieldESecondary+obs2.FieldEPrimary, 2, 2);

        end
        % get the full solution structure
        [EFieldSolution.EPri, EFieldSolution.ESec, EFieldSolution.EDiscin, EFieldSolution.EDisco] = bemfmm_computeSurfaceEField(model, solution); % computes the fields
        app.EFieldSolution{coilIndex} = EFieldSolution;
    end

    %% DISPLAY

    % Set some stuff for dropdown
    processingPlanesDD(app);
    app.VolumeCoilSelectionDropDown.Items = app.positions;
    app.VolumeCoilSelectionDropDown.ItemsData = 1:length(app.positions);
    app.SurfaceCoilSelectionDropDown.Items = app.positions;
    app.SurfaceCoilSelectionDropDown.ItemsData = 1:length(app.positions);
    disp('DONE');

    updatePostProcessingCoilDisplay(app); % update the CoilPPDisplay

    % Plot to the PostProcessing Tab
    updatePostProcessingCoilDisplay(app);

    updatePlanesForPostProcessingTab(app); % display the planes to the CrossSectionPPDisplay
    axis(app.CrossSectionPPDisplay, "equal");

end


% Calculating the EFields

model = app.model;
model.P = model.P .* 1000;


updateSurfaceDisplay(app); % display the surface EField to the SurfaceDisplay
axis(app.SurfaceDisplay, "equal");


end