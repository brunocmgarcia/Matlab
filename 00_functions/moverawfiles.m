%%%%%%%
function moverawfiles(pfad)

    cd(pfad)
        %%% RAW FILES
        FileList = dir('*RAW*.nex'); % finde alle RAW dateien
        N = size(FileList,1);
        if N~=0
            mkdir('RAW');
            for k = 1:N
                filename = FileList(k).name;
                fprintf('%s ', k);
                channelcell = (regexp(filename,'\d*','Match')); %da die channel mit zb 2 und nicht 02
                channelnummer = str2num(channelcell{1,1});      %laufen muss neu geordnet werden
                movefile(filename, sprintf('RAW/%02d.nex', channelnummer)); %alternativ einfach copyfile statt movefile
            end
        else
                fprintf('No RAW Data found\n');
        end

        %%% LFP FILES
        FileList = dir('*LFP*.nex'); % finde alle LFP dateien
        N = size(FileList,1);
        if N~=0
            mkdir('LFP');
            for k = 1:N
                filename = FileList(k).name;
                fprintf('%s ', k);
                channelcell = (regexp(filename,'\d*','Match')); %da die channel mit zb 2 und nicht 02
                channelnummer = str2num(channelcell{1,1});      %laufen muss neu geordnet werden
                movefile(filename, sprintf('LFP/%02d.nex', channelnummer)); %alternativ einfach copyfile statt movefile
            end
        else
                fprintf('No LFP Data found\n');
        end
        
    cd ../
end

    
    
    