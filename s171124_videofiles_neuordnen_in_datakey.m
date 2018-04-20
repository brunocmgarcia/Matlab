%% s171124 videodaten neu ordnen nach chronologisch. problem war dass die videodateinamen nicht 
% %d02 für minuten und sekunden hatten, also das ordnen vorher nicht
% richtig geklappt hat

clear all 
load('VAR_datakey.mat')
counter=0;
xcount=0;
currentanimalandtp='CG01/170126/';
for datakey_i=1:length(datakey.key)
    if strfind(datakey.key(datakey_i).video, currentanimalandtp)
        counter=counter+1;
    else
        vidcount=0;
        if datakey.key(datakey_i-1).video
            for aufnahme_i=(datakey_i-counter):(datakey_i-1)
                vidcount=vidcount+1;
                vid(vidcount,1)=string(datakey.key(aufnahme_i).video);
                [verwerfen rest]=strtok(vid(vidcount,1),'/');
                [verwerfen rest]=strtok(rest,'/');
                [verwerfen rest]=strtok(rest,'/');
                [verwerfen rest]=strtok(rest,'_');
                [verwerfen rest]=strtok(rest,'_');
                rest=extractAfter(rest,1);
                [vid_hour, rest]=strtok(rest, '-');
                if numel(char(vid_hour))==1
                    vid_hour="0" + vid_hour;
                end
                
                [vid_min, rest]=strtok(rest, '-');
                if numel(char(vid_min))==1
                    vid_min="0" + vid_min;
                end
                if vid_min=="60" vid_min="59"; end;
                [vid_sek, rest]=strtok(rest, '-');
                if numel(char(vid_sek))==1
                    vid_sek="0" + vid_sek;
                end
                if vid_sek=="60" vid_sek="59"; end;

                vid(vidcount,1)=(vid_hour+"-"+vid_min+"-"+vid_sek);

            end
            istvar=exist('vid', 'var');
            if istvar==1
            xcount=xcount+1;
            
            x(1:length(vid),xcount)=vid;
            vid=datetime(vid,'InputFormat','HH-mm-ss');
            [sort indexsort]=sort(vid);
            repaircount=0;
            for repair_i=(datakey_i-counter):(datakey_i-1)
                repaircount=repaircount+1;
                newvidorder(repaircount)=string(datakey.key(datakey_i-counter+indexsort(repaircount)-1).video);
            end
            newvidorder=newvidorder';
            repaircount=0;
            for repair_i=(datakey_i-counter):(datakey_i-1)
                repaircount=repaircount+1;
                datakey.key(datakey_i-counter+repaircount-1).video=char(newvidorder(repaircount));
            end
            
            clearvars vid sort indexsort newvidorder;
            end
            
            
            counter=1;
            
            
            
        end
        
        currentanimalandtp=char(strtok(string(datakey.key(datakey_i).video),'o'));
        
      
     end
end
%save 'VAR_datakey.mat' datakey
