function Einc = bemf3_inc_field_electric_generic(coil, Points, constants, options)

if (strcmp(coil.Type, 'curdip'))
    Einc = bemf3_inc_field_electric(coil.strcoil, Points, coil.dIdt, constants.mu0, options.prec);
elseif (strcmp(coil.Type, 'magdip'))
    Einc = bemf3_inc_field_electric_mag_dip(coil.strcoil.positions, coil.strcoil.directivemoments, Points, constants.mu0);
else
    error("Unrecognized coil definition");
end

end