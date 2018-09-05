function downsample_combine_LP(pfad)

    cd(pfad);
    cd RAW;
    channelofinterest=[1:31];
    for i=1:length(channelofinterest)
      cfgp         = [];
      cfgp.dataset = pwd;
      cfgp.channel = channelofinterest(1,i);
      datp         = ft_preprocessing(cfgp);

      cfgr            = [];
      cfgr.resamplefs = 1000; 
      datr{i}         = ft_resampledata(cfgr, datp);
      clear datp
    end

    cfg = [];
    datall = ft_appenddata(cfg, datr{:}); % this expands all cells into input variables
    
    %%%%% LP 500
        cfg.padding      = 0;
        cfg.padtype      = 'data';
        cfg.continuous   = 'yes';
        cfg.demean       = 'yes';
        cfg.lpfilter='yes';
        cfg.lpfreq='500';
        data=ft_preprocessing(cfg, datall);
        save data data
        clear data
    
    cd ../
    cd ../
end 