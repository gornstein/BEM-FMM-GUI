load coilCAD_H1.mat;
load coil_H1.mat;

Orig = (max(P)+min(P))/2;
P = P-Orig;
strcoil.Pwire = strcoil.Pwire-Orig;

save('coil', 'strcoil');
save('coilCAD', 'P', 't', 'tind');