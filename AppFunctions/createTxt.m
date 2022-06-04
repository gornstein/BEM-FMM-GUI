function createTxt(app)
%CREATETXT Summary of this function goes here
%   Detailed explanation goes here
%     if ~isunix
%         s = pwd; addpath(strcat(s, '\BEM-FMM-GUI\Model'));
%     else
%         s = pwd; addpath(strcat(s, '/BEM-FMM-GUI/Model'));
%     end

    fid = fopen('tissue_index.txt','wt');
    for i = 1:size(app.UITable.Data,1)
        filenameSTL = app.meshFileNames{i};
        fprintf(fid, strcat('>',app.meshInternalNames{i},32,':',32,strcat(filenameSTL(1:end-4), '.mat'),32,':',32,num2str(app.meshConductivities{i}),32,':',32,app.meshEncTissues{i},'\n'));
    end
    fclose(fid);

    

end

