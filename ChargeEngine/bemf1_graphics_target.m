function [ ] = bemf1_graphics_target(X, Y, Z, scale) 
%   Target plot
%
%   Copyright SNM 2017-2022

S = load('sphere');
n = length(S.P);
p = patch('vertices', scale*S.P+1e-3*repmat([X(1) Y(1) Z(1)], n, 1), 'faces', S.t);
p.FaceColor = 'r';
p.EdgeColor = 'none';
p.FaceAlpha = 1.0;