function [Pi, ti, polymask, flag] = meshplaneintGeneral(P, t, edges, TriP, TriM, planeABCD) 
%   This function implements the mesh intersection algorithm for a general plane
%   planeABCD: [A B C D] coefficients for plane equation of form Ax+By+Cz+D = 0
%   Output:
%   flag = 0 -> no intersection
%   Pi - intersection nodes
%   polymask - edges formed by intersection nodes
%   ti - indexes into intersected triangles
%
%   Copyright WAW/SNM 2017-2022

    n = planeABCD(1:3);
    D = planeABCD(4);
    if(n(3) ~= 0)
        p = [0, 0, -D/n(3)]; % A point on the plane: specifically the point through which the plane passes at x = y = 0.
    elseif(n(2) ~= 0)
        p = [0, -D/n(2), 0];
    else
        p = [-D/n(1), 0, 0];
    end
    
%   Make sure there are no nodes straight on the plane!
    while 1
        %index1  = P(edges(:, 1), 3)==Z; 
        %index2  = P(edges(:, 2), 3)==Z;
        index   = P*transpose(n)+D == 0; % Find values of P satisfying the plane equation
        
        if any(index)
            D = D + 1e-9;
        else
            break;
        end 
    end    
    
    flag = 1;
    Pi = [];
    ti = [];
    polymask = [];
    
    %   Find all edges (edgesI) intersecting the given plane
    index1  = P(edges(:, 1), :) * transpose(n) + D > 0;
    index2  = P(edges(:, 2), :) * transpose(n) + D > 0;
    index3  = P(edges(:, 1), :) * transpose(n) + D < 0;
    index4  = P(edges(:, 2), :) * transpose(n) + D < 0;
    
    indexU  = index1&index2;
    indexL  = index3&index4;
    indexI  = (~indexU)&(~indexL);
    edgesI  = edges(indexI, :);     %   sorted
    E       = size(edgesI, 1);
    if E==0
        flag = 0;
        return;
    end    
    
    %   Find all intersection points (Pi)
    N   = repmat(n, [E 1]);                         % repmat plane normal
    Pn  = repmat(p, [E 1]);                         % repmat plane center
    V2      = P(edgesI(:, 2), :);
    V1      = P(edgesI(:, 1), :);
    dot1    = dot(N, (V2 - Pn), 2);
    dot2    = dot(N, (V2 - V1), 2);
    dot3    = dot1./dot2; 
    Pi      = V2 - (V2-V1).*repmat(dot3, [1 3]);
    
    %  Establish pairs of interconnected edge nodes
    TP = TriP(indexI);
    TM = TriM(indexI);
    AttTrianglesU  = unique([TP' TM'])';
    E1 = length(AttTrianglesU);    
    polymask = zeros(E1, 2);
    for m = 1:E1
        temp1 = find(TP==AttTrianglesU(m));
        temp2 = find(TM==AttTrianglesU(m));
        temp  = unique([temp1' temp2']);
        polymask(m, :)= temp;
    end
    ti = AttTrianglesU;
end