clear all; %#ok<CLALL>
if ~isunix
    s = pwd; addpath(strcat(s(1:end-5), '\Simulations\ChargeEngine'));
else
    s = pwd; addpath(strcat(s(1:end-5), '/Simulations/ChargeEngine'));
end