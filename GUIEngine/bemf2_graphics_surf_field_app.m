function patchObj = bemf2_graphics_surf_field_app(axis, P, t, FQ, Indicator, tissuenumber, opts) 
%   Surface field graphics:  plot a field quantity FQ at the surface of a
%   brain compartment with the number "tissuenumber"
%
    ind = tissuenumber;                   
    t0  = t(Indicator==ind, :);
    % FQ0 = FQ
    NumberOfTrianglesInShell = size(t0, 1);    
    patchObj = patch(axis, 'faces', t0, 'vertices', P, 'FaceVertexCData', FQ, 'FaceColor', 'flat', 'EdgeColor', 'none', 'FaceAlpha', 1.0);                   
    colormap(axis, "jet"); 
    brighten(axis, 0.33); 
    colorbar(axis); 
    camlight(axis); 
    lighting(axis, "phong");      
    xlabel(axis, 'x, mm'); ylabel(axis, 'y, mm'); zlabel(axis, 'z, mm');
    % set(gcf,'Color','White');    
end