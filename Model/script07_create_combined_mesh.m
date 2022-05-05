%   This script creates the combined tissue/head mesh
%
%   SNM 2022

%  Combine individual meshes into a single mesh
tic
PP          = [];
tt          = [];
nnormals    = [];
Indicator   = [];
for m = 1:length(newname)
    load(newname{m}); 
    [P, t]      = fixmesh(P, t);
    t           = meshreorient(P, t, normals);                          % j ust in case, optional
    P           = P*1e-3;     %  only if the original data were in mm!
    tt          = [tt; t+size(PP, 1)];
    PP          = [PP; P];
    nnormals    = [nnormals; normals];    
    Indicator   = [Indicator; repmat(m, size(t, 1), 1)];
    disp(['Successfully loaded file [' newname{m} ']']);
end
t = tt;
P = PP;
normals = nnormals;
LoadBaseDataTime = toc

%   Process other mesh data
Center      = 1/3*(P(t(:, 1), :) + P(t(:, 2), :) + P(t(:, 3), :));  %   face centers
Area        = meshareas(P, t);                                      %   face areas

%   This block finds all edges and attached triangles for separate brain
%   compartments. It is required for the subsequent visualizations.
m_max   = length(tissue);
tS      = cell(m_max, 1);
nS      = tS; %  Reuse this empty cell array for other initialization
eS      = tS;
TriPS   = tS;
TriMS   = tS;
PS      = P * 1e3; % Convert to mm
for m = 1:m_max
    tS{m}                       = t(Indicator == m, :);
    nS{m}                       = normals(Indicator == m, :);
    [eS{m}, TriPS{m}, TriMS{m}] = mt(tS{m}); , 
end
SurfaceDataProcessTime = toc

%   Save base data
cd ModelEngine
    FileName = 'CombinedMesh.mat';
    save(FileName, 'P', 't', 'normals', 'Area', 'Center', 'Indicator', 'tS', 'eS', 'nS', 'TriPS', 'TriMS');
    ProcessBaseDataTime = toc
cd ..
