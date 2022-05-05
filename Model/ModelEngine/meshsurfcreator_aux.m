function [newAUX] = meshsurfcreator_aux(filename1, filename2)
%   Creates the auxiliary observation surface (between GM and WM)
%   Refines the auxiliary surface as 1:4
%   Creates the auxiliary GM with smoothing for graphics  
%   Variations are possible
%
%   filename1 - mat file for the first or outer surface FS (GM)
%   filename2 - mat file for the second or inner surface FI (WM)
%   Does triangle subdivision for the unner surface FI
%
%   SNM 2022

    %   Prepare data
    FS                = load(filename1);    
    [Vnormals, Vdist] = meshsurfcreator(filename1, filename2);    

    %   Create new observation surface (down from old GM)   
    alpha       = 0.5;                  %   midway
    P           = zeros(size(FS.P));
    GAP         = zeros(size(FS.P, 1), 1);
    
    for m = 1:size(P, 1)
        P(m, :) = FS.P(m, :) - alpha*Vdist(m)*Vnormals(m, :); 
    end
    t       = FS.t;
    meshqualityQ1      = min(simpqual(P, t))

    normals = meshnormals(P, FS.t);
    temp    = sign(dot(normals, FS.normals, 2));
    normals = repmat(temp, 1, 3).*normals;

%     %   Refine AUX at one level
%     [P, t, normals] = meshrefiner_light(P, t, normals); 
%     [P, t]          = fixmesh(P, t);     
%     t               = meshreorient(P, t, normals); 

    newAUX.P         = P;
    newAUX.t         = t;
    newAUX.normals   = normals;

%     %   Refine GM at one level and then smooth a bit
%     [P, t, normals] = meshrefiner_light(FS.P, FS.t, FS.normals); 
%     [P, t]          = fixmesh(P, t);     
%     t               = meshreorient(P, t, normals); 
%     %   Smooth
%     DT          = triangulation(t, P); 
%     V           = vertexAttachments(DT);    
%     P = meshlaplace3Dlumped(P, t, V, 1);
%     P = meshlaplace3Dlumped(P, t, V, 1);
% 
%     newAUX.gm.P         = P;
%     newAUX.gm.t         = t;
%     newAUX.gm.normals   = normals;
    
end

