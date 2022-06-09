function [contrast, condin, condout] = assign_conductivities(cond, condambient, Indicator)
%   This function assigns conductivity contrasts to tissue boundaries.
%   cond: Interior conductivity of a given tissue
%   condambient: conductivity of the medium exterior to the outermost tissue
%   Indicator: Stores the inner (:, 1) and outer (:, 2) tissue classes for each facet 

%   Copyright WAW/SNM 2020
    
    cond(end + 1) = condambient;
    Indicator(Indicator == 0) = length(cond); % Wherever Indicator is zero, ensure that the associated conductivity is condambient.

    condin = transpose(cond(Indicator(:, 1)));
    condout = transpose(cond(Indicator(:, 2)));
    contrast = (condin - condout)./(condin + condout);
    contrast(isnan(contrast)) = 0; % Boundaries between two materials of zero conductivity produce NaNs
end