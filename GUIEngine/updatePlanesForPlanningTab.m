function updatePlanesForPlanningTab(app)

if (~isempty(app.planes) && (app.selectedplaneidx <= length(app.planes)))
    cla(app.CrossSectionDisplay); % clears the axis for the new display

    %% Displays the nifti data and brain regions onto the CrossSectionDisplay

    center = app.planes{app.selectedplaneidx}.position; % m
    width = app.planes{app.selectedplaneidx}.width; % m
    direction = app.planes{app.selectedplaneidx}.direction;

    model = app.model;
    model.P = model.P .* 1000;

    displayplanes(app.CrossSectionDisplay, center, width, direction, model, app.niftidata);
    brighten(app.CrossSectionDisplay, 0.3);



    %% Updates the plane to the coil display
    % Deletes prior patch
    if (length(app.CoilDisplayObjects.planes) >= app.selectedplaneidx)
        delete(app.CoilDisplayObjects.planes{app.selectedplaneidx});
    end

    if (app.planes{app.selectedplaneidx}.visibility)

        center = app.planes{app.selectedplaneidx}.position*1e3; % mm
        width = app.planes{app.selectedplaneidx}.width*1e3; % mm
        direction = app.planes{app.selectedplaneidx}.direction;

        %
        app.CoilDisplayObjects.planes{app.selectedplaneidx} = displayplanesto3Ddisplay(app.CoilDisplay, center, width, direction);
    end

    %% Plot the coil centerline and it's intersection with the plane and the user target point
    % Delete prior lines/intersection points from the CrossSectionDisplay
    delete(app.niftidisplaydata.centerlineintersection);
    delete(app.niftidisplaydata.coilcenterline);

    % Display the coil's centerline and intersection point to the
    % CrossSectionDisplay
    planeOrientation = app.planes{app.selectedplaneidx}.direction;
    planeCenter = app.planes{app.selectedplaneidx}.position*1e3; % mm
    transformationMatrix = [app.MatrixField14.Value, app.MatrixField24.Value, app.MatrixField34.Value]; % Coil location in mm
    rotationMatrix = [app.MatrixField11.Value, app.MatrixField12.Value, app.MatrixField13.Value;
        app.MatrixField21.Value, app.MatrixField22.Value, app.MatrixField23.Value;
        app.MatrixField31.Value, app.MatrixField32.Value, app.MatrixField33.Value];

    [app.niftidisplaydata.coilcenterline, app.niftidisplaydata.centerlineintersection] = updatecoilnormalonplane(app.CrossSectionDisplay, planeOrientation, planeCenter, transformationMatrix, rotationMatrix);

    % Update user's point on the crosssectiondisplay
    delete(app.niftidisplaydata.userpoint);
    app.niftidisplaydata.userpoint = addpointto2Ddisplay(app.CrossSectionDisplay, [app.PointXValEditField.Value, app.PointYValEditField.Value, app.PointZValEditField.Value], app.planes{app.selectedplaneidx}.direction);

    axis(app.CrossSectionDisplay, 'equal');
end
end