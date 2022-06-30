function updatecoilnormaltosolverdisplay(app)

if ~isempty(app.planes) % if the planes are empty then there will be nothing to display to


    coilIntersection = app.niftidatainfo.intersectionPoint;
    startPoint = app.niftidatainfo.coilLineStartPoint;
    endPoint = app.niftidatainfo.coilLineEndPoint;
    
    plot(app.SolverDisplay, coilIntersection(1)*1e-2, coilIntersection(2)*1e-2, 'Color', 'red', 'Marker', 'o', 'MarkerSize', 10, 'LineWidth', 10);
    plot(app.SolverDisplay, [startPoint(1)*1e-2, endPoint(1)*1e-2], [startPoint(2)*1e-2, endPoint(2)*1e-2], 'Color', 'blue', 'LineWidth', 4);


    userPointX = app.PointXValEditField.Value;
    userPointY = app.PointYValEditField.Value;
    userPointZ = app.PointZValEditField.Value;

    switch app.planes{app.selectedplaneidx}{2}
        case 'xy'
            plot(app.SolverDisplay, userPointX*1e-2, userPointY*1e-2, Color = 'green', Marker= '*', MarkerSize=10);
            app.SolverDisplay.XLabel.String = 'X (m)';
            app.SolverDisplay.YLabel.String = 'Y (m)';
        case 'xz'
            plot(app.SolverDisplay, userPointX*1e-2, userPointZ*1e-2, Color = 'green', Marker= '*', MarkerSize=10);
            app.SolverDisplay.XLabel.String = 'X (m)';
            app.SolverDisplay.YLabel.String = 'Z (m)';
        case 'yz'
            plot(app.SolverDisplay, userPointY*1e-2, userPointZ*1e-2, Color = 'green', Marker= '*', MarkerSize=10);
            app.SolverDisplay.XLabel.String = 'Y (m)';
            app.SolverDisplay.YLabel.String = 'Z (m)';
    end
end
end