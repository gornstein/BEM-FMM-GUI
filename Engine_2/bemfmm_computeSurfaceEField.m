function [EPri, ESec, EDiscin, EDisco] = bemfmm_computeSurfaceEField(model, solution)
% coil is the 
% EPri is the primary field from the coil acting on the model
% ESec is the secondary field from the surface charges acting on their own model
% EDiscin is the discontinuous component of the E-Field just inside a surface
% EDisco is the discontinuous component of the E-Field just outside a surface
% Total electric field just inside a compartment is equal to EPri + ESec + EDiscin
% Total electric field just outside a compartment is equal to EPri + ESec + EDisco

% c is charge density which should come from solution input
% P, t, area, and normals are from the model mesh
C = solution.c;
P = model.P;
t = model.t;
Area = model.Area;
normals = model.normals;

%%  Compute surface electric fields
%   Topological low-pass solution filtering (repeat if necessary)
% C = (c.*Area + sum(c(tneighbor).*Area(tneighbor), 2))./(Area + sum(Area(tneighbor), 2));
[~, ESec] = bemf4_surface_field_electric_subdiv(C, P, t, Area, 'barycentric', 3, 1e-1);
par = -1;    %      par=-1 -> E-field just inside surface; par=+1 -> E-field just outside surface     
EDiscin = par/(2)*normals.*repmat(C, 1, 3);    %   full field
par = +1;    %      par=-1 -> E-field just inside surface; par=+1 -> E-field just outside surface     
EDisco = par/(2)*normals.*repmat(C, 1, 3);    %   full field


EPri = solution.EPri;

end
