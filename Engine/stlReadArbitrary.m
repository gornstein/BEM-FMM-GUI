function [v, f, n, name] = stlReadArbitrary(file)

    if ~exist(file,'file')
        error(['File ''%s'' not found. If the file is not on MATLAB''s path' ...
               ', be sure to specify the full path to the file.'], file);
    end
    
    fid = fopen(file,'r');    
    if ~isempty(ferror(fid))
        error(lasterror); %#ok
    end
    
    M = fread(fid,inf,'uint8=>uint8');
    fclose(fid);    
    
    if(isbinary(M))
        [v, f, n, name] = stlReadBinary(file);
    else
        [v, f, n, name] = stlReadAscii(file);
    end
    

end

function tf = isbinary(A)
% ISBINARY determines if an STL file is binary or ASCII.

    % Look for the string 'endsolid' near the end of the file
    if isempty(A) || length(A) < 16
        error('MATLAB:stlread:incorrectFormat', ...
              'File does not appear to be an ASCII or binary STL file.');
    end
    
    % Read final 16 characters of M
    i2  = length(A);
    i1  = max(i2 - 100, 1); % Sometimes the endsolid tag isn't exactly the last 16 chars
    str = char( A(i1:i2)' );
    
    k = strfind(lower(str), 'endsolid');
    if ~isempty(k)
        tf = false; % ASCII
    else
        tf = true;  % Binary
    end
end


