%   This script computes the surface electric fields (just inside/outside
%   any interface) for an inhomogeneous multi-tissue object in an external
%   time-varying magnetic field due to a coil via a subdivision algorithm
%   without any preprocessing
%
%   Copyright WAW/SNM 2020

%%  Compute surface electric fields
tic
h                   = waitbar(0.5, 'Please wait - computing all surface fields'); 
%   Topological low-pass solution filtering (repeat if necessary)
C = (c.*Area + sum(c(tneighbor).*Area(tneighbor), 2))./(Area + sum(Area(tneighbor), 2));
[~, Eadd] = bemf4_surface_field_electric_subdiv(C, P, t, Area, 'barycentric', 3, 1e-1);
par = -1;    %      par=-1 -> E-field just inside surface; par=+1 -> E-field just outside surface     
Ei = Einc + Eadd + par/(2)*normals.*repmat(C, 1, 3);    %   full field
par = +1;    %      par=-1 -> E-field just inside surface; par=+1 -> E-field just outside surface     
Eo = Einc + Eadd + par/(2)*normals.*repmat(C, 1, 3);    %   full field
FieldsTime = toc
close(h)

save output_field_solution Eadd Ei Eo

