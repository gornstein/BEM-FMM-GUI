function [] = displayplanes(app)


%%  Defines the three planes
%   Getting coords for field planes
X = app.PlanesXPoscmSlider.Value;  %   YZ Cross-section position, cm
Y = app.PlanesYPoscmSlider.Value;  %   XZ Cross-section position, cm
Z = app.PlanesZPoscmSlider.Value;  %   XY Cross-section position, cm

%%  Defines aspects for field planes
delta = 2;  %   half plane window, cm
xmin = X - delta;   % Cross-section left edge
xmax = X + delta;   % Cross-section right edge
ymin = Y - delta;   % Cross-section posterior edge
ymax = Y + delta;   % Cross-section anterior edge
zmin = Z - delta;   % Cross-section inferior edge
zmax = Z + delta;   % Cross-section superior edge

%%  Displays the three field planes

if (app.ToggleXYFieldPlaneButton.Value == 1)
    patch(app.CoilDisplay, [xmin xmin xmax xmax], [ymin ymax ymax ymin], [Z Z Z Z], 'c', 'FaceAlpha', 0.35); %   Display XY Plane
end

if (app.ToggleXZFieldPlaneButton.Value == 1)
    patch(app.CoilDisplay, [xmin xmin xmax xmax], [Y Y Y Y], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.35); %   Display XZ Plane
end

if (app.ToggleYZFieldPlaneButton.Value == 1)
    patch(app.CoilDisplay, [X X X X], [ymin ymin ymax ymax], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.35); %   Display YZ Plane
end

%%  Displays the required cross-section

%   Prep for all of the actual code
cla(app.CrossSectionDisplay);

nifti_filepath = 'T1w.nii';
if exist(nifti_filepath, 'file')
    VT1         = niftiread(nifti_filepath);
    info        = niftiinfo(nifti_filepath);
end

%% Assemble the model
%   model = bemfmm_assembleModel('tissue_index.txt');

load("CombinedMesh.mat");
%     May not need any of this
model.P = P*1e3;
model.t = t;
model.normals = normals;
model.Center = Center;
model.Area = Area;
model.Indicator = Indicator;
model.tissue = {'Skin', 'Skull', 'CSF', 'GM', 'Cerebellum', 'WM', 'Ventricles'};


switch app.CrossSectionControlsTabGroup.SelectedTab.Title
    case 'XY Plane'

        % Parameters for plane
        planeNormal  = [0 0 1];
        planeCenter  = [X Y Z]*1e1;    % Not fully confident in the unit conversion here but we have cm and I assume we want m
        planeUp      = [0 1 0];
        planeHeight  = delta*1e-2;         % assuming wanted in m so converting from cm
        planeWidth   = delta*1e-2;
        pointDensity = 300/planeWidth;      %leaving as is
        obs = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity);
        bemplot_2D_niftiCrossSection(app.CrossSectionDisplay, VT1, info, 'xy', Z*1e-2);
        brighten(app.CrossSectionDisplay, 0.3);
        bemplot_2D_modelIntersections(app.CrossSectionDisplay, model, obs); %   Check these things


    case 'XZ Plane'

        % Parameters for plane
        planeNormal  = [0 1 0];
        planeCenter  = [X Y Z]*1e1;    % Not fully confident in the unit conversion here but we have cm and I assume we want m
        planeUp      = [0 0 1];
        planeHeight  = delta*1e-2;         % assuming wanted in m so converting from cm
        planeWidth   = delta*1e-2;
        pointDensity = 300/planeWidth;
        obs = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity);
        bemplot_2D_niftiCrossSection(app.CrossSectionDisplay, VT1, info, 'xz', Y*1e-2);
        brighten(app.CrossSectionDisplay, 0.3);
        bemplot_2D_modelIntersections(app.CrossSectionDisplay, model, obs); %   Check these things


    case 'YZ Plane'

        % Parameters for plane
        planeNormal  = [1 0 0];
        planeCenter  = [X Y Z]*1e1;    % Not fully confident in the unit conversion here but we have cm and I assume we want m
        planeUp      = [0 0 1];
        planeHeight  = delta*1e-2;         % assuming wanted in m so converting from cm
        planeWidth   = delta*1e-2;
        pointDensity = 300/planeWidth;
        obs = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity);
        bemplot_2D_niftiCrossSection(app.CrossSectionDisplay, VT1, info, 'yz', X*1e-2);
        brighten(app.CrossSectionDisplay, 0.3);
        bemplot_2D_modelIntersections(app.CrossSectionDisplay, model, obs); %   Check these things

end
axis(app.CrossSectionDisplay, 'equal');


end