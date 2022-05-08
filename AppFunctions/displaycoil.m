function [ ] = displaycoil(app)
%%  The function called to display the coil

%Loads Coil
Coil        = load('coilCAD.mat');
CoilP = Coil.P;

%   3x3 Rotation Matrix
rotMatrix = [app.MatrixField11.Value, app.MatrixField12.Value, app.MatrixField13.Value;
    app.MatrixField21.Value, app.MatrixField22.Value, app.MatrixField23.Value;
    app.MatrixField31.Value, app.MatrixField32.Value, app.MatrixField33.Value];

%   1x3 Translation Matrix
transMatrix = [app.MatrixField14.Value, app.MatrixField24.Value, app.MatrixField34.Value];

for j = 1:size(CoilP,1)
    Coil.P(j,:) = CoilP(j,:) * rotMatrix + transMatrix;
end

%Makarov's function used to display the coil
bemf1_graphics_coil_CAD(app, Coil.P, Coil.t, 1);

end