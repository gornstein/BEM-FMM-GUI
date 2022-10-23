function [coilPatch, coilNormalLineObj, coilFieldLineObj] = displaycoil(axis, coil, matrix, coilNormal, coilField, isDipole)
%%  The function called to display the coil after transformations on the axis specified
% axis: the axis to display onto
% coil: a struct for the coil's mesh containing fields P and t where P contains the points in display units and t contains the triangles 
% matrix: the 4x4 matrix (in display units)
% coilNormal: a boolean value that determines whether the coil normal line is displayed 
% coilField: a boolean value that determines whether the coil normal field is displayed 
% coilPatch: the display patch object for the coil
% coilNormalLineObject: the display line object for the coil's normal line
% coilFieldLineObj: the display line object for the coil's field line
% isDipole: a boolean value saying if the coil is a dipole coil.
%   if false: the coil will be displayed as a mesh 
%   if true: the coil will be displayed as a swarm of points

if (isDipole)

    for j = 1:size(coil.positions, 1)
        point = [coil.positions(j, :) 1]';
        transformedPoint = matrix * point;
        coil.positions(j,:) = transformedPoint(1:3)';
    end

    coilPatch = plot3(axis, coil.positions(:,1), coil.positions(:,2), coil.positions(:,3));
else

    CoilP = coil.P;
    CoilT = coil.t;

    for j = 1:size(CoilP, 1)
        point = [CoilP(j, :) 1]';
        transformedPoint = matrix * point;
        CoilP(j,:) = transformedPoint(1:3)';
    end

    % display the coil
    coilPatch = bemf1_graphics_coil_CAD_app(axis, CoilP, CoilT, 1);
end

rotMatrix = matrix(1:3, 1:3);
transMatrix = matrix(1:3, 4)';

if (coilNormal)
    %   display the vector showing the coil direction
    coilNormalLineObj = displaycoilnormalvector(axis, rotMatrix, transMatrix);
else
    coilNormalLineObj = [];
end


if (coilField)
    %   display the vector from the origin to the coil's translation location
    coilFieldLineObj = displaycoilfieldlines(axis, rotMatrix,transMatrix);
else
    coilFieldLineObj = [];
end

