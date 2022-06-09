%%  Modified to display on the app
function [] = bemf2_graphics_base_app(app, P, t, c)
%   Surface plot

%   Copyright SNM 2017-2020

    app.brainpatch = patch(app.CoilDisplay, 'vertices', P, 'faces', t);
    app.brainpatch.FaceColor = c.FaceColor;
    app.brainpatch.EdgeColor = c.EdgeColor;
    app.brainpatch.FaceAlpha = c.FaceAlpha;
    daspect(app.CoilDisplay, [1 1 1]);          
	
    NumberOfTrianglesInShell = size(t, 1);
    edges = meshconnee(t);
    temp = P(edges(:, 1), :) - P(edges(:, 2), :);
    AvgEdgeLengthInShell = mean(sqrt(dot(temp, temp, 2)));

    app.brainlight = camlight(app.CoilDisplay);
end