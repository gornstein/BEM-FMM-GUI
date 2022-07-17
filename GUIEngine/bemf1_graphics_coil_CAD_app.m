%%  Modified to display on the app
function [coilPatch] = bemf1_graphics_coil_CAD_app(axes, P, t, flag) 
%   Coil 2D/3D plot with several options
%
%   Copyright SNM 2017-2020

    coilPatch = patch(axes, 'vertices', P, 'faces', t);
    if flag == 0    %   non-transparent coil
        coilPatch.FaceColor = [1 0.75 0.65]; % [0.72 0.45 0.2];  
        coilPatch.EdgeColor = 'none';
        coilPatch.FaceAlpha = 1.0;
        daspect([1 1 1]);
    else
        coilPatch.FaceColor = [1 0.155 0.155];  
        coilPatch.EdgeColor = 'none';
        coilPatch.FaceAlpha = 1;      
    end
end

