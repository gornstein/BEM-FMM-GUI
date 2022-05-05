function [ ] = bemf1_graphics_electrodes(P, t, strge, IndicatorElectrodes, flag) 
%   Electrode plot (with thick edges)
%
%   Copyright SNM 2017-2018

%   Skin surface

for m = 1:strge.NumberOfElectrodes
    if flag == -1    % 3D view
        p = patch('vertices', P, 'faces', t(IndicatorElectrodes==m, :));
        p.FaceColor = 'r';
        p.EdgeColor = strge.Color(m);
        p.LineWidth = 1;
    end
    if flag == 0    % 3D view
        p = patch('vertices', P, 'faces', t(IndicatorElectrodes==m, :));
        p.FaceColor = strge.Color(m);
        p.EdgeColor = 'w';
        p.LineWidth = 2;
    end
    if flag == 1    % XY view
        Q = P; Q(:, 3) = [];
        p = patch('vertices', Q, 'faces', t(IndicatorElectrodes==m, :));
        p.FaceColor = 'none';
        p.EdgeColor = strge.Color(m);
        p.LineWidth = 0.5;
    end
    if flag == 2    % XZ view
        Q = P; Q(:, 2) = [];
        p = patch('vertices', Q, 'faces', t(IndicatorElectrodes==m, :));
        p.FaceColor = 'none';
        p.EdgeColor = strge.Color(m);
        p.LineWidth = 0.5;
    end
    if flag == 3    % YZ view
        Q = P; Q(:, 1) = [];
        p = patch('vertices', Q, 'faces', t(IndicatorElectrodes==m, :));
        p.FaceColor = 'none';
        p.EdgeColor = strge.Color(m);
        p.LineWidth = 0.5;
    end
end
