function updateBrainToCoilDisplay(app)

% Clears prior brain image
delete(app.CoilDisplayObjects.brainpatch);
delete(app.CoilDisplayObjects.light);

% Adds a light to the image
app.CoilDisplayObjects.light = camlight(app.CoilDisplay);

% Displays the new image
app.CoilDisplayObjects.brainpatch = displaybrain(app, app.CoilDisplay);

end