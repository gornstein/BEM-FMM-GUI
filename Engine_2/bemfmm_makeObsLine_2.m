function obsLine = bemfmm_makeObsLine_2(origin, direction, distance, numPoints)
    obsLine.Type = 'Line';

    direction = direction/norm(direction);
    obsLine.direction = direction;
    obsLine.argline = transpose(linspace(0, distance, numPoints));
    
    P = origin + obsLine.argline * direction;
    obsLine.Points = P;
    
    % Create placeholders for E-field neighbor integrals
    obsLine.EC_x = [];
    obsLine.EC_y = [];
    obsLine.EC_z = [];
    
    % Create placeholders for field variables
    obsLine.FieldEPrimary = zeros(size(P));
    obsLine.FieldESecondary = zeros(size(P));
    obsLine.FieldBPrimary = zeros(size(P));
    obsLine.FieldBSecondary = zeros(size(P));
    
end