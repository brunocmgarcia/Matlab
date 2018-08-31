%% s180823_plotting_fooof

clear all
clc

typus='flat';
tiere={'CG04', 'CG05', 'CG06', 'CG07', 'CG08', 'CG09', 'CG10'};
cd('/Users/guettlec/Desktop/downsampled_reref_m1/pwelch/fooof')
FOOOF=load('fooof.mat');
FOOOFbase=load('fooof_realbase.mat');
figure
for ii=1:length(tiere)
    tier=tiere(ii);
    tier=tier{:};
    wanted_fieldnames=fieldnames(FOOOF);
    index=find(contains(wanted_fieldnames, tier));
    wanted_fieldnames=wanted_fieldnames(index);
    clearvars index
    index=find(contains(wanted_fieldnames, typus));
    wanted_fieldnames=wanted_fieldnames(index);
    clearvars index
    
    
    subplot(2,5,ii)
    title(tier)
    hold on
    farbe=parula(length(wanted_fieldnames));
    for i=1:length(wanted_fieldnames)
        gewollt=wanted_fieldnames(i);
        
        gewollt=gewollt{:};
        gewolltbase=[gewollt(1:10) '_praeLD_Ruhe10_' gewollt(22:end)];
        daten=FOOOF.(gewollt)-FOOOFbase.(gewolltbase);
        freq=[gewollt(1:end-(length(typus))) 'freqs'];
        freq=FOOOF.(freq);
        plot(freq, daten, 'Color', farbe(i,:))
        [verwerfen von]=(min(abs(freq-80)));
        [verwerfen bis]=(min(abs(freq-130)));
        TP=str2num(gewollt(9:10));
        gammapower=daten(von:bis);
        ftg(ii,TP)=trapz(gammapower);
        gammapower(gammapower<=0)=0;
        gewichtet=gammapower.*(freq(von:bis));
        gewichtet=sum(gewichtet/sum(gammapower));
        gew_freq(ii,TP)=gewichtet;
        clearvars verwerfen
       

        
        
        
    end
    hold off
  
    ylim([-0.4 1.2])
end
ftg=ftg(:,[1 4 10 16 21]);
gew_freq=gew_freq(:,[1 4 10 16 21]);
subplot(2,5,9)
bar(mean(ftg,1))
subplot(2,5,10)
plot(gew_freq)

