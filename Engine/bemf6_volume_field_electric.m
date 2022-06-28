function E = bemf6_volume_field_electric(Points, c, P, t, Center, Area, normals)
%   Computes electric field for an array Points anywhere in space (line,
%   surface, volume). This field is due to surface charges at triangular
%   facets only. Includes accurate neighbor triangle integrals for
%   points located close to a charged surface.   
%   R is the dimensionless radius of the precise-integration sphere
%
%   Copyright WAW/MR/SNM 2022
%   R = is the local radius of precise integration in terms of average triangle size 
%   Set up arguments for the cool solver
    sinfo           = [];
    sinfo.npatches  = length(c);
    sinfo.centers   = transpose(Center);
    sinfo.verts     = transpose(P);
    sinfo.normals   = transpose(normals);
    sinfo.triind    = transpose(t);
    sinfo.area      = 2*Area;

    targs           = transpose(Points);
    rfac            = 2.0;
    nover           = 1;
    eps             = 1e-4;
    Esec_fmmInts    = -lpeval_lap_g(targs,sinfo,c,rfac,nover,eps);
    E               = transpose(Esec_fmmInts);
end