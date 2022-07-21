function updateBrainToCoilDisplay(app)

% Clears prior brain image
delete(app.brainpatch);
delete(app.brainlight);

% Adds a light to the image
app.brainlight = camlight(app.CoilDisplay);

% Displays the new image
app.brainpatch = displaybrain(app, app.CoilDisplay);

end