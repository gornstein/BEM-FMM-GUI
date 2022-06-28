function updatecoilnormaltocrosssectiondisplay(app)

if ~isempty(app.planes) % if the planes are empty then there will be nothing to display to
    %HARDCODED
    displayDist = 3; % Distance from which the line will be displayed in cm from the surface of the plane
    bounds = 10; % Bounds for what will be displayed (will not display things out of bounds) along the plane from the center in cm

    coilPos = [app.MatrixField14.Value, app.MatrixField24.Value, app.MatrixField34.Value]; % Coil location in cm
    rotMat = [app.MatrixField11.Value, app.MatrixField12.Value, app.MatrixField13.Value;
        app.MatrixField21.Value, app.MatrixField22.Value, app.MatrixField23.Value;
        app.MatrixField31.Value, app.MatrixField32.Value, app.MatrixField33.Value];
    coilNorm = (rotMat * [0; 0; -1])'; % normal vector for coil's direction

    planeCenter = app.planes{app.selectedplaneidx}{3}; % Plane center location in cm


    switch app.planes{app.selectedplaneidx}{2}
        case 'xy'

            % All in cm
            xMin = -bounds;
            xMax = bounds;
            yMin = -bounds;
            yMax = bounds;
            zMin = planeCenter(3) - displayDist;
            zMax = planeCenter(3) + displayDist;
            startPoint = [];
            endPoint = [];

            % find the first point to fall within the bounds
            for (i = 0:0.01:100)
                currentPos = coilPos+coilNorm*i;

                % if the point falls within the bounds
                if (currentPos(1)>= xMin && currentPos(1)<= xMax && currentPos(2)>= yMin && currentPos(2)<= yMax && currentPos(3)>= zMin && currentPos(3)<= zMax)
                    startPoint = currentPos;
                    break;
                end
            end

            if (~isempty(startPoint))
                % find the next point along the vector to fall out of the
                % bounds if any point was within the bounds
                for (j = 0:0.01:100)
                    currentPos = startPoint + coilNorm*j;

                    % if the point falls outside of the bounds
                    if ~(currentPos(1)>= xMin && currentPos(1)<= xMax && currentPos(2)>= yMin && currentPos(2)<= yMax && currentPos(3)>= zMin && currentPos(3)<= zMax)
                        endPoint = currentPos;
                        break;
                    end
                end
            end

            coilIntersection = [];
            % finds the intersection point if it exists
            if ~(coilNorm==0) % not parallel to the plane
                dist = (planeCenter(3)-coilPos(3))/coilNorm(3);
                if dist > 0 % if the vector intersects in the right direction
                    coilIntersection = coilPos+coilNorm*dist;

                    if (coilIntersection(1)>xMax || coilIntersection(1)<xMin || coilIntersection(2)>yMax || coilIntersection(2)<yMin || coilIntersection(3)>zMax || coilIntersection(3)<zMin)
                        coilIntersection = []; % discard the intersection if it is outside of the bounds
                    end
                end
            end

            % displays the intersection point
            if (isfield(app.niftidisplaydata, 'centerlineintersection'))
                delete(app.niftidisplaydata.centerlineintersection);
            end
            if (~isempty(coilIntersection))
                app.niftidatainfo.intersectionPoint = [coilIntersection(1), coilIntersection(2)];
                app.niftidisplaydata.centerlineintersection = plot(app.CrossSectionDisplay, coilIntersection(1)*1e1, coilIntersection(2)*1e1, 'Color', 'red', 'Marker', 'o', 'MarkerSize', 10, 'LineWidth', 6);
            end

            % displays the coil centerline
            if (isfield(app.niftidisplaydata, 'coilcenterline'))
                delete(app.niftidisplaydata.coilcenterline);
            end
            if (~isempty(startPoint) && ~isempty(endPoint))
                app.niftidatainfo.coilLineStartPoint = [startPoint(1), startPoint(2)];
                app.niftidatainfo.coilLineEndPoint = [endPoint(1), endPoint(2)];
                app.niftidisplaydata.coilcenterline = plot(app.CrossSectionDisplay, [startPoint(1)*1e1, endPoint(1)*1e1], [startPoint(2)*1e1, endPoint(2)*1e1], 'Color', 'blue', 'LineWidth', 4);
            else
                disp('No valid points found');
            end

            %%
        case 'xz'
            % All in cm
            xMin = -bounds;
            xMax = bounds;
            yMin = planeCenter(2) - displayDist;
            yMax = planeCenter(2) + displayDist;
            zMin = -bounds;
            zMax = bounds;
            startPoint = [];
            endPoint = [];

            % find the first point to fall within the bounds
            for (i = 0:0.01:100)
                currentPos = coilPos+coilNorm*i;

                % if the point falls within the bounds
                if (currentPos(1)>= xMin && currentPos(1)<= xMax && currentPos(2)>= yMin && currentPos(2)<= yMax && currentPos(3)>= zMin && currentPos(3)<= zMax)
                    startPoint = currentPos;
                    break;
                end
            end

            if (~isempty(startPoint))
                % find the next point along the vector to fall out of the
                % bounds if any point was within the bounds
                for (j = 0:0.01:100)
                    currentPos = startPoint + coilNorm*j;

                    % if the point falls outside of the bounds
                    if ~(currentPos(1)>= xMin && currentPos(1)<= xMax && currentPos(2)>= yMin && currentPos(2)<= yMax && currentPos(3)>= zMin && currentPos(3)<= zMax)
                        endPoint = currentPos;
                        break;
                    end
                end
            end

            coilIntersection = [];
            % finds the intersection point if it exists
            if ~(coilNorm==0) % not parallel to the plane
                dist = (planeCenter(2)-coilPos(2))/coilNorm(2);
                if dist > 0 % if the vector intersects in the right direction
                    coilIntersection = coilPos+coilNorm*dist;

                    if (coilIntersection(1)>xMax || coilIntersection(1)<xMin || coilIntersection(2)>yMax || coilIntersection(2)<yMin || coilIntersection(3)>zMax || coilIntersection(3)<zMin)
                        coilIntersection = []; % discard the intersection if it is outside of the bounds
                    end
                end
            end

            % displays the intersection point
            if (isfield(app.niftidisplaydata, 'centerlineintersection'))
                delete(app.niftidisplaydata.centerlineintersection);
            end
            if (~isempty(coilIntersection))
                app.niftidatainfo.intersectionPoint = [coilIntersection(1), coilIntersection(3)];
                app.niftidisplaydata.centerlineintersection = plot(app.CrossSectionDisplay, coilIntersection(1)*1e1, coilIntersection(3)*1e1, 'Color', 'red', 'Marker', 'o', 'MarkerSize', 10, 'LineWidth', 6);
            end

            % displays the coil centerline
            if (isfield(app.niftidisplaydata, 'coilcenterline'))
                delete(app.niftidisplaydata.coilcenterline);
            end
            if (~isempty(startPoint) && ~isempty(endPoint))
                app.niftidatainfo.coilLineStartPoint = [startPoint(1), startPoint(3)];
                app.niftidatainfo.coilLineEndPoint = [endPoint(1), endPoint(3)];
                app.niftidisplaydata.coilcenterline = plot(app.CrossSectionDisplay, [startPoint(1)*1e1, endPoint(1)*1e1], [startPoint(3)*1e1, endPoint(3)*1e1], 'Color', 'blue', 'LineWidth', 4);
            else
                disp('No valid points found');
            end
            %%
        case 'yz'
            % All in cm
            xMin = planeCenter(1) - displayDist;
            xMax = planeCenter(1) + displayDist;
            yMin = -bounds;
            yMax = bounds;
            zMin = -bounds;
            zMax = bounds;
            startPoint = [];
            endPoint = [];

            % find the first point to fall within the bounds
            for (i = 0:0.01:100)
                currentPos = coilPos+coilNorm*i;

                % if the point falls within the bounds
                if (currentPos(1)>= xMin && currentPos(1)<= xMax && currentPos(2)>= yMin && currentPos(2)<= yMax && currentPos(3)>= zMin && currentPos(3)<= zMax)
                    startPoint = currentPos;
                    break;
                end
            end

            if (~isempty(startPoint))
                % find the next point along the vector to fall out of the
                % bounds if any point was within the bounds
                for (j = 0:0.01:100)
                    currentPos = startPoint + coilNorm*j;

                    % if the point falls outside of the bounds
                    if ~(currentPos(1)>= xMin && currentPos(1)<= xMax && currentPos(2)>= yMin && currentPos(2)<= yMax && currentPos(3)>= zMin && currentPos(3)<= zMax)
                        endPoint = currentPos;
                        break;
                    end
                end
            end

            coilIntersection = [];
            % finds the intersection point if it exists
            if ~(coilNorm==0) % not parallel to the plane
                dist = (planeCenter(3)-coilPos(3))/coilNorm(3);
                if dist > 0 % if the vector intersects in the right direction
                    coilIntersection = coilPos+coilNorm*dist;

                    if (coilIntersection(1)>xMax || coilIntersection(1)<xMin || coilIntersection(2)>yMax || coilIntersection(2)<yMin || coilIntersection(3)>zMax || coilIntersection(3)<zMin)
                        coilIntersection = []; % discard the intersection if it is outside of the bounds
                    end
                end
            end

            % displays the intersection point
            if (isfield(app.niftidisplaydata, 'centerlineintersection'))
                delete(app.niftidisplaydata.centerlineintersection);
            end
            if (~isempty(coilIntersection))
                app.niftidatainfo.intersectionPoint = [coilIntersection(2), coilIntersection(3)];
                app.niftidisplaydata.centerlineintersection = plot(app.CrossSectionDisplay, coilIntersection(2)*1e1, coilIntersection(3)*1e1, 'Color', 'red', 'Marker', 'o', 'MarkerSize', 10, 'LineWidth', 6);
            end

            % displays the coil centerline
            if (isfield(app.niftidisplaydata, 'coilcenterline'))
                delete(app.niftidisplaydata.coilcenterline);
            end
            if (~isempty(startPoint) && ~isempty(endPoint))
                app.niftidatainfo.coilLineStartPoint = [startPoint(2), startPoint(3)];
                app.niftidatainfo.coilLineEndPoint = [endPoint(2), endPoint(3)];
                app.niftidisplaydata.coilcenterline = plot(app.CrossSectionDisplay, [startPoint(2)*1e1, endPoint(2)*1e1], [startPoint(3)*1e1, endPoint(3)*1e1], 'Color', 'blue', 'LineWidth', 4);
            else
                disp('No valid points found');
            end
    end
end
end