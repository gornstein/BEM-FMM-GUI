function model = bemfmm_assembleModel(tissue_manifest)
    [name, tissue, cond, enclosingTissueIdx] = tissue_index_read(tissue_manifest);
    
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

    % Geometric and facet map data
    model.P = P;
    model.t = t;
    model.normals = normals;
    model.Center = Center;
    model.Area = Area;
    model.Indicator = Indicator;
    model.tissue = tissue;
    model.FileNames = name;
    model.condDefault = cond;
    
    % Integrals
    model.EC_base = [];
    model.RnumberE = [];
    model.ineighborE = [];
%    model.tneighbor = tneighbor;
    
    
end