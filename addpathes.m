function [ ] = addpathes(app)
%%  Taken from Makarov's bem00_load_model_obs_surf.m file

s = pwd;
if(~isunix)
    slash = '\';
else
    slash = '/';
end

app_function_path = [s, slash, 'AppFunctions'];
charge_engine_path = [s, slash, 'ChargeEngine'];
coil_path = [s, slash, 'Coil'];
model_path = [s, slash, 'Model'];

addpath(genpath(app_function_path));
addpath(genpath(charge_engine_path));
addpath(genpath(coil_path));
addpath(genpath(model_path));
end