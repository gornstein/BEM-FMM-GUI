function bemfmm_plotObsPlaneField(obsPlane, model, field, numContours)
    if ~strcmpi(obsPlane.Type, 'Plane')
        warning('Use bemfmm_makeObsPlane() to define an observation plane');
    end
    
    levels      = numContours;
    th1 = prctile(field, 1-1/levels); % Highest line
    th2 = prctile(field, 1/levels);   % Low percentile
    bemf2_graphics_vol_field(temp, th1, th2, levels, obsPlane.x, obsPlane.y); hold on;
    
    
    
end