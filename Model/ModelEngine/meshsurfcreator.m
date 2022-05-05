function [Vnormals, Vdist] = meshsurfcreator(filename1, filename2)
%   Computes vector deviation between the two respective surfaces
%
%   filename1 - mat file for the first or outer surface FS
%   filename2 - mat file for the second or inner surface FI
%   Does triangle subdivision for the unner surface FI
%
%   Vnormals - vertex normal vectors of FS directed from the outer surface 
%   to the inner one
%   Vdist    - distances to the second surface along vertex normals
%
%   SNM 2022

    FS          = load(filename1);
    FSCenter    = meshtricenter(FS.P, FS.t);

    FI         = load(filename2);
    HEACenter   = meshtricenter(FI.P, FI.t);

    %   Do FI subdivision
    [coeffS, ~, IndexS]         = tri(5);
    Center_subdiv               = zeros(IndexS*size(FI.t, 1), 3);
    P1                          = FI.P(FI.t(:,1), :);
    P2                          = FI.P(FI.t(:,2), :);
    P3                          = FI.P(FI.t(:,3), :);
    
    %   Find vector distance
    for j = 1:IndexS
        currentIndices                   = ([1:size(FI.t, 1)] - 1)*IndexS + j; 
        Center_subdiv(currentIndices, :) = coeffS(1, j)*P1 + coeffS(2, j)*P2 + coeffS(3, j)*P3;
    end
    wneighbor = knnsearch(Center_subdiv, FSCenter,  'k', 1);   % [1:FS, 1]
    DevVector        = Center_subdiv(wneighbor, :) - FSCenter; 
    DevScalar        = sqrt(dot(DevVector, DevVector, 2));

    %   Find vertex neighbors and vertex normals for FS
    DT          = triangulation(FS.t, FS.P); 
    V           = vertexAttachments(DT);
    Vnormals    = zeros(size(V, 1), 3);
    Vdist       = zeros(size(V, 1), 1);
    for m = 1:size(V, 1)
        Vnormals(m, :)  = sum(FS.normals(V{m}, :), 1);
        Vnormals(m, :)  = Vnormals(m, :)/norm(Vnormals(m, :));
        Vdist(m)        = mean(DevScalar(V{m}));
    end    
end

