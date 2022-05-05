function [ ] = addpathes(app)
%%  Taken from Makarov's bem00_load_model_obs_surf.m file

s = pwd;
if(~isunix)
    slash = '\';
else
    slash = '/';
end

%   If a simulation has already been run with a different model,
%   that model's path may have been loaded, and the desired model's
%   files would then be shadowed by the files on the old model path
%   warning off; rmpath(genpath(s)); warning on; DON'T KNOW IF THIS IS
%   NECESSARY


app_function_path = [s, slash, 'AppFunctions'];
charge_engine_path = [s, slash, 'ChargeEngine'];
coil_path = [s, slash, 'Coil'];
model_path = [s, slash, 'Model'];

addpath(genpath(app_function_path));
addpath(genpath(charge_engine_path));
addpath(genpath(coil_path));
addpath(genpath(model_path));
%%  Sample code from the original files

%engine_path     =   [s, slash, 'ChargeEngine'];
%model_path      =    [s(1:end-11), slash, 'Model']; %  This line controls which model is loaded, if there are multiple
%coil_path      =     [s(1:end-11), slash, 'Coil']; %  This line controls which model is loaded, if there are multiple
%model_data_path =    [s(1:end-11), slash, 'Model', slash, 'ModelEngine']; %  This line controls which model is loaded, if there are multiple

%addpath(engine_path);
%addpath(model_path);
%addpath(coil_path);
%addpath(model_data_path);

end