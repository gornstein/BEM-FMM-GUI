function [cinterp, P, t, normals, Center, Area, Indicator, percentage] = meshadapt(c, P, t, normals, Area, Indicator, tissue, refinement)
%   Adaptive mesh refinement of a composite multicompartment mesh
%   Tissue wise
%   SNM 2021-2022

    charge_face                                 = abs(c).*Area;                             %   face charge in C
    cost_function                               = charge_face;                              %   simple global cost function   
    cost_function(Indicator==1)                 = 0;                                        %   do not refine skin with electrodes
    cost_function(Indicator==length(tissue))    = 0;                                        %   do not refine eyes
    cost_function(Indicator==length(tissue)-1)  = 0;                                        %   do not refine ventricles
    
    index_refine_t = [];
    for m = 2:length(tissue)-2
        temp                = cost_function;
        temp(Indicator~=m) = 0;
        [~, index]          = sort(temp, 'descend');
        index_tissue        = find(Indicator==m); 
        index_refine        = index(1:round(refinement*length(index_tissue))); %    index into global t
        index_refine_t      = [index_refine_t; index_refine];
    end
    index_refine = index_refine_t;
    
    %   Construct the refined structure 
    PP              = [];
    tt              = [];
    nnormals        = [];
    cc              = [];
    Indicatornew    = []; 
    percentage      = zeros(length(tissue), 1);

    for m = 1:length(tissue)
        percentage(m)  = 0;
        index_tissue   = find(Indicator==m);                        %   global indexes for all triangles in the object
        refine         = intersect(index_refine, index_tissue);     %   global indexes of triangles to be refined for the m-th object
        refine         = refine - length(find(Indicator<m));        %   local indexes of triangles to be refined for the m-th object   
        %   Restore object
        obj.t               = t(Indicator==m, :);
        obj.normals         = normals(Indicator==m, :);
        obj.c               = c(Indicator==m);
        [obj.P, obj.t]      = fixmesh(P, obj.t);               
    %     %   Refine object
        if ~isempty(refine)
            percentage(m)  = 100*length(refine)/length(index_tissue);%   normalized to the total number of facets in the tissue
            [ref.P, ref.t, ref.normals, ref.c]      = meshrefiner(obj.P, obj.t(refine, :), obj.normals(refine, :), obj.c(refine));
            obj.P                                   = [ref.P; obj.P];
            norefine                                = setdiff([1:length(obj.t)], refine);
            obj.t                                   = [ref.t; obj.t(norefine, :)+size(ref.P, 1)];
            obj.normals                             = [ref.normals; obj.normals(norefine, :)];
            obj.c                                   = [ref.c; obj.c(norefine)];            
            [obj.P, obj.t]                          = fixmesh(obj.P, obj.t);        
        end
        tt = [tt; obj.t+size(PP, 1)];
        PP = [PP; obj.P]; % in m!
        nnormals = [nnormals; obj.normals];
        cc       = [cc; obj.c];
        Indicatornew= [Indicatornew; repmat(m, size(obj.t, 1), 1)];
    end
    %   Restore global mesh
    Indicator 	= Indicatornew;
    t           = tt;
    P           = PP;
    normals     = nnormals;
    cinterp     = cc;
    %  Meshreorient
    N           = size(t, 1);
    for m = 1:N
        Vertexes        = P(t(m, 1:3)', :)';
        r1              = Vertexes(:, 1);
        r2              = Vertexes(:, 2);
        r3              = Vertexes(:, 3);
        tempv           = cross(r2-r1, r3-r1);  %   definition (*)
        temps           = sqrt(tempv(1)^2 + tempv(2)^2 + tempv(3)^2);
        normalcheck     = tempv'/temps;
        if sum(normalcheck.*normals(m, :))<0;   %   rearrange vertices to have exactly the outer normal
            t(m, 2:3) = t(m, 3:-1:2);           %   by definition (*)
        end     
    end   
    %   Process other data
    Center      = 1/3*(P(t(:, 1), :) + P(t(:, 2), :) + P(t(:, 3), :)); 
    Area        = meshareas(P, t);    
end

