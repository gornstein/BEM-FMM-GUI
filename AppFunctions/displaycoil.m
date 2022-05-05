function [ ] = displaycoil(app)
%%  The function called to display the coil

%% Define coil movement using:
% (i) new rotational angle about an axis (theta);
% (ii) new direction of its axis (Nx, Ny, Nz) and;
% (iii) a new position to move to (MoveX MoveY MoveZ)

theta   = -pi/4;                       %    in radians
Nx      = -0.55;
Ny      = +0.16;
Nz      = 1;
MoveX   = app.shiftX;
MoveY   = app.shiftY;
MoveZ   = app.shiftZ;

%Sets up strcoil0
load coil.mat;
strcoil0    = strcoil;

%Sets up Coil0
Coil        = load('coilCAD.mat');
Coil0       = Coil;

[strcoil, Coil, handle] = positioncoil(strcoil0, Coil0, theta, Nx, Ny, Nz, MoveX, MoveY, MoveZ);



bemf1_graphics_coil_CAD(app, Coil.P, Coil.t, 1);

end