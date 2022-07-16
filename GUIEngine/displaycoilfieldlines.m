function displayObj = displaycoilfieldlines(axis, rotationMatrix, translationMatrix)
%% Displays the vector from (0, 0, 0) to (0, magnitude, 0) after it has been affected by a rotation matrix and a translationMatrix
% axis: the axis to display onto
% rotationMatrix: the 3x3 rotation matrix to apply to the vector
% translationMatrix: the 1x3 matrix componenet that applys the transformations (x, y, z)
% displayObj: the returned display object


magnitude = 100; % distance in mm that vector will extend for

%   Set the points for the vector
vectorEnd = [0, magnitude, 0];
vectorStart = [0, 0, 0];

%   Apply transformations
vectorEnd = manipulatevector(vectorEnd, rotationMatrix, translationMatrix);
vectorStart = manipulatevector(vectorStart, rotationMatrix, translationMatrix);


%   Plot the vector
displayObj = plot3(axis, [vectorStart(1), vectorEnd(1)], [vectorStart(2), vectorEnd(2)], [vectorStart(3), vectorEnd(3)], Color='green', LineWidth=3);

end