%   This script loads model and NIfTI data when availble
%   It can be used as a starting point
%
%   Copyright SNM/WAW 2017-2022

clear all;

s = pwd;
warning off; rmpath(genpath(s)); warning on;
if(~isunix)
    slash = '\';
else
    slash = '/';
end
model_path = [s, slash, 'ModelEngine'];
addpath(model_path);

load('oldtissuelist');      %   load labels & names of original tissues
load('tissuelist');         %   load names of new tissues 
load('allnewshells');       %   load just in case, if you decide to change composition
load('target.mat');         %   load target data
load('CombinedMesh');       %   load precomputed geometry
load('electrode_data');     %   load electrode data

%   Load NIfTI data
%   This block is optional (only if NIfTI data are available)
tic
nifti_filepath = 'T1w.nii';
if exist(nifti_filepath, 'file')
    VT1         = niftiread(nifti_filepath);
    info        = niftiinfo(nifti_filepath);
    N1N2N3      = info.ImageSize;
    d1d2d3      = info.PixelDimensions;
    DimensionX  = d1d2d3(1)*N1N2N3(1);
    DimensionY  = d1d2d3(2)*N1N2N3(2);
    DimensionZ  = d1d2d3(3)*N1N2N3(3);
else
    disp('No T1 NIfTI data are available');
end

nifti_filepath = 'T2w.nii';
if exist(nifti_filepath, 'file')
    VT2         = niftiread(nifti_filepath);
    info        = niftiinfo(nifti_filepath);
    N1N2N3      = info.ImageSize;
    d1d2d3      = info.PixelDimensions;
    DimensionX  = d1d2d3(1)*N1N2N3(1);
    DimensionY  = d1d2d3(2)*N1N2N3(2);
    DimensionZ  = d1d2d3(3)*N1N2N3(3);
else
    disp('No T2 NIfTI data are available');
end
NIFTILoadTime = toc

%   These data are given here for the following scripts 
PS = 1e3*P;
