function [newBone2, newBone3] = meshsurfcreator_bone(filename1, filename2)
    
%   Creates the skull asssembly:
%      Bone1 = Bone (old skull) - Top of outer table (cortical)
%   NewBone2 = Bottom of outer table (cortical) - New
%   NewBone3 = Bottom of diploe (cancellous) - New
%      Bone4 = Dura (old CSF) - Bottom of inner table (cortical)
%   Variations are possible
%
%   filename1 - mat file for the first or outer surface FS (bone)
%   filename2 - mat file for the second or inner surface FI (csf)
%   Does triangle subdivision for the unner surface FI
%
%   SNM 2022

    FS                = load(filename1);    
    [Vnormals, Vdist] = meshsurfcreator(filename1, filename2);    

    %%   Create newBone2 - diploe (down from old skull by 30% of the initial separation) 
    %  Introduce superior-inferior variations: Move a lttle, if any, at the bottom
    margin1 = -30;  % in mm         anterior
    margin2 = -40;  % in mm 
    margin3 = -70;  % in mm         posterior
    margin4 = -80;  % in mm 
    Corrector = zeros(size(FS.P, 1), 1);
    for m = 1:size(FS.P, 1)   
        Corrector(m) = 1;
        if FS.P(m, 2) > -40 
            if FS.P(m, 3) < margin1
                Corrector(m) = 1 - (margin1-FS.P(m, 3))/(margin1-margin2);
            end
            if FS.P(m, 3) < margin2
                Corrector(m) = 0;
            end
        end
        if FS.P(m, 2) <= -40 
            if FS.P(m, 3) < margin3
                Corrector(m) = 1 - (margin3-FS.P(m, 3))/(margin3-margin4);
            end
            if FS.P(m, 3) < margin4
                Corrector(m) = 0;
            end
        end
    end

    
    gap         = 0.20;        %    in mm    
    P           = zeros(size(FS.P));
    GAP         = zeros(size(FS.P, 1), 1);
    for m = 1:size(P, 1)   
        GAP(m) = max(gap, 0.3*Vdist(m)*Corrector(m));
    end
    for m = 1:size(P, 1)
        P(m, :) = FS.P(m, :) - GAP(m)*Vnormals(m, :); 
    end
    t       = FS.t;
    meshqualityQ2      = min(simpqual(P, t))

%     %   Optional smoothing
%     alpha   = 1; 
%     P       = meshlaplace3D(P, t, alpha);

    normals             = meshnormals(P, t);
    temp                = sign(dot(normals, FS.normals, 2));
    normals             = repmat(temp, 1, 3).*normals;
    newBone2.P          = P;
    newBone2.t          = t;
    newBone2.normals    = normals;

    %%   Create newBone3 -inner table (up from old CSF by 30%-20% of the initial separation)
    % Introduce anterior-posterior variations
    % Find vertex of the skull
    [~, index] = max(FS.P(:, 3));
    Factor = FS.P(:, 2) - repmat(FS.P(index, 2), size(FS.P, 1), 1);
    Factor(Factor>0) = 1;                           % frontal lobe 
    Factor(Factor<0) = exp(0.1*Factor(Factor<0));   % parietal lobe 

    gap         = 0.20*2;        % in mm
    P           = zeros(size(FS.P));
    GAP         = zeros(size(FS.P, 1), 1);
    for m = 1:size(P, 1)   
        NewRelDist  = 0.7 + 0.1*(1-Factor(m)); % from 0.7 to 0.8 here   
        GAP(m)      = max(gap, NewRelDist*Vdist(m)*Corrector(m));
    end
    for m = 1:size(P, 1)
        P(m, :) = FS.P(m, :) - GAP(m)*Vnormals(m, :); 
    end
    t       = FS.t;
   meshqualityQ3      = min(simpqual(P, t))

%     %   Optional smoothing
%     alpha   = 1; 
%     P       = meshlaplace3D(P, t, alpha);

    normals = meshnormals(P, t);
    temp    = sign(dot(normals, FS.normals, 2));
    normals = repmat(temp, 1, 3).*normals;

    newBone3.P         = P;
    newBone3.t         = t;
    newBone3.normals   = normals;
end

