function [] = displayplanes(app)


    %%  Defines the three planes
    %   Getting coords for field planes
    X = app.PlanesXPoscmSlider.Value;  %   YZ Cross-section position, cm
    Y = app.PlanesYPoscmSlider.Value;  %   XZ Cross-section position, cm
    Z = app.PlanesZPoscmSlider.Value;  %   XY Cross-section position, cm

    %%  Defines aspects for field planes
    delta = 2;  %   half plane window, cm
    xmin = X - delta;   % Cross-section left edge 
    xmax = X + delta;   % Cross-section right edge
    ymin = Y - delta;   % Cross-section posterior edge
    ymax = Y + delta;   % Cross-section anterior edge
    zmin = Z - delta;   % Cross-section inferior edge
    zmax = Z + delta;   % Cross-section superior edge

    %%  Displays the three field planes

    if (app.ToggleXYFieldPlaneButton.Value == 1)
        patch(app.CoilDisplay, [xmin xmin xmax xmax], [ymin ymax ymax ymin], [Z Z Z Z], 'c', 'FaceAlpha', 0.35); %   Display XY Plane
    end

    if (app.ToggleXZFieldPlaneButton.Value == 1)
    patch(app.CoilDisplay, [xmin xmin xmax xmax], [Y Y Y Y], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.35); %   Display XZ Plane
    end

    if (app.ToggleYZFieldPlaneButton.Value == 1)
    patch(app.CoilDisplay, [X X X X], [ymin ymin ymax ymax], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.35); %   Display YZ Plane
    end

    %%  Displays the required cross-section

    switch app.CrossSectionControlsTabGroup.SelectedTab.Title
        case 'XY Plane'


        case 'XZ Plane'


        case 'YZ Plane'


    end


end