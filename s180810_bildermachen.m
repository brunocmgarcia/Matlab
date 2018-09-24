%% s180810_bildermachen

clear all
files = dir('*.mat');
set(0, 'DefaultTextInterpreter', 'none')
for files_i=1:length(files)

load(files(files_i).name)
for ii=1:31
wantedchannel=ii;
S1=squeeze(S(:,:,wantedchannel));
F1=squeeze(F(:,wantedchannel));
T1=squeeze(T(wantedchannel,:)');


%S1=abs(S(1:end));%.^2; % .^2 dazugefuegt. 
S1=abs(S1);%.^2;



%  normfaktor= repmat(F,1,size(S,2));
%     normfaktor=(normfaktor.^2);
%     normfaktor=1./normfaktor;
%     
%     S_norm= bsxfun(@rdivide, S, normfaktor);


 unten=find(F1<10); unten=unten(end);
 oben=find(F1>70); oben=oben(1);
 Spercentile=S1(unten:oben,:);
 Min_S=prctile(Spercentile(1:end),30);
 Max_S=prctile(Spercentile(1:end),99);

% overlay for parts of the spectrum (noise e.g.)?
%    LO=22.5; %% insert lower limit of band that should be excluded
%    HI=25;   %% higher limit
%    low=find(F<LO); lower=low(end);
%    high=find(F>HI); higher=high(1);
%    S(lower:higher,:)=NaN;

% plot in sec or min?
    T1=T1/60;     % minutes? => run this line, else not
    
%if isnan(Min_S)==0 && isnan(Max_S)==0
figure
map=imagesc(T1, F1, S1);  axis xy; %% take the absolute part of S
%end


colormap jet;
set(gca, 'ylim', [0 70]); 
caxis([Min_S, Max_S]); %[3000000 1e7]] kann auch in imagesc als viertes
%set(gca, 'xlim', [0 178.2]);  % set x limits in unit of x (sec/min/hour)
title([files(files_i).name ' /// ' num2str(ii,'%02d')] , 'FontSize',12,'FontWeight','bold','Color','k')
% xlabel('Time [s]','FontSize',7,'FontWeight','bold','Color','k');
xlabel('Time [min]','FontSize',7,'FontWeight','bold','Color','k');
ylabel('Frequency [Hz]','FontSize',18,'FontWeight','bold','Color','k'); 


dateiname=files(files_i).name;
dateiname=[dateiname(1:end-4) '_' num2str(ii,'%02d')];
savefig(dateiname)
saveas(gcf,[dateiname '.png'])

clearvars S1 F1 T1 dateiname
close all
end
end
%ylabel('Power [a.u.]','FontSize',7,'FontWeight','bold','Color','k'); 
