function coil = bemfmm_loadCoil(fname)
    % Load coil
    coiltemp = load(fname);
  
    % These fields are used to reset the coil
    coil.strcoil_base = coiltemp.coil.strcoil;
    coil.coilCAD_base = coiltemp.coil.coilCAD;
    
    coil.origin_base = [0 0 0]; % May need to come back to this if we save an offset with coil models
    coil.centerlineDirection_base = [0 0 1]; % same here
    coil.centerlineTheta_base = 0;
        
    % These fields will be updated by functions like bemfmm_positionCoil
    coil.strcoil = coiltemp.coil.strcoil;
    coil.coilCAD = coiltemp.coil.coilCAD;
    
    % Positioning information
    coil.origin = [0 0 0];
    coil.centerlineDirection = [0 0 1];
    coil.centerlineTheta = 0;
    
    % Stimulus information (does not need resets)
    coil.I0 = 0;
    coil.dIdt = 0;
    
end