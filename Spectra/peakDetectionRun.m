clear all;
close all;
clc;

root = pwd;

dirData = dir(root);
dirIndex = [dirData.isdir];
for i = 1:length(dirIndex)
    if strfind(dirData(i).name, '.') > 0
        dirIndex(i) = false;
    end
end

binsp = 5;
shiftbins = cell(4000/binsp, 1);
dirList = {dirData(dirIndex).name}';
for i = 1:length(dirList)
    folder = char(dirList(i));
    subDir = strcat(root, '\', folder);
    subdirData = dir(subDir);
    subdirIndex = ~[subdirData.isdir];
    subdirList = {subdirData(subdirIndex).name};
    
    for j = 1:length(subdirList)
        file = char(subdirList(j));
        fileloc = strcat(subDir, '\', file);
        
        try
            origSpectralData = dlmread(fileloc);
        catch ME
            if (strcmp(ME.identifier, 'MATLAB:textscan:handleErrorAndShowInfo'))
                fprintf('Unable to read: %s\n', file);
            end
            continue;
        end
        
        x = origSpectralData(:,1);
        y = origSpectralData(:,2);

        [peaksx, peaksy] = computePeaks(x, y);
        
        for pkx = peaksx
            cell_i = idivide(int32(pkx), int32(binsp), 'floor');
            rowlen = length(shiftbins(cell_i,:));
            if and(rowlen == 1, isempty(cell2mat(shiftbins(cell_i,1))))
                shiftbins(cell_i, 1) = {strcat(folder, '\', file)};
            else
                shiftbins(cell_i, rowlen+1) = {strcat(folder, '\', file)};
            end
        end
    end 
end


[fid, message] = fopen('peak_index.txt', 'w');
for i = 1:size(shiftbins, 1)
    fprintf(fid, '%d : ', binsp * i);
    for j = 1:size(shiftbins, 2)
        if ~isempty(cell2mat(shiftbins(i,j)))
            fprintf(fid, '%s,', char(shiftbins(i, j)));
        end
    end
    fprintf(fid, '\n');
end

fclose(fid);
