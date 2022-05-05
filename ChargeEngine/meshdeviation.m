function [D] = meshdeviation(Psurf, tsurf, Pobs)
%   This function computes minimum distances from any surface (Psurf,
%   tsurf, from face centers) to the observation surface nodes(Pobs)
%   without subdivision 
%
%   Copyright SNM 2021

%   Brain compartment   
FSCenter    = meshtricenter(Psurf, tsurf);

%   Observation surface
[~, D]     = knnsearch(Pobs, FSCenter,  'k', 1);   % [1:FS, 1]
