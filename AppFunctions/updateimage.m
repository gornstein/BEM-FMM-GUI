function [] = updateimage(app, RValue, PhiValue, ThetaValue)
%%  The main function called to update the UIAxes (with the coil and brain)

cla(app.UIAxes); %clears the axis
hold(app.UIAxes, "on"); %ensures that both will be plotted

%Changing the shifts
app.shiftX = RValue * sin(ThetaValue) * cos(PhiValue);
app.shiftY = RValue * sin(ThetaValue) * sin(PhiValue);
app.shiftZ = RValue * cos(ThetaValue);

%displays the brain
displaybrain(app);

%Displays the coil
displaycoil(app);
end