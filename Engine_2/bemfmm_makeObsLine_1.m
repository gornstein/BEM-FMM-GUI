function obsLine = bemfmm_makeObsLine_1(startPoint, endPoint, numPoints)

    obsLine.Type = 'Line';

    % Assign the raw observation points
    P = zeros(numPoints, 3);
    for j = 1:3
        P(:, j) = linspace(startPoint(j), endPoint(j), numPoints);
    end
    obsLine.Points = P;
    
    % Precompute additional line descriptors
    obsLine.direction = (endPoint-startPoint)/norm(endPoint-startPoint);
    obsLine.argline = vecnorm(P-P(1, :), 2, 2);
    
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