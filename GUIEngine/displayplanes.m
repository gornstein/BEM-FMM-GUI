function displayplanes(axis, center, width, direction, model, niftidata)
%% display nifti data from planes to a 2d axis
% axis: the axis to be displayed upon
% center: the center of the plane in m (display units are mm)
% width: the width of the plane in m (display units are mm)
% direction: the orientation of the plane ('xy', 'xz', or 'yz')
% model: a struct with the fields P, t, normals, Center, Area, Indicator, and tissue
% niftidata: a struct with the fields VT1 and info


%%  Defines the three planes
%   Getting coords for field planes
X = center(1);  %   X-Coord of the plane's center (m)
Y = center(2);  %   Y-Coord of the plane's center (m)
Z = center(3);  %   Z-Coord of the plane's center (m)

%%  Defines aspects for field planes
delta = width/2;  %   half of plane width (m)
xmin = X - delta;   % Cross-section left edge (m)
xmax = X + delta;   % Cross-section right edge (m)
ymin = Y - delta;   % Cross-section posterior edge (m)
ymax = Y + delta;   % Cross-section anterior edge (m)
zmin = Z - delta;   % Cross-section inferior edge (m)
zmax = Z + delta;   % Cross-section superior edge (m)

%% Assemble the model

switch direction
    case 'xy'

        % Parameters for plane
        planeNormal  = [0 0 1];
        planeCenter  = [X Y Z]*1e3; % m to mm
        planeUp      = [0 1 0];
        planeHeight  = delta*1e3; % m to mm
        planeWidth   = delta*1e3; % m to mm
        pointDensity = 300/planeWidth;
        obs = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity);
        try
            bemplot_2D_niftiCrossSection_app(axis, niftidata.VT1, niftidata.info, 'xy', Z);
        catch
            app = 5; % fake variable to bypass .mlapp function parameter requirements for the first param to be app
            throwErrorPopup(app, 'Your plane is outside of the head and thus nothing could be displayed. Please place your plane within the head.', 'Error');
            return;
        end
        brighten(axis, 0.3);
        bemplot_2D_modelIntersections_app(axis, model, obs);

        % Set axis labels
        axis.XLabel.String = 'X (mm)';
        axis.YLabel.String = 'Y (mm)';

        %Display the square crosssection
        rectangle(axis, 'Position', [(X-delta)*1e3, (Y-delta)*1e3, 2*delta*1e3, 2*delta*1e3], 'EdgeColor', 'cyan', 'LineWidth', 4);


    case 'xz'

        % Parameters for plane
        planeNormal  = [0 1 0];
        planeCenter  = [X Y Z]*1e3; % mm
        planeUp      = [0 0 1];
        planeHeight  = delta*1e3; % m to mm
        planeWidth   = delta*1e3; % m to mm
        pointDensity = 300/planeWidth;
        obs = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity);
        try
            bemplot_2D_niftiCrossSection_app(axis, niftidata.VT1, niftidata.info, 'xz', Y);
        catch
            app = 5; % fake variable to bypass .mlapp function parameter requirements for the first param to be app
            throwErrorPopup(app, 'Your plane is outside of the head and thus nothing could be displayed. Please place your plane within the head.', 'Error');
            return;
        end
        brighten(axis, 0.3);
        bemplot_2D_modelIntersections_app(axis, model, obs);

        % Set axis labels
        axis.XLabel.String = 'X (mm)';
        axis.YLabel.String = 'Z (mm)';

        %Display the square crosssection
        rectangle(axis, 'Position', [(X-delta)*1e3, (Z-delta)*1e3, 2*delta*1e3, 2*delta*1e3], 'EdgeColor', 'cyan', 'LineWidth', 4);


    case 'yz'

        % Parameters for plane
        planeNormal  = [1 0 0];
        planeCenter  = [X Y Z]*1e3; % m to mm
        planeUp      = [0 0 1];
        planeHeight  = delta*1e3; % m to mm
        planeWidth   = delta*1e3; % m to mm
        pointDensity = 300/planeWidth;
        obs = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity);
        try
            bemplot_2D_niftiCrossSection_app(axis, niftidata.VT1, niftidata.info, 'yz', X);
        catch
            app = 5; % fake variable to bypass .mlapp function parameter requirements for the first param to be app
            throwErrorPopup(app, 'Your plane is outside of the head and thus nothing could be displayed. Please place your plane within the head.', 'Error');
            return;
        end
        brighten(axis, 0.3);
        bemplot_2D_modelIntersections_app(axis, model, obs);

        % Set axis labels
        axis.XLabel.String = 'Y (mm)';
        axis.YLabel.String = 'Z (mm)';

        %Display the square crosssection
        rectangle(axis, 'Position', [(Y-delta)*1e3, (Z-delta)*1e3, 2*delta*1e3, 2*delta*1e3], 'EdgeColor', 'cyan', 'LineWidth', 4);
end
end