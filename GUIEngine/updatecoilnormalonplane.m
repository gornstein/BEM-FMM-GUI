function [displayLine, displayIntersection] = updatecoilnormalonplane(axis, planeOrientation, planeCenter, translationMatrix, rotationMatrix)
    %% display the coil normal/centerline and it's intersection with the plane within 
    %% a range from the origin (dictated by displayDist and bounds) ALL UNITS ARE DISPLAY UNITS
    % axis: the axis to display to
    % planeOrientation: the plane's direction (either 'xy', 'xz', or 'yz')
    % planeCenter: the center of the plane
    % translationMatrix: the coil's translation as a 1x3 vector (x, y, z)
    % rotationMatrix: the coil's rotation as a 3x3 matrix
    

    %HARDCODED
    displayDist = 30; % Distance from which the line will be displayed in mm from the surface of the plane
    bounds = 100; % Bounds for what will be displayed (will not display things out of bounds) along the plane from the center in mm

    coilPos = translationMatrix; % coil location
    coilNorm = (rotationMatrix * [0; 0; -1])'; % normal vector for coil's direction

    switch planeOrientation
        case 'xy'
            xMin = -bounds;
            xMax = bounds;
            yMin = -bounds;
            yMax = bounds;
            zMin = planeCenter(3) - displayDist;
            zMax = planeCenter(3) + displayDist;
            startPoint = [];
            endPoint = [];

            % find the first point to fall within the bounds
            for (i = 0:1:10000) % checking if there is a point in the first 10000 display units
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
                for (j = 0:1:10000) % checking if there is a point in the first 10000 display units
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

            % displays the coil centerline intersection with the plane
            if (~isempty(coilIntersection))
                displayIntersection = plot(axis, coilIntersection(1), coilIntersection(2), 'Color', 'red', 'Marker', 'o', 'MarkerSize', 10, 'LineWidth', 6);
            else
                displayIntersection = [];
            end

            % displays the coil centerline
            if (~isempty(startPoint) && ~isempty(endPoint))
                displayLine = plot(axis, [startPoint(1), endPoint(1)], [startPoint(2), endPoint(2)], 'Color', 'blue', 'LineWidth', 4);
            else
                displayLine = [];
            end

        case 'xz'
            xMin = -bounds;
            xMax = bounds;
            yMin = planeCenter(2) - displayDist;
            yMax = planeCenter(2) + displayDist;
            zMin = -bounds;
            zMax = bounds;
            startPoint = [];
            endPoint = [];

            % find the first point to fall within the bounds
            for (i = 0:1:10000) % checking if there is a point in the first 10000 display units
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
                for (j = 0:1:10000) % checking if there is a point in the first 10000 display units
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

            % displays the coil centerline intersection with the plane
            if (~isempty(coilIntersection))
                displayIntersection = plot(axis, coilIntersection(1), coilIntersection(3), 'Color', 'red', 'Marker', 'o', 'MarkerSize', 10, 'LineWidth', 6);
            else
                displayIntersection = [];
            end

            % displays the coil centerline
            if (~isempty(startPoint) && ~isempty(endPoint))
                displayLine = plot(axis, [startPoint(1), endPoint(1)], [startPoint(3), endPoint(3)], 'Color', 'blue', 'LineWidth', 4);
            else
                displayLine = [];
            end

        case 'yz'
            xMin = planeCenter(1) - displayDist;
            xMax = planeCenter(1) + displayDist;
            yMin = -bounds;
            yMax = bounds;
            zMin = -bounds;
            zMax = bounds;
            startPoint = [];
            endPoint = [];

            % find the first point to fall within the bounds
            for (i = 0:1:10000) % checking if there is a point in the first 10000 display units
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
                for (j = 0:1:10000) % checking if there is a point in the first 10000 display units
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

            % displays the coil centerline intersection with the plane
            if (~isempty(coilIntersection))
                displayIntersection = plot(axis, coilIntersection(2), coilIntersection(3), 'Color', 'red', 'Marker', 'o', 'MarkerSize', 10, 'LineWidth', 6);
            else
                displayIntersection = [];
            end

            % displays the coil centerline
            if (~isempty(startPoint) && ~isempty(endPoint))
                displayLine = plot(axis, [startPoint(2), endPoint(2)], [startPoint(3), endPoint(3)], 'Color', 'blue', 'LineWidth', 4);
            else
                displayLine = [];
            end
    end
end
