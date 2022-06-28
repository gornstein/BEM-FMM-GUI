function obs = bemfmm_computeObsIntegrals(obs, model, obsOptions)
    % Decision: is integrationRadius an absolute measurement (in model
    % units) or a relative measurement with respect to average triangle
    % size?
    meanTriangleSize  = mean(sqrt(model.Area));
    R = obsOptions.relativeIntegrationRadius; % shorthand
    if nargout < 1
        error('The first input argument to this function should also be the output argument to ensure proper storage of integrals');
    end
    
    % Efficiently find triangles in the model that are close enough to potentially be neighbors
    
    if strcmpi(obs.Type, 'Line')
        % Distance-from-line formula: d = ||(p-a) - ((p-a) dot n)n||
        % where p is the point, a is the line origin, and n is the 
        % line direction
        vecOriginToPoints = model.Center - obs.Points(1, :);
        projectionOntoLine = vecOriginToPoints*transpose(obs.direction)*obs.direction;
        d = vecnorm(vecOriginToPoints - projectionOntoLine, 2, 2);
        
        eligibleTriangles = find(d <= R*meanTriangleSize);
        
        
%         % Debugging
%         figure;
%         patch('Faces', model.t(eligibleTriangles, :), 'Vertices', model.P, 'FaceColor', 'c', 'EdgeColor', 'k');
%         axis equal;
        
    elseif strcmpi(obs.Type, 'Plane')
        
        d1 = abs(obs.PlaneABCD(1)*model.Center(:,1) + obs.PlaneABCD(2)*model.Center(:,2) + obs.PlaneABCD(3)*model.Center(:,3) + obs.PlaneABCD(4));
        d2 = norm(obs.PlaneABCD(1:3));
        d = d1./d2;
        eligibleTriangles = find(d <= R*meanTriangleSize);
        
    else
        eligibleTriangles = 1:size(t, 1);
    end
    
    %% Compute and save neighbor integrals
    % Find neighbor triangles to each observation point
    ineighborlocal  = rangesearch(model.Center(eligibleTriangles, :), obs.Points, R*meanTriangleSize, 'NSMethod', 'kdtree');
    numNeighbors    = transpose(arrayfun (@(x) length(ineighborlocal{x}), 1:length(ineighborlocal)));
    
    RnumberE    = max(numNeighbors);
    
    
    
    N = size(obs.Points, 1);
    % Initialize error correction matrices, neighbor listing
    correctionX      = zeros(RnumberE, N);    %   exact Ex integrals for array of neighbor triangles 
    correctionY      = zeros(RnumberE, N);    %   exact Ey integrals for array of neighbor triangles 
    correctionZ      = zeros(RnumberE, N);    %   exact Ez integrals for array of neighbor triangles 
    integralpe      = zeros(RnumberE, N);    %   exact potential integrals for array of neighbor triangles 
    
    integralxc      = zeros(RnumberE, N);    %   center-point Ex integrals for array of neighbor triangles 
    integralyc      = zeros(RnumberE, N);    %   center-point Ey integrals for array of neighbor triangles 
    integralzc      = zeros(RnumberE, N);    %   center-point Ez integrals for array of neighbor triangles 
    integralpc      = zeros(RnumberE, N);    %   center-point potential integrals for array of neighbor triangles 
    
    % Break structures up so we don't copy every part of every structure to every parallel worker
    P       = model.P;
    t       = model.t;
    normals = model.normals;
    Center  = model.Center;
    Area    = model.Area;
    
    obsPoints = obs.Points;
    
    % Each iteration of the for loop ... does what?
    parfor j = 1:N
        temp = ineighborlocal{j};       % Eligible neighbors of the current obs point
        if isempty(temp)
            continue;
        end
        temp = eligibleTriangles(temp);    % Convert from index of eligible neighbors array to actual triangle indices
        
        I = zeros(RnumberE, 3);
        J = I;
        for k = 1:length(temp)            
            m = temp(k);
            % Exact integral
            r1      = P(t(m, 1), :);        %   row
            r2      = P(t(m, 2), :);        %   row
            r3      = P(t(m, 3), :);        %   row
            I(k, :) = potint2(r1, r2, r3, normals(m, :), obsPoints(j, :)); %   Outer integral is computed analytically, for all inner IntPoints  
            
            % Coulomb's Law approximation:
            r    = obsPoints(j, :) - Center(m, :); % Vector from triangle to observation point
            rmag = vecnorm(r, 2, 2);
            J(k, :) = Area(m).*r./repmat(rmag.^3, 1, 3);
        end
        
        % J points from triangle to obs point, I points from obs point to triangle
        correctionX(:, j) = -I(:, 1) - J(:,1);
        correctionY(:, j) = -I(:, 2) - J(:,2);
        correctionZ(:, j) = -I(:, 3) - J(:,3);
    end

    % Convert all matrices to 1-dimensional vectors for sparse matrix
    % initialization
    ii = eligibleTriangles(horzcat(ineighborlocal{:}));
    jj  = reshape(repmat(1:N, RnumberE, 1), [], 1);
    correctionX = reshape(correctionX, [], 1);
    correctionY = reshape(correctionY, [], 1);
    correctionZ = reshape(correctionZ, [], 1);
    
    % Clean out entries corresponding to unused neighbors
    % Check for exact equality because correction matrices were initialized
    %  with zeros
    unusedIndices = (correctionX == 0) & (correctionY == 0) & (correctionZ == 0);
    correctionX(unusedIndices) = [];
    correctionY(unusedIndices) = [];
    correctionZ(unusedIndices) = [];
    jj(unusedIndices)          = [];
    
    const = 1/(4*pi);
    correctionX = const*correctionX;
    correctionY = const*correctionY;
    correctionZ = const*correctionZ;
    
    obs.EC_x = sparse(jj, ii, correctionX, N, size(model.t, 1));
    obs.EC_y = sparse(jj, ii, correctionY, N, size(model.t, 1));
    obs.EC_z = sparse(jj, ii, correctionZ, N, size(model.t, 1));
    
    
end