function Pnew = meshlaplace3D(P, t, alpha)
%   SYNTAX 
%   P = meshlaplace3D(P, t, nodes, alpha)
%   DESCRIPTION 
%   This function implements lumped Laplacian smoothing 
%   based on existing Delaunay connectivity for a given set of nodes. 
%   Inputs:
%   P - array of vertices; t - array of faces;
%   alpha - weighting parameter
% This function uses an excellent piece of the code by Marc Lalancette, Toronto, Canada, 2014-02-04
%  http://www.mathworks.com/matlabcentral/fileexchange/26982-volume-of-a-surface-triangulation  
      Edges = unique([t(:), [t(:, 2); t(:, 3); t(:, 1)]], 'rows');
      C = sparse(Edges(:, 1), Edges(:, 2), true);
      C = C | C';
      nV = size(P, 1);
      CCell = cell(nV, 1);
      for v = 1:nV
        CCell{v} = find(C(:, v));
      end
      % Number of connected neighbors at each vertex.
      nC = full(sum(C, 1));
      clear C
      Pnew = P;
      for m = 1:nV                                  
            Pnew(m, :) = alpha*sum(P(CCell{m}, :))/nC(m)+(1-alpha)*P(m, :);   
      end  
end