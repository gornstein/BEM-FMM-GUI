%   This script plots the induced surface charge density for
%   any brain compartment surface (plots the density + optionally
%   coil geometry).
%
%   Copyright SNM/WAW 2017-2020

%%   Graphics
tissue_to_plot = 'GM';
%   Topological low-pass solution filtering (repeat if necessary)
C = (c.*Area + sum(c(tneighbor).*Area(tneighbor), 2))./(Area + sum(Area(tneighbor), 2));

objectnumber    = find(strcmp(tissue, tissue_to_plot));
temp            = eps0*C(Indicator(:, 1)==objectnumber);  % the real charge density is eps0*c
figure;
bemf2_graphics_surf_field(P, t, temp, Indicator(:,1), objectnumber);
title(strcat('Solution: Surface charge density in C/m^2 for: ', tissue{objectnumber}));

% Coil centerline graphics 
hold on;
%plot3(positions(:, 1), positions(:, 2), positions(:, 3), '.');
plot3(pointsline(:, 1), pointsline(:, 2), pointsline(:, 3), '-m', 'lineWidth', 5);

% General
axis tight; %view(-90, 25), camzoom(2);

brighten(0.4);