%% 190222_coefficiant_of_variation
% load('/Users/guettlec/Desktop/burststruct.mat')
% load VAR_baselineschluessel
% baselineschluessel=baselineschluessel(10:end,:);


clearvars -except burststruct


clearvars -except burststruct
close all
allLD=[1 2 4 5 7 8 9; 23 24 26 28 30 32 33; 35 36 38 40 42 44 45; 47 48 50 51 52 54 55; 66 67 69 70 71 73 74]';

for i=1:size(allLD,1)
    for ii=1:size(allLD,2)
        dat{i,ii}=(burststruct(allLD(i,ii)).LD.dat); %now minutes
    end
end


clearvars CV
timeperiods=[0 10 15 20 30 50 70 90 110 130 150 170 180];

for i=1:7
    for ii=1:5
       testdat=dat{i,ii};
       testdat=abs(hilbert(abs(hilbert(testdat))));
       testdattimes=([1:length(testdat)])./(500*60); % in min
       [~,~,testdatsnps]=histcounts(testdattimes,timeperiods);
       testdatsnps(testdatsnps==3)=0;
       testdatsnps=testdatsnps-((testdatsnps>3)*2);
       testdatsnps(testdat==0)=[];
       testdat(testdat==0)=[];
       %testdatsnps(isempty(testdatsnps))=0;
       for iii=1:10
            CV(i,ii,iii)=100*mad(testdat(testdatsnps==iii),1)/median(testdat(testdatsnps==iii));
       end
       clearvars testdat testdattimes testdatsnps
    end
    
end
figure
farben=parula(7);
hold on
for i=1:5
    
plot(squeeze(nanmedian(CV(i,:,:),2)),'Color',farben(i,:))
% plot(squeeze(nanmean(CV(i,:,:),2))+(squeeze(nanstd(CV(i,:,:),[],2))./sqrt(5)),'Color',farben(i,:))
% plot(squeeze(nanmean(CV(i,:,:),2))-(squeeze(nanstd(CV(i,:,:),[],2))./sqrt(5)),'Color',farben(i,:))

end
hold off

hold on
plot(CV,'r')
plot(CV+CVstd,'b')
plot(CV-CVstd,'b')
hold off



