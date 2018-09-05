function prepare4klusta(path2rawfiles)

    striatalekontakte=[2 4 6 8 10 12 14 16 18 22 24 26 28 30]; %14  % Channelkonfiguration!
    SNRkontakte=[1 3 5 7 9 11 15 17 19 21 23 25 27 29 31];     %15
    M1kontakt=13;
    Cerebkontrarefkontakt=20;
    previewsize=600000; % samples
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    cd(path2rawfiles);

    FileList = dir('*RAW*.nex'); % finde alle RAW dateien
    N = size(FileList,1);
    
    formatSpec = 'Es wurden %i RAW .nex Dateien gefunden\nDas Laden der Rohdaten läuft... \nDatei: ';
    fprintf(formatSpec,N);
    
    hdr=ft_read_header(FileList(1).name);
    minuten=(hdr.nSamples/hdr.Fs)/60;
    daten=zeros(N,hdr.nSamples, 'int32');
   
    
    for k = 1:N
        filename = FileList(k).name;
        fprintf('%i ', k);
        channelcell = (regexp(filename,'\d*','Match')); %da die channel mit zb 2 und nicht 02
        channelnummer = str2num(channelcell{1,1});      %laufen muss neu geordnet werden
        daten(channelnummer,:)=int32(ft_read_data(filename));

    end
    
    fprintf('\nAbgeschlossen.\n\n');
    

    
    
    formatSpec = 'Aufnahmedauer: %i Minuten bei einer Fs von %i/s \n\n';
    fprintf(formatSpec,round(minuten,1),hdr.Fs);
    
    
  
    t1=sprintf('%i ', striatalekontakte);
    t2=sprintf('%i ', SNRkontakte);
    t3=sprintf('%i ', M1kontakt);
    t4=sprintf('%i ', Cerebkontrarefkontakt);
    fprintf('Striatale Kontakte: %s\nSNR Kontakte: %s \nM1 Kontakt: %s \nKontralaterales Cerebellum: %s \n\n', t1, t2, t3, t4);
    fprintf('Das Scheiben der Binaryfiles läuft... \n'); 
   
    mkdir('Klusta');
    cd Klusta;
    
    figure('units','normalized','outerposition',[0 0 1 1])
   
    Striatum=daten([striatalekontakte],:);
        fprintf('Striatum.dat / Striatum.prm / Striatum.prb\n'); 
        mkdir('Striatum');
        cd Striatum;
        fid=fopen('Striatum.dat','w+');

        fwrite(fid,Striatum,'int32');
        fclose(fid);
        copyfile('C:\Users\guettlec\Documents\KlustaSuite\Striatum.prb',pwd,'f');
        copyfile('C:\Users\guettlec\Documents\KlustaSuite\Striatum.prm',pwd,'f');
        cd ../;
        K10Striatum=Striatum(:, 1:previewsize)';
    clear Striatum;
    probepreview('Striatum', K10Striatum, 1);
    clear K10Striatum;
    
    SNpr=daten(SNRkontakte,:);
        mkdir('SNpr');
        cd SNpr;
        fprintf('SNpr.dat \n'); 
        fid=fopen('SNpr.dat','w+');
        fwrite(fid,SNpr,'int32');
        fclose(fid);
        copyfile('C:\Users\guettlec\Documents\KlustaSuite\SNpr.prb',pwd,'f');
        copyfile('C:\Users\guettlec\Documents\KlustaSuite\SNpr.prm',pwd,'f');   
        cd ../;
        K10SNpr=SNpr(:, 1:previewsize)';
    clear SNpr;
    probepreview('SNpr', K10SNpr, 2);
    clear K10SNpr;

    M1=daten(M1kontakt,:);
        fprintf('M1.dat \n'); 
        fid=fopen('M1.dat','w+');
        fwrite(fid,M1,'int32');
        fclose(fid);
        K10M1=M1(:, 1:600000)';
    clear M1;
    subplot(2,2,3)
    plot(K10M1)
        title('M1')
        xlabel('Zeit (timestamps)')
        ylabel('Voltage')
    
    CereContraRef=daten(Cerebkontrarefkontakt,:);
        fprintf('CereContraRef.dat \n'); 
        fid=fopen('CereContraRef.dat','w+');
        fwrite(fid,CereContraRef,'int32');
        fclose(fid);
        K10CereContraRef=CereContraRef(:, 1:600000)';
    clear CereContraRef;
    subplot(2,2,4)
    plot(K10CereContraRef)
        title('Kontralaterales Cerebellum')
        xlabel('Zeit (timestamps)')
        ylabel('Voltage')
    
    fprintf('Abgeschlossen.\n\n');
    dir
    cd 'C:\Users\guettlec\Documents\MATLAB';
    clearvars;

end
