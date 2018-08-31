%% s180814_ds_reref_selectM1

clear all
ordner=dir('*.mat');
files={ordner.name}';


for i=1:length(files)
    file=files(i);
    file=file{:};
    
   
    
   load(file);
   
   cfg=[];
   %cfg.channel={data.label{30}, data.label{31}};
   cfg.channel={data.label{30}};
   data=ft_selectdata(cfg,data);
   
   
   cfg=[];
   cfg.resamplefs=500;
   data=ft_resampledata(cfg,data);
   
   cfg=[]
   cfg.reref='no';
   %cfg.refchannel=data.label{2};
   data=ft_preprocessing(cfg,data);
   
%    cfg=[];
%    cfg.channel=data.label{1};
%    data=ft_selectdata(cfg,data);
   
   
   
    cd downsampled_NOreref_m1
    
    save([file(1:end-4) '_ds_NOreref_m1.mat'],'data')  % function form 
    cd ..
   
    clearvars -except i files
end