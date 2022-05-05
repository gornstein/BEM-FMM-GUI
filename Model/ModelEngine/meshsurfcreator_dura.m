function [newCSF, newDURA] = meshsurfcreator_dura(filename1, filename2)
%   Creates the new dura surface (old CSF) and the new CSF surface
%   (down by 1.11+0.2 mm DURA + Arachnoid)
%   Variations are possible
%
%   filename1 - mat file for the first or outer surface FS (CSF)
%   filename2 - mat file for the second or inner surface FI (GM)
%   Does triangle subdivision for the unner surface FI
%
%   SNM 2022

    %   Prepare data
    FS                = load(filename1);    
    [Vnormals, Vdist] = meshsurfcreator(filename1, filename2);    

    %   Create new CSF (down from old CSF)
    gap         = 1.31;        %    in mm (1.11+0.2)DURA + Arachnoid
    separation  = 0.20;        %    minimum separation in mm    
    P           = zeros(size(FS.P));
    GAP         = zeros(size(FS.P, 1), 1);
    for m = 1:size(P, 1)   
        GAP(m) = min(gap, Vdist(m)-separation);
    end
    for m = 1:size(P, 1)
        P(m, :) = FS.P(m, :) - GAP(m)*Vnormals(m, :); 
    end
    t       = FS.t;
    meshqualityQ1      = min(simpqual(P, t))

    normals = meshnormals(P, FS.t);
    temp    = sign(dot(normals, FS.normals, 2));
    normals = repmat(temp, 1, 3).*normals;

    newCSF.P         = P;
    newCSF.t         = t;
    newCSF.normals   = normals;

    %   Create new DURA (up or do not move vs old CSF)
    gap         = 0.0;        % in mm
    P           = zeros(size(FS.P));
    GAP         = zeros(size(FS.P, 1), 1);
    for m = 1:size(P, 1)       
        GAP(m) = gap;
    end
    for m = 1:size(P, 1)
        P(m, :) = FS.P(m, :) + GAP(m)*Vnormals(m, :); 
    end
    t       = FS.t;
    meshqualityQ2      = min(simpqual(P, t))
   
    normals = meshnormals(P, FS.t);
    temp    = sign(dot(normals, FS.normals, 2));
    normals = repmat(temp, 1, 3).*normals;

    newDURA.P         = P;
    newDURA.t         = t;
    newDURA.normals   = normals;    
    
end

