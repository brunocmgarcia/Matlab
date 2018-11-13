%% saveallopenfigures
function saveallopenfigures()
    abbildungen=findall(0,'type','figure');
    monitors= get(0,'MonitorPositions');
    for i=1:length(abbildungen)
        aktuellefigure=figure(i)
        orient(aktuellefigure,'landscape')
        set(aktuellefigure,'renderer','painters')
        try
            set(aktuellefigure, 'outerposition',monitors(2,:))
        catch
            set(aktuellefigure, 'outerposition',monitors(1,:))
        end
        speichername=sprintf('img_%02d.emf',i); 
        saveas(aktuellefigure,speichername);
    end
end