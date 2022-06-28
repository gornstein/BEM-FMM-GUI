function obs = bemfmm_computeObsField_oneshot(obs, coil, model, solution, constants, obsOptions)

    Epri = bemf3_inc_field_electric(coil.strcoil, obs.Points, coil.dIdt, constants.mu0, obsOptions.prec);
    Esec = bemf6_volume_field_electric(obs.Points, solution.c, model.P, model.t, model.Center, model.Area, model.normals);


    obs.FieldEPrimary = Epri;
    obs.FieldESecondary = Esec;
end