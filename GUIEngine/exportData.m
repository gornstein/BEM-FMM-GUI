function exportData(app, filepath)

nodeNames{1} = '';

for n = 1:length(app.DataExportTree.CheckedNodes)
    nodeNames{n} = app.DataExportTree.CheckedNodes(n).Text;

end

%% Head Model
if any(strcmp(nodeNames, 'Head Model'))
    Points = app.model.P;
    triangles = app.model.t;
    normals = app.model.normals;
    Center = app.model.Center;
    Area = app.model.Area;
    Indicator = app.model.Indicator;
    Tissue = app.model.tissue;
    FileNames = app.model.FileNames;
    condDefault = app.model.condDefault;

    save([filepath, '\HeadModel.mat'], 'Points', 'triangles', 'normals', 'Center', 'Area', 'Indicator', 'Tissue', 'FileNames', 'condDefault');
end

%% Coil
if any(strcmp(nodeNames, 'Coil'))
    load('Coil.mat');
    load('CoilCAD.mat');

    if (app.isDipoleCoil)
        CoilCAD.positions = positions;
    else
        CoilCAD.P = P;
        CoilCAD.t = t;
        strcoil.tind = tind;
    end
    
    CoilMatrices = app.solvedmatrices;

    save([filepath, '\Coil.mat'], 'CoilCAD', 'strcoil');
    save([filepath, '\CoilPositions.mat'], 'CoilMatrices')
end

%% EField
if any(strcmp(nodeNames, 'EField'))
    CoilSolutions = cell(0);
    for i = 1:length(app.EFieldSolution)
        Solution.EPrimary = app.EFieldSolution{i}.EPri;
        Solution.ESecondary = app.EFieldSolution{i}.ESec;
        Solution.EDiscontInside = app.EFieldSolution{i}.EDiscin;
        Solution.EDiscontOutside = app.EFieldSolution{i}.EDisco;
        CoilSolutions{i} = Solution;
    end
    save([filepath, '\EField.mat'], "CoilSolutions");
end

%% Surface Fields
CoilFields = cell(0);
for i = 1:length(app.EFieldSolution)
    SurfaceFields = cell(0);
    for n = 1:length(nodeNames)
        if any(strcmp(app.mesh.tissue, nodeNames{n}))
            Indicator = app.model.Indicator(:, 1);
            tissuenumber = find(contains(app.model.tissue, nodeNames{n}));
            idx = Indicator == tissuenumber;

            tempin = app.EFieldSolution{i}.EDiscin(idx, :) + app.EFieldSolution{i}.EPri(idx, :) + app.EFieldSolution{i}.ESec(idx, :);
            tempout = app.EFieldSolution{i}.EDisco(idx, :) + app.EFieldSolution{i}.EPri(idx, :) + app.EFieldSolution{i}.ESec(idx, :);
            surface.surfaceName = nodeNames{n};
            surface.innerField = tempin;
            surface.outerField = tempout;

            surface.Center = app.mesh.Center(idx, :);
            surface.normals = app.mesh.normals(idx, :);
            surface.Area = app.mesh.Area(idx, :);
            t = app.mesh.t(idx, :);
            [surface.P, surface.t] = fixmesh(app.mesh.P, t);

            SurfaceFields{length(SurfaceFields)+1} = surface;
        end
    end
    CoilFields{i} = SurfaceFields;
end
if (~isempty(CoilFields))
    save([filepath, '\SurfaceFields.mat'], "CoilFields");
end

%% Surface Example Plotting
if any(strcmp(nodeNames, 'Surfaces Plotting Example'))
    copyfile( [ app.dir app.slash 'EFieldPlotter.m' ], filepath);
end


%% Planes
Planes = cell(0);
CoilPlanes = cell(0);
if any(strcmp(nodeNames, 'Planes'))
    for i = 1:length(app.EFieldObs2)
        for n = 1:length(app.planes)
            plane = app.EFieldObs2{i}{n};
            plane.name = app.solvedplanes{n}.name;
            plane.width = app.solvedplanes{n}.width;
            Planes{n} = plane;
        end
        CoilPlanes{i} = Planes;
    end

    if (~isempty(CoilPlanes))
        save([filepath, '\Planes'], "CoilPlanes");
    end

end