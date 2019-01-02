%% s181213_optical_flow_partII
% Flow files nehmen und in einer grossen HDF5 database mit max compression
% zusammenbauen. 

clear all
clc
close all

cd('/Volumes/A_guettlec/Auswertung/tensorflow/videoartefaktdef')
ordner=dir('*Flow.mat');
files={ordner.name}';
fileindices=1:length(files);
fileindices=fileindices(randperm(length(fileindices)));

 h5create('/Volumes/A_guettlec/Auswertung/tensorflow/OpticalFlow4Keras.h5','/x',[2 120 160 inf] ,'ChunkSize',[2 120 160 100], 'Datatype','single','Deflate',9);
 h5create('/Volumes/A_guettlec/Auswertung/tensorflow/OpticalFlow4Keras.h5','/y',[1 inf] ,'ChunkSize',[1 100], 'Datatype','uint8','Deflate',9);
 h5disp('/Volumes/A_guettlec/Auswertung/tensorflow/OpticalFlow4Keras.h5')
 index_x=1;
 index_y=1;
 counter=0;

for file_i=fileindices
    counter=counter+1;
    disp(counter)
    datei=files(file_i);
    datei=datei{:};
    load(datei)
%     total_u=total_u(:,5:5:end,5:5:end);
%     total_v=total_v(:,5:5:end,5:5:end);
    y=uint8(time(2,1:end-1));
   
    x=permute(cat(4,total_u,total_v),[4 2 3 1]);
    frame_indices=(1:length(y))';
    frame_indices=frame_indices(randperm(length(frame_indices)));
    x = x(:,:,:,frame_indices);
    y=y(:,frame_indices);
  %  disp(size(x1))
  %  disp(size(time))
     

h5write('/Volumes/A_guettlec/Auswertung/tensorflow/OpticalFlow4Keras.h5','/x',x, [1 1 1 index_x], size(x));
h5write('/Volumes/A_guettlec/Auswertung/tensorflow/OpticalFlow4Keras.h5','/y',y, [1 index_y], size(y));
index_x=index_x+size(x,4);
index_y=index_y+size(y,2);

clearvars -except file_i files index_x index_y fileindices counter
end
h5disp('/Volumes/A_guettlec/Auswertung/tensorflow/OpticalFlow4Keras.h5')
cd('/Volumes/A_guettlec/Auswertung/tensorflow/')
