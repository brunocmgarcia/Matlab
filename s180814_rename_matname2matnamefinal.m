%% s180814_rename_matname2matnamefinal

clear all
load VAR_datakey
Matliste={datakey.key(:).MAT_name}';

ordner=dir('*.mat');
files={ordner.name}';

for i=34:length(files)
    file=files(i);
    file=file{:}
    file=file(1:end-4);
    index = find(strcmp(Matliste, file));
    if ~isempty(datakey.key(index).MAT_name_final)
        if iscell(datakey.key(index).MAT_name_final)
            final_name=[cell2mat(datakey.key(index).MAT_name_final) '.mat']
        else
             final_name=[(datakey.key(index).MAT_name_final) '.mat']
        end
    movefile([file '.mat'], final_name);
    end
    clearvars file index final_name 
end