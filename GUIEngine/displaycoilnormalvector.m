function displaycoilnormalvector(app, rotationMatrix, translationMatrix)

    %   Make the vector length be the length from the origin (arbitrary)
    magnitude = sqrt(translationMatrix(1)^2 + translationMatrix(2)^2 + translationMatrix(3)^2);

    %   Set the points for the vector
        vectorEnd = [0, 0, -magnitude];
    vectorStart = [0, 0, 0];

    %   Apply transformations
    vectorEnd = manipulatevector(vectorEnd, rotationMatrix, translationMatrix);
    vectorStart = manipulatevector(vectorStart, rotationMatrix, translationMatrix);

    %   Plot the vector
    app.coilnormalline = plot3(app.CoilDisplay, [vectorStart(1), vectorEnd(1)], [vectorStart(2), vectorEnd(2)], [vectorStart(3), vectorEnd(3)], Color='blue', LineWidth=3);

end