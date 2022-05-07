function [ ] = displaycoil(app)
%%  The function called to display the coil

%Loads Coil
Coil        = load('coilCAD.mat');


%Makarov's function used to display the coil
bemf1_graphics_coil_CAD(app, Coil.P, Coil.t, 1);

end