function [ ] = displaybrain(app)
%%  The function called to display the brain figure

load('tissuelist');
load('CombinedMesh.mat', 't', 'Indicator');


tissue_to_plot = 'GM'; %swap to skin
t0 = t(Indicator==find(strcmp(tissue, tissue_to_plot)), :);    % (change indicator if necessary: 1-skin, 2-skull, etc.)

%Creates str
%graphics stuff
str.EdgeColor = 'none'; str.FaceColor = [1 0.75 0.65]; str.FaceAlpha = 1.0;

%final plotting
bemf2_graphics_base(app, app.P, t0, str);

camlight(app.UIAxes);

end