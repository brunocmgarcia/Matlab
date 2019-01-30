%% Ldopa4: nimmt die gefoooften datein zur�ck dann look at beta.
%output:
clear all
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/fooofed_beta')
ziel='/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/fooofed_beta/img/';

% cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/fooofedbeta_pwelch')
% ziel='/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/fooofedbeta_pwelch/img/';
% 

load VAR_wanted181008
wanted=wanted(:,[1 3 4 5 7]);
wanted(6,:)=[16 45 60 73 97]; % präraclo
wanted(7,:)=[18 47 62 75 99]; % präsch
ordner=dir('*.mat');
files={ordner.name}';
wantedfiles=files(wanted);
   lowerfreq=12;
higherfreq=49;

for file_i=1:numel(wantedfiles)
    file=wantedfiles(file_i);
    dateiname=file{:};
    s=load(dateiname);
    fields=fieldnames(s);
    gaussparams=s.(cell2mat(fields(1)));
    peakfit=s.(cell2mat(fields(2)));
    flat=s.(cell2mat(fields(3)));
    bgfit=s.(cell2mat(fields(4)));
    freq=s.(cell2mat(fields(5)));
    power=s.(cell2mat(fields(6)));
    R2=s.(cell2mat(fields(7)));
    spec_peak_rm=s.(cell2mat(fields(8)));
    fooofed=s.(cell2mat(fields(9)));
     figure
    subplot(1,2,1)
    hold on
    plot(freq,power)
    plot(freq,bgfit)
       

    hold off
    ylim([6 9])
     [verwerfen lower]=min(abs(lowerfreq-freq));
    [verwerfen upper]=min(abs(higherfreq-freq));
    [verwerfen peakfreq]=max(flat(lower:upper));
    maxpeakfreq=freq(peakfreq+lower);
    maxpeakheight=flat(peakfreq+lower);
    beta_integral=trapz(freq(lower:upper),flat(lower:upper));
    mygauss=[maxpeakfreq, maxpeakheight];
      subplot(1,2,2)
      hold on
          plot(freq,flat)
          plot(freq,peakfit)
          text(freq(1),(min(flat)*.9),num2str(gaussparams))
          text(freq(1),(min(flat)*.7),num2str(mygauss))
          
      hold off
      ylim([-.1 .6])
    params(file_i,1)=gaussparams(1);
    params(file_i,2)=gaussparams(2);
    params(file_i,3)=gaussparams(3);
    myparams(file_i,1)=mygauss(1);
        myparams(file_i,2)=mygauss(2);
        mytrap(file_i,1)=beta_integral;
           saveas(gcf,[ziel dateiname(1:end-10) 'fooofedbeta.png'])
    close gcf
clearvars -except wantedfiles files ziel file_i lowerfreq higherfreq params myparams mytrap
end

ruhemytrap=mytrap;

%%
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/fooofed_beta')
clearvars -except ruhemytrap
load VAR_wanted181129
ziel=('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/180/TFRsWithNaN/fooofed_beta/img')
%wanted=wanted(1:5,:);
set(0, 'DefaultTextInterpreter', 'none')

%wanted=wanted';
wanted=wanted(:,[1 3 4 5 7]);
ordner=dir('*.mat');
files={ordner.name}';
wantedfiles=files(wanted);
   lowerfreq=12;
higherfreq=49;

for file_i=1:numel(wantedfiles)
    file=wantedfiles(file_i);
    dateiname=file{:};
    s=load(dateiname);
    fields=fieldnames(s);
    gaussparams=s.(cell2mat(fields(1)));
    peakfit=s.(cell2mat(fields(2)));
    flat=s.(cell2mat(fields(3)));
    bgfit=s.(cell2mat(fields(4)));
    freq=s.(cell2mat(fields(5)));
    power=s.(cell2mat(fields(6)));
    R2=s.(cell2mat(fields(7)));
    spec_peak_rm=s.(cell2mat(fields(8)));
    fooofed=s.(cell2mat(fields(9)));
     figure
    subplot(1,2,1)
    hold on
    plot(freq,power)
    plot(freq,bgfit)
        

    hold off
    ylim([6 9])
     [verwerfen lower]=min(abs(lowerfreq-freq));
    [verwerfen upper]=min(abs(higherfreq-freq));
    [verwerfen peakfreq]=max(flat(lower:upper));
    maxpeakfreq=freq(peakfreq+lower);
    maxpeakheight=flat(peakfreq+lower);
    beta_integral=trapz(freq(lower:upper),flat(lower:upper));
    mygauss=[maxpeakfreq, maxpeakheight];
      subplot(1,2,2)
      hold on
          plot(freq,flat)
          plot(freq,peakfit)
          text(freq(1),(min(flat)*.9),num2str(gaussparams))
          text(freq(1),(min(flat)*.7),num2str(mygauss))
          
      hold off
      ylim([-.1 .6])
    params(file_i,1)=gaussparams(1);
    params(file_i,2)=gaussparams(2);
    params(file_i,3)=gaussparams(3);
    myparams(file_i,1)=mygauss(1);
        myparams(file_i,2)=mygauss(2);
        mytrap(file_i,1)=beta_integral;
            saveas(gcf,[ziel dateiname(1:end-10) 'fooofedbeta.png'])
   close gcf
clearvars -except ruhemytrap wantedfiles files ziel file_i lowerfreq higherfreq params myparams mytrap
end

mytrap=reshape(mytrap,[7 5]);
ruhemytrap=reshape(ruhemytrap,[7 5]);
forplotmytrap=cat(3,ruhemytrap,mytrap);



figure('Units','Normalized','Position',[0 0 1 1]) 
title('beta reduction')
hold on
bar(squeeze(mean(forplotmytrap,2)),'BarWidth',0.8,'EdgeColor','none','FaceColor','k');

xticklabels({'101','104','110','116','121','A','B'})
xticks(1:7)

ylabel('beta power')
ngroups=7;
nbars=2;
groupwidth=min(0.8, nbars/(nbars+1.5));
BLerrorbarx=squeeze(nanmean(forplotmytrap,2));
BLerrorbary=(squeeze(nanstd(forplotmytrap,[],2)))/(sqrt(5));
for i=1:nbars
    x=(1:ngroups)-groupwidth/2+(2*i-1)*groupwidth/(2*nbars);
    
    errorbar(x,BLerrorbarx(:,i),[],BLerrorbary(:,i),'k','linestyle','none');
end
legend({'TP101','TP104','TP110','TP116', 'TP121', 'D1ant', 'D2ant'}, 'Location','best') 
%ylim([0 0.6])
hold off





