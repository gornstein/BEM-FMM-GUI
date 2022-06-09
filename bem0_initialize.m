%   This script loads mesh data into the MATLAB workspace. The data include
%   surface meshes and the potential integrals. It also computes useful
%   sparse matrices for GMRES speed up
%
%   Copyright SNM/WAW 2017-2020

s = pwd;
if(~isunix)
    slash = '\';
else
    slash = '/';
end

%   If a simulation has already been run with a different model,
%   that model's path may have been loaded, and the desired model's 
%   files would then be shadowed by the files on the old model path
warning off; rmpath(genpath(s)); warning on;

engine_path =   [s, slash, 'Engine']; 
engine_path2 =  [s, slash, 'Engine_2'];
engine_path4 =  [s, slash, 'Engine_Vis'];
model_path =    [s, slash, 'Model']; %  This line controls which model is loaded
coil_path =     [s, slash, 'Coil'];

addpath(engine_path);
addpath(engine_path2);
addpath(engine_path4);
addpath(model_path);
addpath(coil_path);

%%  Define EM constants
constants.eps0        = 8.85418782e-012;  %   Dielectric permittivity of vacuum(~air)
constants.mu0         = 1.25663706e-006;  %   Magnetic permeability of vacuum(~air)
