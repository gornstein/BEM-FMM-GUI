function [coincidentFacets, perturbedCentroids] = find_coincident_facets(P, t, normals, centroids)
%   This function searches for facets that are duplicates of other facets, or otherwise have centroids that are
%   too close together to be properly treated by BEM-FMM.

%   Copyright WAW/SNM 2019-2021

    %---Find nearest neighbors for every facet---
    disp('  Evaluating nearest neighbors ...');
    [index, DIST] = knnsearch(centroids, centroids, 'k', 2);
    
    % Now find entries where DIST is zero
    index_trimmed = index(DIST(:,2) < eps,:);
    index_trimmed = sort(index_trimmed, 2, 'descend');  % Higher index first in each row
    index_trimmed = sortrows(index_trimmed);            % Order rows lowest to highest
    k = reshape(1:size(index_trimmed, 1), [],1);        % Every other row is a duplicate
    index_trimmed(mod(k,2) == 1,:) = [];                % Delete duplicate rows

    % Now find the facets associated with each index
    facetList1 = t(index_trimmed(:,1), :);
    facetList2 = t(index_trimmed(:,2), :);

    %---Check that coincident facets have identical vertices---
    disp('  Evaluating coincident facets ...');
    coincidentFacetsCounter = 0;
    coincidentCentroidsCounter = 0;
    coincidentFacets = zeros(size(facetList1,1), 2);
    coincidentCentroids = zeros(size(facetList1,1), 2);
    for j = 1:size(facetList1,1)
        % Can probably do this outside the for loop - assign vertices1 and
        % vertices2 exactly as they are, but replace 'j' with ':'.  If it turns
        % out that one pair of rows doesn't match, take int(rownumber)/3+1 to
        % find offending entry in facetList.
        vertices1 = [P(facetList1(j, 1), :); P(facetList1(j, 2), :); P(facetList1(j,3),:)];
        vertices2 = [P(facetList2(j, 1), :); P(facetList2(j, 2), :); P(facetList2(j, 3),:)];
        
        % Make sure the vertices are listed in the same order
        % (Need to do this intelligently if we want to take this outside the
        % for loop)
        vertices1 = sortrows(vertices1);
        vertices2 = sortrows(vertices2);
        
        %Check for coincident vertices
        if(all(abs(vertices1 - vertices2) < eps))
            coincidentFacetsCounter = coincidentFacetsCounter + 1;
            coincidentFacets(coincidentFacetsCounter,:) = index_trimmed(j,:);    
        else
            coincidentCentroidsCounter = coincidentCentroidsCounter + 1;
            coincidentCentroids(coincidentCentroidsCounter,:) = index_trimmed(j,:);
        end
    end
    
    %Clean out unused rows
    coincidentFacets( (coincidentFacets(:, 1) == 0) & (coincidentFacets(:, 2) == 0), : )= [];
    coincidentCentroids( (coincidentCentroids(:, 1) == 0) & (coincidentCentroids(:, 2) == 0), : )= [];

    disp(['  Found ' num2str(coincidentFacetsCounter) ' duplicate facets']);
    if(coincidentCentroidsCounter ~= 0)
        % The odds of encountering this case are vanishingly small.  Handle
        % it by pulling the offending centroids apart by a very small distance
        warning(['Found ' num2str(coincidentCentroidsCounter) ' facets with coincident centroids that do not have coincident vertices.  Resolving by perturbing centroids of both meshes']);
        centroids(coincidentCentroids, :) = centroids(coincidentCentroids, :) - 1e-6 * normals(coincidentCentroids, :);      
    end
    perturbedCentroids = centroids;

end