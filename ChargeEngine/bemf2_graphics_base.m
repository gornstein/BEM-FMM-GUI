%%  Modified to display on the app
function [] = bemf2_graphics_base(app, P, t, c)
%   Surface plot

%   Copyright SNM 2017-2020

    p = patch(app.UIAxes, 'vertices', P, 'faces', t);
    p.FaceColor = c.FaceColor;
    p.EdgeColor = c.EdgeColor;
    p.FaceAlpha = c.FaceAlpha;
    daspect(app.UIAxes, [1 1 1]);          
	
    NumberOfTrianglesInShell = size(t, 1);
    edges = meshconnee(t);
    temp = P(edges(:, 1), :) - P(edges(:, 2), :);
    AvgEdgeLengthInShell = mean(sqrt(dot(temp, temp, 2)));
end