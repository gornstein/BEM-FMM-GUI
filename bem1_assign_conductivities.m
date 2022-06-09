%   This script assigns conductivity contrast data to each facet of the mesh

%% Load conductivity data
condambient = 0; % The medium outside the model has conductivity 0 S/m
conductivityFile = 'conductivity_simulations_corrected_extended.txt';
%conductivityLine = 10;
conductivityLine = 0;

if conductivityLine ~= 0
    fileID = fopen(conductivityFile);
    numConductivities = max(Indicator);

    % Cycle through lines until we get to the line we want
    currentLine = [];
    for j = 1:conductivityLine
        currentLine = fgetl(fileID);
    end

    dividerIndex = find(currentLine == ' ');
    dividerIndex(end + 1) = length(currentLine);
    lastDivider = 1;
    for j = 1:length(dividerIndex)
        tempConductivity = strtrim(currentLine(lastDivider:dividerIndex(j)));
        lastDivider = dividerIndex(j);

        conductivityList(j,1) = str2double(tempConductivity);
    end
    % Map from conductivityList to cond
    fclose(fileID);

    % Map conductivities to their associated tissues
    % Order: WM, GM, Pia, CSF, Arachnoid, Dura, Bone, Skin
    cond(1:8) = flipud(conductivityList); % Conductivities were conveniently presented in reverse order 
    cond(9) = conductivityList(4); % Ventricles are CSF
end

%% Assign conductivities
[contrast, condin, condout] = assign_conductivities(cond, condambient, Indicator);

%%   Normalize sparse matrix EC by contrast
N   = size(Center, 1);
ii  = ineighborE;
jj  = repmat(1:N, RnumberE, 1); 
CO  = sparse(ii, jj, contrast(ineighborE));
EC  = CO.*EC_base;