%   This script computes the line electric fields on the coil centerline or
%   elsewhere without any preprocessing
%
%   Copyright SNM/WAW 2017-2020

%%  Compute fields along the coil centerline
R = 5;  %   Accurate integration domain
tic
Epri    = bemf3_inc_field_electric(strcoil, pointsline, dIdt, mu0);             %   Incident coil field
Esec    = bemf5_volume_field_electric(pointsline, c, P, t, Center, Area, normals, R, []);
disp(['On-the-fly line fields computed in ' num2str(toc) ' s']);
Etotal  = Epri + Esec;
Etotal = Esec;
EtotalmagCtrline   = sqrt(dot(Etotal, Etotal, 2)); %   field along the line
arg    = 1e3*(pointsline-repmat(pointsline(1, :), size(pointsline, 1), 1)); arg = sqrt(sum(arg.*arg, 2));   %   distance along the line

figure;
plot(arg, EtotalmagCtrline, 'r', 'LineWidth', 2);
xlabel('distance along coil centerline, mm');
title('Centerline field, V/m');

%%  Indicate tissue boundaries
text(0, max(EtotalmagCtrline), 'Coil bottom');
intersections_to_find = tissue;
for m = 1:length(intersections_to_find)
    k = find(strcmp(intersections_to_find{m}, tissue));    
    S = load(name{k});
    d = meshsegtrintersection(orig, dir, dist, S.P, S.t);
    d = d(d>0);
    if ~isempty(d)
        for n = 1:length(d)
            IntersectionPoint = d(n);
            line([IntersectionPoint IntersectionPoint], [min(EtotalmagCtrline) max(EtotalmagCtrline)]);
            q = m + n;
            text(IntersectionPoint, (1 - 0.05*q)*max(EtotalmagCtrline), tissue{m});
            if strcmp(intersections_to_find{m}, 'WM')
                text(IntersectionPoint, (1 - 0.05*q)*max(EtotalmagCtrline), 'WM/GM');
            end
        end
    end
end

axis([0 max(arg) 0 1.1*max(EtotalmagCtrline)]);
grid on;

