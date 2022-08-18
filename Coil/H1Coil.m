load coilCAD_H1.mat;
load coil_H1.mat;
Orig = (max(P)+min(P))/2;
P = P-Orig;
strcoil.Pwire = strcoil.Pwire-Orig;
P = P*1.2;
strcoil.Pwire = strcoil.Pwire*1.2;

save('coil', 'strcoil');
save('coilCAD', 'P', 't', 'tind');