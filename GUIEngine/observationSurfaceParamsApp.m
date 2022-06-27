function [planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity] = observationSurfaceParamsApp(app)

planeWidth = app.PlaneWidthcmEditField.Value;
planeAxis = app.planes{app.selectedplaneidx}{2};
planeCenter = app.planes{app.selectedplaneidx}{3}*1e-2;
planeHeight = 40*1e-3; % Hardcoded for now, not sure if this should be an option to change
pointDensity = 300/planeWidth; % As it was in v0.4, might change to a non scaling method

if strcmp(planeAxis,'xy') == 1
    planeNormal = [0 0 1];
    planeUp = [0 1 0];

elseif strcmp(planeAxis,'xz') == 1
    planeNormal = [0 1 0];
    planeUp = [0 0 1];

elseif strcmp(planeAxis,'yz') == 1
    planeNormal = [1 0 0];
    planeUp = [0 0 1];
    
end

end

