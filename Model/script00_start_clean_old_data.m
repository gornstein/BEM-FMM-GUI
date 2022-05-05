%   This script sets path(s) and clean all previous MATLAB data
%   SNM 2022

model = '120111';

s = pwd;
warning off; rmpath(genpath(s)); warning on;
if(~isunix)
    slash = '\';
else
    slash = '/';
end
model_path = [s, slash, 'ModelEngine'];
addpath(model_path);

label{1} = '_skin_headreco';
label{2} = '_bone_headreco';
label{3} = '_csf_headreco';
label{4} = '_gm_headreco';
label{5} = '_wm_headreco';
label{6} = '_ventricles_headreco';
label{7} = '_eyes_headreco';

%   Original compartments - names
skin            = strcat(model, label{1});
bone            = strcat(model, label{2});
csf             = strcat(model, label{3});
gm              = strcat(model, label{4});
wm              = strcat(model, label{5});
ventricles      = strcat(model, label{6});
eyes            = strcat(model, label{7});

cd ModelEngine
    %   Clean all previous data (clean all old MATLAB data files)
    files    = '*.mat'; listing  = dir(files);
    if ~isempty(listing)
        delete(listing(:).name);
    end
    save('oldtissuelist',  'skin', 'bone', 'csf', 'gm', 'wm', 'ventricles', 'eyes', 'label', 'model');
cd ..