function Einc = bemf3_inc_field_electric_mag_dip(positions, directivemoments, Points, mu0)  
%   Computes electric field of a number of magnetic dipoles via the FMM
%   in terms of the pseudo electric potentials
%
%   Copyright SNM 2020

    %  Define dipole positions, directions, and moments
    M  = size(positions, 1);
    N  = size(Points, 1);
    segpoints   = positions;   
    moments     = -directivemoments;   %   minus here
   
     %  Compute and normalize pseudo normal vectors
    nx(:, 1) = +0*moments(:, 1);
    nx(:, 2) = -1*moments(:, 3);
    nx(:, 3) = +1*moments(:, 2);
    ny(:, 1) = +1*moments(:, 3);
    ny(:, 2) = +0*moments(:, 2);
    ny(:, 3) = -1*moments(:, 1);
    nz(:, 1) = -1*moments(:, 2);
    nz(:, 2) = +1*moments(:, 1);
    nz(:, 3) = +0*moments(:, 3);

    %   FMM 2019
    srcinfo.nd      = 3;                            %   three charge vectors    
    srcinfo.sources = segpoints';                   %   source points
    targ            = Points';                      %   target points
    prec            = 1e-1;                         %   precision    
    pg      = 0;                                    %   nothing is evaluated at sources
    pgt     = 1;                                    %   potential is evaluated at target points
    srcinfo.dipoles(1, :, :)     = nx.';                             
    srcinfo.dipoles(2, :, :)     = ny.';                             
    srcinfo.dipoles(3, :, :)     = nz.';                       
    U                        = lfmm3d(prec, srcinfo, pg, targ, pgt);
    Einc(:, 1)               = mu0*U.pottarg(1, :)/(4*pi);
    Einc(:, 2)               = mu0*U.pottarg(2, :)/(4*pi);
    Einc(:, 3)               = mu0*U.pottarg(3, :)/(4*pi); 
end

