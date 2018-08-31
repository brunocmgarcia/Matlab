%% s180810_bildermachen

clear all
files = dir('*.mat');

for files_i=1:length(files)

load(files(files_i).name)

wantedchannel=30;
S=squeeze(S(:,:,wantedchannel));
F=squeeze(F(:,wantedchannel));
T=squeeze(T(wantedchannel,:)');


%S1=abs(S(1:end));%.^2; % .^2 dazugefuegt. 
S=abs(S);%.^2;



%  normfaktor= repmat(F,1,size(S,2));
%     normfaktor=(normfaktor.^2);
%     normfaktor=1./normfaktor;
%     
%     S_norm= bsxfun(@rdivide, S, normfaktor);


% unten=find(F<80); unten=unten(end);
% oben=find(F>120); oben=oben(end);
% Spercentile=S(unten:oben,:);
% Min_S=prctile(Spercentile(1:end),90);
% Max_S=prctile(Spercentile(1:end),100);

% overlay for parts of the spectrum (noise e.g.)?
%    LO=22.5; %% insert lower limit of band that should be excluded
%    HI=25;   %% higher limit
%    low=find(F<LO); lower=low(end);
%    high=find(F>HI); higher=high(1);
%    S(lower:higher,:)=NaN;

% plot in sec or min?
    T=T/60;     % minutes? => run this line, else not
    
%if isnan(Min_S)==0 && isnan(Max_S)==0
figure
map=imagesc(T, F, S);  axis xy; %% take the absolute part of S
%end


colormap jet;
set(gca, 'ylim', [0 250]); 
caxis([3000000 1e7]); %[Min_S, Max_S] kann auch in imagesc als viertes
%set(gca, 'xlim', [0 178.2]);  % set x limits in unit of x (sec/min/hour)
title([files(files_i).name ' /// M1'] , 'FontSize',12,'FontWeight','bold','Color','k')
% xlabel('Time [s]','FontSize',7,'FontWeight','bold','Color','k');
xlabel('Time post L-Dopa Injection [min]','FontSize',7,'FontWeight','bold','Color','k');
ylabel('Frequency [Hz]','FontSize',18,'FontWeight','bold','Color','k'); 


dateiname=files(files_i).name;
dateiname=dateiname(1:end-4);
savefig(dateiname)
saveas(gcf,[dateiname '.png'])

clearvars S F T dateiname
close all
end
%ylabel('Power [a.u.]','FontSize',7,'FontWeight','bold','Color','k'); 
