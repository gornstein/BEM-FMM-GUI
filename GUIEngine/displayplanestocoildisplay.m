function displayplanestocoildisplay(app)
if (~isempty(app.planes) & (app.selectedplaneidx <= length(app.planes)))

    %%  Defines the three planes
    %   Getting coords for field planes
    X = app.planes{app.selectedplaneidx}{3}(1)*1e3;  %   X-Coord of the plane's center (mm)
    Y = app.planes{app.selectedplaneidx}{3}(2)*1e3;  %   Y-Coord of the plane's center (mm)
    Z = app.planes{app.selectedplaneidx}{3}(3)*1e3;  %   Z-Coord of the plane's center (mm)

    %%  Defines aspects for field planes
    delta = app.planes{app.selectedplaneidx}{3}(4)/2*1e3;  %   half plane width (mm)
    xmin = (X - delta);   % Cross-section left edge (mm)
    xmax = (X + delta);   % Cross-section right edge (mm)
    ymin = (Y - delta);   % Cross-section posterior edge (mm)
    ymax = (Y + delta);   % Cross-section anterior edge (mm)
    zmin = (Z - delta);   % Cross-section inferior edge (mm)
    zmax = (Z + delta);   % Cross-section superior edge (mm)

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