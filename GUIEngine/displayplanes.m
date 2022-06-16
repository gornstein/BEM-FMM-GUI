function displayplanes(app)

if (~isempty(app.planes) & (app.selectedplaneidx <= length(app.planes)))

        %%  Defines the three planes
    %   Getting coords for field planes
    X = app.planes{app.selectedplaneidx}{3}(1);  %   X-Coord of the plane's center
    Y = app.planes{app.selectedplaneidx}{3}(2);  %   Y-Coord of the plane's center
    Z = app.planes{app.selectedplaneidx}{3}(3);  %   Z-Coord of the plane's center

    %%  Defines aspects for field planes
    delta = app.PlaneWidthcmEditField.Value;  %   half plane window, cm
    xmin = X - delta;   % Cross-section left edge
    xmax = X + delta;   % Cross-section right edge
    ymin = Y - delta;   % Cross-section posterior edge
    ymax = Y + delta;   % Cross-section anterior edge
    zmin = Z - delta;   % Cross-section inferior edge
    zmax = Z + delta;   % Cross-section superior edge

    displayplanestocoildisplay(app); %  Display the planes to the coildisplay

    %%  Displays the required cross-section

    %   Prep for all of the actual code
    cla(app.CrossSectionDisplay);

    %% Assemble the model
    %   model = bemfmm_assembleModel('tissue_index.txt');

    load("CombinedMesh.mat");
    %     May not need any of this
    model.P = app.mesh.P*1e3;
    model.t = app.mesh.t;
    model.normals = app.mesh.normals;
    model.Center = app.mesh.Center;
    model.Area = app.mesh.Area;
    model.Indicator = app.mesh.Indicator;

    %   Need to make this abstract
    model.tissue = app.meshInternalNames;


    switch app.planes{app.selectedplaneidx}{2}
        case 'xy'

            % Parameters for plane
            planeNormal  = [0 0 1];
            planeCenter  = [X Y Z]*1e1;    % Not fully confident in the unit conversion here but we have cm and I assume we want m
            planeUp      = [0 1 0];
            planeHeight  = delta*1e-2;         % Points in cm to mm
            planeWidth   = delta*1e-2;
            pointDensity = 300/planeWidth;      %leaving as is
            obs = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity);
            bemplot_2D_niftiCrossSection_app(app.CrossSectionDisplay, app.niftidata.VT1, app.niftidata.info, 'xy', Z*1e-2);
            brighten(app.CrossSectionDisplay, 0.3);
            bemplot_2D_modelIntersections_app(app.CrossSectionDisplay, model, obs); %   Check these things

            app.CrossSectionDisplay.XLabel.String = 'X (cm)';
            app.CrossSectionDisplay.YLabel.String = 'Y (cm)';


        case 'xz'

            % Parameters for plane
            planeNormal  = [0 1 0];
            planeCenter  = [X Y Z]*1e1;    % Not fully confident in the unit conversion here but we have cm and I assume we want m
            planeUp      = [0 0 1];
            planeHeight  = delta*1e-2;         % Points in cm to mm
            planeWidth   = delta*1e-2;
            pointDensity = 300/planeWidth;
            obs = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity);
            bemplot_2D_niftiCrossSection_app(app.CrossSectionDisplay, app.niftidata.VT1, app.niftidata.info, 'xz', Y*1e-2);
            brighten(app.CrossSectionDisplay, 0.3);
            bemplot_2D_modelIntersections_app(app.CrossSectionDisplay, model, obs); %   Check these things

            app.CrossSectionDisplay.XLabel.String = 'X (cm)';
            app.CrossSectionDisplay.YLabel.String = 'Z (cm)';


        case 'yz'

            % Parameters for plane
            planeNormal  = [1 0 0];
            planeCenter  = [X Y Z]*1e1;    % Points in cm to mm
            planeUp      = [0 0 1];
            planeHeight  = delta*1e-2;         % assuming wanted in m so converting from cm
            planeWidth   = delta*1e-2;
            pointDensity = 300/planeWidth;
            obs = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity);
            bemplot_2D_niftiCrossSection_app(app.CrossSectionDisplay, app.niftidata.VT1, app.niftidata.info, 'yz', X*1e-2);
            brighten(app.CrossSectionDisplay, 0.3);
            bemplot_2D_modelIntersections_app(app.CrossSectionDisplay, model, obs); %   Check these things

            app.CrossSectionDisplay.XLabel.String = 'Y (cm)';
            app.CrossSectionDisplay.YLabel.String = 'Z (cm)';

    end
    axis(app.CrossSectionDisplay, 'equal');

end
end