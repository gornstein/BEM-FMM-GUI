function [newGM, newPIA] = meshsurfcreator_pia(filename1, filename2)
%   Creates the new pia surface (old GM) and the new GM (down by 0.1 mm)
%   Variations are possible
%
%   filename1 - mat file for the first or outer surface FS
%   filename2 - mat file for the second or inner surface FI
%   Does triangle subdivision for the unner surface FI
%
%   SNM 2022

    %   Prepare data
    FS                = load(filename1);    
    [Vnormals, Vdist] = meshsurfcreator(filename1, filename2);    

    %   Create new GM (down from old GM)
    gap         = 0.1;        % in mm
    P           = zeros(size(FS.P));
    GAP         = zeros(size(FS.P, 1), 1);
    for m = 1:size(P, 1)   
        GAP(m) = min(gap, 0.5*Vdist(m));    %   the last value is the abs minimum
    end
    for m = 1:size(P, 1)
        P(m, :) = FS.P(m, :) - GAP(m)*Vnormals(m, :); 
    end
    t       = FS.t;
    meshqualityQ1      = min(simpqual(P, t))

    normals = meshnormals(P, FS.t);
    temp    = sign(dot(normals, FS.normals, 2));
    normals = repmat(temp, 1, 3).*normals;

    newGM.P         = P;
    newGM.t         = t;
    newGM.normals   = normals;

    %   Create new PIA (up or do not move vs old GM)
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

    newPIA.P         = P;
    newPIA.t         = t;
    newPIA.normals   = normals;    
    
end

