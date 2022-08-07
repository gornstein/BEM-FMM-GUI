function updatePlanesForPostProcessingTab(app)

if (~isempty(app.planes) && (app.processingPlaneidx <= length(app.planes)))
    cla(app.CrossSectionPPDisplay); % clears the axis for the new display

    %% Displays the nifti data and brain regions onto the CrossSectionDisplay

    center = app.planes{app.processingPlaneidx}.position; % m
    width = app.planes{app.processingPlaneidx}.width; % m
    direction = app.planes{app.processingPlaneidx}.direction;

    model = app.model;
    model.P = model.P .* 1000;

    displayplanes(app.CrossSectionPPDisplay, center, width, direction, model, app.niftidata);
    brighten(app.CrossSectionPPDisplay, 0.3);

    %% Plot the coil centerline and it's intersection with the plane and the user target point
    % Delete prior lines/intersection points from the CrossSectionDisplay
    delete(app.niftidisplaydatapp.centerlineintersection);
    delete(app.niftidisplaydatapp.coilcenterline);

    % Display the coil's centerline and intersection point to the
    % CrossSectionDisplay
    planeOrientation = app.planes{app.processingPlaneidx}.direction;
    planeCenter = app.planes{app.processingPlaneidx}.position*1e3; % mm
    transformationMatrix = [app.MatrixField14.Value, app.MatrixField24.Value, app.MatrixField34.Value]; % Coil location in mm
    rotationMatrix = [app.MatrixField11.Value, app.MatrixField12.Value, app.MatrixField13.Value;
        app.MatrixField21.Value, app.MatrixField22.Value, app.MatrixField23.Value;
        app.MatrixField31.Value, app.MatrixField32.Value, app.MatrixField33.Value];

    [app.niftidisplaydatapp.coilcenterline, app.niftidisplaydatapp.centerlineintersection] = updatecoilnormalonplane(app.CrossSectionPPDisplay, planeOrientation, planeCenter, transformationMatrix, rotationMatrix);

    % Update user's point on the crosssectiondisplay
    delete(app.niftidisplaydatapp.userpoint);
    app.niftidisplaydatapp.userpoint = addpointto2Ddisplay(app.CrossSectionPPDisplay, [app.PointXValEditField.Value, app.PointYValEditField.Value, app.PointZValEditField.Value], app.planes{app.processingPlaneidx}.direction);

    axis(app.CrossSectionPPDisplay, 'equal');
end
end