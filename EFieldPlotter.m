load("SurfaceFields.mat");
% EFieldPlotter plots normal and/or tangential EField on any surface

% tissueNumber = 1; % Cerebellum
% tissueNumber = 2; % CSF
% tissueNumber = 3; % GM
% tissueNumber = 4; % Skin
% tissueNumber = 5; % Skull
% tissueNumber = 6; % Ventricles
% tissueNumber = 7; % WM

tissueNumber = 7; % GM
coilNumber = 1; % selected coil if you've exported multiple
srf = CoilFields{coilNumber}{tissueNumber};

FQ = dot(srf.innerField, srf.normals, 2); % srf.innerField for inside field and .outerField for field outside surface
% FQ(FQ<0) = 0; % only positive normal field is plotted
DT          = triangulation(srf.t, srf.P); 
tneighbor   = neighbors(DT);
FQ           = mean(FQ(tneighbor), 2);

f = figure; ax = gca;
patch('faces', srf.t, 'vertices', srf.P, 'FaceVertexCData', FQ, 'FaceColor', 'flat', 'EdgeColor', 'none', 'FaceAlpha', 1.0);
colormap(vpmkmp(256, 'Swtth'));
brighten(0.33);
colorbar;
camlight;
lighting phong;
xlabel('x, m'); ylabel('y, m'); zlabel('z, m');
set(gca,'Color','White');
axis equal;
title "Normal Component"

FQ = cross(srf.innerField, srf.normals, 2); % srf.innerField for inside field and .outerField for field outside surface
FQ = sqrt(dot(FQ, FQ, 2));
DT          = triangulation(srf.t, srf.P); 
tneighbor   = neighbors(DT);
FQ           = mean(FQ(tneighbor), 2);

f = figure; ax = gca;
patch('faces', srf.t, 'vertices', srf.P, 'FaceVertexCData', FQ, 'FaceColor', 'flat', 'EdgeColor', 'none', 'FaceAlpha', 1.0);
colormap(vpmkmp(256, 'Swtth'));
brighten(0.33);
colorbar;
camlight;
lighting phong;
xlabel('x, m'); ylabel('y, m'); zlabel('z, m');
set(gca,'Color','White');
axis equal;
title "Tangential Component"
