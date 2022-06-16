function displayobslines(app)
%   Deletes prior drawn line if there is any
if (length(app.lines{app.selectedlineidx}) == 5)
    delete(app.lines{app.selectedlineidx}{5});
end

%   Sets all of the variables
startingXCoord = app.lines{app.selectedlineidx}{3}(1);
startingYCoord = app.lines{app.selectedlineidx}{3}(2);
startingZCoord = app.lines{app.selectedlineidx}{3}(3);
magnitude = app.lines{app.selectedlineidx}{2}(4);
endingXCoord = startingXCoord + app.lines{app.selectedlineidx}{2}(1) * magnitude;
endingYCoord = startingYCoord + app.lines{app.selectedlineidx}{2}(2) * magnitude;
endingZCoord = startingZCoord + app.lines{app.selectedlineidx}{2}(3) * magnitude;

%   Plots the line if visability is set to true
if (app.lines{app.selectedlineidx}{4})
    app.lines{app.selectedlineidx}{5} = plot3(app.CoilDisplay, [endingXCoord, startingXCoord], [endingYCoord, startingYCoord], [endingZCoord, startingZCoord], Color='blue', LineWidth=2);
end
end