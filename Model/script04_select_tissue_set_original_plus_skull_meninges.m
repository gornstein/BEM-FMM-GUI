%   This script selects the model compartments: 
%   standard + outer table + diploe + inner table 
%
%   SNM 2022

cd ModelEngine

    %   First, all old compartments will be deleted 
    files    = strcat('*', model, 'new*.mat'); listing  = dir(files);
    if ~isempty(listing)
        delete(listing(:).name);
    end
    
    %   Now, the new compartments will be listed (in the enclosing order)
    %   This block varies depending on what we'd like to put in 
    clear newname; clear auxname;
    
   %   Auxiliary observation surface and auxiliary smooth GM
    P = newAUX.P; t = newAUX.t; normals = newAUX.normals;  
    auxname1   = strcat(model, 'new', '__aux');
    save(auxname1, 'P', 't', 'normals');
    
    %   SKIN
    i = 1;  tissue{i} = 'SKIN'; tissue_outside{i} = 'AIR';
    load(skin); 
    newname{i} = strcat(model, 'new', label{1});
    color(i, :) = [1 1 1]; 
    save(newname{i}, 'P', 't', 'normals');
    
    %   BONE OUTER
    i = 2;  tissue{i} = 'BONEOUTER'; tissue_outside{i} = 'SKIN';
    load(bone); 
    newname{i} = strcat(model, 'new', label{2});
    color(i, :) = [0 1 1]; 
    save(newname{i}, 'P', 't', 'normals');
    
    %   BONE DIPLOE
    i = 3;  tissue{i} = 'BONEDIPLOE'; tissue_outside{i} = 'BONEOUTER';
    newname{i} = strcat(model, 'new', '_diploe_headreco');
    P = newBone2.P; t = newBone2.t; normals = newBone2.normals;  
    color(i, :) = [0 1 1]; 
    save(newname{i}, 'P', 't', 'normals');
    
    %   BONE INNER
    i = 4;  tissue{i} = 'BONEINNER'; tissue_outside{i} = 'BONEDIPLOE';
    newname{i} = strcat(model, 'new', '_innertable_headreco');
    P = newBone3.P; t = newBone3.t; normals = newBone3.normals;  
    color(i, :) = [0 1 1]; 
    save(newname{i}, 'P', 't', 'normals');
    
    %   DURA
    i = 5;  tissue{i} = 'DURA'; tissue_outside{i} = 'BONEINNER';
    newname{i} = strcat(model, 'new', '_dura_headreco');
    P = newDURA.P; t = newDURA.t; normals = newDURA.normals;  
    color(i, :) = [1 0.75 0.65]; 
    save(newname{i}, 'P', 't', 'normals');
    
    %   ARACHNOID
    i = 6;  tissue{i} = 'ARACHNOID'; tissue_outside{i} = 'DURA';
    newname{i} = strcat(model, 'new', '_arach_headreco');
    P = newARACH.P; t = newARACH.t; normals = newARACH.normals;
    color(i, :) = [1 0.75 0.65]; 
    save(newname{i}, 'P', 't', 'normals');
    
    %   CSF
    i = 7;  tissue{i} = 'CSF'; tissue_outside{i} = 'ARACHNOID';
    newname{i} = strcat(model, 'new', '_csf_headreco');
    P = newCSF.P; t = newCSF.t; normals = newCSF.normals; 
    color(i, :) = [1 0.75 0.65]; 
    save(newname{i}, 'P', 't', 'normals');   
    
    %   PIA
    i = 8;  tissue{i} = 'PIA'; tissue_outside{i} = 'CSF';
    newname{i} = strcat(model, 'new', '_pia_headreco');
    P = newPIA.P; t = newPIA.t; normals = newPIA.normals; 
    color(i, :) = [1 0.75 0.65]; 
    save(newname{i}, 'P', 't', 'normals');
    
    %   GM
    i = 9;  tissue{i} = 'GM'; tissue_outside{i} = 'PIA';
    newname{i} = strcat(model, 'new', label{4});
    P = newGM.P; t = newGM.t; normals = newGM.normals;
    color(i, :) = [1 0.75 0.65]; 
    save(newname{i}, 'P', 't', 'normals');
    
    %   WM
    i = 10;  tissue{i} = 'WM'; tissue_outside{i} = 'GM';
    load(wm); 
    newname{i} = strcat(model, 'new', label{5});
    color(i, :) = [1 0.75 0.65];
    save(newname{i}, 'P', 't', 'normals');
    
    %   VENTRICLES
    i = 11;  tissue{i} = 'VENTRICLES'; tissue_outside{i} = 'WM';
    load(ventricles); 
    newname{i} = strcat(model, 'new', label{6});
    color(i, :) = [1 0.75 0.65];
    save(newname{i}, 'P', 't', 'normals');
    
     %   EYES
    i = 12;  tissue{i} = 'EYES'; tissue_outside{i} = 'SKIN';
    load(eyes); 
    newname{i} = strcat(model, 'new', label{7});
    color(i, :) = [1 0.75 0.65]; 
    save(newname{i}, 'P', 't', 'normals');
    
    %   Save the full list(s)
    save('tissuelist', 'newname', 'tissue', 'tissue_outside', 'auxname1', 'color');
cd ..