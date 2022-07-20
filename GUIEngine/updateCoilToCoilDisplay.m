function updateCoilToCoilDisplay(app)
%Clears prior coil image data
delete(app.coilpatch);
delete(app.coilnormalline);
delete(app.coilfieldline);

% Displays the new coil image data
[app.coilpatch, app.coilnormalline, app.coilfieldline] = displaycoil(app, app.CoilDisplay);

end