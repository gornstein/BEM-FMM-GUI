function [EPri, ESec, EDisc] = bemfmm_computeSurfaceEField(coil, model, solution, constants, obsOptions)

%bemf4_surface_field_electric_subdiv(c, P, t, Area, mode, modeArg, prec) 

%%  Compute surface electric fields
%   Topological low-pass solution filtering (repeat if necessary)
% C = (c.*Area + sum(c(tneighbor).*Area(tneighbor), 2))./(Area + sum(Area(tneighbor), 2));
[~, Eadd] = bemf4_surface_field_electric_subdiv(C, P, t, Area, 'barycentric', 3, 1e-1);
par = -1;    %      par=-1 -> E-field just inside surface; par=+1 -> E-field just outside surface     
Ei = Einc + Eadd + par/(2)*normals.*repmat(C, 1, 3);    %   full field
par = +1;    %      par=-1 -> E-field just inside surface; par=+1 -> E-field just outside surface     
Eo = Einc + Eadd + par/(2)*normals.*repmat(C, 1, 3);    %   full field

end
