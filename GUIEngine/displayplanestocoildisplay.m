function displayplanestocoildisplay(app)
if (~isempty(app.planes) & (app.selectedplaneidx <= length(app.planes)))

    %%  Defines the three planes
    %   Getting coords for field planes
    X = app.planes{app.selectedplaneidx}{3}(1);  %   X-Coord of the plane's center
    Y = app.planes{app.selectedplaneidx}{3}(2);  %   Y-Coord of the plane's center
    Z = app.planes{app.selectedplaneidx}{3}(3);  %   Z-Coord of the plane's center

    %%  Defines aspects for field planes
    delta = app.PlaneWidthcmEditField.Value/2;  %   half plane window, cm
    xmin = X - delta;   % Cross-section left edge
    xmax = X + delta;   % Cross-section right edge
    ymin = Y - delta;   % Cross-section posterior edge
    ymax = Y + delta;   % Cross-section anterior edge
    zmin = Z - delta;   % Cross-section inferior edge
    zmax = Z + delta;   % Cross-section superior edge

    %%  Displays the three field planes

    if (app.planes{app.selectedplaneidx}{4})

        % Deletes prior patch
        if (length(app.planes{app.selectedplaneidx}) == 5)
            delete(app.planes{app.selectedplaneidx}{5});
        end

        if (strcmp(app.planes{app.selectedplaneidx}{2}, 'xy'))
            app.planes{app.selectedplaneidx}{5} = patch(app.CoilDisplay, [xmin xmin xmax xmax], [ymin ymax ymax ymin], [Z Z Z Z], 'c', 'FaceAlpha', 0.35); %   Display XY Plane
        end

        if (strcmp(app.planes{app.selectedplaneidx}{2}, 'xz'))
            app.planes{app.selectedplaneidx}{5} = patch(app.CoilDisplay, [xmin xmin xmax xmax], [Y Y Y Y], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.35); %   Display XZ Plane
        end

        if (strcmp(app.planes{app.selectedplaneidx}{2}, 'yz'))
            app.planes{app.selectedplaneidx}{5} = patch(app.CoilDisplay, [X X X X], [ymin ymin ymax ymax], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.35); %   Display YZ Plane
        end
    end
end
end