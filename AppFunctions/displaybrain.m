function [ ] = displaybrain(app)
%%  The function called to display the brain figure

load('tissuelist');
load('CombinedMesh.mat', 't', 'Indicator');


%Display different head compartments based on the chosen compartment

switch app.HeadCompartmentsDropDown.Value
    case 'Skin'
        tissue_to_plot = 'SKIN';
    case 'Bone'
        tissue_to_plot = 'BONE';
    case 'CSF'
        tissue_to_plot = 'CSF';
    case 'GM'
        tissue_to_plot = 'GM';
    case 'WM'
        tissue_to_plot = 'WM';
    case 'Ventricles'
        tissue_to_plot = 'VENTRICLES';
    case 'Eyes'
        tissue_to_plot = 'EYES';
end


t0 = t(Indicator==find(strcmp(tissue, tissue_to_plot)), :);    % (change indicator if necessary: 1-skin, 2-skull, etc.)


%Creates str
%graphics stuff
str.EdgeColor = 'none'; str.FaceColor = [1 0.75 0.65]; str.FaceAlpha = 1.0;

%final plotting
bemf2_graphics_base(app, app.P, t0, str);

camlight(app.UIAxes);

end