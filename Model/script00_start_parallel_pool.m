%   This script starts MATLAB parallel pool (could be useful)
%
%   SNM 2022

ppool           = gcp('nocreate');
numThreads      = 20;          %   number of cores to be used
if isempty(ppool)
    tic
    parpool(numThreads);
    disp([newline 'Started parallel pool in ' num2str(toc) ' s']);
end