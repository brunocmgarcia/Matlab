%s180820_dysVideosUmbennen  DYS_CG04_TP101_000_145444.mp4

clear all

%DYS_CG04_TP101_000_145444.mp4
load VAR_datakey
ordner=dir('*.mp4');
files={ordner.name}';
tiere={ordner.folder}';
ursprungsordner=cd;
zielordner='/Volumes/MOV_chronic/dyskinesie/sorted/newsort/';


for i=1:length(files)
    file=files(i);
    file=file{:};
    tier=tiere(i);
    tier=tier{:};
    tier=tier((end-3):end);
    TPliste=datakey.TP2dates.(tier);
    datum=file(3:8);
    TP=num2str(TPliste(TPliste(:,1)==str2num(datum),2));
    if isempty(TP)
        TP='XXX';
    end
    newname=['DYS_' tier '_TP' TP '_YYY_' file(end-9:end-4) '.mp4']
    
    copyfile(file, [zielordner newname]);
    
    clearvars newname TP datum TPliste tier file
end
    
  