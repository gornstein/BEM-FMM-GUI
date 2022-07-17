function displaybrain(app)
%%  The function called to display the brain figure

% Clears prior brain image
delete(app.brainpatch);
delete(app.brainlight);

%   Assume that dropdown has been populated from internal names
%   Assume that we are saving internal names as app.meshInternalNames
%   Assume meshes have been loaded from stl files to app.meshList
%   Assume app.meshList is in the same order as a table
tissue_to_plot = app.HeadCompartmentsDropDown.Value;
ind1 = strcmp(app.meshInternalNames,tissue_to_plot);
t0 = app.meshList{ind1}.ConnectivityList;
P = app.meshList{ind1}.Points; % mm


%Creates str
%graphics stuff
str.EdgeColor = 'none'; str.FaceColor = [1 0.75 0.65]; str.FaceAlpha = 1.0;

%final plotting
app.brainlight = camlight(app.CoilDisplay);
app.brainpatch = bemf2_graphics_base_app(app.CoilDisplay, P, t0, str);

end