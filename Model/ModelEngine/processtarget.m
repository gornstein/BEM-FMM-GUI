function [TargetSkin1, TargetSkin2, TargetSkin3, TargetSkin4, TargetSkin5] = processtarget(Target, P, t, center)
%   Positions the ring electrodes in coronal and sagittal planes 

    face                = knnsearch(center, Target, 'k', 1);
    TargetSkin1         = center(face, :);                                          %   center electrode
    dir1                = (TargetSkin1 - Target)/norm(TargetSkin1 - Target);        %   center electrode

   
    TargetSkin2         = TargetSkin1;
    TargetSkin3         = TargetSkin1;
    TargetSkin4         = TargetSkin1;
    TargetSkin5         = TargetSkin1;
    
    
    %   Corrector for the distance
    M       = 50;
    DIST    = 27.5;   %   Required distance between electrodes
    
    for m = 1:M
        if norm(TargetSkin1-TargetSkin2)<DIST
            dir2                = dir1 + 2*m/M*[1 0 0]; dir2 = dir2/norm(dir2);
            orig                = Target; dir = dir2; dist = 1e3;
            d                   = meshsegtrintersection(orig, dir, dist, P, t);
            IntersectionPoint   = min(d(d>0));
            TargetSkin2         = orig + dir*IntersectionPoint;
        end
    end
    for m = 1:M
        if norm(TargetSkin1-TargetSkin3)<DIST
            dir3                = dir1 - 12.0*[1 0 m/M]; dir3 = dir3/norm(dir3);             %   large here
            orig                = Target; dir = dir3; dist = 1e3;
            d                   = meshsegtrintersection(orig, dir, dist, P, t);
            IntersectionPoint   = min(d(d>0));
            TargetSkin3         = orig + dir*IntersectionPoint;
        end
    end
    for m = 1:M
        if norm(TargetSkin1-TargetSkin4)<DIST
            dir4                 = dir1 + 10*m/M*[0 1 0]; dir4 = dir4/norm(dir4);
            orig                = Target; dir = dir4; dist = 1e3;
            d                   = meshsegtrintersection(orig, dir, dist, P, t);
            IntersectionPoint   = min(d(d>0));
            TargetSkin4         = orig + dir*IntersectionPoint;
        end
    end
    for m = 1:M
        if norm(TargetSkin1-TargetSkin5)<DIST
            dir5                 = dir1 - 4*m/M*[0 1 0]; dir5 = dir5/norm(dir5);
            orig                = Target; dir = dir5; dist = 1e3;
            d                   = meshsegtrintersection(orig, dir, dist, P, t);
            IntersectionPoint   = min(d(d>0));
            TargetSkin5         = orig + dir*IntersectionPoint;
        end
    end
end