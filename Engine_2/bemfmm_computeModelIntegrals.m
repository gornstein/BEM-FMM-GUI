function [model] = bemfmm_computeModelIntegrals(model, RnumberE)

% model:    model structure for which neighbor integrals are to be computed
% RnumberE: number of neighbor triangles for analytical integration (fixed, optimized)

    %% Find topological neighbors
    DT = triangulation(model.t, model.P); 
    tneighbor = neighbors(DT);
    % Fix cases where not all triangles have three neighbors
    tneighbor = pad_neighbor_triangles(tneighbor);    

    %%   Add accurate integration for electric field/electric potential on neighbor facets

    % Find neighbor triangles and precompute analytical integrals
    ineighborE      = knnsearch(model.Center, model.Center, 'k', RnumberE);   % [1:N, 1:Rnumber]
    ineighborE      = ineighborE';
    EC_base         = meshneighborints_2(model.P, model.t, model.normals, model.Area, model.Center, RnumberE, ineighborE);

    model.tneighbor = tneighbor;
    model.RnumberE = RnumberE;
    model.EC_base = EC_base;
    model.ineighborE = ineighborE;
end