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
        CoilCAD.P = P;
        CoilCAD.t = t;
        strcoil.tind = tind;

        save([filepath, '\Coil.mat'], 'CoilCAD', 'strcoil');
    end

    %% EField
    if any(strcmp(nodeNames, 'EField'))
        EPrimary = app.EFieldSolution.EPri;
        ESecondary = app.EFieldSolution.ESec;
        EDiscontInside = app.EFieldSolution.EDiscin;
        EDiscontOutside = app.EFieldSolution.EDisco;
        save([filepath, '\EField.mat'], "EPrimary", "ESecondary", "EDiscontInside", "EDiscontOutside");
    end
    
    %% Surface Fields
    SurfaceFields = cell(0);
    for n = 1:length(nodeNames)

        if any(strcmp(app.mesh.tissue, nodeNames{n}))
            Indicator = app.model.Indicator(:, 1);
            tissuenumber = find(contains(app.model.tissue, nodeNames{n}));
            idx = Indicator == tissuenumber;

            tempin = app.EFieldSolution.EDiscin(idx, :) + app.EFieldSolution.EPri(idx, :) + app.EFieldSolution.ESec(idx, :);
            tempout = app.EFieldSolution.EDisco(idx, :) + app.EFieldSolution.EPri(idx, :) + app.EFieldSolution.ESec(idx, :);
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
    if (~isempty(SurfaceFields))
        save([filepath, '\SurfaceFields.mat'], "SurfaceFields");
    end

    %% Surface Example Plotting
    if any(strcmp(nodeNames, 'Surfaces Plotting Example'))
        copyfile( [ app.dir app.slash 'EFieldPlotter.m' ], filepath);
    end


    %% Planes
    Planes = cell(0);
    if any(strcmp(nodeNames, 'Planes'))
        for n = 1:length(app.planes)
            plane = app.EFieldObs2{n};
            plane.name = app.planes{n}.name;
            plane.width = app.planes{n}.width;
            Planes{n} = plane;
        end

        if (~isempty(Planes))
            save([filepath, '\Planes'], "Planes");
        end

end