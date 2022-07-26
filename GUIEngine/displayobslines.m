function displayobslines(app)
%   Deletes prior drawn line if there is any
if (length(app.CoilDisplayObjects.lines) >= app.selectedlineidx)
    delete(app.CoilDisplayObjects.lines{app.selectedlineidx}); % if there is data for the patch
    % of the line being deleted then remove the patch from the display
end

%   Sets all of the variables
startingXCoord = app.linez{app.selectedlineidx}.position(1)*1e3; % from m to mm
startingYCoord = app.linez{app.selectedlineidx}.position(2)*1e3; % from m to mm
startingZCoord = app.linez{app.selectedlineidx}.position(3)*1e3; % from m to mm
magnitude = app.linez{app.selectedlineidx}.length*1e3; % from m to mm
xDirection = app.linez{app.selectedlineidx}.direction(1);
yDirection = app.linez{app.selectedlineidx}.direction(2);
zDirection = app.linez{app.selectedlineidx}.direction(3);

% get normal components for the direction vector components
directionVectMag = sqrt(xDirection^2 + yDirection^2 + zDirection^2);
xNorm = xDirection / directionVectMag;
yNorm = yDirection / directionVectMag;
zNorm = zDirection / directionVectMag;

endingXCoord = startingXCoord + xNorm * magnitude;
endingYCoord = startingYCoord + yNorm * magnitude;
endingZCoord = startingZCoord + zNorm * magnitude;

%   Plots the line if visability is set to true
if (app.linez{app.selectedlineidx}.visibility)
    app.CoilDisplayObjects.lines{app.selectedlineidx} = plot3(app.CoilDisplay, [endingXCoord, startingXCoord], [endingYCoord, startingYCoord], [endingZCoord, startingZCoord], Color='magenta', LineWidth=4);
end
end