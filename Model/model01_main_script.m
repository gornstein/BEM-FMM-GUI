%   This is a mesh processor script: it computes basis triangle parameters
%   and necessary potential integrals, and constructs a combined mesh of a
%   multi-object structure (for example, a head or a whole body)
%
%   Copyright SNM/WAW 2017-2021

if ~isunix
    s = pwd; addpath(strcat(s(1:end-6), '\Engine'));
else
    s = pwd; addpath(strcat(s(1:end-6), '/Engine'));
end

%% Load tissue filenames and tissue display names from index file
index_name = 'tissue_index.txt';
[name, tissue, cond, enclosingTissueIdx] = tissue_index_read(index_name);

%% Load tissue meshes and combine individual meshes into a single mesh
tic
PP = [];
tt = [];
nnormals = [];
IndicatorIn = [];

% Combine individual meshes into a single mesh
for m = 1:length(name)
    load(name{m}); 
    P = P*1e-3;     %  only if the original data were in mm!
    tt = [tt; t+size(PP, 1)];
    PP = [PP; P];
    nnormals = [nnormals; normals];    
    IndicatorIn= [IndicatorIn; repmat(m, size(t, 1), 1)];
    disp(['  Successfully loaded file [' name{m} ']']);
end
t = tt;
P = PP;
normals = nnormals;
t = meshreorient(P, t, normals); % Preemptively fix triangle orientation
disp(['Component meshes loaded in ' num2str(toc) ' s']);

%% Compute additional facet properties
tic
Indicator = assign_initial_indicator(IndicatorIn, enclosingTissueIdx);
Center      = 1/3*(P(t(:, 1), :) + P(t(:, 2), :) + P(t(:, 3), :));  % Face centers
Area        = meshareas(P, t);                                      % Face areas  
disp(['Facet properties assigned in ' num2str(toc) ' s']);

%% Check for and process triangles that have coincident centroids
tic
disp('Checking combined mesh for duplicate facets ...');
[coincidentFacets, Center] = find_coincident_facets(P, t, normals, Center);

disp('  Resolving duplicate facets ...');
if(~isempty(coincidentFacets))
    keepFacet = coincidentFacets(:,1);
    deleteFacet = coincidentFacets(:,2);
    
    % The outer material of the facet to be kept is equivalent 
    % to the inner material of the facet to be deleted
    Indicator(keepFacet, 2) = Indicator(deleteFacet, 1);
    
    % Delete duplicated facets and all associated information
    areas(deleteFacet,:) = [];
    centroids(deleteFacet,:) = [];
    Indicator(deleteFacet,:) = [];
    normals(deleteFacet,:) = [];
    t(deleteFacet,:) = [];
end

%Remove unreferenced vertices
[P, t] = fixmesh(P, t, 0);
disp(['Resolved all duplicate facets in ' num2str(toc) ' s']);

%% Save base data
tic
FileName = 'CombinedMesh.mat';
save(FileName, 'P', 't', 'normals', 'Area', 'Center', 'Indicator', 'name', 'tissue', 'cond', 'enclosingTissueIdx');
disp(['Geometric mesh data saved in ' num2str(toc) ' s']);

%% Find topological neighbors
DT = triangulation(t, P); 
tneighbor = neighbors(DT);
% Fix cases where not all triangles have three neighbors
tneighbor = pad_neighbor_triangles(tneighbor);

%%   Add accurate integration for electric field/electric potential on neighbor facets
% Start parallel pool if one is not already running with the proper number of threads
tic
numThreads = 15;            %   number of cores to be used
tempPool = gcp('nocreate'); %   See if a parallel pool already exists
if isempty(tempPool) || tempPool.NumWorkers ~= numThreads
    delete(gcp('nocreate'));
    parpool(numThreads);
end
disp(['Parallel pool started in ' num2str(toc) ' s']);

% Find neighbor triangles and precompute analytical integrals
RnumberE        = 16;    % number of neighbor triangles for analytical integration (fixed, optimized)
ineighborE      = knnsearch(Center, Center, 'k', RnumberE);   % [1:N, 1:Rnumber]
ineighborE      = ineighborE';
EC_base         = meshneighborints_2(P, t, normals, Area, Center, RnumberE, ineighborE, numThreads);

% Save neighbor integrals
tic
NewName  = 'CombinedMeshP.mat';
save(NewName, 'tneighbor',  'RnumberE',   'ineighborE', 'EC_base', '-v7.3');
disp(['Neighbor integrals saved in ' num2str(toc) ' s']);