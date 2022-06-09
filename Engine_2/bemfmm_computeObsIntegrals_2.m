function obs = bemfmm_computeObsIntegrals_2(obs, model, integrationRadius)
    % Decision: is integrationRadius an absolute measurement (in model
    % units) or a relative measurement with respect to average triangle
    % size?
    meanTriangleSize  = mean(sqrt(model.Area));
    R = integrationRadius; % shorthand
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
        
        
        % Debugging
        figure;
        patch('Faces', model.t(eligibleTriangles, :), 'Vertices', model.P, 'FaceColor', 'c', 'EdgeColor', 'k');
        axis equal;
        
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
    correctionX = cell(N, 1);
    correctionY = cell(N, 1);
    correctionZ = cell(N, 1);
    correctionP = cell(N, 1);
    jj          = cell(N, 1);
    
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
        
        I = zeros(length(temp), 3);
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
        correctionX{j} = -I(:, 1) - J(:,1);
        correctionY{j} = -I(:, 2) - J(:,2);
        correctionZ{j} = -I(:, 3) - J(:,3);
        
        jj = repmat(j, 1, length(temp));
    end

    % Convert all matrices to 1-dimensional vectors for sparse matrix
    % initialization
    ii = eligibleTriangles(horzcat(ineighborlocal{:}));
    jj  = transpose(horzcat(jj{:}));
    correctionX = transpose(horzcat(correctionX{:}));
    correctionY = transpose(horzcat(correctionY{:}));
    correctionZ = transpose(horzcat(correctionZ{:}));
    
    const = 1/(4*pi);
    correctionX = const*correctionX;
    correctionY = const*correctionY;
    correctionZ = const*correctionZ;
    
    obs.EC_x = sparse(jj, ii, correctionX, N, size(model.t, 1));
    obs.EC_y = sparse(jj, ii, correctionY, N, size(model.t, 1));
    obs.EC_z = sparse(jj, ii, correctionZ, N, size(model.t, 1));
    
    
end