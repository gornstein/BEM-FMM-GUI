function [strcoil, Coil, handle] = positioncoil(strcoil, Coil, theta, Nx, Ny, Nz, MoveX, MoveY, MoveZ)
    %%   Define coil position: rotate and then tilt and move the entire coil as appropriate
    
    %   Step 1 Rotate the coil about its axis as required (pi/2 - anterior; 0 - posterior)
    coilaxis        = [0 0 1];
    strcoil.Pwire   = meshrotate2(strcoil.Pwire, coilaxis, theta);
    Coil.P          = meshrotate2(Coil.P, coilaxis, theta);

    %   Step 2 Tilt the coil axis with direction vector Nx, Ny, Nz as required
    strcoil.Pwire = meshrotate1(strcoil.Pwire, Nx, Ny, Nz);
    Coil.P        = meshrotate1(Coil.P, Nx, Ny, Nz);

    %   Step 3 Move the coil as required
    strcoil.Pwire(:, 1)   = strcoil.Pwire(:, 1) + MoveX;
    strcoil.Pwire(:, 2)   = strcoil.Pwire(:, 2) + MoveY;
    strcoil.Pwire(:, 3)   = strcoil.Pwire(:, 3) + MoveZ;

    Coil.P(:, 1)   = Coil.P(:, 1) + MoveX;
    Coil.P(:, 2)   = Coil.P(:, 2) + MoveY;
    Coil.P(:, 3)   = Coil.P(:, 3) + MoveZ;
    
    handle          = [1 0 0];
    coilaxis        = [0 0 1];
    handle          = meshrotate2(handle, coilaxis, theta);
    handle          = meshrotate1(handle, Nx, Ny, Nz);
    handle          = handle/norm(handle);
end

