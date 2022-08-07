function updateSurfaceDisplay(app, solution)

cla(app.SurfaceDisplay); % clears the prior plot

model = app.model;
model.P = model.P .* 1000;

[EPri, ESec, EDiscin, EDisco] = bemfmm_computeSurfaceEField(model, solution); % computes the fields

P = model.P;
t = model.t;
FQ = EPri + ESec + EDiscin; % ??
Indicator = model.Indicator;
tissuenumber = find(contains(model.tissue,'GM')); % semi hard coded

bemf2_graphics_surf_field_app(app.SurfaceDisplay, P, t, FQ, Indicator, tissuenumber);

end

