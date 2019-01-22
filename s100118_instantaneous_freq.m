%% s100118_instantaneous_freq
 clear all
 close all 
 clc
 load VAR_baselineschluessel
 baselineschluessel=baselineschluessel(10:end,:);
 cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/fooofed/MAT_processed')

load  VAR_centerofmasspeakfreqs 
%masterpeakfreq=results.masterpeakfreq; % edit centerofmass
masterpeakfreq=f; % edit centerofmass
masterpeakfreq=masterpeakfreq(10:end,:);
%masterpeakfreq=nanmedian(masterpeakfreq(:,5:6),2);
masterpeakfreq=nanmean(masterpeakfreq(:,4:7),2); % edit centerofmass

clearvars results f



if ~ispc
    cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/')
else
    cd('F:/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/')

end
cd('180')

for file_i=4%:length(baselineschluessel)    
    datei=baselineschluessel(file_i,1);
    datei=[datei{:}(1:end-18) '.mat']
    baselinedat=baselineschluessel(file_i,2);
    if ~isempty(baselinedat{:})
    baselinedat=baselinedat{:}(1:end-18);
    baselinedat=[baselinedat '_burst.mat']
    load(datei)
    basestruct=load(['/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/burstCenterOfMass/' baselinedat]);
    cfg=[]; 
    cfg.demean='yes';
    data=ft_preprocessing(cfg,data);
    
    load(['TFRsWithNan/' datei(1:end-4) '_ArtTimes.mat'])
    
    for i=1:numel(threshold)
    [verwerfen time2sample]=(min(abs(threshold(i)-data.time{1,1})));
    threshold(i)=time2sample;
    end
    
    for i=1:numel(zvalue)
    [verwerfen time2sample]=(min(abs(zvalue(i)-data.time{1,1})));
    zvalue(i)=time2sample;
    end
    
    binaryartefactchannel=data.time{1,1}*0;
    for artefakt_i=1:size(zvalue,1) 
        binaryartefactchannel(zvalue(artefakt_i,1):zvalue(artefakt_i,2))=1;
    end
    for artefakt_i=1:size(threshold,1)       
        binaryartefactchannel(threshold(artefakt_i,1):threshold(artefakt_i,2))=1;  
    end
    clearvars artefakt_i

    % jetzt habe ich eine 0-1 timeline die mit den samples übereinstimmt.
    % 1=artefakt. Jetzt normales vorgehen zum burstfinden, erstmal mit
    % rect/smooth 

    %1: bp filtern
    cfg=[];
    cfg.bpfilter='yes';
    cfg.bpfreq=[masterpeakfreq(file_i)-5 masterpeakfreq(file_i)+5];
    cfg.bpfiltord=5;
    data=ft_preprocessing(cfg,data);
    orig_data=data;
    %2: rectify
    cfg=[];
    %cfg.rectify='yes';
    cfg.hilbert='complex';
    data=ft_preprocessing(cfg,data);

    %3: smoothing & discard artfkt episodes CAVE GEHT NUR MIT SIGNAL PROCESSING
    %TOOLBOX
    %datrectsmooth=smoothdata(data.trial{1,1},2,'gaussian',(0.1*data.fsample));
    datrectsmooth=abs(data.trial{1,1});
    datrectsmoothorig=data.trial{1,1};
    
%     datrectsmooth(binaryartefactchannel==1)=0;
%     datrectsmooth=datrectsmooth(2000001:2010000);
%     instantfreq=500*diff(unwrap(angle(datrectsmooth)))/(2*pi);
%     figure
%     hold on
%     plot((abs(datrectsmooth))./1e4)
%     plot((instantfreq-108)./10)
%     
%     hold off
%       figure
%     hold on
%     
%     plot(CG_zscore(diff((abs(datrectsmooth))./1e4)))
%     plot(CG_zscore(diff((instantfreq-108)))*3)
%     plot(CG_zscore(((abs(datrectsmooth))./1e4)))
%     hold off
% %     
% %     n_order=50;
% %     orders=linspace(10,300,n_order)/2;
% %     orders=round(orders/(1000/500));
% %     phasemed=zeros(length(orders),length(datrectsmooth));
% %     for oi=1:n_order
% %         for ti=1:length(datrectsmooth)
% %             temp=sort(instantfreq(max(ti-orders(oi),1:min(ti+orders(oi),length(instantfreq)-1))));
% %             phasemed(oi,ti)=temp(floor(numel(temp)/2)+1);
% %         end
% %     end
% %     
% %     subplot(4,1,4)
% %     plot(mean(phasemed,1))
% %     
    
    
    
    
    
    
    
    
    
    
    
    
    %% ztransform with mean and variance from baseline
    datrectsmooth = (datrectsmooth - basestruct.zscore_my) ./ basestruct.zscore_sy;
    
    
    
    
    
    
    
    
    
    
    
    
    %%
    datrectsmooth(binaryartefactchannel==1)=NaN;

    

    %4: berechnung p75
    % P75rs=prctile(datrectsmooth,75); % --> übernahme aus BL dateien
    P75rs=basestruct.P75rs;
    P75rs_curve=((ones(length(datrectsmooth),1)*P75rs)');
    datrectsmooth(isnan(datrectsmooth))=0;
    P75rs_curve(P75rs_curve>=datrectsmooth)=NaN;
    rs_ueberthreshold           = diff( ~isnan([ NaN P75rs_curve NaN ]) );
    rs_NumBlockStart   = find( rs_ueberthreshold>0 )-0;
    rs_NumBlockStartold=rs_NumBlockStart;
    rs_NumBlockEnd     = find( rs_ueberthreshold<0 )-1;
    rs_NumBlockEndold=rs_NumBlockEnd;
    rs_NumBlockLength  = (rs_NumBlockEnd - rs_NumBlockStart + 1)/data.fsample;
    rs_NumBlockLengthold=rs_NumBlockLength;
    rs_NumBlockStart = rs_NumBlockStart(rs_NumBlockStartold>(3000*data.fsample) & rs_NumBlockEndold <(7800*data.fsample));
    rs_NumBlockEnd = rs_NumBlockEnd(rs_NumBlockStartold>(3000*data.fsample) & rs_NumBlockEndold <(7800*data.fsample));
    rs_NumBlockLength = rs_NumBlockLength(rs_NumBlockStartold>(3000*data.fsample) & rs_NumBlockEndold <(7800*data.fsample));%(7800*data.fsample));
    
    datrectsmoothsub=datrectsmooth-P75rs;
    datrectsmoothsub(datrectsmoothsub<=0)=0;

    ausschnitt=orig_data.trial{1,1}(rs_NumBlockStart(ceil(length(rs_NumBlockStart)/2))...
        :rs_NumBlockStart(ceil(length(rs_NumBlockStart)/2))+1500);

    
    
     %datrectsmoothorig(binaryartefactchannel==1)=0;
    instantfreq=(500*diff(unwrap(angle(datrectsmoothorig)))/(2*pi));
    instantfreq=(instantfreq-(median(instantfreq,2)))./10;
    %instantfreqsmooth=smoothdata(instantfreq,2,'gaussian',(0.1*500));
    instantfreqsmooth=(medfilt1(instantfreq,150,2));
 
   % instantfreq=CG_zscore(instantfreq);
    
    figure
    axis tight
    hold on
    a1=plot(datrectsmooth(1:end),'r')
    a2=plot(instantfreq(1:end),'b')
    a3=plot(instantfreqsmooth(1:end),'g')
     a1.Color(4)=.1; 
      a2.Color(4)=.1; 
       a3.Color(4)=.1; 
    hold off
%    
%     
%     
%     figure; hold on;
%     axis tight
%     for burst_i=10:1:length(rs_NumBlockStart)
%         randint=int32(rand*(length(datrectsmooth)-50));
%         datrectaverage(burst_i,:)=datrectsmooth(rs_NumBlockStart(burst_i)-150:rs_NumBlockStart(burst_i)+150);          
%         instantfreqaverage(burst_i,:)=((instantfreqsmooth(rs_NumBlockStart(burst_i)-150:rs_NumBlockStart(burst_i)+150)));
%      %   datrectaverage(burst_i,:)=datrectsmooth(randint-50:randint+50);          
%       %  instantfreqaverage(burst_i,:)=((instantfreqsmooth(randint-50:randint+50)));
%         plota=plot(datrectaverage(burst_i,:),'r');
%         plota.Color(4)=.01;
%         %if max(instantfreqaverage(burst_i,135:155))<6 && min(instantfreqaverage(burst_i,135:155))>-4
%         plotb=plot(instantfreqaverage(burst_i,:),'b');
%         plotb.Color(4)=.01; 
%         %end
%     end
%     hold off
%     ylim([-10 10])
    instantphases=((angle(datrectsmoothorig)))/(2*pi);
    
    figure('Units','Normalized','Position', [0,0,1,1])
    axis tight
    clearvars datrectaverage instantfreqaverage
    hold on
     for burst_i=10:length(rs_NumBlockStart)
%       %  randint=int32(rand*(length(datrectsmooth)-50));
%         
%         datrectaverage(burst_i,:)=datrectsmooth(rs_NumBlockStart(burst_i)-150:rs_NumBlockStart(burst_i)+50);          
%         instantfreqaverage(burst_i,:)=((instantphases(rs_NumBlockStart(burst_i)-150:rs_NumBlockStart(burst_i)+50)));
%      %   datrectaverage(burst_i,:)=datrectsmooth(randint-50:randint+50);          
%       %  instantfreqaverage(burst_i,:)=((instantfreqsmooth(randint-50:randint+50)));
%          plota=plot(datrectsmooth(rs_NumBlockStart(burst_i)-150:rs_NumBlockStart(burst_i)+150),'r');
%          plota.Color(4)=.1;
%         %if max(instantfreqaverage(burst_i,135:155))<6 && min(instantfreqaverage(burst_i,135:155))>-4
%        plotb=plot(((instantphases(rs_NumBlockStart(burst_i)-150:rs_NumBlockStart(burst_i)+150))),'b');
%        plotb.Color(4)=.01; 
         plotc=plot(((instantfreqsmooth(rs_NumBlockStart(burst_i)-300:rs_NumBlockEnd(burst_i)))),'r');
         plotc.Color(4)=.01; 
          
        %end
    end
    hold off
    %xlim([130 170])
   % ylim([-1.5 2])
    
    %ylim([-10 10])
    
    
    
    %% bis hier
  
    end
    %clearvars -except baselineschluessel file_i masterpeakfreq 
end
