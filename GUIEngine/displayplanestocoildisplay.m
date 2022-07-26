function displayplanestocoildisplay(app)
if (~isempty(app.planes) & (app.selectedplaneidx <= length(app.planes)))

    %%  Defines the three planes
    %   Getting coords for field planes
    X = app.planes{app.selectedplaneidx}.position(1)*1e3;  %   X-Coord of the plane's center (mm)
    Y = app.planes{app.selectedplaneidx}.position(2)*1e3;  %   Y-Coord of the plane's center (mm)
    Z = app.planes{app.selectedplaneidx}.position(3)*1e3;  %   Z-Coord of the plane's center (mm)

    %%  Defines aspects for field planes
    delta = app.planes{app.selectedplaneidx}.width/2*1e3;  %   half plane width (mm)
    xmin = (X - delta);   % Cross-section left edge (mm)
    xmax = (X + delta);   % Cross-section right edge (mm)
    ymin = (Y - delta);   % Cross-section posterior edge (mm)
    ymax = (Y + delta);   % Cross-section anterior edge (mm)
    zmin = (Z - delta);   % Cross-section inferior edge (mm)
    zmax = (Z + delta);   % Cross-section superior edge (mm)

    %%  Displays the three field planes

    if (app.planes{app.selectedplaneidx}.visibility)

        % Deletes prior patch
        if (length(app.CoilDisplayObjects.planes) >= app.selectedplaneidx)
            delete(app.CoilDisplayObjects.planes{app.selectedplaneidx});
        end

        if (strcmp(app.planes{app.selectedplaneidx}.direction, 'xy'))
            app.CoilDisplayObjects.planes{app.selectedplaneidx} = patch(app.CoilDisplay, [xmin xmin xmax xmax], [ymin ymax ymax ymin], [Z Z Z Z], 'c', 'FaceAlpha', 0.35); %   Display XY Plane
        end

        if (strcmp(app.planes{app.selectedplaneidx}.direction, 'xz'))
            app.CoilDisplayObjects.planes{app.selectedplaneidx} = patch(app.CoilDisplay, [xmin xmin xmax xmax], [Y Y Y Y], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.35); %   Display XZ Plane
        end

        if (strcmp(app.planes{app.selectedplaneidx}.direction, 'yz'))
            app.CoilDisplayObjects.planes{app.selectedplaneidx} = patch(app.CoilDisplay, [X X X X], [ymin ymin ymax ymax], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.35); %   Display YZ Plane
        end
    end
end
end