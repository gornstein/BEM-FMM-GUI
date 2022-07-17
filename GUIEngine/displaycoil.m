function displaycoil(app)
%%  The function called to display the coil

%Clears prior coil image data
delete(app.coilpatch);
delete(app.coilnormalline);
delete(app.coilfieldline);

%Loads Coil
Coil = app.coil;
CoilP = Coil.P;

%   3x3 Rotation Matrix
rotMatrix = [app.MatrixField11.Value, app.MatrixField12.Value, app.MatrixField13.Value;
    app.MatrixField21.Value, app.MatrixField22.Value, app.MatrixField23.Value;
    app.MatrixField31.Value, app.MatrixField32.Value, app.MatrixField33.Value];

%   1x3 Translation Matrix
transMatrix = [app.MatrixField14.Value, app.MatrixField24.Value, app.MatrixField34.Value];

%   Scale Matrix (m to mm)
scaleMatrix = [1000 0 0;
    0 1000 0;
    0 0 1000];

%   Apply the rotations and transformation to the coil
for j = 1:size(CoilP,1)
    transformedPoint = scaleMatrix * rotMatrix * CoilP(j,:)' + transMatrix';
    Coil.P(j,:) = transformedPoint';
end

if (strcmp(app.VectorfromcoilSwitch.Value, 'On'))
    %   display the vector showing the coil direction
    app.coilnormalline = displaycoilnormalvector(app.CoilDisplay, rotMatrix, transMatrix);
end

if (strcmp(app.FieldVectorSwitch.Value, 'On'))
    %   display the vector from the origin to the coil's translation location
    app.coilfieldline = displaycoilfieldlines(app.CoilDisplay, rotMatrix,transMatrix);
end

% Display the coil
[app.coilpatch] = bemf1_graphics_coil_CAD_app(app.CoilDisplay, Coil.P, Coil.t, 1);

%% Delete prior lines/intersection points from the CrossSectionDisplay
if (~isempty(app.planes))
    delete(app.niftidisplaydata.centerlineintersection);
    delete(app.niftidisplaydata.coilcenterline);

    % Display the coil's centerline and intersection point to the
    % CrossSectionDisplay
    planeOrientation = app.planes{app.selectedplaneidx}{2};
    planeCenter = app.planes{app.selectedplaneidx}{3}(1:3)*1e3; % mm
    transformationMatrix = [app.MatrixField14.Value, app.MatrixField24.Value, app.MatrixField34.Value]; % Coil location in mm
    rotationMatrix = [app.MatrixField11.Value, app.MatrixField12.Value, app.MatrixField13.Value;
        app.MatrixField21.Value, app.MatrixField22.Value, app.MatrixField23.Value;
        app.MatrixField31.Value, app.MatrixField32.Value, app.MatrixField33.Value];

    [app.niftidisplaydata.coilcenterline, app.niftidisplaydata.centerlineintersection] = updatecoilnormalonplane(app.CrossSectionDisplay, planeOrientation, planeCenter, transformationMatrix, rotationMatrix);
end

end