function [inoutDistVector, inoutDistScalar] = shellDeviationEstimate(meshOut, meshIn)
    
    % FS == out, HEA == in
    meshOutCenter = meshtricenter(meshOut.P, meshOut.t);
    % meshInCenter = meshtricenter(meshIn.P, meshIn.t);
    
    % Subdivide the inner surface
    [coeffS, weightsS, IndexS]  = tri(5);
    Center_subdiv               = zeros(IndexS*size(meshIn.t, 1), 3);
    
    P1                          = meshIn.P(meshIn.t(:, 1), :);
    P2                          = meshIn.P(meshIn.t(:, 2), :);
    P3                          = meshIn.P(meshIn.t(:, 3), :);
    
    for j = 1:IndexS
        currentIndices                   = ([1:size(meshIn.t, 1)] - 1)*IndexS + j; 
        Center_subdiv(currentIndices, :) = coeffS(1, j)*P1 + coeffS(2, j)*P2 + coeffS(3, j)*P3;
    end
    wneighbor = knnsearch(Center_subdiv, meshOutCenter,  'k', 1);   % [1:FS, 1]
    
    inoutDistVector        = Center_subdiv(wneighbor, :) - meshOutCenter;
    inoutDistScalar        = vecnorm(inoutDistVector, 2, 2);
end