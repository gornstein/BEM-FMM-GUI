%   This script creates required extracerebral compartments including the
%   observation surface. The design is modular: any compartment can be
%   added/removed
%
%   SNM 2022

%   Create new observation surface
tic
[newAUX] = meshsurfcreator_aux(gm, wm);
CreateAuxTime = toc

%   Create new PIA and new GM
tic
[newGM, newPIA] = meshsurfcreator_pia(gm, wm);
CreatePiaTime = toc

%   Create new ARACH
tic
[newARACH] = meshsurfcreator_arach(csf, gm);
CreateArachnoidTime = toc

%   Create new DURA and new CSF
tic
[newCSF, newDURA] = meshsurfcreator_dura(csf, gm);
CreateDuraTime = toc

%   Create two extra skull surfaces (bottom of the outer table and top of the inner table)
tic
[newBone2, newBone3] = meshsurfcreator_bone(bone, csf);
CreateBoneTime = toc

%   Create two extra skin surfaces (fat and muscle)
tic
[newSkin2, newSkin3] = meshsurfcreator_scalp(skin, bone);
CreateScalpTime = toc

cd ModelEngine    
    save('allnewshells', 'newAUX', 'newGM', 'newPIA', 'newARACH', 'newCSF', 'newDURA', 'newBone2', 'newBone3', 'newSkin2', 'newSkin3');
cd ..
