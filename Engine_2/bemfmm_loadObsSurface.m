% fname: full file path + filename of surface to load
function obs = bemfmm_loadObsSurface(fname)
    
    obs.Type = 'Surface';
    
    extension = fname(end-3:end);
    if strcmp(extension, 'mat')
        temp = load(fname); % Use structure to ensure proper scope is maintained
        P = temp.P; t = temp.t; normals = temp.normals;
    elseif strcmp(extension, 'stl')
        [P, t, normals] = stlReadArbitrary(fname);
    end
    
    % Surface-specific properties
    obs.TemplateP = P;
    obs.Templatet = t;
    obs.TemplateNormals = normals;
    obs.TemplateCenter = meshtricenter(P, t);
    
    obs.Points = obs.TemplateCenter;
    
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