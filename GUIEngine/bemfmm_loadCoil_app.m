function coil = bemfmm_loadCoil_app(fnamecoil, fnamecoilcad)
    % Load the two coil .mat files (used in GUI)
    load(fnamecoil);
    coilCAD = load(fnamecoilcad);

    % Concatenate both coil files for use here
    coiltemp = struct('strcoil', strcoil, 'coilCAD', coilCAD);
  
    % These fields are used to reset the coil
    coil.strcoil_base = coiltemp.strcoil;
    coil.coilCAD_base = coiltemp.coilCAD;
    
    coil.origin_base = [0 0 0]; % May need to come back to this if we save an offset with coil models
    coil.centerlineDirection_base = [0 0 1]; % same here
    coil.centerlineTheta_base = 0;
        
    % These fields will be updated by functions like bemfmm_positionCoil
    coil.strcoil = coiltemp.strcoil;
    coil.coilCAD = coiltemp.coilCAD;
    
    % Positioning information
    coil.origin = [0 0 0];
    coil.centerlineDirection = [0 0 1];
    coil.centerlineTheta = 0;
    
    % Stimulus information (does not need resets)
    coil.I0 = 0;
    coil.dIdt = 0;
    
    if (isfield(coil.strcoil, 'directivemoments'))
        coil.Type = 'magdip';
    else
        coil.Type = 'curdip';
    end
    
end