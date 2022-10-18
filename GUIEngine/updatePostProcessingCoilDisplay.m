%function updates the coil display on the post processing volume tab to
%match the 
function updatePostProcessingCoilDisplay(app)
selectedPlane = app.PlaneSelectionDropDown.Value;
selectedCoil = app.VolumeCoilSelectionDropDown.Value;

cla(app.CoilPPDisplay);

coil.P = app.coil.P * 1e3; % scaling the points to mm
coil.t = app.coil.t;
matrix = app.solvedmatrices{selectedCoil}; % building the matrix from the app
displaycoil(app.CoilPPDisplay, coil, matrix, true, true); % displays the coil

displaybrain(app, app.CoilPPDisplay); % display the brain model
camlight(app.CoilPPDisplay); % adds a light to improve brain appearance

for i = 1:length(app.solvedplanes)
    center = app.solvedplanes{i}.position*1e3; % convert to mm
    width = app.solvedplanes{i}.width*1e3; % convert into mm
    direction = app.solvedplanes{i}.direction;
    displayplanesto3Ddisplay(app.CoilPPDisplay, center, width, direction);
end

% Changing the direction of the CoilPPDisplay to look perpendicular to the
% plane that is being examined
switch app.solvedplanes{selectedPlane}.direction
    case 'xy'
        view(app.CoilPPDisplay, 0, 90);
    case 'xz'
        view(app.CoilPPDisplay, 0, 0);
    case 'yz'
        view(app.CoilPPDisplay, 90, 0);
end
end

