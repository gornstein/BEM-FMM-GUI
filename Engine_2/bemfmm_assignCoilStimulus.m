function coil = bemfmm_assignCoilStimulus(coil, I, dIdt)

    coil.I0 = I;
    coil.dIdt = dIdt;

end