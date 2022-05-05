function [ ] = displaybrain(app)
%%  The function called to display the brain figure

load('tissuelist');
load('CombinedMesh.mat', 't', 'Indicator');

%Creates t0
tissue_to_plot = 'GM'; %swap to skin
%Strcmp returns true if tissue == tissue_to_plot
%t0 = filtered t for the mesh we want to display
t0 = t(Indicator==find(strcmp(tissue, tissue_to_plot)), :);    % (change indicator if necessary: 1-skin, 2-skull, etc.)

%Creates str
%graphics stuff
str.EdgeColor = 'none'; str.FaceColor = [1 0.75 0.65]; str.FaceAlpha = 1.0;

%final plotting
bemf2_graphics_base(app, app.P, t0, str);


camlight(app.UIAxes);


%not really sure what this line did in the original
%lighting (app.UIAxes, phong);

end