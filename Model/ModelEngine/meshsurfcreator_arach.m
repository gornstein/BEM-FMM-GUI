function [newARACH] = meshsurfcreator_arach(filename1, filename2)
%   Creates the new arachnoid surface (down by 1.11 mm from CSF)
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

    %   Create new ARACH (down from old CSF)
    gap         = 1.11;        %    in mm 1.11 from new DURA (old CSF)
    separation  = 0.30;        %    minimum separation in mm    
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

    newARACH.P         = P;
    newARACH.t         = t;
    newARACH.normals   = normals;
    
end

