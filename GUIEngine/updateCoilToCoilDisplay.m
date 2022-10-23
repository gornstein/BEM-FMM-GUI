function updateCoilToCoilDisplay(app)
%Clears prior coil image data
delete(app.CoilDisplayObjects.coilpatch);
delete(app.CoilDisplayObjects.coilNormalLine);
delete(app.CoilDisplayObjects.coilFieldLine);

if (app.isDipoleCoil)
    coil.positions = app.coil.positions * 1e3; % scaling the points to mm
else
    coil.P = app.coil.P * 1e3; % scaling the points to mm
    coil.t = app.coil.t;
end

matrix = [app.MatrixField11.Value, app.MatrixField12.Value, app.MatrixField13.Value, app.MatrixField14.Value;
    app.MatrixField21.Value, app.MatrixField22.Value, app.MatrixField23.Value, app.MatrixField24.Value;
    app.MatrixField31.Value, app.MatrixField32.Value, app.MatrixField33.Value, app.MatrixField34.Value;
    app.MatrixField41.Value, app.MatrixField42.Value, app.MatrixField43.Value, app.MatrixField44.Value]; % building the matrix from the app

coilNormal = strcmp(app.VectorfromcoilSwitch.Value, 'On'); % sets whether the coil's normal vector will be displayed
coilField = strcmp(app.FieldVectorSwitch.Value, 'On'); % sets whether the coil's field vector will be displayed

% Displays the new coil image data
[app.CoilDisplayObjects.coilpatch, app.CoilDisplayObjects.coilNormalLine, app.CoilDisplayObjects.coilFieldLine] = displaycoil(app.CoilDisplay, coil, matrix, coilNormal, coilField, app.isDipoleCoil);

end