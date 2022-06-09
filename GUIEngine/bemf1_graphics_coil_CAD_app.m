%%  Modified to display on the app
function [ ] = bemf1_graphics_coil_CAD_app(app, P, t, flag) 
%   Coil 2D/3D plot with several options
%
%   Copyright SNM 2017-2020

    app.coilpatch = patch(app.CoilDisplay, 'vertices', P, 'faces', t);
    if flag == 0    %   non-transparent coil
        app.coilpatch.FaceColor = [1 0.75 0.65]; % [0.72 0.45 0.2];  
        app.coilpatch.EdgeColor = 'none';
        app.coilpatch.FaceAlpha = 1.0;
        daspect([1 1 1]);
        app.coillight = camlight(app.CoilDisplay);
    else
        app.coilpatch.FaceColor = [1 0.155 0.155];  
        app.coilpatch.EdgeColor = 'none';
        app.coilpatch.FaceAlpha = 1;      
    end
end

