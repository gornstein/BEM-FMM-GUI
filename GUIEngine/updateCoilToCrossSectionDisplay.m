function updateCoilToCrossSectionDisplay(app)
%% Delete prior lines/intersection points from the CrossSectionDisplay
if (~isempty(app.planes))
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
end
end