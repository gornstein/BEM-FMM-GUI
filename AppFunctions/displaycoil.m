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

%   Scale Matrix (m to cm)
scaleMatrix = [100 0 0;
    0 100 0;
    0 0 100];

%   Apply the rotations and transformation to the coil
for j = 1:size(CoilP,1)
    transformedPoint = scaleMatrix * rotMatrix * CoilP(j,:)' + transMatrix';
    Coil.P(j,:) = transformedPoint';
end

if (strcmp(app.VectorfromcoilSwitch.Value, 'On'))
%   display the vector showing the coil direction
    displaycoilnormalvector(app, rotMatrix, transMatrix);
end

if (strcmp(app.VectortocoilSwitch.Value, 'On'))
%   display the vector from the origin to the coil's translation location
    displayvectortocoil(app, transMatrix);
end

%Makarov's function used to display the coil
bemf1_graphics_coil_CAD(app, Coil.P, Coil.t, 1);

end