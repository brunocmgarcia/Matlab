%% s181216_optical_flow_partIII
clear all
clc
a=hdf5info('/Volumes/A_guettlec/Auswertung/tensorflow/OpticalFlow4Keras.h5');
datadims=a.GroupHierarchy.Datasets(1).Dims;

h5create('/Volumes/A_guettlec/Auswertung/tensorflow/OpticalFlow4KerasShuffle.h5','/x', datadims,'Datatype','single','ChunkSize',[2 120 160 1],'Deflate',9);
h5create('/Volumes/A_guettlec/Auswertung/tensorflow/OpticalFlow4KerasShuffle.h5','/y',[1 datadims(4)] , 'Datatype','uint8','ChunkSize',[1 1],'Deflate',9);

indices=1:datadims(4);
indices=indices(randperm(length(indices)));

for i=1:length(indices)
    x=h5read('/Volumes/A_guettlec/Auswertung/tensorflow/OpticalFlow4Keras.h5','/x',[1 1 1 indices(i)], [2 120 160 1]);
    y=h5read('/Volumes/A_guettlec/Auswertung/tensorflow/OpticalFlow4Keras.h5','/y',[1 indices(i)], [1 1]);
    h5write('/Volumes/A_guettlec/Auswertung/tensorflow/OpticalFlow4KerasShuffle.h5','/x',x, [1 1 1 i], [size(x) 1]);
    h5write('/Volumes/A_guettlec/Auswertung/tensorflow/OpticalFlow4KerasShuffle.h5','/y',y, [1 i], size(y));
    disp([num2str(i) ' of ' num2str(datadims(4))])
    clearvars x y
end
