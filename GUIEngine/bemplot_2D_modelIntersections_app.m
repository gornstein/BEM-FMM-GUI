function [intersectionTraces] = bemplot_2D_modelIntersections_app(axis, model, obsPlane, options)
    
    numTissues = length(model.tissue);
    
    if nargin < 4 || isempty(options) || ~isfield(options.color) || isempty(options.color)
        color   = prism(numTissues); color(4, :) = [0 1 1];
    end
    
    %%   Process cross-section data to enable fast (real time) display 
    %   This block finds all edges and attached triangles for separate brain
    %   compartments. This script is required for subsequent visualizations.
    %   Process surface model data
    tic
    
    %   Preallocate cell arrays
    tS = cell(numTissues, 1);
    nS = tS; %  Reuse this empty cell array for other initialization
    eS = tS;
    TriPS = tS;
    TriMS = tS;
    
    PInter = cell(numTissues, 1);   %   intersection nodes for a tissue
    EInter = cell(numTissues, 1);   %   edges formed by intersection nodes for a tissue
    TInter = cell(numTissues, 1);   %   intersected triangles
    NInter = cell(numTissues, 1);   %   normal vectors of intersected triangles
    countInter = [];   %   number of every tissue present in the slice
    
    % Loop over all tissues, find intersection traces
    for m = 1:numTissues
        % Extract current tissue from full model
        tS{m} = model.t(model.Indicator(:,1) == m, :);
        nS{m} = model.normals(model.Indicator(:,1) == m, :);
        [eS{m}, TriPS{m}, TriMS{m}] = mt(tS{m});
        
        % Find trace described by intersection of current tissue and plane
        [Pi, ti, polymask, flag] = meshplaneintGeneral(model.P, tS{m}, eS{m}, TriPS{m}, TriMS{m}, obsPlane.PlaneABCD);

        if flag % intersection found                
            countInter               = [countInter m];
            PInter{m}            = Pi;               %   intersection nodes
            EInter{m}            = polymask;         %   edges formed by intersection nodes
            TInter{m}            = ti;               %   intersected triangles
            NInter{m}            = nS{m}(ti, :);     %   normal vectors of intersected triangles        
        end
    end
    
    % If this is an axis-aligned plane, just grab the components parallel to the plane
    isAxisAligned = obsPlane.PlaneABCD(1:3) > 0.99;
    if(sum(isAxisAligned) == 1)
        for m = countInter
            edges           = EInter{m};             %   this is for the contour
            points          = PInter{m};
            points(:, isAxisAligned) = [];
            patch(axis, 'Faces', edges, 'Vertices', points, 'EdgeColor', color(m, :), 'LineWidth', 2.0);    %   this is contour plot
        end
        
    else % Otherwise, project the traces onto the plane using the plane center as the origin
        for m = countInter
            edges           = EInter{m};             %   this is for the contour
            points          = PInter{m};
            
            % Undo translation
            points = points - obsPlane.PlaneCenter;
            %Decompose in terms of plane "up" vector
            tempUpVec = repmat(obsPlane.PlaneUp, size(points, 1), 1);
            tempXVec = cross(obsPlane.PlaneUp, obsPlane.PlaneABCD(1:3));
            tempXVec = repmat(tempXVec, size(points, 1), 1);
            y = dot(points, tempUpVec, 2); % Magnitude parallel to plane up vector
            
            x_temp = points - y.*tempUpVec;
            x = dot(x_temp, tempXVec, 2);
%             x = vecnorm(points - y.*tempUpVec, 2, 2); % Magnitude perpendicular to plane up vector
            points = [x y];
            patch(axis, 'Faces', edges, 'Vertices', points, 'EdgeColor', color(m, :), 'LineWidth', 2.0);    %   this is contour plot
        end  
    end
end