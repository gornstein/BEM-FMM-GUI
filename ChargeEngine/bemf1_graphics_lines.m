function [] = bemf1_graphics_lines(Nx, Ny, Nz, MoveX, MoveY, MoveZ, Target, handle, ind)
%   Plots coil centerline and handle

    %%   Define the observation line from the bottom center of the coil into the head 
    M = 5000;        
    argline      = linspace(0, 50e-3, M);              %   distance along a 100 mm long line   
    dirline      = -[Nx Ny Nz]/norm([Nx Ny Nz]);        %   line direction (along the coil axis)   
    offline      = 0e-3;                                %   offset from the coil
    pointsline(1:M, 1) = MoveX + dirline(1)*(argline + offline);
    pointsline(1:M, 2) = MoveY + dirline(2)*(argline + offline);
    pointsline(1:M, 3) = MoveZ + dirline(3)*(argline + offline);

    %%  Define coil handle projection for the GM intersection point
    handle      = cross(handle, dirline);
    starthandle = Target - 2e-3*dirline;
    pointshandle(1:M, 1) = starthandle(1) + handle(1)*(argline + offline);
    pointshandle(1:M, 2) = starthandle(2) + handle(2)*(argline + offline);
    pointshandle(1:M, 3) = starthandle(3) + handle(3)*(argline + offline);

    %%  Plot coil centerline and handle
    scale = 1e3;
    if strcmp(ind, 'xyz')  
        hold on;
        plot3(pointsline(:, 1), pointsline(:, 2), pointsline(:, 3), '-k', 'lineWidth', 3);
        plot3(pointshandle(:, 1), pointshandle(:, 2), pointshandle(:, 3), '-w', 'lineWidth', 3);
        S = load('sphere'); S.P = S.P; n = length(S.P); scale = 2.5;
        p = patch('vertices', scale*S.P+repmat(Target, n, 1), 'faces', S.t); p.FaceColor = 'c'; p.EdgeColor = 'none'; p.FaceAlpha = 1.0;
    end
    if strcmp(ind, 'xy')
        hold on;
        plot(scale*pointsline(:, 1), scale*pointsline(:, 2), '-k', 'lineWidth', 3);
        plot(scale*pointshandle(:, 1), scale*pointshandle(:, 2), '-w', 'lineWidth', 3);
    end
    if strcmp(ind, 'xz')
        hold on;
        plot(scale*pointsline(:, 1), scale*pointsline(:, 3), '-k', 'lineWidth', 3);
        plot(scale*pointshandle(:, 1), scale*pointshandle(:, 3), '-w', 'lineWidth', 3);
    end
    if strcmp(ind, 'yz')
        hold on;
        plot(scale*pointsline(:, 2), scale*pointsline(:, 3), '-k', 'lineWidth', 3);
        plot(scale*pointshandle(:, 2), scale*pointshandle(:, 3), '-w', 'lineWidth', 3);
    end
end