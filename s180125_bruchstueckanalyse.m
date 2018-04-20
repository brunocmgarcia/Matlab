%%s180125_bruchstueckanalyse


clear all
dateiliste=dir('*LB*');
dateiliste={dateiliste.name}';


for i=1:length(dateiliste)
    aktuelledatei=dateiliste(i);
    aktuelledatei=aktuelledatei{:};
    load(aktuelledatei)
    
    try 
        bruchstuecke=data.sampleinfo/data.fsample;
    catch
        bruchstuecke=data.sampleinfo/2000;
        %errordlg([aktuelledatei ': data.fsample not found. used 2000']);
        
    end
    bruchstuecke=bruchstuecke(:,2)-bruchstuecke(:,1);
    Bruchanalyse.name(i)={aktuelledatei(1:end-4)};
    Bruchanalyse.stuecke(i)={bruchstuecke};
    
    
    
    
    
    
    
    clearvars -except dateiliste i Bruchanalyse
end


[max_size, max_index] = max(cellfun('size',Bruchanalyse.stuecke,1));
for i=1:length(Bruchanalyse.stuecke)
    if i ~= max_index
    a=cell2mat(Bruchanalyse.stuecke(i));
    a(end:120)=NaN;
    Bruchanalyse.stuecke(i)={a};
    
    clearvars a
    end
end
for i=1:length(Bruchanalyse.stuecke)
    
    
    MatrixBruch(:,:,i)=cell2mat(Bruchanalyse.stuecke(i));
    
    
end
MatrixBruch=squeeze(MatrixBruch);
MatrixBruch=permute(MatrixBruch, [2 1]);


edges=[0 0.3 0.6 0.9 1.2 1.5 1.8 2.1 ];
counts=histc(MatrixBruch, edges, 2);
hf=figure;
ha=axes;
hb=bar3(edges,counts.');
bar3(counts.')




Y=histcounts(data,edges);
histogram(data,edges)
 


figure
hold on


for i=1:length(Bruchanalyse.stuecke)
    a=Bruchanalyse.stuecke(i);
    a=a{:};
    
    histogram(a,);
    %scatter((ones(length(a),1)*i),a);
    clearvars a
end
hold off
    