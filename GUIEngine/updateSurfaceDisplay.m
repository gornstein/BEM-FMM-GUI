function updateSurfaceDisplay(app)

cla(app.SurfaceDisplay); % clears the prior plot

%% Displaying the surface field
coilidx = app.SurfaceCoilSelectionDropDown.Value;
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
            temp = app.EFieldSolution{coilidx}.EPri(Indicator == tissuenumber, :) + app.EFieldSolution{coilidx}.ESec(Indicator == tissuenumber, :) + app.EFieldSolution{coilidx}.EDiscin(Indicator == tissuenumber, :);
        case 'Primary Field'
            temp = app.EFieldSolution{coilidx}.EPri(Indicator == tissuenumber, :);
        case 'Secondary Field'
            temp = app.EFieldSolution{coilidx}.ESec(Indicator == tissuenumber, :) + app.EFieldSolution{coilidx}.EDiscin(Indicator == tissuenumber, :);
    end
else
    switch app.FieldSourceTypeDropDown.Value
        case 'Total Field'
            temp = app.EFieldSolution{coilidx}.EPri(Indicator == tissuenumber, :) + app.EFieldSolution{coilidx}.ESec(Indicator == tissuenumber, :) + app.EFieldSolution{coilidx}.EDisco(Indicator == tissuenumber, :);
        case 'Primary Field'
            temp = app.EFieldSolution{coilidx}.EPri(Indicator == tissuenumber, :);
        case 'Secondary Field'
            temp = app.EFieldSolution{coilidx}.ESec(Indicator == tissuenumber, :) + app.EFieldSolution{coilidx}.EDisco(Indicator == tissuenumber, :);
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

if (app.isDipoleCoil)
    coil.positions = app.coil.positions * 1e3; % scaling the points to mm
else
    coil.P = app.coil.P * 1e3; % scaling the points to mm
    coil.t = app.coil.t;
end

matrix = app.solvedmatrices{coilidx};

coilNormal = strcmp(app.VectorfromcoilSwitch.Value, 'On'); % sets whether the coil's normal vector will be displayed
coilField = strcmp(app.FieldVectorSwitch.Value, 'On'); % sets whether the coil's field vector will be displayed

coilNormal = false;
coilField = false;
[coil, coilnorm, coilfield] = displaycoil(app.SurfaceDisplay, coil, matrix, coilNormal, coilField, app.isDipoleCoil);

transparency = 0.2; % 0 = fully transparent 1 is fully visable
alpha(coil, transparency);



end

