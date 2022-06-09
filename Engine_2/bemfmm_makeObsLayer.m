% Given outer and inner shells defined by meshOut and meshIn, 
%  interpolate an observation surface between them
% distFraction is between 0 and 1: in terms of fraction of distance between
%  inner shell and outer shell, how far from the inner shell should the
%  interpolated shell lie?  (0: coincides with inner shell. 1: coincides
%  with outer shell. 0.5: halfway between outer shell and inner shell)

function obs = bemfmm_makeObsLayer(meshOut, meshIn, distFraction)

    if distFraction > 1 || distFraction < 0
        error('distFraction must be between 0 and 1');
    end

    % FS == out, HEA == in
    meshOutCenter = meshtricenter(meshOut.P, meshOut.t);
    % meshInCenter = meshtricenter(meshIn.P, meshIn.t);
    
    % Subdivide the inner surface
    [coeffS, weightsS, IndexS]  = tri(5);
    Center_subdiv               = zeros(IndexS*size(meshIn.t, 1), 3);
    
    P1                          = meshIn.P(meshIn.t(:, 1), :);
    P2                          = meshIn.P(meshIn.t(:, 2), :);
    P3                          = meshIn.P(meshIn.t(:, 3), :);
    
    for j = 1:IndexS
        currentIndices                   = ([1:size(meshIn.t, 1)] - 1)*IndexS + j; 
        Center_subdiv(currentIndices, :) = coeffS(1, j)*P1 + coeffS(2, j)*P2 + coeffS(3, j)*P3;
    end
    wneighbor = knnsearch(Center_subdiv, meshOutCenter,  'k', 1);   % [1:FS, 1]
    
    midP = distFraction * centerOut + (1-distFraction)*Center_subdiv(wneighbor, :);
    
    %% Assemble structure
    
    obs.Type = 'Surface';
    obs.TemplateP = meshOut.P;
    obs.Templatet = meshOut.t;
    obs.TemplateNormals = []; % Consider finding a way to fill this field in
    obs.TemplateCenter = meshOutCenter;
    
    obs.Points = midP;
    
    % Create placeholders for E-field neighbor integrals
    obs.EC_x = [];
    obs.EC_y = [];
    obs.EC_z = [];
    
    % Create placeholders for field variables
    obs.FieldEPrimary = zeros(size(obs.Points));
    obs.FieldESecondary = zeros(size(obs.Points));
    obs.FieldBPrimary = zeros(size(obs.Points));
    obs.FieldBSecondary = zeros(size(obs.Points));
    
end