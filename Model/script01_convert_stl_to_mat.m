%   This script converts STL head compartments into MATLAB format (or vice versa)
%   SNM 2022

%   Read STL files 
for m = 1:length(label)
    filename = strcat(model, label{m}, '.stl');
    TR       = stlread(filename);
    P        = TR.Points;
    t        = TR.ConnectivityList;
    [P, t]   = fixmesh(P, t);
    %   Smooth original measehes
    %         if m == 2
    %             alpha   = 1; 
    %             P       = meshlaplace3D(P, t, alpha);
    %             %   disp('smooth bone used')
    %         end
    %   End of smoothing    
    normals  = meshnormals(P, t);
    filename = strcat(model, label{m}, '.mat');
    %   Refine original meshes (1 level of refinement)
    %         [P, t, normals] = meshrefiner_light(P, t, normals); 
    %         [P, t]          = fixmesh(P, t);     
    %         t               = meshreorient(P, t, normals);                 
    %   End of refinement  
    cd ModelEngine
        save(filename, 'P', 't', 'normals');
    cd ..
    disp(filename);
end

% %   And vice versa
% %   This script converts head compartments from MATLAB format to STL format
% %   SNM 2022
% for m = 1:length(label)
%     filename            = strcat(model, label{m}, '.mat');
%     load(filename);    
%     TR                  = triangulation(t, P);   
%     filename = strcat(model, label{m}, '.stl');
%     stlwrite(TR, filename, 'binary');   
% end
%     
    

