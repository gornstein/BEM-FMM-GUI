function [positions, directivemoments] = positioncoil(positions, directivemoments, theta, Nx, Ny, Nz, MoveX, MoveY, MoveZ);
    %%   Define coil position: rotate and then tilt and move the entire coil as appropriate
    
    %   Step 1 Rotate the coil about its axis as required (pi/2 - anterior; 0 - posterior)
    coilaxis        = [0 0 1];
    positions       = meshrotate2(positions, coilaxis, theta);
    directivemoments= meshrotate2(directivemoments, coilaxis, theta);
    

    %   Step 2 Tilt the coil axis with direction vector Nx, Ny, Nz as required
    positions               = meshrotate1(positions, Nx, Ny, Nz);
    directivemoments        = meshrotate1(directivemoments, Nx, Ny, Nz);

    %   Step 3 Move the coil as required
    positions(:, 1)   = positions(:, 1) + MoveX;
    positions(:, 2)   = positions(:, 2) + MoveY;
    positions(:, 3)   = positions(:, 3) + MoveZ;
end

