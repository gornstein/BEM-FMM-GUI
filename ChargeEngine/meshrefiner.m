function [P, t, normals, cinterp] = meshrefiner(P, t, normals, c)
%   This script performs mesh refinement using
%   barycentric triangle subdivision (1:4)
%   INPUTS
%   P       - contains nodes of facets to be refined
%   t       - set of facets to be refined
%   normals - normal vectors of facets to be refined
%   c       - charge on facets to be refined 
%   OUTPUTS
%   P       - nodes of refined triangles only
%   t       - set of refined facets
%   normals - normal vectors of refined facets 
%   cinterp - interpolated charge 

%   Copyright SNM 2021-2022
    
    %% Introduce new nodes
    %   New nodes 12 (between vertices 1 and 2) for every triangle
    P12 = 0.5*(P(t(:, 1), :) + P(t(:, 2), :));
    %   New nodes 13 (between vertices 1 and 3) for every triangle
    P13 = 0.5*(P(t(:, 1), :) + P(t(:, 3), :));
    %   New nodes 23 (between vertices 2 and 3) for every triangle
    P23 = 0.5*(P(t(:, 2), :) + P(t(:, 3), :));
    
    %% Introduce a duplicated set of nodes
    Pnew = [P; P12; P13; P23]; % size(P, 1), size(t, 1), size(t, 1), size(t, 1)
    
    %  Introduce the full set of triangles
    indexp      = size(P, 1);  
    indext      = size(t, 1);   
    array       = [1:indext]';
    
    tA(:, 1)    = array + indexp;                       %   12
    tA(:, 2)    = array + indexp + indext;              %   13    
    tA(:, 3)    = array + indexp + indext + indext;     %   23      
    
    tB(:, 1)    = t(:, 1);                              %   1
    tB(:, 2)    = array + indexp;                       %   12    
    tB(:, 3)    = array + indexp + indext;              %   13 
    
    tC(:, 1)    = t(:, 2);                              %   2
    tC(:, 2)    = array + indexp;                       %   12    
    tC(:, 3)    = array + indexp + indext + indext;     %   23 
    
    tD(:, 1)    = t(:, 3);                              %   3
    tD(:, 2)    = array + indexp + indext;              %   13    
    tD(:, 3)    = array + indexp + indext + indext;     %   23        
    
    tnew = [tA; tB; tC; tD];
    
    %  Remove duplicated nodes    
    [P, t]  = fixmesh(Pnew, tnew);  
    normals = [normals; normals; normals; normals]; 
    cinterp = [c; c; c; c];
end







