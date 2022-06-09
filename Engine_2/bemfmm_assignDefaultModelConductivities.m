function model = bemfmm_assignDefaultModelConductivities(model, condambient)

    % Compute contrast
    [model.contrast, model.condin, model.condout] = assign_conductivities(model.condDefault, condambient, model.Indicator);
    
    model.cond = model.condDefault;
    
    %   Normalize sparse matrix EC by contrast
    N   = size(model.t, 1);
    ii  = model.ineighborE;
    jj  = repmat(1:N, model.RnumberE, 1); 
    CO  = sparse(ii, jj, model.contrast(model.ineighborE));
    model.EC  = CO.*model.EC_base;
    
end