%   This script defines target point(s) on the original gray matter
%   interface
%
%   Copyright SNM 2017-2022

%  Define target points for the given model - M1 of gray matter -L+R
TARGET(1, :) = [-26.8313 -1.0875 55.5739];
TARGET(2, :) = [-33.4032 -3.1121 52.8864];
TARGET(3, :) = [-35.9373 5.1281 50.2520];
TARGET(4, :) = [33.1535 3.7579 54.4407];
TARGET(5, :) = [41.3505 3.5610 49.4213];
TARGET(6, :) = [47.0781 10.9801 43.4004];

%   Choose M1 of the left hemisphere (the approximate center of M1)
X       = TARGET(2, 1);
Y       = TARGET(2, 2);
Z       = TARGET(2, 3);
cd ModelEngine
    save target X Y Z;
cd ..

%   Display target(s)
load(gm);
p = patch('vertices', P, 'faces', t);
p.FaceColor = [1 0.75 0.65];
p.EdgeColor = 'none';
p.FaceAlpha = 1.0;
daspect([1 1 1]);
camlight; lighting phong;
xlabel('x, mm'); ylabel('y, mm'); zlabel('z, mm');

S = load('sphere');
n = length(S.P);
scale = 4*1e3;
p = patch('vertices', scale*S.P+repmat([X(1) Y(1) Z(1)], n, 1), 'faces', S.t);
p.FaceColor = 'r';
p.EdgeColor = 'none';
p.FaceAlpha = 1.0;