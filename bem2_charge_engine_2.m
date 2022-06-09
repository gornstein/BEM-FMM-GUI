%   This script computes the induced surface charge density for an
%   inhomogeneous multi-tissue object in an external time-varying magnetic
%   field due to a coil via a BEM/FMM iterative solution with accurate
%   neighbor integration
%
%   Copyright SNM/WAW 2017-2020


%%  Parameters of the iterative solution
relres       = 1e-12;           %    Minimum acceptable relative residual 
weight       = 1/2;             %    Weight of the charge conservation law to be added (empirically found)
iter         = 25;

%%  Right-hand side b of the matrix equation Zc = b. Compute pointwise
%   Surface charge density is normalized by eps0: real charge density is eps0*c
tic
EincP    = bemf3_inc_field_electric(coil.strcoil, model.P, coil.dIdt, mu0);             %   Incident coil field
Einc     = 1/3*(EincP(model.t(:, 1), :) + EincP(model.t(:, 2), :) + EincP(model.t(:, 3), :));
b        = 2*(model.contrast.*sum(model.normals.*Einc, 2));                         %   Right-hand side of the matrix equation
IncFieldTime = toc

%% GMRES iterative solution
tic
prec            = 1e-3;                         %   precision  
MATVEC = @(c) c+bemf4_surface_field_lhs(c, model.Center, model.Area, model.contrast, model.normals, weight, model.EC, prec);   
[c, its, resvec] = fgmres(MATVEC, b, relres, 'restart', iter, 'x0', b);
g.GMRESTime = toc;

%%  Plot convergence history
figure; 
semilogy(resvec/resvec(1), '-o'); grid on;
title('Relative residual of the iterative solution');
xlabel('Iteration number');
ylabel('Relative residual');
