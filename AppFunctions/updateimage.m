function [] = updateimage(app)
%%  The main function called to update the UIAxes (with the coil and brain)

%   Rounds all of the fields in the matrix
app.MatrixField11.Value = round(app.MatrixField11.Value, 10);
app.MatrixField12.Value = round(app.MatrixField12.Value, 10);
app.MatrixField13.Value = round(app.MatrixField13.Value, 10);
app.MatrixField21.Value = round(app.MatrixField21.Value, 10);
app.MatrixField22.Value = round(app.MatrixField22.Value, 10);
app.MatrixField23.Value = round(app.MatrixField23.Value, 10);
app.MatrixField31.Value = round(app.MatrixField31.Value, 10);
app.MatrixField32.Value = round(app.MatrixField32.Value, 10);
app.MatrixField33.Value = round(app.MatrixField33.Value, 10);
app.MatrixField41.Value = round(app.MatrixField41.Value, 10);
app.MatrixField42.Value = round(app.MatrixField42.Value, 10);
app.MatrixField43.Value = round(app.MatrixField43.Value, 10);

cla(app.UIAxes); %clears the axis

%displays the brain
displaybrain(app);

%Displays the coil
displaycoil(app);
end