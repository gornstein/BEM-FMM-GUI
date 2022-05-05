%   This script displays a mesh from a *.mat P-t file and reports the
%   number of triangles, minimum triangle quality, and minimum edge length

%   SNM 2012-2022
FileName = uigetfile('*.mat','Select the tissue mesh file to open'); load(FileName, '-mat');

p = patch('vertices', P, 'faces', t);
p.FaceColor = [1 0.75 0.65];
p.EdgeColor = 'k';
p.FaceAlpha = 1.0;
daspect([1 1 1]);
camlight; lighting phong;
xlabel('x, mm'); ylabel('y, mm'); zlabel('z, mm');
    
Mesh.NumberOfNodes           = size(P, 1);
Mesh.NumberOfFacets          = size(t, 1);
Mesh.DimX = max(P(:, 1)) - min(P(:, 1));
Mesh.DimY = max(P(:, 2)) - min(P(:, 2));
Mesh.DimZ = max(P(:, 3)) - min(P(:, 3));
Mesh


