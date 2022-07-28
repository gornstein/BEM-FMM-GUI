function planeDisplayObj = displayplanesto3Ddisplay(axis, center, width, direction)
%% displays a plane to a 3d axis
% axis: the axis to display the plane to
% center: the center of the plane [x, y, z] in display units
% width: the width of the plane in display units
% direction: the orientation of the plane ('xy', 'xz', 'yz')
% planeDisplayObj: the display object for the plotted plane


%%  Defines the three planes
%   Getting coords for field planes
X = center(1);
Y = center(2);
Z = center(3);

%%  Defines aspects for field planes
delta = width/2;  %   half plane width
xmin = (X - delta);   % Cross-section left edge
xmax = (X + delta);   % Cross-section right edge
ymin = (Y - delta);   % Cross-section posterior edge
ymax = (Y + delta);   % Cross-section anterior edge
zmin = (Z - delta);   % Cross-section inferior edge
zmax = (Z + delta);   % Cross-section superior edge

%%  Displays the plane

if (strcmp(direction, 'xy'))
    planeDisplayObj = patch(axis, [xmin xmin xmax xmax], [ymin ymax ymax ymin], [Z Z Z Z], 'c', 'FaceAlpha', 0.35); %   Display XY Plane
end

if (strcmp(direction, 'xz'))
    planeDisplayObj = patch(axis, [xmin xmin xmax xmax], [Y Y Y Y], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.35); %   Display XZ Plane
end

if (strcmp(direction, 'yz'))
    planeDisplayObj = patch(axis, [X X X X], [ymin ymin ymax ymax], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.35); %   Display YZ Plane
end
end