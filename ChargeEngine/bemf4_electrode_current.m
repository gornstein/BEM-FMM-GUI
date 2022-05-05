function [electrodeCurrents] = bemf4_electrode_current(c, Center, Area, normals, EC, prec, ElectrodeIndexes, condin)    
%   Computes the electrode currents
%
%   Copyright SNM 2021-2022

    %   Find total electrode currents at the electrodes
    En = bemf4_surface_field_electric_accurate(c, Center, Area, normals, EC, prec);   % normal electric field just inside
    electrodeCurrents = zeros(length(ElectrodeIndexes), 1);    
    for j = 1:length(ElectrodeIndexes)
        index = ElectrodeIndexes{j};       
        electrodeCurrents(j) = -sum(En(index).*Area(index).*condin(index));
    end    
end
