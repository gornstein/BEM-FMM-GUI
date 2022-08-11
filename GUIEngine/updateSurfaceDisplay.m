function updateSurfaceDisplay(app)

cla(app.SurfaceDisplay); % clears the prior plot

%% Displaying the surface field

model = app.model;
model.P = model.P .* 1000; % converting points from m to mm for display
P = model.P;
t = model.t;
Indicator = model.Indicator(:, 1);
tissuenumber = find(contains(model.tissue, app.SurfaceHeadCompartmentsDropDown.Value)); 
temp = app.EFieldSolution.EDiscin(Indicator == tissuenumber, :) + app.EFieldSolution.EPri(Indicator == tissuenumber, :);
temp = sqrt(dot(temp, temp, 2));
FQ = temp;

bemf2_graphics_surf_field_app(app.SurfaceDisplay, P, t, FQ, Indicator(:,1), tissuenumber);

%% Display the coil

coil.P = app.coil.P * 1e3; % scaling the points to mm
coil.t = app.coil.t;

matrix = [app.MatrixField11.Value, app.MatrixField12.Value, app.MatrixField13.Value, app.MatrixField14.Value;
    app.MatrixField21.Value, app.MatrixField22.Value, app.MatrixField23.Value, app.MatrixField24.Value;
    app.MatrixField31.Value, app.MatrixField32.Value, app.MatrixField33.Value, app.MatrixField34.Value;
    app.MatrixField41.Value, app.MatrixField42.Value, app.MatrixField43.Value, app.MatrixField44.Value]; % building the matrix from the app

coilNormal = strcmp(app.VectorfromcoilSwitch.Value, 'On'); % sets whether the coil's normal vector will be displayed
coilField = strcmp(app.FieldVectorSwitch.Value, 'On'); % sets whether the coil's field vector will be displayed

[coil, coilnorm, coilfield] = displaycoil(app.SurfaceDisplay, coil, matrix, coilNormal, coilField);

transparency = 0.2; % 0 = fully transparent 1 is fully visable
alpha(coil, transparency);
alpha(coilnorm, transparency);
alpha(coilfield, transparency);



end

