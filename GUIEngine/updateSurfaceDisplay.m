function updateSurfaceDisplay(app)

cla(app.SurfaceDisplay); % clears the prior plot

%% Displaying the surface field

model = app.model;
model.P = model.P .* 1000; % converting points from m to mm for display
P = model.P;
t = model.t;
Indicator = model.Indicator(:, 1);
tissuenumber = find(contains(model.tissue, app.SurfaceHeadCompartmentsDropDown.Value));

% Get user's preference for EField location and EField source
if (strcmp(app.SurfaceEFieldLocationSwitch.Value, 'Inside Layer'))
    switch app.FieldSourceTypeDropDown.Value
        case 'Total Field'
            temp = app.EFieldSolution.EPri(Indicator == tissuenumber, :) + app.EFieldSolution.ESec(Indicator == tissuenumber, :) + app.EFieldSolution.EDiscin(Indicator == tissuenumber, :);
        case 'Primary Field'
            temp = app.EFieldSolution.EPri(Indicator == tissuenumber, :);
        case 'Secondary Field'
            temp = app.EFieldSolution.ESec(Indicator == tissuenumber, :) + app.EFieldSolution.EDiscin(Indicator == tissuenumber, :);
    end
else
    switch app.FieldSourceTypeDropDown.Value
        case 'Total Field'
            temp = app.EFieldSolution.EPri(Indicator == tissuenumber, :) + app.EFieldSolution.ESec(Indicator == tissuenumber, :) + app.EFieldSolution.EDisco(Indicator == tissuenumber, :);
        case 'Primary Field'
            temp = app.EFieldSolution.EPri(Indicator == tissuenumber, :);
        case 'Secondary Field'
            temp = app.EFieldSolution.ESec(Indicator == tissuenumber, :) + app.EFieldSolution.EDisco(Indicator == tissuenumber, :);
    end
end

% Get user's preference for displayed field quantity
switch app.FieldValueTypeDropDown.Value
    case 'Total Magnitude'
        temp = sqrt(dot(temp, temp, 2));
    case 'Normal Component'
        temp = dot(temp, model.normals(Indicator == tissuenumber, :), 2);
    case 'Tangential Component'
        temp = cross(temp, model.normals(Indicator == tissuenumber, :), 2);
        temp = sqrt(dot(temp, temp, 2));
end


FQ = temp;

opts = 1;

BrainPatch = bemf2_graphics_surf_field_app(app.SurfaceDisplay, P, t, FQ, Indicator(:,1), tissuenumber, opts);
low = min(FQ);
high = max(FQ);
if (app.SurfaceThresholdLow.Value ~= -1)
    low = app.SurfaceThresholdLow.Value;
end

if (app.SurfaceThresholdHigh.Value ~= -1)
    high = app.SurfaceThresholdHigh.Value;
end
app.SurfaceDisplay.CLim = [low high];
%% Display the coil

coil.P = app.coil.P * 1e3; % scaling the points to mm
coil.t = app.coil.t;

matrix = [app.MatrixField11.Value, app.MatrixField12.Value, app.MatrixField13.Value, app.MatrixField14.Value;
    app.MatrixField21.Value, app.MatrixField22.Value, app.MatrixField23.Value, app.MatrixField24.Value;
    app.MatrixField31.Value, app.MatrixField32.Value, app.MatrixField33.Value, app.MatrixField34.Value;
    app.MatrixField41.Value, app.MatrixField42.Value, app.MatrixField43.Value, app.MatrixField44.Value]; % building the matrix from the app

coilNormal = strcmp(app.VectorfromcoilSwitch.Value, 'On'); % sets whether the coil's normal vector will be displayed
coilField = strcmp(app.FieldVectorSwitch.Value, 'On'); % sets whether the coil's field vector will be displayed

coilNormal = false;
coilField = false;
[coil, coilnorm, coilfield] = displaycoil(app.SurfaceDisplay, coil, matrix, coilNormal, coilField);

transparency = 0.2; % 0 = fully transparent 1 is fully visable
alpha(coil, transparency);



end

