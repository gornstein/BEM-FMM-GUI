function obs = bemfmm_computeObsField(obs, coil, model, solution, constants, obsOptions)
    

    Epri        = bemf3_inc_field_electric(coil.strcoil, obs.Points, coil.dIdt, constants.mu0, obsOptions.prec);
    Esec_init   = bemf5_volume_field_electric_plain(obs.Points, solution.c, model.Center, model.Area, obsOptions.prec);
    
    Esec_init(:,1)   = Esec_init(:,1) + obs.EC_x * solution.c;
    Esec_init(:,2)   = Esec_init(:,2) + obs.EC_y * solution.c;
    Esec_init(:,3)   = Esec_init(:,3) + obs.EC_z * solution.c;
    
    obs.FieldEPrimary = Epri;
    obs.FieldESecondary = Esec_init;
end