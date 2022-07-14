function newVector = manipulatevector(vector, rotationMatrix, translationMatrix)
%% Transforms vector by the given rotation and translation matrices 
% vector: the endpoint of the given vector
% rotationMatrix: the 3x3 rotation matrix
% translationMatrix: the 1x3 translation matrix (x, y, z)

newVector = rotationMatrix * vector' + translationMatrix';

end