%% s171108 MRI für fieldtrip erzeugen mit richtigen coordinaten

[mri] = ft_read_mri('WHS_SD_rat_T2star_v1.01_downsample3.nii') ; 
mri.unit='mm'
mri.coordsys='paxinos'

mri.transform=[
         0   -0.1172         0   26.0000    % x
   -0.1172         0         0   9.700    % y 
         0         0    0.1172  -16.9000    % z
         0         0         0    1.0000]   %

cfg=[];
ft_sourceplot(cfg,mri)

mri.unit='cm';
save VAR_mri_paxinos mri

%% useful commands

%cfg=[];
%cfg.coordsys  = 'paxinos';
%mri = ft_volumerealign(cfg, mri);


%mri = ft_volumereslice(cfg, mri);


