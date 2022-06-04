function displaybrain(app)
%%  The function called to display the brain figure

% load('tissuelist');
% load('CombinedMesh.mat', 't', 'Indicator');


%Display different head compartments based on the chosen compartment

%   Populate head compartments dropdown with tissue names
%   Skip switch statement
% switch app.HeadCompartmentsDropDown.Value
%     case 'Skin'
%         tissue_to_plot = 'SKIN';
%     case 'Bone'
%         tissue_to_plot = 'BONE';
%     case 'CSF'
%         tissue_to_plot = 'CSF';
%     case 'GM'
%         tissue_to_plot = 'GM';
%     case 'WM'
%         tissue_to_plot = 'WM';
%     case 'Ventricles'
%         tissue_to_plot = 'VENTRICLES';
%     case 'Eyes'
%         tissue_to_plot = 'EYES';
% end

%   Assume that dropdown has been populated from internal names
%   Assume that we are saving internal names as app.meshInternalNames
%   Assume meshes have been loaded from stl files to app.meshList
%   Assume app.meshList is in the same order as a table
tissue_to_plot = app.HeadCompartmentsDropDown.Value;
ind1 = strcmp(app.meshInternalNames,tissue_to_plot);
t0 = app.meshList{ind1}.ConnectivityList;
P = app.meshList{ind1}.Points;
%t0 = t(Indicator==find(strcmp(tissue, tissue_to_plot)), :);    % (change indicator if necessary: 1-skin, 2-skull, etc.)


%Creates str
%graphics stuff
str.EdgeColor = 'none'; str.FaceColor = [1 0.75 0.65]; str.FaceAlpha = 1.0;

%final plotting
bemf2_graphics_base(app, P, t0, str);

camlight(app.CoilDisplay);

end