function displayobslines(app)
%   Deletes prior drawn line if there is any
if (length(app.lines{app.selectedlineidx}) == 5)
    delete(app.lines{app.selectedlineidx}{5});
end

%   Sets all of the variables
startingXCoord = app.lines{app.selectedlineidx}{3}(1)*1e3; % from m to mm
startingYCoord = app.lines{app.selectedlineidx}{3}(2)*1e3; % from m to mm
startingZCoord = app.lines{app.selectedlineidx}{3}(3)*1e3; % from m to mm
magnitude = app.lines{app.selectedlineidx}{2}(4)*1e3; % from m to mm
xDirection = app.lines{app.selectedlineidx}{2}(1);
yDirection = app.lines{app.selectedlineidx}{2}(2);
zDirection = app.lines{app.selectedlineidx}{2}(3);

% get normal components for the direction vector components
directionVectMag = sqrt(xDirection^2 + yDirection^2 + zDirection^2);
xNorm = xDirection / directionVectMag;
yNorm = yDirection / directionVectMag;
zNorm = zDirection / directionVectMag;

endingXCoord = startingXCoord + xNorm * magnitude;
endingYCoord = startingYCoord + yNorm * magnitude;
endingZCoord = startingZCoord + zNorm * magnitude;

%   Plots the line if visability is set to true
if (app.lines{app.selectedlineidx}{4})
    app.lines{app.selectedlineidx}{5} = plot3(app.CoilDisplay, [endingXCoord, startingXCoord], [endingYCoord, startingYCoord], [endingZCoord, startingZCoord], Color='magenta', LineWidth=4);
end
end