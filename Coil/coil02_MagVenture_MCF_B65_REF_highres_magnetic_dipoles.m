% clear all; %#ok<CLALL>

fileID  = fopen('MagVenture_MCF_B65_REF_highres_cleaned.ccd', 'r');

A       = fscanf(fileID, '%f');
positions(:, 1) = A(1:6:end);
positions(:, 2) = A(2:6:end);
positions(:, 3) = A(3:6:end);
directivemoments(:, 1)= 1e6*A(4:6:end);
directivemoments(:, 2)= 1e6*A(5:6:end);
directivemoments(:, 3)= 1e6*A(6:6:end);

%plot3(positions(:, 1), positions(:, 2), positions(:, 3), '.');
%axis equal; axis tight; grid on; 
%xlabel('x'), ylabel('y'), zlabel('z')

bL = min(positions);
bH = max(positions);
P = zeros(8,3);
for i = 0:7
    currentPoint = bL;
    if (bitand(i,4))
        currentPoint(1) = bH(1);
    end

    if (bitand(i,2))
        currentPoint(2) = bH(2);
    end

    if (bitand(i,1))
        currentPoint(3) = bH(3);
    end
    P(i+1,:) = currentPoint;
end

% figure; plot3(P(:,1), P(:,2), P(:,3), 'r*', 'MarkerSize', 20); hold on; 
% 
% for i=1:8
%     text(P(i,1), P(i,2), P(i,3), num2str(i));
% end
%axis equal;
t = [1 2 4; 4 3 1; ...
     1 5 6; 6 2 1; ...
     5 7 8; 8 6 5; ...
     7 3 4; 4 8 7; ...
     2 6 8; 8 4 2; ...
     3 7 5; 5 1 3];
% figure; patch('Faces', t, 'Vertices', P, 'FaceColor', 'c', 'EdgeColor', 'k'); axis equal;
tind = 0;
strcoil.positions = positions;
strcoil.directivemoments = directivemoments;

if ((exist('app', 'var')==1) && (exist('Coil', 'dir')==7))
    save([app.dir app.slash 'Coil' app.slash 'coil'], 'strcoil');
    save([app.dir app.slash 'Coil' app.slash 'coilCAD'], 'P', 't', 'tind');  %   optional, slow
else
    save('coil', 'strcoil');
    save('coilCAD', 'P', 't', 'tind');  %   optional, slow
end
