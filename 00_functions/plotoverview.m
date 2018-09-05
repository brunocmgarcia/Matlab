function plotoverview(data)

    figure;

    for i=1:data.hdr.nChans;
        subplot(2,2,i);
        plot(data.time{1,1}(1,1:600000), data.trial{1,1}(i,1:600000));
        ylim([-100000 100000]);
        ylabel({'µV'; data.label{i,1}});
    end
    
    subplot(2,2,4);
    plot(data.time{1,1}(1,1:600000), data.trial{1,1}(:,1:600000));
    ylim([-100000 100000]);
    ylabel({'µV'; 'combined'});

end
