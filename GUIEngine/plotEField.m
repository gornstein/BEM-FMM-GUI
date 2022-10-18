function plotEField(app)
if (~isempty(app.solvedplanes))
    % Clears the UIAxis on the processing tab
    % Uses the stored data from ProcessEField to plot the selected
    %   plane
    % Updates the currently selected plane idx value
    idx = app.processingPlaneidx;
    coilidx = app.VolumeCoilSelectionDropDown.Value;
    cla(app.SolverDisplay);

    opts.ThresholdHigh = app.EFieldThresholdHigh.Value; opts.ThresholdLow = app.EFieldThresholdLow.Value; opts.NumLevels = app.EFieldPlotLevels.Value;
    lims = bemplot_2D_planeField_app(app.SolverDisplay, app.EFieldObs2{coilidx}{idx}, app.vecnormObs2{coilidx}{idx}, opts);

    bemplot_2D_modelIntersections_app2(app.SolverDisplay, app.EFieldModel, app.EFieldObs2{coilidx}{idx});

    % Set plot axis limits
    app.SolverDisplay.XLim = lims.XLim*1e3;
    app.SolverDisplay.YLim = lims.YLim*1e3;
    % Make colorbar
    colorbar(app.SolverDisplay,"north");

    %% Display the coil's centerline and intersection point to the SolverDisplay
    if (~isempty(app.solvedplanes))
        planeOrientation = app.solvedplanes{idx}.direction;
        planeCenter = app.solvedplanes{idx}.position*1e3; % mm
        transformationMatrix = [app.MatrixField14.Value, app.MatrixField24.Value, app.MatrixField34.Value]; % Coil location in mm
        rotationMatrix = [app.MatrixField11.Value, app.MatrixField12.Value, app.MatrixField13.Value;
            app.MatrixField21.Value, app.MatrixField22.Value, app.MatrixField23.Value;
            app.MatrixField31.Value, app.MatrixField32.Value, app.MatrixField33.Value];

        updatecoilnormalonplane(app.SolverDisplay, planeOrientation, planeCenter, transformationMatrix, rotationMatrix);
    end

    updatePostProcessingCoilDisplay(app); % update the CoilPPDisplay
end
end