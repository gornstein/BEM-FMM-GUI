function [] = displayvectortocoil(app, translationVector)

    %   plot the vector
    plot3(app.CoilDisplay, [0, translationVector(1)], [0, translationVector(2)], [0, translationVector(3)], Color='red', LineWidth=2);


end