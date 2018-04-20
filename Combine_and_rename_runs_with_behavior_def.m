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
    singleNames=uniqueList(N==1);
    
    mehrfach_namen=dupNames(2:end);
    dupNdxs = arrayfun(@(x) find(uniqueNdx==x), find(N>1), ...
        'UniformOutput',false);
    mehrfach_indices = dupNdxs(2:end);
    
clearvars -except datakey mehrfach_indices mehrfach_namen
       
% dann verknuepfen

for bigloop_i=1:length(mehrfach_namen)

    zu_verknuepfende_dateien_idx=mehrfach_indices{bigloop_i}; 
    zu_verknuepfende_dateien={datakey.key(zu_verknuepfende_dateien_idx).MAT_name}';




    for zu_verknuepfend_i=1:length(zu_verknuepfende_dateien)
        aktuelledatei=zu_verknuepfende_dateien(zu_verknuepfend_i);
        aktuelledatei=aktuelledatei{:};
        fieldname=sprintf('data%02d',zu_verknuepfend_i)
        % TODO markiere in datakeyspalte das mehrfach angewendet wird
        DataStruct.(fieldname)=load([char(zu_verknuepfende_dateien(zu_verknuepfend_i)) '.mat']);
        cfg=[];
        
                behaviordefname=[aktuelledatei '_viddef.mat'];
                load(behaviordefname);
            
         cfg.artfctdef.behave.artifact = videoartdef; 
       
        cfg.artfctdef.reject='partial';
        DataStruct.(fieldname).data = ft_rejectartifact(cfg, DataStruct.(fieldname).data); 


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
    dateiname_speichern=datakey.key(mehrfach_indices{bigloop_i}(1)).MAT_name_final;
    dateiname_speichern=[cd '/trialappend/'...
        dateiname_speichern '.mat'];
    save(dateiname_speichern,'data')
    clearvars -except datakey mehrfach_indices mehrfach_namen bigloop_i
    
end

%% jetzt die einzelnen (unikate) mit neuen namen in den ordner kopieren

clearvars -except datakey

% einzelne finden
    aList={datakey.key(:).MAT_name_final}';
    aList = cellfun(@num2str, aList, 'Un', 0 );
    [uniqueList,~,uniqueNdx] = unique(aList);
    N = histc(uniqueNdx,1:numel(uniqueList));
    singleNames=uniqueList(N==1);
    singleIndex = arrayfun(@(x) find(uniqueNdx==x), find(N==1), ...
        'UniformOutput',false);
    clearvars -except datakey singleIndex singleNames
% einzelne dateien mit TrialDefBehave begluecken und mit MAT_name_final
% abspeichern
    for i=1:length(singleNames)
        aktueller_index=singleIndex(i);
        aktueller_index=aktueller_index{:};
        load(datakey.key(aktueller_index).MAT_name)
        
        cfg=[];
        
        load([datakey.key(aktueller_index).MAT_name '_viddef.mat']);   
        cfg.artfctdef.behave.artifact = videoartdef; 
        
        cfg.artfctdef.reject='partial';
        data = ft_rejectartifact(cfg, data);
        
        %urprungsdatei=[cd '/' urprungsdatei '.mat'];
        aktueller_name=singleNames(i);
        aktueller_name=aktueller_name{:};
        aktueller_name=  [cd '/trialappend/' aktueller_name '.mat'];
        save(aktueller_name,'data');
        clearvars -except datakey singleIndex singleNames i
    end


