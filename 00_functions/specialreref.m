%% s180228_ownreref_function: data=specialreref(varargin). 
% data=specialreref(data) -> standart channels
% data=specialreref(striatum, snr, m1, cere, data)  mit striatim e.g. [1:15]
       
function data=specialreref(varargin)
switch length(varargin)
    case 1
        data=varargin{1};
        striatum=[1:15];
        snr=[16:29];
        m1=30;
        cere=31;
        
    case 5
        striatum=varargin{1};
        snr=varargin{2};
        m1=varargin{3};
        cere=varargin{4};
        data=varargin{5};
end
        
        

for trial_i=1:length(data.trial)

    refstruct(1,:) = mean(data.trial{1,trial_i}(striatum,:), 1);
    refstruct(2,:) = mean(data.trial{1,trial_i}(snr,:), 1);
    refstruct(3,:) = data.trial{1,trial_i}(m1,:);
    refstruct(4,:) = data.trial{1,trial_i}(cere,:);
    ref=mean(refstruct,1);
    for chan=1:31
      data.trial{1,trial_i}(chan,:) = data.trial{1,trial_i}(chan,:) - ref;
    end
    clearvars refstruct ref chan
end

end
