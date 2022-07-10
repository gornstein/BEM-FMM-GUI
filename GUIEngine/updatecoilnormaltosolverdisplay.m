function updatecoilnormaltosolverdisplay(app)

%%  FIND THE START AND END POINT FOR THE COIL NORMAL WITHIN RANGE AND THE INTERSECTION 
% BETWEEN THE COIL NORMAL AND THE TARGET PLANE IF THEY EXIST
if ~isempty(app.planes) % if the planes are empty then there will be nothing to display to

    %HARDCODED
    displayDist = 30; % Distance from which the line will be displayed in mm from the surface of the plane
    bounds = 100; % Bounds for what will be displayed (will not display things out of bounds) along the plane from the center in mm

    coilPos = [app.MatrixField14.Value, app.MatrixField24.Value, app.MatrixField34.Value]; % Coil location in mm
    rotMat = [app.MatrixField11.Value, app.MatrixField12.Value, app.MatrixField13.Value;
        app.MatrixField21.Value, app.MatrixField22.Value, app.MatrixField23.Value;
        app.MatrixField31.Value, app.MatrixField32.Value, app.MatrixField33.Value];
    coilNorm = (rotMat * [0; 0; -1])'; % normal vector for coil's direction

    planeCenter = app.planes{app.selectedplaneidx}{3}(1:3)*1e3; % Plane center location in mm (from m to mm)


    switch app.planes{app.processingPlaneidx}{2}
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
            for (i = 0:1:10000)
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
                for (j = 0:1:10000)
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

            % saves the inversection point
            if (~isempty(coilIntersection))
                coilIntersection = [coilIntersection(1), coilIntersection(2)];
            end

            % saves the coil centerline
            if (~isempty(startPoint) && ~isempty(endPoint))
                startPoint = [startPoint(1), startPoint(2)];
                endPoint = [endPoint(1), endPoint(2)];
            else
                % disp('No valid points found'); debugging
            end

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
            for (i = 0:1:10000)
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
                for (j = 0:1:10000)
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

            % saves the intersection point
            if (~isempty(coilIntersection))
                coilIntersection = [coilIntersection(1), coilIntersection(3)];
            end

            % saves the coil centerline
            if (~isempty(startPoint) && ~isempty(endPoint))
                startPoint = [startPoint(1), startPoint(3)];
                endPoint = [endPoint(1), endPoint(3)];
            else
                disp('No valid points found');
            end

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
            for (i = 0:1:10000)
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
                for (j = 0:1:10000)
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

            % saves the intersection point
            if (~isempty(coilIntersection))
                coilIntersection = [coilIntersection(2), coilIntersection(3)];
            end

            % saves the coil centerline
            if (~isempty(startPoint) && ~isempty(endPoint))
                startPoint = [startPoint(2), startPoint(3)];
                endPoint = [endPoint(2), endPoint(3)];
            else
                disp('No valid points found');
            end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% PLOT THE INTERSECTION POINT AND THE COIL NORMAL IN RANGE

    % coilIntersection is the intersection of the coil normal and the plane
    % startPoint is the first point of the coil normal that falls within
    % the bounds dictated by displayDist and bounds
    % endPoint is the last point of the coil normal that falls within
    % the bounds dictated by displayDist and bounds
    
    plot(app.SolverDisplay, coilIntersection(1), coilIntersection(2), 'Color', 'red', 'Marker', 'o', 'MarkerSize', 10, 'LineWidth', 10);
    plot(app.SolverDisplay, [startPoint(1), endPoint(1)], [startPoint(2), endPoint(2)], 'Color', 'blue', 'LineWidth', 4);


    userPointX = app.PointXValEditField.Value; % mm
    userPointY = app.PointYValEditField.Value; % mm
    userPointZ = app.PointZValEditField.Value; % mm

    % Plots the user's point and sets the axis labels for the solver
    % display
    switch app.planes{app.processingPlaneidx}{2}
        case 'xy'
            plot(app.SolverDisplay, userPointX, userPointY, Color = 'green', Marker= '*', MarkerSize=10);
            app.SolverDisplay.XLabel.String = 'X (mm)';
            app.SolverDisplay.YLabel.String = 'Y (mm)';
        case 'xz'
            plot(app.SolverDisplay, userPointX, userPointZ, Color = 'green', Marker= '*', MarkerSize=10);
            app.SolverDisplay.XLabel.String = 'X (mm)';
            app.SolverDisplay.YLabel.String = 'Z (mm)';
        case 'yz'
            plot(app.SolverDisplay, userPointY, userPointZ, Color = 'green', Marker= '*', MarkerSize=10);
            app.SolverDisplay.XLabel.String = 'Y (mm)';
            app.SolverDisplay.YLabel.String = 'Z (mm)';
    end
end
end