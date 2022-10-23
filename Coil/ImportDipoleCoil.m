function ImportDipoleCoil(importFile, saveLocation)

fileID  = fopen(importFile, 'r');

A       = fscanf(fileID, '%f');
positions(:, 1) = A(1:6:end);
positions(:, 2) = A(2:6:end);
positions(:, 3) = A(3:6:end);
directivemoments(:, 1)= 1e6*A(4:6:end);
directivemoments(:, 2)= 1e6*A(5:6:end);
directivemoments(:, 3)= 1e6*A(6:6:end);

strcoil.positions = positions;
strcoil.directivemoments = directivemoments;
save([saveLocation 'coil'], 'strcoil');
save([saveLocation 'coilCAD'], 'positions');

end
