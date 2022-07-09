function displayplanes(app)

if (~isempty(app.planes) & (app.selectedplaneidx <= length(app.planes)))

    %%  Defines the three planes
    %   Getting coords for field planes
    X = app.planes{app.selectedplaneidx}{3}(1);  %   X-Coord of the plane's center (m)
    Y = app.planes{app.selectedplaneidx}{3}(2);  %   Y-Coord of the plane's center (m)
    Z = app.planes{app.selectedplaneidx}{3}(3);  %   Z-Coord of the plane's center (m)

    %%  Defines aspects for field planes
    delta = app.planes{app.selectedplaneidx}{3}(4)/2;  %   half of plane width (m)
    xmin = X - delta;   % Cross-section left edge (m)
    xmax = X + delta;   % Cross-section right edge (m)
    ymin = Y - delta;   % Cross-section posterior edge (m)
    ymax = Y + delta;   % Cross-section anterior edge (m)
    zmin = Z - delta;   % Cross-section inferior edge (m)
    zmax = Z + delta;   % Cross-section superior edge (m)

    displayplanestocoildisplay(app); %  Display the planes to the coildisplay

    %%  Displays the required cross-section

    %   Prep for all of the actual code
    cla(app.CrossSectionDisplay);

    %% Assemble the model
    %   model = bemfmm_assembleModel('tissue_index.txt');

    load("CombinedMesh.mat");
    %     May not need any of this
    model.P = app.mesh.P*1e3; % mm
    model.t = app.mesh.t;
    model.normals = app.mesh.normals;
    model.Center = app.mesh.Center; % m
    model.Area = app.mesh.Area;
    model.Indicator = app.mesh.Indicator;

    %   Need to make this abstract
    model.tissue = app.meshInternalNames;


    switch app.planes{app.selectedplaneidx}{2}
        case 'xy'

            % Parameters for plane
            planeNormal  = [0 0 1];
            planeCenter  = [X Y Z]; % mm
            planeUp      = [0 1 0];
            planeHeight  = delta*1e-3; % mm to m
            planeWidth   = delta*1e-3; % mm to m
            pointDensity = 300/planeWidth;
            obs = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity);
            bemplot_2D_niftiCrossSection_app(app.CrossSectionDisplay, app.niftidata.VT1, app.niftidata.info, 'xy', Z*1e-3);
            brighten(app.CrossSectionDisplay, 0.3);
            bemplot_2D_modelIntersections_app(app.CrossSectionDisplay, model, obs);

            % Set axis labels
            app.CrossSectionDisplay.XLabel.String = 'X (mm)';
            app.CrossSectionDisplay.YLabel.String = 'Y (mm)';

            %Display the square crosssection
            if(isfield(app.niftidisplaydata, 'fieldplane'))
                delete(app.niftidisplaydata.fieldplane);
            end
            app.niftidisplaydata.fieldplane = rectangle(app.CrossSectionDisplay, 'Position', [(X-delta)*1e3, (Y-delta)*1e3, 2*delta*1e3, 2*delta*1e3], 'EdgeColor', 'cyan', 'LineWidth', 4);


        case 'xz'

            % Parameters for plane
            planeNormal  = [0 1 0];
            planeCenter  = [X Y Z]; % mm
            planeUp      = [0 0 1];
            planeHeight  = delta*1e-3; % mm to m
            planeWidth   = delta*1e-3; % mm to m
            pointDensity = 300/planeWidth;
            obs = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity);
            bemplot_2D_niftiCrossSection_app(app.CrossSectionDisplay, app.niftidata.VT1, app.niftidata.info, 'xz', Y*1e-3);
            brighten(app.CrossSectionDisplay, 0.3);
            bemplot_2D_modelIntersections_app(app.CrossSectionDisplay, model, obs);

            % Set axis labels
            app.CrossSectionDisplay.XLabel.String = 'X (mm)';
            app.CrossSectionDisplay.YLabel.String = 'Z (mm)';

            %Display the square crosssection
            if(isfield(app.niftidisplaydata, 'fieldplane'))
                delete(app.niftidisplaydata.fieldplane);
            end
            app.niftidisplaydata.fieldplane = rectangle(app.CrossSectionDisplay, 'Position', [(X-delta)*1e3, (Z-delta)*1e3, 2*delta*1e3, 2*delta*1e3], 'EdgeColor', 'cyan', 'LineWidth', 4);


        case 'yz'

            % Parameters for plane
            planeNormal  = [1 0 0];
            planeCenter  = [X Y Z]; % mm
            planeUp      = [0 0 1];
            planeHeight  = delta*1e-3; % mm to m
            planeWidth   = delta*1e-3; % mm to m
            pointDensity = 300/planeWidth;
            obs = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity);
            bemplot_2D_niftiCrossSection_app(app.CrossSectionDisplay, app.niftidata.VT1, app.niftidata.info, 'yz', X*1e-3);
            brighten(app.CrossSectionDisplay, 0.3);
            bemplot_2D_modelIntersections_app(app.CrossSectionDisplay, model, obs);

            % Set axis labels
            app.CrossSectionDisplay.XLabel.String = 'Y (mm)';
            app.CrossSectionDisplay.YLabel.String = 'Z (mm)';

            %Display the square crosssection
            if(isfield(app.niftidisplaydata, 'fieldplane'))
                delete(app.niftidisplaydata.fieldplane);
            end
            app.niftidisplaydata.fieldplane = rectangle(app.CrossSectionDisplay, 'Position', [(Y-delta)*1e3, (Z-delta)*1e3, 2*delta*1e3, 2*delta*1e3], 'EdgeColor', 'cyan', 'LineWidth', 4);

    end
    % Display the coil's centerline and intersection point
    updatecoilnormaltocrosssectiondisplay(app);
    % Display the user's point if it exists
    updateuserpointcrosssectiondisplay(app);
    axis(app.CrossSectionDisplay, 'equal');

end
end