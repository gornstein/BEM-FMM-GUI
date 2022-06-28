function updatecoilnormaltosolverdisplay(app)

if ~isempty(app.planes) % if the planes are empty then there will be nothing to display to


    coilIntersection = app.niftidatainfo.intersectionPoint;
    startPoint = app.niftidatainfo.coilLineStartPoint;
    endPoint = app.niftidatainfo.coilLineEndPoint;

    plot(app.SolverDisplay, coilIntersection(1)*1e-2, coilIntersection(2)*1e-2, 'Color', 'red', 'Marker', 'o', 'MarkerSize', 10, 'LineWidth', 10);
    plot(app.SolverDisplay, [startPoint(1)*1e-2, endPoint(1)*1e-2], [startPoint(2)*1e-2, endPoint(2)*1e-2], 'Color', 'blue', 'LineWidth', 4);

end
end