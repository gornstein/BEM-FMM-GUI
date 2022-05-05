%   This is an electrode processor script: it imprints an arbitrary number
%   of electrodes. In this case, we consider the ring electrode
%   configuration:
% Datta A, Bansal V, Diaz J, Patel J, Reato D, Bikson M. Gyri-precise head
% model of transcranial direct current stimulation: improved spatial
% focality using a ring electrode versus conventional rectangular pad.
% Brain Stimul. 2009;2(4):201-207.e1. doi:10.1016/j.brs.2009.03.005
%
%   Copyright SNM 2012-2022

%  Load skin mesh to imprint electrodes
load(skin);
NumberOfTrianglesOriginal   = size(t, 1);
center                      = meshtricenter(P, t);
edges                       = meshconnee(t);
temp                        = P(edges(:, 1), :) - P(edges(:, 2), :);
Mesh.AvgEdgeLength          = mean(sqrt(dot(temp, temp, 2)));

%   Determine electrode numbers/positions/radii   
%   Positions are determined automatically
load('target.mat');
Target                          = [X(1) Y(1) Z(1)]; %   gm target 
[TargetSkin(1, :), TargetSkin(2, :), TargetSkin(3, :), TargetSkin(4, :), TargetSkin(5, :)] = processtarget(Target, P, t, center);
Q                               = size(TargetSkin, 1);
NOE                             = Q;                        %   number of active electrodes 
RadE                            = 5;                        %   electrode radius in mm (at least 3 triangles along the diameter)
strge.NumberOfElectrodes        = NOE; 
strge.RadiusOfElectrodes        = RadE*ones(1, NOE);%   in mm here
    
%   Display electrode positions
figure
p = patch('vertices', P, 'faces', t);
p.FaceColor = [0.8 0.8 0.8];
p.EdgeColor = 'none';
p.FaceAlpha = 1.0;
S = load('sphere');
n = length(S.P);
scale = 8*1e3;
for m = 1:Q
    p = patch('vertices', scale*S.P+repmat(TargetSkin(m, :), n, 1), 'faces', S.t);
    p.FaceColor = 'b';
    if m ==1
        p.FaceColor = 'r';
    end
    p.EdgeColor = 'none';
    p.FaceAlpha = 1.0;
    vector      = TargetSkin(m, :) + 10*TargetSkin(m, :)/norm(TargetSkin(m, :));    
    text(vector(1), vector(2), vector(3), num2str(m), 'color', 'w');
end
daspect([1 1 1]);
camlight; lighting phong;
xlabel('x'); ylabel('y'); zlabel('z');
view(-130, 50)
drawnow

%   Now accurately imprint the electrodes (takes time)
for m = 1:NOE
    strge.PositionOfElectrodes(m, :) = [TargetSkin(m, 1) TargetSkin(m, 2) TargetSkin(m, 3)];    
    %[P, t, normals] = mesh_refinement(P, t, normals, strge.PositionOfElectrodes(m, :), RadE);
    strge.Color(m)      = 'r';
end
[P, t, normals, IndicatorElectrodes] = meshimprint(P, t, normals, strge);

%  Now put electrodes up front sequentially (1, 2, 3, etc.)
tt = [];
nn = [];
ie = [];
for m = 1:strge.NumberOfElectrodes 
    index  = IndicatorElectrodes==m;
    tt     = [tt; t(index, :)];
    nn     = [nn; normals(index, :)];
    ie     = [ie; m*ones(sum(index), 1)];
end
index               = IndicatorElectrodes==0;
t                   = [tt; t(index, :)];
normals             = [nn; normals(index, :)];
IndicatorElectrodes = [ie; IndicatorElectrodes(index)];

index               = IndicatorElectrodes>0;
t                   = [t(index, :); t(~index, :)];
normals             = [normals(index, :); normals(~index, :)];
IndicatorElectrodes = IndicatorElectrodes(index);
IndicatorElectrodes(end+1:size(t, 1)) = 0;

%  Display electrodes
figure;
p = patch('vertices', P, 'faces', t);
p.FaceAlpha = 1.0;
p.FaceColor = [1 0.75 0.65];
p.EdgeColor = 'k';
%   Electrodes
for m = 1:strge.NumberOfElectrodes    
    p = patch('vertices', P, 'faces', t(IndicatorElectrodes==m, :));
    p.FaceColor = strge.Color(m);
    p.EdgeColor = 'k';
    p.FaceAlpha = 1.0;
    vector      = strge.PositionOfElectrodes(m, :) + 10*strge.PositionOfElectrodes(m, :)/norm(strge.PositionOfElectrodes(m, :));    
    text(vector(1), vector(2), vector(3), num2str(m), 'color', 'w', 'fontsize', 15);
end

daspect([1 1 1]);
camlight; lighting phong;
xlabel('x'); ylabel('y'); zlabel('z');
view(-130, 50)
set(gca, 'Clipping', 'off');
set(gcf,'Color','White');
    
NumberOfTrianglesWithElectrodes = size(t, 1)
QualityFactor = min(simpqual(P, t))

% Save
cd ModelEngine
    save('electrode_data.mat', 'IndicatorElectrodes', 'strge', 'TargetSkin');
    save(newname{1}, 'P', 't', 'normals'); %    overwrite the new skin
cd ..