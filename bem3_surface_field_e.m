%   This script computes and plots the electric field just inside/outside
%   any brain compartment surface (plots the surface field + optionally
%   coil geometry).
%
%   Copyright SNM/WAW 2017-2020

%%   Select surface/interface and compute field magnitude (tangential or normal or total)
tissue_to_plot = 'GM';

objectnumber= find(strcmp(tissue, tissue_to_plot));
E           = Ei(Indicator(:,1) ==objectnumber, :);
par         = -1;

Normals     = normals(Indicator(:,1)==objectnumber, :);
Enormal     = sum(E.*Normals, 2); % this is a projection onto normal vector (directed outside!)
temp        = Normals.*repmat(Enormal, 1, 3);
Etangent    = E - temp;
Etangent    = sqrt(dot(Etangent, Etangent, 2));
Etotal      = sqrt(dot(E, E, 2));
e.MAXEtotal     = max(Etotal);
e.MAXEnormal    = max(abs(Enormal));
e.MAXEtangent   = max(abs(Etangent));
e

%%   Graphics
temp = Etotal;
figure;
bemf2_graphics_surf_field(P, t, temp, Indicator(:,1), objectnumber);
if par == +1; string = ' just outside:'; end
if par == -1; string = ' just inside:'; end
title(strcat('Solution: E-field (total, normal, or tang.) in V/m: ', string, tissue{objectnumber}));

% Coil centerline graphics 
% hold on;
% plot3(positions(:, 1), positions(:, 2), positions(:, 3), '.');
hold on;
plot3(pointsline(:, 1), pointsline(:, 2), pointsline(:, 3), '-m', 'lineWidth', 3);

% General
axis tight; % view(-90, 25), camzoom(2); axis off; % brighten(0.4);