function bemplot_2D_niftiCrossSection_app(axis, VT1, info, plane, m)
%   Valid options for plane are 'xy', 'xz', or 'yz'
%   m (in meters) is the z coord in case of 'xy', y coord in case of 'xz', x coord in case of 'yz'

m = m*1e3; %converts m to mm

N1N2N3      = info.ImageSize;
d1d2d3      = info.PixelDimensions;
DimensionX  = d1d2d3(1)*N1N2N3(1);
DimensionY  = d1d2d3(2)*N1N2N3(2);
DimensionZ  = d1d2d3(3)*N1N2N3(3);

if(strcmp(plane, 'xy'))

    I = round(m/d1d2d3(3) + N1N2N3(3)/2);
    S = squeeze(VT1(:, :, I))';      %   choose the Z cross-section
    S = S(:, end:-1:1);
    image(axis, [-DimensionX/2 +DimensionX/2], [-DimensionY/2 +DimensionY/2], S, 'CDataMapping', 'scaled');

elseif(strcmp(plane, 'xz'))

    I = round(m/d1d2d3(2) + N1N2N3(2)/2);
    S = squeeze(VT1(:, I, :))';      %   choose the Y cross-section
    S = S(:, end:-1:1);
    image(axis, [-DimensionX/2 +DimensionX/2], [-DimensionZ/2 +DimensionZ/2], S, 'CDataMapping', 'scaled');

elseif(strcmp(plane, 'yz'))

    I = round(m/d1d2d3(1) + N1N2N3(1)/2);
    S = squeeze(VT1(I, :, :))';      %   choose the X cross-section
    S = S(:, 1:1:end);
    image(axis, [-DimensionY/2 +DimensionY/2], [-DimensionZ/2 +DimensionZ/2], S, 'CDataMapping', 'scaled');

end
colormap(axis, bone);
end
