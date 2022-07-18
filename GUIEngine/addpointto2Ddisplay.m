function pointObj = addpointto2Ddisplay(axis, point, planeOrientation)
%% Takes the 3D point and plots it on a 2D display based on the orientation of the display
% axis: the axis to plot on
% point: the point (x, y, z) in display units to be plotted
% planeOrientation: the orientation ('xy', 'xz', or 'yz') of the plane
% pointObj: the point's display object

    switch planeOrientation
        case 'xy'
            pointObj = plot(axis, point(1), point(2), Color = 'green', Marker= '*', MarkerSize=10);
        case 'xz'
            pointObj = plot(axis, point(1), point(3), Color = 'green', Marker= '*', MarkerSize=10);
        case 'yz'
            pointObj = plot(axis, point(2), point(3), Color = 'green', Marker= '*', MarkerSize=10);
    end
end