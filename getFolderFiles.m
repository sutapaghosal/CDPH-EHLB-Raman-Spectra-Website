root = pwd;

fid = fopen('dir_index.txt', 'w');

dirData = dir(root);
dirIndex = [dirData.isdir];
for i = 1:length(dirIndex)
    if strfind(dirData(i).name, '.') > 0
        dirIndex(i) = false;
    end
end

dirList = {dirData(dirIndex).name}';
for i = 1:length(dirList)
    fprintf(fid, '__FOLDER__: %s\n', char(dirList(i)));
    
    subDir = strcat(root, '\', char(dirList(i)));
    subdirData = dir(subDir);
    subdirIndex = ~[subdirData.isdir];
    subdirList = {subdirData(subdirIndex).name};
    
    for j = 1:length(subdirList)
        fprintf(fid, '%s\n', char(subdirList(j)));
    end
    
    fprintf(fid, '\n');
end

fclose(fid);

