function [P, t, normals] = mesh_refinement(P, t, normals, SphereC, SphereR)
%   DESCRIPTION 
%   This script performs mesh refinement in a selected domain using
%   barycentric triangle subdivision. The input mesh must be 2 manifold
%
%   Low-Frequency Electromagnetic Modeling for Electrical and Biological
%   Systems Using MATLAB, Sergey N. Makarov, Gregory M. Noetscher, and Ara
%   Nazarian, Wiley, New York, 2015, 1st ed.

%     %   Define the sphere where the mesh is refined
%     SphereC = [3.62 4.90 79.45];
%     SphereR = 10;

    t = sort(t, 2);

    tic
    %   Index into edges to be refined
    edges = meshconnee(t);
    center  = 1/2*(P(edges(:, 1), :) + P(edges(:, 2), :));

    dist    = center - repmat(SphereC, size(center, 1), 1);
    dist 	= sqrt(dot(dist, dist, 2));
    index   = find(dist<SphereR);

    %   Nodes to be added up front
    Nodes = center(index, :);
    P = [Nodes; P];
    t       = t + size(Nodes, 1);
    edges   = edges + size(Nodes, 1);
    %   Edges attached to every triangle
    se      = meshconnte(t, edges);

    %   Triangles/normals to be added/removed
    remove      = [];
    add         = [];
    nremove     = [];
    nadd        = [];
    for m = 1:size(t, 1)
        temp1 = find(index==se(m, 1));
        temp2 = find(index==se(m, 2));
        temp3 = find(index==se(m, 3));
        node1 = intersect(edges(se(m, 1), :), edges(se(m, 3), :));
        node2 = intersect(edges(se(m, 1), :), edges(se(m, 2), :));
        node3 = intersect(edges(se(m, 2), :), edges(se(m, 3), :));
        if ~isempty(temp1)|~isempty(temp2)|~isempty(temp3)
            remove  = [remove m];
            nremove = [nremove m];
            if temp1&temp2&temp3            
                add = [ [temp1 temp2 temp3];...
                        [temp1 temp2 node2];...
                        [temp1 temp3 node1];...               
                        [temp2 temp3 node3];...
                        add];
                nadd = [ normals(m, :);...
                         normals(m, :);...
                         normals(m, :);...
                         normals(m, :); nadd];
            end
            if temp1&temp2&(isempty(temp3))
                add = [ [temp1 temp2 node2];...
                        [temp1 temp2 node1];...               
                        [temp2 node1 node3];...
                        add];
                nadd = [ normals(m, :);...
                         normals(m, :);...                   
                         normals(m, :); nadd];                
            end
            if temp1&temp3&(isempty(temp2))
                add = [ [temp1 temp3 node1];...
                        [temp1 temp3 node3];...               
                        [temp1 node2 node3];...
                        add];
                nadd = [ normals(m, :);...
                         normals(m, :);...                   
                         normals(m, :);nadd];          
            end
            if temp2&temp3&(isempty(temp1))
                add = [ [temp2 temp3 node3];...
                        [temp2 temp3 node1];...               
                        [temp2 node1 node2];...
                        add];
               nadd = [ normals(m, :);...
                         normals(m, :);...                   
                         normals(m, :); nadd];          
            end
            if temp1&(isempty(temp2))&(isempty(temp3))
                add = [ [temp1 node1 node3];...    
                        [temp1 node2 node3];...
                        add];
                nadd = [ normals(m, :);...               
                         normals(m, :); nadd];          
            end
            if temp2&(isempty(temp1))&(isempty(temp3))
                add = [ [temp2 node1 node2];...    
                        [temp2 node1 node3];...
                        add];
                nadd = [ normals(m, :);...               
                         normals(m, :); nadd];                      
            end
            if temp3&(isempty(temp1))&(isempty(temp2))
                add = [ [temp3 node1 node2];...    
                        [temp3 node2 node3];...
                        add];  
               nadd = [ normals(m, :);...               
                         normals(m, :); nadd];      
            end
        end
    end

    t(remove, :)            = [];
    normals(nremove, :)     = [];
    t                       = [t; add];
    normals                 = [normals; nadd];
    t                       = sort(t, 2);    
    RefTime = toc
end





