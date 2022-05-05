function se = meshconnte(t, edges)
%   SYNTAX 
%   se = meshconnte(t, edges)
%   DESCRIPTION 
%   This function returns edges (indexes into array edges) for every
%   triangle - a Nx3 array. It is meaningful for manifold meshes only
%
%   Low-Frequency Electromagnetic Modeling for Electrical and Biological
%   Systems Using MATLAB, Sergey N. Makarov, Gregory M. Noetscher, and Ara
%   Nazarian, Wiley, New York, 2015, 1st ed.
%   Find edges (indexes) attached to every triangle (Nx3 array)

    N       = size(t, 1);
    se      = zeros(N, 3);
    t       = sort(t, 2);
    edges   = sort(edges, 2);
    for m = 1:N
        temp1 = edges(:, 1)==t(m, 1)|edges(:, 1)==t(m, 2);
        temp2 = edges(:, 2)==t(m, 2)|edges(:, 2)==t(m, 3);
        se(m, :) = find(temp1&temp2>0);
    end 
    se = sort(se, 2);
end