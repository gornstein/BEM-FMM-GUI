% Assign interior and exterior tissue 
function [Indicator] = assign_initial_indicator(IndicatorInner, enclosingTissueIdx)
%   This function assigns inner and exterior material type information to each facet

%   Copyright WAW/SNM 2020

    IndicatorOuter = enclosingTissueIdx(IndicatorInner);

    Indicator = [IndicatorInner IndicatorOuter];
end
