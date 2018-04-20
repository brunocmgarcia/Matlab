%% s180116 zeug um das layout aus einem MRI slice zu erstellen.

[B]=permute(squeeze(mri.anatomy(50,:,:)), [2 1]);
B=flipud(B);
B=fliplr(B);
B=mat2gray(B);

rgb=B(:,:,[1 1 1]);
imshow(imcomplement(rgb))%,[0 65536])
IM2 = imcomplement(IM)
rgb=imcomplement(rgb);
imwrite(rgb,'layout_image.png');

cfg=[];
cfg.image='layout_image.png';
lay=ft_prepare_layout(cfg);

cfg = [];
cfg.image  = 'layout_image.png';    % use the photo as background
cfg.layout = lay;                 % this is the layout structure that you created with ft_prepare_layout
ft_layoutplot(cfg);

save VAR_lay.mat lay



cfg           = [];
cfg.component = 'all';%[1:20];       % specify the component(s) that should be plotted
cfg.layout    = lay; % specify the layout file that should be used for plotting
cfg.comment   = 'no';
ft_topoplotIC(cfg, comp)