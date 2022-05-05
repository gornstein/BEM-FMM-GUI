function [P, t, normals, IndicatorElectrodes] = meshimprint(P, t, normals, strge)

%%   Imprint electrodes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Imprints an arbitrary number of electrodes
%   Returns new arrays P, t, normals
%   Returns indexes in t into particular electrodes
%   Copyright SNM 2016-2019

    NumberOfElectrodes      = strge.NumberOfElectrodes; 
    PositionOfElectrodes    = strge.PositionOfElectrodes; 
    RadiusOfElectrodes      = strge.RadiusOfElectrodes; 
    
    %%   Establish connectivity
    %   si - triangles attached to every vertex (neighbor triangles)
    %   vi - vertices attached to every vertex (neighbor edges)      
    [si, vi]        = vertices(P, t);
    %   edges - array of mesh edges
    edges           = meshconnee(t);
    %   avgedgelength - average edge length   
    temp            = P(edges(:, 1), :) - P(edges(:, 2), :);                              
    
    %%  Move nodes located close to the boundary exactly to the boundary
    avgedgelength   = mean(sqrt(dot(temp, temp, 2)));
    %   tol - relative tolerance with regard to edge length
    tol = 0.2;        
    for m = 1:NumberOfElectrodes        
        position    = PositionOfElectrodes(m, :);
        DIST        = sqrt((P(:, 1)-position(1)).^2 + (P(:, 2)-position(2)).^2 + (P(:, 3)-position(3)).^2);
        temp1       = DIST-RadiusOfElectrodes(m);
        temp2       = abs(temp1)/avgedgelength<tol;
        dirvector   = (P(temp2, :) - position);
        dirvector   = dirvector./repmat(sqrt(dot(dirvector, dirvector, 2)), 1, 3);
        P(temp2, :) = P(temp2, :) - dirvector.*repmat(temp1(temp2), 1, 3);
    end

    %%   Split all intersected triangles    
    %   Add boundary nodes/add triangles for all edges crossing the boundary
    Numbers  = size(P, 1);     %    global numbers of new boundary nodes (accumulating)
    NewTriangles = [];         %    new triangles
    NewNormals   = [];         %    new normal vectors
    NewNodes     = [];         %    new nodes (with repetition)    
    Remove       = [];         %    triangles to remove (to split)    
    for m = 1:NumberOfElectrodes
        %   Find all nodes within the sphere
        position =  PositionOfElectrodes(m, :);
        DIST = sqrt((P(:, 1)-position(1)).^2 + (P(:, 2)-position(2)).^2 + (P(:, 3)-position(3)).^2);
        temp  = DIST<RadiusOfElectrodes(m)-1024*eps;
        temp  = find(temp>0);   %   all nodes within the sphere      
        for n = 1:length(temp)  %   node, which is in 
            point = temp(n);    %   check this inner node
            index_in        = intersect(vi{point}, temp);   %   all neighbor nodes of the inner node which are inside the sphere
            index_out       = setdiff(vi{point}, temp);     %   all neighbor nodes of the inner node which are outside the sphere                
            if ~isempty(index_out)                          %   find all crossing triangles   
                for p = 1:length(si{point})                 %   loop over triangles attached to the inner node which may intersect the boundary
                    TriNum = si{point}(p);                  %   individual triangle TriNum attached to the inner node which may intersect the boundary
                    IndexIn     = intersect(t(TriNum, 1:3)', index_in);     %    index into node(s) of TriNum that are inside                    
                    IndexOut    = intersect(t(TriNum, 1:3)', index_out);    %    index into node(s) of TriNum that are outside                                  
                    if length(IndexOut)==2                  %    two nodes of TriNum are outside and one (target node) is inside                    
                        OutNode1    = P(IndexOut(1), :);
                        OutNode2    = P(IndexOut(2), :);
                        InNode      = P(point, :);               
                        InterNode1  = linesphere(OutNode1, InNode, position, RadiusOfElectrodes(m));
                        Numbers = Numbers + 1;
                        InterNode2  = linesphere(OutNode2, InNode, position, RadiusOfElectrodes(m));                                                          
                        Numbers = Numbers + 1;
                        %   Construct subdivision triangles                        
                        tadd1 = [IndexOut(1)  Numbers-1  IndexOut(2)];
                        tadd2 = [IndexOut(2)  Numbers-1  Numbers-0];                    
                        tadd3 = [point        Numbers-1  Numbers-0];
                        NewTriangles    = [NewTriangles; tadd1; tadd2; tadd3];
                        NewNormals      = [NewNormals; normals(TriNum, :); normals(TriNum, :); normals(TriNum, :)];
                        Remove          = [Remove; TriNum];
                        NewNodes        = [NewNodes; InterNode1; InterNode2];  
                        if norm(InterNode1-InterNode2)<1024*eps
                            'here'
                        end
                    end                    
                    if (length(IndexIn)==1)&&(length(IndexOut)==1)          %   two nodes of TriNum are inside and one outside  
                        if isempty(intersect(Remove, TriNum))
                            InNode1 = P(IndexIn, :);
                            InNode2 = P(point, :);
                            OutNode = P(IndexOut, :);
                            InterNode1  = linesphere(InNode1, OutNode, position, RadiusOfElectrodes(m));
                            Numbers = Numbers + 1;
                            InterNode2  = linesphere(InNode2, OutNode, position, RadiusOfElectrodes(m));                                                          
                            Numbers = Numbers + 1;
                            %   Construct subdivision triangles                
                            tadd1 = [IndexIn   Numbers-1  point];
                            tadd2 = [point     Numbers-1  Numbers-0];
                            tadd3 = [IndexOut  Numbers-1  Numbers-0]; % good
                            NewTriangles    = [NewTriangles; tadd1; tadd2; tadd3];   
                            NewNormals      = [NewNormals; normals(TriNum, :); normals(TriNum, :); normals(TriNum, :)];
                            Remove          = [Remove; TriNum];
                            NewNodes        = [NewNodes; InterNode1; InterNode2];                              
                        end
                    end                    
                end                
            end
        end
    end     
   
    %   Construct the new mesh
    t(Remove, :)        = [];
    normals(Remove, :)  = [];
    t                   = [t; NewTriangles];
    normals             = [normals; NewNormals];
    P                   = [P; NewNodes];
    
    %   Remove triangles with coincident points from the mesh (when two nodes are at the boundary)
    A = meshareas(P, t);
    index = find(A<1e-9);
    t(index, :)                 = [];
    normals(index, :)           = []; 
        
    %  Remove duplicated nodes from the mesh        
    [P, t]  = fixmesh(P, t);
    
    %   Remove duplicated triangles with equal centers
    C = meshtricenter(P, t);
    [~, index, ~] = unique(C, 'rows');
    t             = t(index, :);
    normals       = normals(index, :);
    
    %   Reorient triangles as required
    t = meshreorient(P, t, normals);
    
    %   Select electrodes  
    IndicatorElectrodes = zeros(size(t, 1), 1);    
    C = meshtricenter(P, t);
    for m =  1:NumberOfElectrodes
        %   Identify new electrode triangles     
        position =  PositionOfElectrodes(m, :);       
        temp = (C(:, 1)-position(1)).^2  + (C(:, 2)-position(2)).^2  + (C(:, 3)-position(3)).^2;        
        R2 = RadiusOfElectrodes(m)^2;
        temp   = find( temp<=R2 - 1024*eps);
        IndicatorElectrodes(temp) = m;    
    end      
   
end

function [si, vi] = vertices(P, t)
    %   si - triangles attached to every vertex (neighbor triangles)
    %   vi - Vertices attached to every vertex (neighbor edges)   
    si = cell(size(P, 1), 1);
    vi = cell(size(P, 1), 1);
    for m = 1:size(P, 1)
        temp  = (t(:, 1)==m)|(t(:, 2)==m)|(t(:, 3)==m);
        si{m} = find(temp>0);
        temp  = unique([t(si{m}, 1); t(si{m}, 2); t(si{m}, 3)]);
        temp(temp==m) = [];  
        vi{m} = temp(temp>0);
    end    
end

function IntersectionPoint = linesphere(P1, P2, P3, R)
    %   P1, P2 - line;
    %   P3 - sphere center
    %   R  - sphere radius
    %   x, y, z - intersection point
    x1 = P1(1); x2 = P2(1);
    y1 = P1(2); y2 = P2(2);
    z1 = P1(3); z2 = P2(3);
    x3 = P3(1); y3 = P3(2); z3 = P3(3); 
    a = (x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2;
    b = 2*( (x2-x1)*(x1-x3) + (y2-y1)*(y1-y3) + (z2-z1)*(z1-z3) );
    c = x3^2 + y3^2 + z3^2 + x1^2 + y1^2 + z1^2 - 2*(x3*x1 + y3*y1 + z3*z1) - R^2;
    t1 = (-b + sqrt(b^2-4*a*c))/(2*a);
    t2 = (-b - sqrt(b^2-4*a*c))/(2*a);
    t = 0;
    if t1<=1+1024*eps&t1>0 t = t1; end;
    if t2<=1+1024*eps&t2>0 t = t2; end;
    IntersectionPoint(1) = x1 + (x2-x1)*t;
    IntersectionPoint(2) = y1 + (y2-y1)*t;
    IntersectionPoint(3) = z1 + (z2-z1)*t;
end