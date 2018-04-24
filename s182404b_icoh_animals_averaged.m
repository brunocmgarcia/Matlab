%% s182404b average all valid channel combinations for icoherence in groups like str2str and str2snr etc.
% AND THEN AVERAGING ANIMALS

clear all
cd('F:\Auswertung\FINAL180416\AllCombIcoh\grouped4behave\LB20')
files=dir('*.mat');




for animal_i=1:length(files)
    load(files(animal_i).name)
  
    [striatalebeteiligung verwerfen] = find(~cellfun('isempty', strfind(fd(1).labelcmb, 'STR')));    
    [nigralebeteiligung verwerfen] = find(~cellfun('isempty', strfind(fd(1).labelcmb, 'SNR'))); 
    [M1beteiligung verwerfen] = find(~cellfun('isempty', strfind(fd(1).labelcmb, 'M1'))); 
    [str2m1_ind verwerfen]=find(ismember(striatalebeteiligung,M1beteiligung));
    str2m1_ind=striatalebeteiligung(str2m1_ind);
    [snr2m1_ind verwerfen]=find(ismember(nigralebeteiligung,M1beteiligung));
    snr2m1_ind=nigralebeteiligung(snr2m1_ind);
    [str2snr_ind verwerfen]=find(ismember(striatalebeteiligung,nigralebeteiligung));
    str2snr_ind=striatalebeteiligung(str2snr_ind);

    [verwerfen,einzelne_nigral,verwerfen]=unique(nigralebeteiligung);
    snr2snr_ind=nigralebeteiligung;
    snr2snr_ind(einzelne_nigral)=0;
    [snr2snr_ind verwerfen]=find(snr2snr_ind);
    snr2snr_ind=nigralebeteiligung(snr2snr_ind);

    [verwerfen,einzelne_striatal,verwerfen]=unique(striatalebeteiligung);
    str2str_ind=striatalebeteiligung;
    str2str_ind(einzelne_striatal)=0;
    [str2str_ind verwerfen]=find(str2str_ind);
    str2str_ind=striatalebeteiligung(str2str_ind);
     
    for timepoint_i=1:length(fd)
        str2strspec(animal_i,timepoint_i,:)=mean(fd(timepoint_i).cohspctrm(str2str_ind,:),1);
        snr2snrspec(animal_i,timepoint_i,:)=mean(fd(timepoint_i).cohspctrm(snr2snr_ind,:),1);
        str2m1spec(animal_i,timepoint_i,:)=mean(fd(timepoint_i).cohspctrm(str2m1_ind,:),1);
        snr2m1spec(animal_i,timepoint_i,:)=mean(fd(timepoint_i).cohspctrm(snr2m1_ind,:),1);
        str2snrspec(animal_i,timepoint_i,:)=mean(fd(timepoint_i).cohspctrm(str2snr_ind,:),1);
    end
         
            
end

mylim=[-.5 .5];
myColormap = jet(14);


figure('Name','LB20cms', 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);

subplot(5,1,1)
    axis tight
    hold on
        for timepoint_i=1:size(str2strspec,2)
           plot(fd(1).freq, squeeze(nanmean(str2strspec(:,timepoint_i,:),1)), 'color', myColormap(timepoint_i,:))
        end
    hold off
    title('Str 2 Str averaged, all animals');
    ylim(mylim)
    
 subplot(5,1,2)
    axis tight
    hold on
        for timepoint_i=1:size(snr2snrspec,2)
           plot(fd(1).freq, squeeze(nanmean(snr2snrspec(:,timepoint_i,:),1)), 'color', myColormap(timepoint_i,:))
        end
    hold off
    title('SNR 2 SNR averaged, all animals');
    ylim(mylim)

subplot(5,1,3)
    axis tight
    hold on
        for timepoint_i=1:size(str2m1spec,2)
           plot(fd(1).freq, squeeze(nanmean(str2m1spec(:,timepoint_i,:),1)), 'color', myColormap(timepoint_i,:))
        end
    hold off
    title('STR 2 M1 averaged, all animals');
    ylim(mylim)    

subplot(5,1,4)
    axis tight
    hold on
        for timepoint_i=1:size(snr2m1spec,2)
           plot(fd(1).freq, squeeze(nanmean(snr2m1spec(:,timepoint_i,:),1)), 'color', myColormap(timepoint_i,:))
        end
    hold off
    title('SNR 2 M1 averaged, all animals');
    ylim(mylim)    
    
subplot(5,1,5)
    axis tight
    hold on
        for timepoint_i=1:size(str2snrspec,2)
           plot(fd(1).freq, squeeze(nanmean(str2snrspec(:,timepoint_i,:),1)), 'color', myColormap(timepoint_i,:))
        end
    hold off
    title('STR 2 SNR averaged, all animals');
    ylim(mylim)    