function [recommendedLimits] = bemplot_2D_planeField(obsPlane, fieldToPlot, options)

    % fieldToPlot: One entry per observation point
    % options: structure with following fields:
    %   options.ThresholdLow:   field values below this value will be truncated
    %   options.ThresholdHigh:  field values above this value will be truncated
    %   options.NumLevels:      Number of levels into which the field should be divided
    
    %% If the user didn't specify the field to be plotted, use the total E-field magnitude
    if nargin < 2 || isempty(fieldToPlot)
        temp = vecnorm(obsPlane.FieldEPrimary + obsPlane.FieldESecondary, 2, 2);
    else
        temp = fieldToPlot;
    end
    
    %% Perform thresholding
    % If a low threshold is not specified, use the 2nd percentile of the data
    if nargin < 3 || isempty(options) || ~isfield(options, 'ThresholdLow') || isempty(options.ThresholdLow)
        sortedTemp = sort(temp);
        lowPercentileIndex = floor(0.02*length(temp));
        thLow = sortedTemp(lowPercentileIndex);
    else
        thLow = options.ThresholdLow;
    end
    
    % If a high threshold is not specified, use the 98th percentile of the data
    if nargin < 3 || isempty(options) || ~isfield(options, 'ThresholdHigh') || isempty(options.ThresholdHigh)
        if ~exist(sortedTemp, 'var') % Reuse the sorted list if available
            sortedTemp = sort(temp);
        end
        highPercentileIndex = floor(0.98*length(temp));
        thHigh = sortedTemp(highPercentileIndex);
    else
        thHigh = options.ThresholdHigh;
    end
    % Thresholding
    temp(temp > thHigh) = thHigh;
    temp(temp < thLow)  = thLow;
    
    
    %% Set contour tick
    % If number of levels is not specified, use 20 by default
    if nargin < 3 || isempty(options) || ~isfield(options, 'NumLevels') || isempty(options.NumLevels)
        levels = 20;
    else
        levels = options.NumLevels;
    end
    tick            = round((thHigh-thLow)/levels, 1, 'significant');
    
    %% Set plot axis and scale
    % If cross-section plane is axis-aligned, plot according to axis-aligned coordinates
    isAxisAligned = obsPlane.PlaneABCD(1:3) > 0.99;
    if(sum(isAxisAligned) == 1)    
        pointsPlot = obsPlane.Points;
        pointsPlot(:, isAxisAligned) = [];
        pointsPlot = round(pointsPlot, 6);

        [pointsPlot, idx] = sortrows(pointsPlot);
        a = unique(pointsPlot(:, 1));
        b = unique(pointsPlot(:, 2));
        temp = temp(idx);
    else % If not axis-aligned, decompose observation points in terms of the plane's basis
        a = obsPlane.x;
        b = obsPlane.y;
    end
    
    %% Plot
    [C, h]          = contourf(a, b, reshape(temp, length(a), length(b)), levels);
    h.LevelList     = tick*round(h.LevelList/tick);
    
    recommendedLimits.XLim = [min(a) max(a)];
    recommendedLimits.YLim = [min(b) max(b)];
end