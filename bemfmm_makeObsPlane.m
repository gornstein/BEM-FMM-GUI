

function obs = bemfmm_makeObsPlane(planeNormal, planeCenter, planeUp, planeHeight, planeWidth, pointDensity)
    % Argument checking
    planeUp = planeUp/norm(planeUp);
    planeNormal = planeNormal/norm(planeNormal);

    % Initialize plane dimensions
    xmin = -planeWidth/2;
    xmax =  planeWidth/2;
    ymin = -planeHeight/2;
    ymax =  planeHeight/2;
    
    % Create set of initial points in XY plane centered on [0 0 0]
    x = linspace(xmin, xmax, pointDensity*planeWidth);
    y = linspace(ymin, ymax, pointDensity*planeHeight);
    [X0, Y0] = meshgrid(x, y);
    pointsInit(:, 1) = reshape(X0, 1, []);
    pointsInit(:, 2) = reshape(Y0, 1, []);
    sz = size(pointsInit, 1);
    pointsInit(:, 3) = zeros(sz, 1);
    
    %% Rotate points to align with plane normal
    initialPlaneUp = [0 1 0];
    P = meshrotate1(pointsInit, planeNormal(1), planeNormal(2), planeNormal(3));
    initialPlaneUp = meshrotate1(initialPlaneUp, planeNormal(1), planeNormal(2), planeNormal(3));
    
    %% Rotate initial plane about its normal so that its major axis direction corresponds to the desired major axis direction
    % First, remove any component of the desired up vector that is parallel
    % to the plane normal
    projAlongNormal = dot(planeUp, planeNormal);
%     planeUpProjected = planeUp - projAlongNormal*planeUp;
    planeUpProjected = planeUp - projAlongNormal*planeNormal;
    planeUpProjected = planeUpProjected/norm(planeUpProjected);
    
    % Next, calculate the angle between the desired major axis and the initial major axis
    % If the cross product of the initial major axis and the desired major axis points in the direction of the normal vector, we rotate with a positive angle
    % Otherwise, we rotate with a negative angle
    angleSign = sign(dot(cross(initialPlaneUp, planeUpProjected), planeNormal)); 
    
    % Compute rotation angle and perform rotation
    angle = angleSign*acos(dot(initialPlaneUp, planeUpProjected));
    P = meshrotate2(P, planeNormal, angle);
    
    %% Translate plane to its proper position
    P = P + planeCenter;
    
    %% Assemble final structure
    % Plane meta-parameters
    obs.Type = 'Plane';
    obs.PlaneABCD = [planeNormal, -dot(planeNormal, planeCenter)];
    obs.PlaneCenter = planeCenter;
    obs.PlaneUp = planeUpProjected/norm(planeUpProjected);
    obs.Points = P;
    
    % Create placeholders for E-field neighbor integrals
    obs.EC_x = [];
    obs.EC_y = [];
    obs.EC_z = [];
    
    % Create placeholders for field variables
    obs.FieldEPrimary = zeros(size(P));
    obs.FieldESecondary = zeros(size(P));
    obs.FieldBPrimary = zeros(size(P));
    obs.FieldBSecondary = zeros(size(P));
    
    % Temporary: need to remove eventually
    obs.x = x;
    obs.y = y;
    
end