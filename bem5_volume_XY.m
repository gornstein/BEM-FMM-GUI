%   This script accurately computes and displays electric fields sampled on
%   a cross-section (transverse plane) via the FMM method with accurate neighbor integration
%
%   Copyright SNM/WAW 2017-2020

%%  Load/prepare data
planeABCD = [0 0 1 -Z*1e-3];        % Equation of the plane of the cross-section (Ax + By + Cz + D = 0)(meters) for neighbor triangle search acceleration

%%  Post processing parameters
component   = 4;        %   field component to be plotted (1, 2, 3 or x, y, z, or 4 - total) 
temp        = ['x' 'y' 'z' 't'];
label       = temp(component);

%%  Define dimensionless radius of the integration sphere (for precise integration near boundaries)
R = 4;

%%  Define observation points in the cross-section (MsxMs observation points)
Ms = 200;
%   Coronal plane
x = linspace(xmin, xmax, Ms);
y = linspace(ymin, ymax, Ms);
[X0, Y0]  = meshgrid(x, y);
clear pointsXY;
pointsXY(:, 1) = reshape(X0, 1, Ms^2);
pointsXY(:, 2) = reshape(Y0, 1, Ms^2);  
pointsXY(:, 3) = Z*ones(1, Ms^2);
pointsXY       = 1e-3*pointsXY;  %  Convert back to m
%  Assign tissue types to observation points
obsPointTissues = assign_tissue_type_volume(pointsXY, normals, Center, Indicator(:,1));
in              = obsPointTissues > 2;    % skin, skull excluded

%%  Find the E-field at each observation point in the cross-section        
tic
Epri           = zeros(Ms*Ms, 3);
Esec           = zeros(Ms*Ms, 3);
Epri(in, :)    = bemf3_inc_field_electric(strcoil, pointsXY(in, :), dIdt, mu0);             %   Incident coil field
Esec(in, :)    = bemf5_volume_field_electric(pointsXY(in, :), c, P, t, Center, Area, normals, R, planeABCD);
Etotal         = Epri + Esec;   
fieldPlaneTime = toc  

%% Calculate current density at each observation point
% Observation points in free space were originally assigned tissue code 0, 
% so provide an extra "Free Space" conductivity entry and point free space obs pts to that entry.
condTemp = [cond 0];                                        
obsPointTissues(obsPointTissues == 0) = length(condTemp);

% Calculate current density J = sigma * E
condTempExpanded = transpose(condTemp(obsPointTissues));
Jtotal = repmat(condTempExpanded, 1, 3).*Etotal;

%%  Plot the E-field in the cross-section
figure;
% E-field plot: contour plot
if component == 4
    temp      = abs(sqrt(dot(Etotal, Etotal, 2)));
else
    temp      = abs(Etotal(:, component));
end
th1 = 0.9*max(temp);          %   in V/m
th2 = 0;            %   in V/m
levels      = 20;
bemf2_graphics_vol_field(temp, th1, th2, levels, x, y);
xlabel('Distance x, mm');
ylabel('Distance y, mm');
title(['E-field (V/m), ', label, '-component in the transverse plane.']);

% E-field plot: tissue boundaries
color   = prism(length(tissue)); color(4, :) = [0 1 1];
for m = countXY
    edges           = EofXY{m};              %   this is for the contour
    points          = [];
    points(:, 1)    = +PofXY{m}(:, 1);       %   this is for the contour  
    points(:, 2)    = +PofXY{m}(:, 2);       %   this is for the contour
    patch('Faces', edges, 'Vertices', points, 'EdgeColor', color(m, :), 'LineWidth', 2.0);    %   this is contour plot
end
% E-field plot: general settings 
axis 'equal';  axis 'tight';     
colormap parula; colorbar;
axis([xmin xmax ymin ymax]);
line(mean([xmin xmax]), mean([ymin, ymax]), 'Marker', 'o', 'MarkerFaceColor', 'm', 'MarkerSize', 12); 
grid off; set(gcf,'Color','White');

%% Plot the current distribution in the cross-section
figure;
% J-field plot: Contour plot
if component == 4
    temp      = abs(sqrt(dot(Jtotal, Jtotal, 2)));
else
    temp      = abs(Jtotal(:, component));
end
th1 = 0.9*max(temp);          %   in V/m
th2 = 0;            %   in V/m
levels      = 20;
bemf2_graphics_vol_field(temp, th1, th2, levels, x, y);
xlabel('Distance x, mm');
ylabel('Distance y, mm');
title(['Current density (A/m^2), ', label, '-component in the transverse plane.']);

% J-field plot: tissue boundaries
color   = prism(length(tissue)); color(4, :) = [0 1 1];
for m = countXY
    edges           = EofXY{m};              %   this is for the contour
    points          = [];
    points(:, 1)    = +PofXY{m}(:, 1);       %   this is for the contour  
    points(:, 2)    = +PofXY{m}(:, 2);       %   this is for the contour
    patch('Faces', edges, 'Vertices', points, 'EdgeColor', color(m, :), 'LineWidth', 2.0);    %   this is contour plot
end
% J-field plot: general settings 
axis 'equal';  axis 'tight';     
colormap parula; colorbar;
axis([xmin xmax ymin ymax]);
line(mean([xmin xmax]), mean([ymin, ymax]), 'Marker', 'o', 'MarkerFaceColor', 'm', 'MarkerSize', 12); 
grid off; set(gcf,'Color','White');

