%% Ldopa4: nimmt die gefoooften datein zurück dann look at beta.
%output:
clear all
cd('/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/fooofedbeta')
ziel='/Volumes/A_guettlec/Auswertung/00_LDopa_Paper/02a_NOreref_justM1_ds500/Ruhe10/TFRsWithNaN/fooofedbeta/img/';



ordner=dir('*.mat');
files={ordner.name}';
   lowerfreq=18;
higherfreq=60;

for file_i=1:length(files)
    file=files(file_i);
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
%     figure
%     subplot(1,2,1)
%     hold on
%     plot(freq,power)
%     plot(freq,bgfit)
       

%     hold off
     [verwerfen lower]=min(abs(lowerfreq-freq));
    [verwerfen upper]=min(abs(higherfreq-freq));
    [verwerfen peakfreq]=max(flat(lower:upper));
    maxpeakfreq=freq(peakfreq+lower);
    maxpeakheight=flat(peakfreq+lower);
    beta_integral=trapz(freq(lower:upper),flat(lower:upper));
    mygauss=[maxpeakfreq, maxpeakheight];
%       subplot(1,2,2)
%       hold on
%           plot(freq,flat)
%           plot(freq,peakfit)
%           text(freq(1),(min(flat)*.9),num2str(gaussparams))
%           text(freq(1),(min(flat)*.7),num2str(mygauss))
%           
%       hold off
%       ylim([-.1 .6])
    params(file_i,1)=gaussparams(1);
    params(file_i,2)=gaussparams(2);
    params(file_i,3)=gaussparams(3);
    myparams(file_i,1)=mygauss(1);
        myparams(file_i,2)=mygauss(2);
        mytrap(file_i)=beta_integral;
%              saveas(gcf,[ziel dateiname(1:end-10) 'fooofedbeta.png'])
%     close gcf
end
% figure
% subplot(1,2,1)
% hold on
%  %   plot(params(:,1))
%      plot(myparams(:,1))
%      hold off
%      subplot(1,2,2)
%      
%      hold on
%   %  plot(params(:,2))
%     plot(myparams(:,2))
%     hold off
load VAR_wanted181008
for i=1:size(wanted,1)
relevante_betapower(:,:,i)=p(wanted(i,:),:);
relevante_betapower=