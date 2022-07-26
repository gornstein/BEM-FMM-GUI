function updateCoilToCoilDisplay(app)
%Clears prior coil image data
delete(app.CoilDisplayObjects.coilpatch);
delete(app.CoilDisplayObjects.coilNormalLine);
delete(app.CoilDisplayObjects.coilFieldLine);

% Displays the new coil image data
[app.CoilDisplayObjects.coilpatch, app.CoilDisplayObjects.coilNormalLine, app.CoilDisplayObjects.coilFieldLine] = displaycoil(app, app.CoilDisplay);

end