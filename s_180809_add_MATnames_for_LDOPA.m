%% s_180809_add_MATnames_for_LDOPA

clear all
load VAR_datakey
counter=0;

% tiere= {'CG02'
%         'CG04'
%         'CG05'
%         'CG06'
%         'CG07'
%         'CG08'
%         'CG09'
%         'CG10'};
tiere= {'CG08', 'CG09', 'CG10'};
Ephysliste={datakey.key(:).ephys}';    
    
for i=1:length(tiere)
    tier=tiere(i);
    tier=tier{:};
    dates=datakey.TP2dates.(tier);
    dates=dates(dates(:,2)<100,:);
    dates=dates(dates(:,2)>-1,:);
    for ii=1:size(dates,1)
        searchterm=[tier '/' num2str(dates(ii,1))]; 
        Index = find(contains(string(Ephysliste),searchterm));
        for iii=1:length(Index)
            datakey.key(Index(iii)).MAT_name  =sprintf('%s_TP%02d_Rec%02d', ...
                    tier, dates(ii,2), iii);
                counter=counter+1;
        end
    end
end
    
    
    
    
