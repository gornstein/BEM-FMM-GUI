function solution = bemfmm_chargeEngineBase(model, coil, constants, solverOptions)
    % Unpack inputs (cheap as long as we don't modify them)
    P = model.P;
    t = model.t;
    normals = model.normals;
    contrast = model.contrast;
    Center   = model.Center;
    Area     = model.Area;
    EC       = model.EC;
    
    EincP = bemf3_inc_field_electric_generic(coil, P, constants, solverOptions);
    Einc = 1/3*(EincP(t(:,1), :) + EincP(t(:, 2), :) + EincP(t(:, 3), :));
    
    % Matrix RHS
    b = 2 * (contrast.*sum(normals.*Einc, 2));
    
    MATVEC = @(c_temp) c_temp + bemf4_surface_field_lhs(c_temp, Center, Area, contrast, normals, solverOptions.weight, EC, solverOptions.prec);
    [c, its, resvec] = fgmres(MATVEC, b, solverOptions.relRes, 'restart', solverOptions.maxIter, 'x0', b);
    
    solution.c = c;
    solution.residuals = resvec;
    solution.iterations = its;
    solution.EPri = Einc;
    
end