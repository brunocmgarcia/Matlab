function probepreview(name, selectprobe, lokalisation)

    clear x y z n k;
    
    z = selectprobe;
    [samples, channels]=size(z);


    for k=1:channels
        x(:,k)=[1:samples];
        y(:,k)=[k * ones(1, samples)];
    end

    
    
    subplot(2,2,lokalisation)
    
    plot3(x,y,z)
    box on
    grid on

    view(26, 42) % blickwinkel
    %axis([0 10 0 10 0 10]) %Achseneinstellung
    
    title(name)
    xlabel('Zeit (timestamps)')
    ylabel('Channel #')
    zlabel('Voltage')
   
    clearvars;

end