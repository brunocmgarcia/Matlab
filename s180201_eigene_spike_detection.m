%% s180201_costum spike detection gaidi.ca/weblog

% part 1 ist daten laden und bandpass filter
clear all
load('CG02_TP-13_Rec02_Chop01of02.mat')

%% artefactrem

 cfg=[];
    % automatic z value artifactremoval
        try cfg.artfctdef.bahave.artifact = videoartdef; end;    
        cfg.artfctdef.zvalue.channel    = 'all';
        cfg.artfctdef.zvalue.cutoff     = 20;
        cfg.artfctdef.zvalue.trlpadding = 0;
        cfg.artfctdef.zvalue.artpadding = 3;
        cfg.artfctdef.zvalue.fltpadding = 0;
        cfg.artfctdef.zvalue.cumulative    = 'yes';
        cfg.artfctdef.zvalue.medianfilter  = 'no';
        cfg.artfctdef.zvalue.medianfiltord = 9;

        cfg.artfctdef.zvalue.absdiff       = 'yes';
        cfg.artfctdef.zvalue.interactive = 'yes';

        [cfg, artifact_times] = ft_artifact_zvalue(cfg, data);


       

%%

cfg=[];
cfg.demean='yes';
cfg.reref='yes';
cfg.refchannel='all';
cfg.bpfilter='yes';
cfg.bpfreq=[300 3000];
data=ft_preprocessing(cfg,data);
medianvoltageperchannel(:,1)=median(data.trial{1,1}(:,artifact_times(1,2)+1:artifact_times(1,2)+100),2);
for i=1:length(artifact_times)
    data.trial{1,1}(:,artifact_times(i,1):artifact_times(i,2))=0;%...
        %repmat(medianvoltageperchannel,1,(length(artifact_times(i,1): ...
        %artifact_times(i,2))));
end
clearvars artifact_times



recording=data.trial{1,1};
recording=recording/800;

% BandPassFreq=[300 3000];
% [b,a]=butter(4, (BandPassFreq/(Fs/2)));
% try 
%     rmpath /Users/guettlec/Documents/MATLAB/fieldtrip-20170816/external/signal/;
% end
% filtered_recording=filtfilt(b,a,recording);
% try
%     addpath /Users/guettlec/Documents/MATLAB/fieldtrip-20170816/external/signal/;
% end
clearvars -except recording data

allLocs = getSpikeLocations(recording,ones(31,1),30000, 'saveDir', cd, 'savePrefix', 'beginn', 'threshGain', 10);

% 
% % alles groesser als threshhold auf null setzten.
% thresh=90;
% 
%   locs = [];
%     for ii=1:size(filtered_recording,1)
%         tlocs = peakseek(abs(filtered_recording(ii,:)),1,thresh);
%         locs = [locs tlocs];
%     end
%     
%     %put the locations in order
%     locs = sort(locs);
% 
%     % waveform has to come back to baseline
%     baseline = 50; % good for uV, might be different for EEG
%     for ii=1:size(filtered_recording,1)
%        
%         for iLoc=1:length(locs)
%             % get quiet locations before/after artifact peak, this if/else
%             % structure reduce computation time significantly
%             if(iLoc==1)
%                 zeroBefore = find(abs(filtered_recording(ii,1:locs(iLoc)))<baseline,1,'last');
%                 % if signal starts out over thresh
%                 if(isempty(zeroBefore))
%                     zeroBefore = 1;
%                 end
%             else
%                 zeroBefore = locs(iLoc-1) + find(abs(filtered_recording(ii,locs(iLoc-1):locs(iLoc)))<baseline,1,'last');
%                 % no zero crossing between last peak and this peak
%                 if(isempty(zeroBefore))
%                     zeroBefore = locs(iLoc-1);
%                 end
%             end
%             if(iLoc==length(locs))
%                 zeroAfter = locs(iLoc) + find(abs(filtered_recording(ii,locs(iLoc):end))<baseline,1,'first');
%                 % if signal ends up over thresh
%                 if(isempty(zeroAfter))
%                     zeroAfter = size(filtered_recording,2);
%                 end
%             else
%                 % minus one doesn't fill in next peak
%                 zeroAfter = locs(iLoc) + find(abs(filtered_recording(ii,locs(iLoc):locs(iLoc+1)))<baseline,1,'first') - 1;
%                 % no zero crossing between this peak and next peak
%                 if(isempty(zeroAfter))
%                     zeroAfter = locs(iLoc+1) - 1;
%                 end
%             end
%             % apply zeros to the entire area that the artifact contains, try to
%             % minimize amount of operations performed
%             if(~isempty(zeroBefore) || ~isempty(zeroAfter))
%                 if(~isempty(zeroBefore) && isempty(zeroAfter))
%                     filtered_recording(ii,zeroBefore:locs(iLoc)) = 0;
%                 elseif(isempty(zeroBefore) && ~isempty(zeroAfter))
%                     filtered_recording(ii,locs(iLoc):zeroAfter) = 0;
%                 else
%                     filtered_recording(ii,zeroBefore:zeroAfter) = 0;
%                 end
%             end
%         end
%     end
%     if length(locs) > 0
%         disp([num2str(length(locs)),' artifacts cured']);
%     end

