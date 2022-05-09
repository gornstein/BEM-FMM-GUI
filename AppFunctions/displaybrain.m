function [ ] = displaybrain(app)
%%  The function called to display the brain figure

load('tissuelist');
load('CombinedMesh.mat', 't', 'Indicator');


%Display different head compartments based on the chosen button

if app.SkinButton_2.Value == 1
    tissue_to_plot = 'SKIN';
elseif app.BoneButton.Value == 1
    tissue_to_plot = 'BONE';
elseif app.CSFButton.Value == 1
    tissue_to_plot = 'CSF';
elseif app.GMButton.Value == 1
    tissue_to_plot = 'GM';
elseif app.WMButton.Value == 1
    tissue_to_plot = 'WM';
elseif app.VentriclesButton.Value == 1
    tissue_to_plot = 'VENTRICLES';
elseif app.EyesButton.Value == 1
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