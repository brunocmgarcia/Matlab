%s180228_allesschnelldownsamplen
 
  
clear all
dateien=dir('*.mat');
dateien={dateien.name};
dateien=dateien';
mkdir autoartefakt

for i=1:length(dateien)
    i
    datei_i=dateien(i);
    datei_i=datei_i{:};
    load(datei_i);
    cfg=[];
    cfg.feedback='no';
    cfg.resamplefs=500;
    data=ft_resampledata(cfg,data);
%         cfg=[];
%         cfg.reref='yes';
%         cfg.refchannel=31;
%         cfg.demean='yes';
%         data=ft_preprocessing(cfg,data);
%         
%     
%     
%       cfg=[];
%    
%     
%       cfg.artfctdef.zvalue.channel    = 30;
%          cfg.artfctdef.zvalue.cutoff      = 4;
%    cfg.artfctdef.zvalue.trlpadding  = 0;
%    cfg.artfctdef.zvalue.artpadding  = 1;
%    cfg.artfctdef.zvalue.fltpadding  = 0;
%  
%    % algorithmic parameters
%    cfg.artfctdef.zvalue.bpfilter   = 'yes';
%    cfg.artfctdef.zvalue.bpfilttype = 'but';
%    cfg.artfctdef.zvalue.bpfreq     = [1 15];
%    cfg.artfctdef.zvalue.bpfiltord  = 4;
%    cfg.artfctdef.zvalue.hilbert    = 'yes';
%  
%    % feedback
%    cfg.artfctdef.zvalue.interactive = 'no';
%         
%         [cfg, artifact_jump] = ft_artifact_zvalue(cfg, data);
% 
%         
%         
%     % reject  
%         cfg.artfctdef.reject='partial';
%         data = ft_rejectartifact(cfg, data);  
%     
%     
%     
    zielname=[cd '\autoartefakt\' datei_i(1:end-4) '_ds.mat'];
    save(zielname, 'data');
    
    
    
    clearvars -except i dateien
end