%%  Modified to display on the app
function [brainPatch] = bemf2_graphics_base_app(axis, P, t, c)
%   Surface plot

%   Copyright SNM 2017-2020

    brainPatch = patch(axis, 'vertices', P, 'faces', t);
    brainPatch.FaceColor = c.FaceColor;
    brainPatch.EdgeColor = c.EdgeColor;
    brainPatch.FaceAlpha = c.FaceAlpha;
    daspect(axis, [1 1 1]);          
	
    NumberOfTrianglesInShell = size(t, 1);
    edges = meshconnee(t);
    temp = P(edges(:, 1), :) - P(edges(:, 2), :);
    AvgEdgeLengthInShell = mean(sqrt(dot(temp, temp, 2)));
end