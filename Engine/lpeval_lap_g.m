function [grad] = lpeval_lap_g(targs,sinfo,charges,rfac,nover,eps)
    [~,nt] = size(targs);
    npatches = sinfo.npatches;
    centers = sinfo.centers;
    verts = sinfo.verts;
    [~,nv] = size(verts);
    triind = sinfo.triind;
    area = sinfo.area;
    rnormals = sinfo.normals;
    
    grad = zeros(3,nt);
    
    mex_id_ = 'lpeval_lap_g(i int[x], i double[xx], i int[x], i double[xx], i int[x], i double[xx], i int[xx], i double[x], i double[xx], i double[x], i double[x], i int[x], i double[x], io double[xx])';
    [grad] = flattrirouts(mex_id_, nt, targs, npatches, centers, nv, verts, triind, area, rnormals, charges, rfac, nover, eps, grad, 1, 3, nt, 1, 3, npatches, 1, 3, nv, 3, npatches, npatches, 3, npatches, npatches, 1, 1, 1, 3, nt);

end
    



