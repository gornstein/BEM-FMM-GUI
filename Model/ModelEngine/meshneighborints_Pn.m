function [PC, integralpd] = meshneighborints_Pn(P, t, normals, Area, Center, RnumberP, ineighborP, Indicator)
%   Accurate integration for electric potential on neighbor facets
%   Done for a selected interface only ("Indicator" variable is used)
%   Copyright SNM 2018-2022
    
    N               = size(t, 1);
    integralpe      = zeros(RnumberP, N);    %   exact potential integrals for array of neighbor triangles 
    integralpc      = zeros(RnumberP, N);    %   center-point potential integrals for array of neighbor triangles 
    
    % Select one tissue with electrodes
    M           = length(find(Indicator == 1));   

    gauss       = 25;   %   number of integration points in the Gaussian quadrature  
                        %   for the outer potential integrals
                        %   Numbers 1, 4, 7, 13, 25 are permitted 
    %   Gaussian weights for analytical integration (for the outer integral)
    if gauss == 1;  [coeffS, weightsS, IndexS]  = tri(1, 1);    end;
    if gauss == 4;  [coeffS, weightsS, IndexS]  = tri(4, 3);    end;
    if gauss == 7;  [coeffS, weightsS, IndexS]  = tri(7, 5);    end;
    if gauss == 13; [coeffS, weightsS, IndexS]  = tri(13, 7);   end;
    if gauss == 25; [coeffS, weightsS, IndexS]  = tri(25, 10);  end;
    W           = repmat(weightsS', 1, 3);

    %%   Main loop for analytical double integrals (parallel)
    %   This is the loop over columns of the system matrix
    parfor n = 1:M                  %   inner integral; (n =1 - first column of the system matrix, etc.)        
        r1      = P(t(n, 1), :);    %   [1x3]
        r2      = P(t(n, 2), :);    %   [1x3]
        r3      = P(t(n, 3), :);    %   [1x3]  
      
        %%   Accurate electric-potential integrals
        index       = ineighborP(:, n);             %   those are non-zero rows of the system matrix for given n
        ObsPoints   = zeros(RnumberP*IndexS, 3);    %   to compute RnumberE outer integrals numerically
        IP          = zeros(RnumberP, 1);           %   for the potential
        %%   Accurate electric-potential integrals
        for q = 1:RnumberP
            num = index(q);
            for p = 1:IndexS
                ObsPoints(p+(q-1)*IndexS, :)  = coeffS(1, p)*P(t(num, 1), :) +  coeffS(2, p)*P(t(num, 2), :) +  coeffS(3, p)*P(t(num, 3), :);
            end
        end            
        [JP, ~] = potint(r1, r2, r3, normals(n, :), ObsPoints);     %   JP was calculated without the area Area(n)      
        for q = 1:RnumberP      
            IP(q)   = sum(W(:, 1).*JP([1:IndexS]+(q-1)*IndexS), 1);
        end
        integralpe(:, n) = +IP;                     %   accurate integrals (here is without the area!)        
        %%   Center-point electric-potential integrals   
        temp    = repmat(Center(n, :), RnumberP, 1) - Center(index, :); %   these are distances to the observation/target triangle
        DIST    = sqrt(dot(temp, temp, 2));                             %   single column      
        IPC     = Area(n)./DIST;                                        %   center-point integral, standard format 
        IPC(1)  = 0;                                                    %   this must be zero
        integralpc(:, n) = +IPC;                                        %   center-point approximation
    end 
    
    %%  Define useful sparse matrices EC, PC (for GMRES speed up)    
    N               = size(t, 1);
    const           = 1/(4*pi);  
    
    ii  = ineighborP;
    jj  = repmat([1:N], RnumberP, 1);
    PC  = sparse(ii, jj, const*(-integralpc + integralpe));               %   almost symmetric

    integralpd = integralpe - integralpc;
end