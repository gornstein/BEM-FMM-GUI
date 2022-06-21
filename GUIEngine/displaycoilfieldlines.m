function displaycoilfieldlines(app, rotationMatrix, translationMatrix)


    magnitude = 10;

    %   Set the points for the vector
    vectorEnd = [0, magnitude, 0];
    vectorStart = [0, 0, 0];

    %   Translate points
    vectorEnd = rotationMatrix * vectorEnd' + translationMatrix';
    vectorStart = rotationMatrix * vectorStart' + translationMatrix';

    vectorEnd = vectorEnd';
    vectorStart = vectorStart';

    %   Plot the vector
    app.coilfieldline = plot3(app.CoilDisplay, [vectorStart(1), vectorEnd(1)], [vectorStart(2), vectorEnd(2)], [vectorStart(3), vectorEnd(3)], Color='green', LineWidth=3);

end