function [] = updateimage(app)
%%  The main function called to update the UIAxes (with the coil and brain)

cla(app.UIAxes); %clears the axis
hold(app.UIAxes, "on"); %ensures that both will be plotted

%displays the brain
displaybrain(app);

%Displays the coil
displaycoil(app);
end