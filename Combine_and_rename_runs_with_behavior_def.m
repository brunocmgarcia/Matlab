%% s180124 nimmt alle dateien mit vorhandenen MAT_name_final und
% macht aus den 'CGXX_TPXX_RecXX.mat' ein 'CGXX_TPXX_LB20.mat' oder LB10
% etc. Dabei wird geschaut ob das jeweilige MAT_name_final aus mehreren
% _RecXX files zusammengesetzt wird. wenn ja dann anwendung von
% TrialDefBehave und ft_appenddata der jeweiligen _rec files. Wenn nicht
% dann nur anwendung von TrialDefBehave.
% load into structure with dynamic fieldnames
clear all
mkdir trialappend



% doppelte finden 
load VAR_datakey
aList={datakey.key(:).MAT_name_final}';
    aList = cellfun(@num2str, aList, 'Un', 0 );


    [uniqueList,~,uniqueNdx] = unique(aList);
    N = histc(uniqueNdx,1:numel(uniqueList));
    dupNames = uniqueList(N>1);
    einfach_namen=uniqueList(N==1);
    
    mehrfach_namen=dupNames(2:end);
    dupNdxs = arrayfun(@(x) find(uniqueNdx==x), find(N>1), ...
        'UniformOutput',false);
    mehrfach_indices = dupNdxs(2:end);
    
   
    singNdxs = arrayfun(@(x) find(uniqueNdx==x), find(N==1), ...
        'UniformOutput',false);
    einfach_indices =singNdxs;
    
clearvars -except einfach_indices einfach_namen datakey mehrfach_indices mehrfach_namen 
dateien=dir('*.mat');
dateien={dateien.name};
dateien=dateien';       
% dann verknuepfen
MatNameList={(datakey.key(:).MAT_name)}';
for i=1:length(MatNameList)
    if ischar(cell2mat(MatNameList(i)))==0
        MatNameList(i)={''};
    end
end

for datei_i=1:length(dateien)
    currentfile=dateien(datei_i);
    currentfile=currentfile{:};
    currentfile_matname=currentfile(1:15);
    currentfile_index=find(not(cellfun('isempty', strfind(MatNameList,currentfile_matname))));
    
    
    
    ineinfach=(cellfun(@(x)ismember(x,currentfile_index),einfach_indices, 'UniformOutput',false));
    ineinfach=find([ineinfach{:}]);
    inmehrfach=(cellfun(@(x)ismember(x,currentfile_index),mehrfach_indices, 'UniformOutput',false));
    inmehrfach=(cellfun(@(x)sum(x),inmehrfach, 'UniformOutput',false));
    inmehrfach=find([inmehrfach{:}]);
    inmehrfachbackup=inmehrfach;
    inmehrfach=cell2mat(mehrfach_indices(inmehrfach));
    if isempty(ineinfach)==0
        cfg=[];
        load(currentfile);
        try 
            load([currentfile_matname '_viddef.mat']); 
            cfg.artfctdef.behave.artifact = videoartdef; 

            cfg.artfctdef.reject='partial';
            data = ft_rejectartifact(cfg, data);    
            aktueller_name=  [cd '\trialappend\' datakey.key(currentfile_index).MAT_name_final '.mat'];
            save(aktueller_name,'data');
        catch
            aktueller_name=  [cd '\trialappend\' datakey.key(currentfile_index).MAT_name_final '_noART.mat'];
            save(aktueller_name,'data');
        end
    elseif isempty(inmehrfach)==0
        for zu_verknuepfend_i=1:length(inmehrfach)
            aktuelledatei=inmehrfach(zu_verknuepfend_i);
            aktuelledatei=dir(['*' datakey.key(aktuelledatei).MAT_name '*']);
            aktuelledatei=aktuelledatei.name;
            
            fieldname=sprintf('data%02d',zu_verknuepfend_i)
            DataStruct.(fieldname)=load(aktuelledatei);
            try
            cfg=[];
                
            behaviordefname=[datakey.key(inmehrfach(zu_verknuepfend_i)).MAT_name '_viddef.mat'];
            load(behaviordefname);

            cfg.artfctdef.behave.artifact = videoartdef; 

            cfg.artfctdef.reject='partial';
            DataStruct.(fieldname).data = ft_rejectartifact(cfg, DataStruct.(fieldname).data); 
                hastrialdefswitch=1;
            catch
                hastrialdefswitch=0;
            end

        end

        switch zu_verknuepfend_i
        case 2
        cfg=[];
        data = ft_appenddata(cfg, DataStruct.data01.data, DataStruct.data02.data);
        case 3
        cfg=[];
        data = ft_appenddata(cfg, DataStruct.data01.data, DataStruct.data02.data, DataStruct.data03.data);
        case 4
        cfg=[];
        data = ft_appenddata(cfg, DataStruct.data01.data, DataStruct.data02.data,...
        DataStruct.data03.data, DataStruct.data04.data);
        case 5
        cfg=[];
        data = ft_appenddata(cfg, DataStruct.data01.data, DataStruct.data02.data,...
        DataStruct.data03.data, DataStruct.data04.data, DataStruct.data05.data);
        case 6
        cfg=[];
        data = ft_appenddata(cfg, DataStruct.data01.data, DataStruct.data02.data,...
        DataStruct.data03.data, DataStruct.data04.data, DataStruct.data05.data,...
        DataStruct.data06.data);
        case 7
        cfg=[];
        data = ft_appenddata(cfg, DataStruct.data01.data, DataStruct.data02.data,...
        DataStruct.data03.data, DataStruct.data04.data, DataStruct.data05.data,...
        DataStruct.data06.data, DataStruct.data07.data);
        end
        if hastrialdefswitch==1;
          aktueller_name=  [cd '\trialappend\' datakey.key(currentfile_index).MAT_name_final '.mat'];
          save(aktueller_name,'data');
        else
          aktueller_name=  [cd '\trialappend\' datakey.key(currentfile_index).MAT_name_final '_noART.mat'];
          save(aktueller_name,'data');
        end
        mehrfach_indices{inmehrfachbackup,1}=[];
        mehrfach_namen{inmehrfachbackup,1}=[];
    end
clearvars -except datakey datei_i dateien mehrfach_namen mehrfach_indices MatNameList einfach_namen einfach_indices
end



