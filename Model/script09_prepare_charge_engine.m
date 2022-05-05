%   This is a mesh processor script: it computes neighbor potential
%   integrals necessary for BEM-FMM and the electrode preconditioner
%
%   Copyright SNM/WAW 2017-2022

%   Compute accurate integration for electric field/electric potential on all neighbor facets

script00_start_parallel_pool;

RnumberE        = 4;    %   number of neighbor triangles for analytical integration (fixed, optimized)
ineighborE      = knnsearch(Center, Center, 'k', RnumberE);   % [1:N, 1:Rnumber]
ineighborE      = ineighborE';           %   do transpose  

RnumberP        = 4;           %   number of neighbor triangles for analytical integration of electric potential
ineighborP      = knnsearch(Center, Center, 'k', RnumberP);   % [1:N, 1:RnumberP]
ineighborP      = ineighborP';          %   do transpose  

% Neighbor integrals
warning off
tic
EC                  = meshneighborints_En(P, t, normals, Area, Center, RnumberE, ineighborE);
Neighbor.EnTime = toc;
tic
[PC, integralpd]    = meshneighborints_Pn(P, t, normals, Area, Center, RnumberP, ineighborP, Indicator);
Neighbor.Ptime = toc;
disp(Neighbor)
warning on

%  Compute electrode preconditioner M (left). Electrodes may be assigned to different tissues
tic
load electrode_data;
ElectrodeIndexes = cell(max(IndicatorElectrodes), 1);
for j = 1:max(IndicatorElectrodes)
    ElectrodeIndexes{j} = find(IndicatorElectrodes==j);
end
indexe = transpose(vertcat(ElectrodeIndexes{:}));   %   this index is not contiguous

Ne          = length(indexe); 
tempC       = Center(indexe, :); 
tempA       = Area(indexe); 
A           = repmat(tempA, 1, length(tempA));
M           = (1/(4*pi))*1./dist(tempC').*A';       %   base preconditioner matrix
for m = 1:Ne                                        %   base matrix with zero elements
    M(m, m) = 0;
end
for m = 1:Ne                                                    %   put in neighbor integrals
    indexf                  = indexe(m);                        %   global facet number on electrodes
    mneighbors              = ineighborP(:, indexf);            %   global neighbor numbers of facet indexf
    temp                    = intersect(indexe, mneighbors);    %   global numbers for neighbors of facet indexf within electrodes
    for n = 1:length(temp)
        indexintoM  = find(temp(n)==indexe);                    %   local number for the neighbor temp(n) in indexe - into matrix
        indexintoPD = find(mneighbors==temp(n));                %   local index for the neighbor temp(n) in integralpd - into integralpd
        M(indexintoM, m)  = M(indexintoM, m) + integralpd(indexintoPD, indexf)/(4*pi);
    end
end
M = inv(M);                                        %   direct inversion - replace
disp([newline 'Preconditioner computed in ' num2str(toc) ' s']);

tic
cd ModelEngine
    NewName  = 'CombinedMeshP.mat';
    save(NewName, 'EC', 'PC', 'M', 'integralpd', 'ineighborE', 'ineighborP', '-v7.3');    
    disp([newline 'Neighbor integrals/preconditioner saved in ' num2str(toc) ' s']);
cd ..