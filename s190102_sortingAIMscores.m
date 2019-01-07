%%
clear all
close all
load VAR_GlobalAim

namelist={GlobalAim{:,1}}';
globalaims=[GlobalAim{:,4}]'; % 2= kaloyan 3= saskia 4=average
%%
CG04=find(contains(namelist,'CG04'));
CG05=find(contains(namelist,'CG05'));
CG06=find(contains(namelist,'CG06'));
CG07=find(contains(namelist,'CG07'));
CG08=find(contains(namelist,'CG08'));
CG09=find(contains(namelist,'CG09'));
CG10=find(contains(namelist,'CG10'));
%%
TP101=find(contains(namelist,'TP101'));
TP104=find(contains(namelist,'TP104'));
TP110=find(contains(namelist,'TP110'));
TP116=find(contains(namelist,'TP116'));
TP121=find(contains(namelist,'TP121'));
TP200=find(contains(namelist,'TP200'));
TP300=find(contains(namelist,'TP300'));
TP400=find(contains(namelist,'TP400'));
TP500=find(contains(namelist,'TP500'));
%%
T000=find(contains(namelist,'_000_'));
T005=find(contains(namelist,'_005_'));
T020=find(contains(namelist,'_020_'));
T030=find(contains(namelist,'_030_'));
T040=find(contains(namelist,'_040_'));
T060=find(contains(namelist,'_060_'));
T080=find(contains(namelist,'_080_'));
T100=find(contains(namelist,'_100_'));
T120=find(contains(namelist,'_120_'));
T140=find(contains(namelist,'_140_'));
T160=find(contains(namelist,'_160_'));
T180=find(contains(namelist,'_180_'));
%%

Animals_TP101(1:7,1)=0;
try Animals_TP101(1,1)=globalaims(intersect(intersect(CG04,TP101),T000)); end
try Animals_TP101(2,1)=globalaims(intersect(intersect(CG05,TP101),T000)); end
try Animals_TP101(3,1)=globalaims(intersect(intersect(CG06,TP101),T000)); end
try Animals_TP101(4,1)=globalaims(intersect(intersect(CG07,TP101),T000)); end
try Animals_TP101(5,1)=globalaims(intersect(intersect(CG08,TP101),T000)); end
try Animals_TP101(6,1)=globalaims(intersect(intersect(CG09,TP101),T000)); end
try Animals_TP101(7,1)=globalaims(intersect(intersect(CG10,TP101),T000)); end
    
Animals_TP101(1:7,2)=0;
try Animals_TP101(1,2)=globalaims(intersect(intersect(CG04,TP101),T005)); end
try Animals_TP101(2,2)=globalaims(intersect(intersect(CG05,TP101),T005)); end
try Animals_TP101(3,2)=globalaims(intersect(intersect(CG06,TP101),T005)); end
try Animals_TP101(4,2)=globalaims(intersect(intersect(CG07,TP101),T005)); end
try Animals_TP101(5,2)=globalaims(intersect(intersect(CG08,TP101),T005)); end
try Animals_TP101(6,2)=globalaims(intersect(intersect(CG09,TP101),T005)); end
try Animals_TP101(7,2)=globalaims(intersect(intersect(CG10,TP101),T005)); end        
    
Animals_TP101(1:7,3)=0;
try Animals_TP101(1,3)=globalaims(intersect(intersect(CG04,TP101),T020)); end
try Animals_TP101(2,3)=globalaims(intersect(intersect(CG05,TP101),T020)); end
try Animals_TP101(3,3)=globalaims(intersect(intersect(CG06,TP101),T020)); end
try Animals_TP101(4,3)=globalaims(intersect(intersect(CG07,TP101),T020)); end
try Animals_TP101(5,3)=globalaims(intersect(intersect(CG08,TP101),T020)); end
try Animals_TP101(6,3)=globalaims(intersect(intersect(CG09,TP101),T020)); end
try Animals_TP101(7,3)=globalaims(intersect(intersect(CG10,TP101),T020)); end

Animals_TP101(1:7,4)=0;
try Animals_TP101(1,4)=globalaims(intersect(intersect(CG04,TP101),T030)); end
try Animals_TP101(2,4)=globalaims(intersect(intersect(CG05,TP101),T030)); end
try Animals_TP101(3,4)=globalaims(intersect(intersect(CG06,TP101),T030)); end
try Animals_TP101(4,4)=globalaims(intersect(intersect(CG07,TP101),T030)); end
try Animals_TP101(5,4)=globalaims(intersect(intersect(CG08,TP101),T030)); end
try Animals_TP101(6,4)=globalaims(intersect(intersect(CG09,TP101),T030)); end
try Animals_TP101(7,4)=globalaims(intersect(intersect(CG10,TP101),T030)); end

Animals_TP101(1:7,5)=0;
try Animals_TP101(1,5)=globalaims(intersect(intersect(CG04,TP101),T040)); end
try Animals_TP101(2,5)=globalaims(intersect(intersect(CG05,TP101),T040)); end
try Animals_TP101(3,5)=globalaims(intersect(intersect(CG06,TP101),T040)); end
try Animals_TP101(4,5)=globalaims(intersect(intersect(CG07,TP101),T040)); end
try Animals_TP101(5,5)=globalaims(intersect(intersect(CG08,TP101),T040)); end
try Animals_TP101(6,5)=globalaims(intersect(intersect(CG09,TP101),T040)); end
try Animals_TP101(7,5)=globalaims(intersect(intersect(CG10,TP101),T040)); end

Animals_TP101(1:7,6)=0;
try Animals_TP101(1,6)=globalaims(intersect(intersect(CG04,TP101),T060)); end
try Animals_TP101(2,6)=globalaims(intersect(intersect(CG05,TP101),T060)); end
try Animals_TP101(3,6)=globalaims(intersect(intersect(CG06,TP101),T060)); end
try Animals_TP101(4,6)=globalaims(intersect(intersect(CG07,TP101),T060)); end
try Animals_TP101(5,6)=globalaims(intersect(intersect(CG08,TP101),T060)); end
try Animals_TP101(6,6)=globalaims(intersect(intersect(CG09,TP101),T060)); end
try Animals_TP101(7,6)=globalaims(intersect(intersect(CG10,TP101),T060)); end

Animals_TP101(1:7,7)=0;
try Animals_TP101(1,7)=globalaims(intersect(intersect(CG04,TP101),T080)); end
try Animals_TP101(2,7)=globalaims(intersect(intersect(CG05,TP101),T080)); end
try Animals_TP101(3,7)=globalaims(intersect(intersect(CG06,TP101),T080)); end
try Animals_TP101(4,7)=globalaims(intersect(intersect(CG07,TP101),T080)); end
try Animals_TP101(5,7)=globalaims(intersect(intersect(CG08,TP101),T080)); end
try Animals_TP101(6,7)=globalaims(intersect(intersect(CG09,TP101),T080)); end
try Animals_TP101(7,7)=globalaims(intersect(intersect(CG10,TP101),T080)); end

Animals_TP101(1:7,8)=0;
try Animals_TP101(1,8)=globalaims(intersect(intersect(CG04,TP101),T100)); end
try Animals_TP101(2,8)=globalaims(intersect(intersect(CG05,TP101),T100)); end
try Animals_TP101(3,8)=globalaims(intersect(intersect(CG06,TP101),T100)); end
try Animals_TP101(4,8)=globalaims(intersect(intersect(CG07,TP101),T100)); end
try Animals_TP101(5,8)=globalaims(intersect(intersect(CG08,TP101),T100)); end
try Animals_TP101(6,8)=globalaims(intersect(intersect(CG09,TP101),T100)); end
try Animals_TP101(7,8)=globalaims(intersect(intersect(CG10,TP101),T100)); end

Animals_TP101(1:7,9)=0;
try Animals_TP101(1,9)=globalaims(intersect(intersect(CG04,TP101),T120)); end
try Animals_TP101(2,9)=globalaims(intersect(intersect(CG05,TP101),T120)); end
try Animals_TP101(3,9)=globalaims(intersect(intersect(CG06,TP101),T120)); end
try Animals_TP101(4,9)=globalaims(intersect(intersect(CG07,TP101),T120)); end
try Animals_TP101(5,9)=globalaims(intersect(intersect(CG08,TP101),T120)); end
try Animals_TP101(6,9)=globalaims(intersect(intersect(CG09,TP101),T120)); end
try Animals_TP101(7,9)=globalaims(intersect(intersect(CG10,TP101),T120)); end

Animals_TP101(1:7,10)=0;
try Animals_TP101(1,10)=globalaims(intersect(intersect(CG04,TP101),T140)); end
try Animals_TP101(2,10)=globalaims(intersect(intersect(CG05,TP101),T140)); end
try Animals_TP101(3,10)=globalaims(intersect(intersect(CG06,TP101),T140)); end
try Animals_TP101(4,10)=globalaims(intersect(intersect(CG07,TP101),T140)); end
try Animals_TP101(5,10)=globalaims(intersect(intersect(CG08,TP101),T140)); end
try Animals_TP101(6,10)=globalaims(intersect(intersect(CG09,TP101),T140)); end
try Animals_TP101(7,10)=globalaims(intersect(intersect(CG10,TP101),T140)); end

Animals_TP101(1:7,11)=0;
try Animals_TP101(1,11)=globalaims(intersect(intersect(CG04,TP101),T160)); end
try Animals_TP101(2,11)=globalaims(intersect(intersect(CG05,TP101),T160)); end
try Animals_TP101(3,11)=globalaims(intersect(intersect(CG06,TP101),T160)); end
try Animals_TP101(4,11)=globalaims(intersect(intersect(CG07,TP101),T160)); end
try Animals_TP101(5,11)=globalaims(intersect(intersect(CG08,TP101),T160)); end
try Animals_TP101(6,11)=globalaims(intersect(intersect(CG09,TP101),T160)); end
try Animals_TP101(7,11)=globalaims(intersect(intersect(CG10,TP101),T160)); end


Animals_TP101(1:7,12)=0;
try Animals_TP101(1,12)=globalaims(intersect(intersect(CG04,TP101),T180)); end
try Animals_TP101(2,12)=globalaims(intersect(intersect(CG05,TP101),T180)); end
try Animals_TP101(3,12)=globalaims(intersect(intersect(CG06,TP101),T180)); end
try Animals_TP101(4,12)=globalaims(intersect(intersect(CG07,TP101),T180)); end
try Animals_TP101(5,12)=globalaims(intersect(intersect(CG08,TP101),T180)); end
try Animals_TP101(6,12)=globalaims(intersect(intersect(CG09,TP101),T180)); end
try Animals_TP101(7,12)=globalaims(intersect(intersect(CG10,TP101),T180)); end

%%

Animals_TP104(1:7,1)=0;
try Animals_TP104(1,1)=globalaims(intersect(intersect(CG04,TP104),T000)); end
try Animals_TP104(2,1)=globalaims(intersect(intersect(CG05,TP104),T000)); end
try Animals_TP104(3,1)=globalaims(intersect(intersect(CG06,TP104),T000)); end
try Animals_TP104(4,1)=globalaims(intersect(intersect(CG07,TP104),T000)); end
try Animals_TP104(5,1)=globalaims(intersect(intersect(CG08,TP104),T000)); end
try Animals_TP104(6,1)=globalaims(intersect(intersect(CG09,TP104),T000)); end
try Animals_TP104(7,1)=globalaims(intersect(intersect(CG10,TP104),T000)); end
    
Animals_TP104(1:7,2)=0;
try Animals_TP104(1,2)=globalaims(intersect(intersect(CG04,TP104),T005)); end
try Animals_TP104(2,2)=globalaims(intersect(intersect(CG05,TP104),T005)); end
try Animals_TP104(3,2)=globalaims(intersect(intersect(CG06,TP104),T005)); end
try Animals_TP104(4,2)=globalaims(intersect(intersect(CG07,TP104),T005)); end
try Animals_TP104(5,2)=globalaims(intersect(intersect(CG08,TP104),T005)); end
try Animals_TP104(6,2)=globalaims(intersect(intersect(CG09,TP104),T005)); end
try Animals_TP104(7,2)=globalaims(intersect(intersect(CG10,TP104),T005)); end        
    
Animals_TP104(1:7,3)=0;
try Animals_TP104(1,3)=globalaims(intersect(intersect(CG04,TP104),T020)); end
try Animals_TP104(2,3)=globalaims(intersect(intersect(CG05,TP104),T020)); end
try Animals_TP104(3,3)=globalaims(intersect(intersect(CG06,TP104),T020)); end
try Animals_TP104(4,3)=globalaims(intersect(intersect(CG07,TP104),T020)); end
try Animals_TP104(5,3)=globalaims(intersect(intersect(CG08,TP104),T020)); end
try Animals_TP104(6,3)=globalaims(intersect(intersect(CG09,TP104),T020)); end
try Animals_TP104(7,3)=globalaims(intersect(intersect(CG10,TP104),T020)); end

Animals_TP104(1:7,4)=0;
try Animals_TP104(1,4)=globalaims(intersect(intersect(CG04,TP104),T030)); end
try Animals_TP104(2,4)=globalaims(intersect(intersect(CG05,TP104),T030)); end
try Animals_TP104(3,4)=globalaims(intersect(intersect(CG06,TP104),T030)); end
try Animals_TP104(4,4)=globalaims(intersect(intersect(CG07,TP104),T030)); end
try Animals_TP104(5,4)=globalaims(intersect(intersect(CG08,TP104),T030)); end
try Animals_TP104(6,4)=globalaims(intersect(intersect(CG09,TP104),T030)); end
try Animals_TP104(7,4)=globalaims(intersect(intersect(CG10,TP104),T030)); end

Animals_TP104(1:7,5)=0;
try Animals_TP104(1,5)=globalaims(intersect(intersect(CG04,TP104),T040)); end
try Animals_TP104(2,5)=globalaims(intersect(intersect(CG05,TP104),T040)); end
try Animals_TP104(3,5)=globalaims(intersect(intersect(CG06,TP104),T040)); end
try Animals_TP104(4,5)=globalaims(intersect(intersect(CG07,TP104),T040)); end
try Animals_TP104(5,5)=globalaims(intersect(intersect(CG08,TP104),T040)); end
try Animals_TP104(6,5)=globalaims(intersect(intersect(CG09,TP104),T040)); end
try Animals_TP104(7,5)=globalaims(intersect(intersect(CG10,TP104),T040)); end

Animals_TP104(1:7,6)=0;
try Animals_TP104(1,6)=globalaims(intersect(intersect(CG04,TP104),T060)); end
try Animals_TP104(2,6)=globalaims(intersect(intersect(CG05,TP104),T060)); end
try Animals_TP104(3,6)=globalaims(intersect(intersect(CG06,TP104),T060)); end
try Animals_TP104(4,6)=globalaims(intersect(intersect(CG07,TP104),T060)); end
try Animals_TP104(5,6)=globalaims(intersect(intersect(CG08,TP104),T060)); end
try Animals_TP104(6,6)=globalaims(intersect(intersect(CG09,TP104),T060)); end
try Animals_TP104(7,6)=globalaims(intersect(intersect(CG10,TP104),T060)); end

Animals_TP104(1:7,7)=0;
try Animals_TP104(1,7)=globalaims(intersect(intersect(CG04,TP104),T080)); end
try Animals_TP104(2,7)=globalaims(intersect(intersect(CG05,TP104),T080)); end
try Animals_TP104(3,7)=globalaims(intersect(intersect(CG06,TP104),T080)); end
try Animals_TP104(4,7)=globalaims(intersect(intersect(CG07,TP104),T080)); end
try Animals_TP104(5,7)=globalaims(intersect(intersect(CG08,TP104),T080)); end
try Animals_TP104(6,7)=globalaims(intersect(intersect(CG09,TP104),T080)); end
try Animals_TP104(7,7)=globalaims(intersect(intersect(CG10,TP104),T080)); end

Animals_TP104(1:7,8)=0;
try Animals_TP104(1,8)=globalaims(intersect(intersect(CG04,TP104),T100)); end
try Animals_TP104(2,8)=globalaims(intersect(intersect(CG05,TP104),T100)); end
try Animals_TP104(3,8)=globalaims(intersect(intersect(CG06,TP104),T100)); end
try Animals_TP104(4,8)=globalaims(intersect(intersect(CG07,TP104),T100)); end
try Animals_TP104(5,8)=globalaims(intersect(intersect(CG08,TP104),T100)); end
try Animals_TP104(6,8)=globalaims(intersect(intersect(CG09,TP104),T100)); end
try Animals_TP104(7,8)=globalaims(intersect(intersect(CG10,TP104),T100)); end

Animals_TP104(1:7,9)=0;
try Animals_TP104(1,9)=globalaims(intersect(intersect(CG04,TP104),T120)); end
try Animals_TP104(2,9)=globalaims(intersect(intersect(CG05,TP104),T120)); end
try Animals_TP104(3,9)=globalaims(intersect(intersect(CG06,TP104),T120)); end
try Animals_TP104(4,9)=globalaims(intersect(intersect(CG07,TP104),T120)); end
try Animals_TP104(5,9)=globalaims(intersect(intersect(CG08,TP104),T120)); end
try Animals_TP104(6,9)=globalaims(intersect(intersect(CG09,TP104),T120)); end
try Animals_TP104(7,9)=globalaims(intersect(intersect(CG10,TP104),T120)); end

Animals_TP104(1:7,10)=0;
try Animals_TP104(1,10)=globalaims(intersect(intersect(CG04,TP104),T140)); end
try Animals_TP104(2,10)=globalaims(intersect(intersect(CG05,TP104),T140)); end
try Animals_TP104(3,10)=globalaims(intersect(intersect(CG06,TP104),T140)); end
try Animals_TP104(4,10)=globalaims(intersect(intersect(CG07,TP104),T140)); end
try Animals_TP104(5,10)=globalaims(intersect(intersect(CG08,TP104),T140)); end
try Animals_TP104(6,10)=globalaims(intersect(intersect(CG09,TP104),T140)); end
try Animals_TP104(7,10)=globalaims(intersect(intersect(CG10,TP104),T140)); end

Animals_TP104(1:7,11)=0;
try Animals_TP104(1,11)=globalaims(intersect(intersect(CG04,TP104),T160)); end
try Animals_TP104(2,11)=globalaims(intersect(intersect(CG05,TP104),T160)); end
try Animals_TP104(3,11)=globalaims(intersect(intersect(CG06,TP104),T160)); end
try Animals_TP104(4,11)=globalaims(intersect(intersect(CG07,TP104),T160)); end
try Animals_TP104(5,11)=globalaims(intersect(intersect(CG08,TP104),T160)); end
try Animals_TP104(6,11)=globalaims(intersect(intersect(CG09,TP104),T160)); end
try Animals_TP104(7,11)=globalaims(intersect(intersect(CG10,TP104),T160)); end


Animals_TP104(1:7,12)=0;
try Animals_TP104(1,12)=globalaims(intersect(intersect(CG04,TP104),T180)); end
try Animals_TP104(2,12)=globalaims(intersect(intersect(CG05,TP104),T180)); end
try Animals_TP104(3,12)=globalaims(intersect(intersect(CG06,TP104),T180)); end
try Animals_TP104(4,12)=globalaims(intersect(intersect(CG07,TP104),T180)); end
try Animals_TP104(5,12)=globalaims(intersect(intersect(CG08,TP104),T180)); end
try Animals_TP104(6,12)=globalaims(intersect(intersect(CG09,TP104),T180)); end
try Animals_TP104(7,12)=globalaims(intersect(intersect(CG10,TP104),T180)); end


%%

Animals_TP110(1:7,1)=0;
try Animals_TP110(1,1)=globalaims(intersect(intersect(CG04,TP110),T000)); end
try Animals_TP110(2,1)=globalaims(intersect(intersect(CG05,TP110),T000)); end
try Animals_TP110(3,1)=globalaims(intersect(intersect(CG06,TP110),T000)); end
try Animals_TP110(4,1)=globalaims(intersect(intersect(CG07,TP110),T000)); end
try Animals_TP110(5,1)=globalaims(intersect(intersect(CG08,TP110),T000)); end
try Animals_TP110(6,1)=globalaims(intersect(intersect(CG09,TP110),T000)); end
try Animals_TP110(7,1)=globalaims(intersect(intersect(CG10,TP110),T000)); end
    
Animals_TP110(1:7,2)=0;
try Animals_TP110(1,2)=globalaims(intersect(intersect(CG04,TP110),T005)); end
try Animals_TP110(2,2)=globalaims(intersect(intersect(CG05,TP110),T005)); end
try Animals_TP110(3,2)=globalaims(intersect(intersect(CG06,TP110),T005)); end
try Animals_TP110(4,2)=globalaims(intersect(intersect(CG07,TP110),T005)); end
try Animals_TP110(5,2)=globalaims(intersect(intersect(CG08,TP110),T005)); end
try Animals_TP110(6,2)=globalaims(intersect(intersect(CG09,TP110),T005)); end
try Animals_TP110(7,2)=globalaims(intersect(intersect(CG10,TP110),T005)); end        
    
Animals_TP110(1:7,3)=0;
try Animals_TP110(1,3)=globalaims(intersect(intersect(CG04,TP110),T020)); end
try Animals_TP110(2,3)=globalaims(intersect(intersect(CG05,TP110),T020)); end
try Animals_TP110(3,3)=globalaims(intersect(intersect(CG06,TP110),T020)); end
try Animals_TP110(4,3)=globalaims(intersect(intersect(CG07,TP110),T020)); end
try Animals_TP110(5,3)=globalaims(intersect(intersect(CG08,TP110),T020)); end
try Animals_TP110(6,3)=globalaims(intersect(intersect(CG09,TP110),T020)); end
try Animals_TP110(7,3)=globalaims(intersect(intersect(CG10,TP110),T020)); end

Animals_TP110(1:7,4)=0;
try Animals_TP110(1,4)=globalaims(intersect(intersect(CG04,TP110),T030)); end
try Animals_TP110(2,4)=globalaims(intersect(intersect(CG05,TP110),T030)); end
try Animals_TP110(3,4)=globalaims(intersect(intersect(CG06,TP110),T030)); end
try Animals_TP110(4,4)=globalaims(intersect(intersect(CG07,TP110),T030)); end
try Animals_TP110(5,4)=globalaims(intersect(intersect(CG08,TP110),T030)); end
try Animals_TP110(6,4)=globalaims(intersect(intersect(CG09,TP110),T030)); end
try Animals_TP110(7,4)=globalaims(intersect(intersect(CG10,TP110),T030)); end

Animals_TP110(1:7,5)=0;
try Animals_TP110(1,5)=globalaims(intersect(intersect(CG04,TP110),T040)); end
try Animals_TP110(2,5)=globalaims(intersect(intersect(CG05,TP110),T040)); end
try Animals_TP110(3,5)=globalaims(intersect(intersect(CG06,TP110),T040)); end
try Animals_TP110(4,5)=globalaims(intersect(intersect(CG07,TP110),T040)); end
try Animals_TP110(5,5)=globalaims(intersect(intersect(CG08,TP110),T040)); end
try Animals_TP110(6,5)=globalaims(intersect(intersect(CG09,TP110),T040)); end
try Animals_TP110(7,5)=globalaims(intersect(intersect(CG10,TP110),T040)); end

Animals_TP110(1:7,6)=0;
try Animals_TP110(1,6)=globalaims(intersect(intersect(CG04,TP110),T060)); end
try Animals_TP110(2,6)=globalaims(intersect(intersect(CG05,TP110),T060)); end
try Animals_TP110(3,6)=globalaims(intersect(intersect(CG06,TP110),T060)); end
try Animals_TP110(4,6)=globalaims(intersect(intersect(CG07,TP110),T060)); end
try Animals_TP110(5,6)=globalaims(intersect(intersect(CG08,TP110),T060)); end
try Animals_TP110(6,6)=globalaims(intersect(intersect(CG09,TP110),T060)); end
try Animals_TP110(7,6)=globalaims(intersect(intersect(CG10,TP110),T060)); end

Animals_TP110(1:7,7)=0;
try Animals_TP110(1,7)=globalaims(intersect(intersect(CG04,TP110),T080)); end
try Animals_TP110(2,7)=globalaims(intersect(intersect(CG05,TP110),T080)); end
try Animals_TP110(3,7)=globalaims(intersect(intersect(CG06,TP110),T080)); end
try Animals_TP110(4,7)=globalaims(intersect(intersect(CG07,TP110),T080)); end
try Animals_TP110(5,7)=globalaims(intersect(intersect(CG08,TP110),T080)); end
try Animals_TP110(6,7)=globalaims(intersect(intersect(CG09,TP110),T080)); end
try Animals_TP110(7,7)=globalaims(intersect(intersect(CG10,TP110),T080)); end

Animals_TP110(1:7,8)=0;
try Animals_TP110(1,8)=globalaims(intersect(intersect(CG04,TP110),T100)); end
try Animals_TP110(2,8)=globalaims(intersect(intersect(CG05,TP110),T100)); end
try Animals_TP110(3,8)=globalaims(intersect(intersect(CG06,TP110),T100)); end
try Animals_TP110(4,8)=globalaims(intersect(intersect(CG07,TP110),T100)); end
try Animals_TP110(5,8)=globalaims(intersect(intersect(CG08,TP110),T100)); end
try Animals_TP110(6,8)=globalaims(intersect(intersect(CG09,TP110),T100)); end
try Animals_TP110(7,8)=globalaims(intersect(intersect(CG10,TP110),T100)); end

Animals_TP110(1:7,9)=0;
try Animals_TP110(1,9)=globalaims(intersect(intersect(CG04,TP110),T120)); end
try Animals_TP110(2,9)=globalaims(intersect(intersect(CG05,TP110),T120)); end
try Animals_TP110(3,9)=globalaims(intersect(intersect(CG06,TP110),T120)); end
try Animals_TP110(4,9)=globalaims(intersect(intersect(CG07,TP110),T120)); end
try Animals_TP110(5,9)=globalaims(intersect(intersect(CG08,TP110),T120)); end
try Animals_TP110(6,9)=globalaims(intersect(intersect(CG09,TP110),T120)); end
try Animals_TP110(7,9)=globalaims(intersect(intersect(CG10,TP110),T120)); end

Animals_TP110(1:7,10)=0;
try Animals_TP110(1,10)=globalaims(intersect(intersect(CG04,TP110),T140)); end
try Animals_TP110(2,10)=globalaims(intersect(intersect(CG05,TP110),T140)); end
try Animals_TP110(3,10)=globalaims(intersect(intersect(CG06,TP110),T140)); end
try Animals_TP110(4,10)=globalaims(intersect(intersect(CG07,TP110),T140)); end
try Animals_TP110(5,10)=globalaims(intersect(intersect(CG08,TP110),T140)); end
try Animals_TP110(6,10)=globalaims(intersect(intersect(CG09,TP110),T140)); end
try Animals_TP110(7,10)=globalaims(intersect(intersect(CG10,TP110),T140)); end

Animals_TP110(1:7,11)=0;
try Animals_TP110(1,11)=globalaims(intersect(intersect(CG04,TP110),T160)); end
try Animals_TP110(2,11)=globalaims(intersect(intersect(CG05,TP110),T160)); end
try Animals_TP110(3,11)=globalaims(intersect(intersect(CG06,TP110),T160)); end
try Animals_TP110(4,11)=globalaims(intersect(intersect(CG07,TP110),T160)); end
try Animals_TP110(5,11)=globalaims(intersect(intersect(CG08,TP110),T160)); end
try Animals_TP110(6,11)=globalaims(intersect(intersect(CG09,TP110),T160)); end
try Animals_TP110(7,11)=globalaims(intersect(intersect(CG10,TP110),T160)); end


Animals_TP110(1:7,12)=0;
try Animals_TP110(1,12)=globalaims(intersect(intersect(CG04,TP110),T180)); end
try Animals_TP110(2,12)=globalaims(intersect(intersect(CG05,TP110),T180)); end
try Animals_TP110(3,12)=globalaims(intersect(intersect(CG06,TP110),T180)); end
try Animals_TP110(4,12)=globalaims(intersect(intersect(CG07,TP110),T180)); end
try Animals_TP110(5,12)=globalaims(intersect(intersect(CG08,TP110),T180)); end
try Animals_TP110(6,12)=globalaims(intersect(intersect(CG09,TP110),T180)); end
try Animals_TP110(7,12)=globalaims(intersect(intersect(CG10,TP110),T180)); end

%%

Animals_TP116(1:7,1)=0;
try Animals_TP116(1,1)=globalaims(intersect(intersect(CG04,TP116),T000)); end
try Animals_TP116(2,1)=globalaims(intersect(intersect(CG05,TP116),T000)); end
try Animals_TP116(3,1)=globalaims(intersect(intersect(CG06,TP116),T000)); end
try Animals_TP116(4,1)=globalaims(intersect(intersect(CG07,TP116),T000)); end
try Animals_TP116(5,1)=globalaims(intersect(intersect(CG08,TP116),T000)); end
try Animals_TP116(6,1)=globalaims(intersect(intersect(CG09,TP116),T000)); end
try Animals_TP116(7,1)=globalaims(intersect(intersect(CG10,TP116),T000)); end
    
Animals_TP116(1:7,2)=0;
try Animals_TP116(1,2)=globalaims(intersect(intersect(CG04,TP116),T005)); end
try Animals_TP116(2,2)=globalaims(intersect(intersect(CG05,TP116),T005)); end
try Animals_TP116(3,2)=globalaims(intersect(intersect(CG06,TP116),T005)); end
try Animals_TP116(4,2)=globalaims(intersect(intersect(CG07,TP116),T005)); end
try Animals_TP116(5,2)=globalaims(intersect(intersect(CG08,TP116),T005)); end
try Animals_TP116(6,2)=globalaims(intersect(intersect(CG09,TP116),T005)); end
try Animals_TP116(7,2)=globalaims(intersect(intersect(CG10,TP116),T005)); end        
    
Animals_TP116(1:7,3)=0;
try Animals_TP116(1,3)=globalaims(intersect(intersect(CG04,TP116),T020)); end
try Animals_TP116(2,3)=globalaims(intersect(intersect(CG05,TP116),T020)); end
try Animals_TP116(3,3)=globalaims(intersect(intersect(CG06,TP116),T020)); end
try Animals_TP116(4,3)=globalaims(intersect(intersect(CG07,TP116),T020)); end
try Animals_TP116(5,3)=globalaims(intersect(intersect(CG08,TP116),T020)); end
try Animals_TP116(6,3)=globalaims(intersect(intersect(CG09,TP116),T020)); end
try Animals_TP116(7,3)=globalaims(intersect(intersect(CG10,TP116),T020)); end

Animals_TP116(1:7,4)=0;
try Animals_TP116(1,4)=globalaims(intersect(intersect(CG04,TP116),T030)); end
try Animals_TP116(2,4)=globalaims(intersect(intersect(CG05,TP116),T030)); end
try Animals_TP116(3,4)=globalaims(intersect(intersect(CG06,TP116),T030)); end
try Animals_TP116(4,4)=globalaims(intersect(intersect(CG07,TP116),T030)); end
try Animals_TP116(5,4)=globalaims(intersect(intersect(CG08,TP116),T030)); end
try Animals_TP116(6,4)=globalaims(intersect(intersect(CG09,TP116),T030)); end
try Animals_TP116(7,4)=globalaims(intersect(intersect(CG10,TP116),T030)); end

Animals_TP116(1:7,5)=0;
try Animals_TP116(1,5)=globalaims(intersect(intersect(CG04,TP116),T040)); end
try Animals_TP116(2,5)=globalaims(intersect(intersect(CG05,TP116),T040)); end
try Animals_TP116(3,5)=globalaims(intersect(intersect(CG06,TP116),T040)); end
try Animals_TP116(4,5)=globalaims(intersect(intersect(CG07,TP116),T040)); end
try Animals_TP116(5,5)=globalaims(intersect(intersect(CG08,TP116),T040)); end
try Animals_TP116(6,5)=globalaims(intersect(intersect(CG09,TP116),T040)); end
try Animals_TP116(7,5)=globalaims(intersect(intersect(CG10,TP116),T040)); end

Animals_TP116(1:7,6)=0;
try Animals_TP116(1,6)=globalaims(intersect(intersect(CG04,TP116),T060)); end
try Animals_TP116(2,6)=globalaims(intersect(intersect(CG05,TP116),T060)); end
try Animals_TP116(3,6)=globalaims(intersect(intersect(CG06,TP116),T060)); end
try Animals_TP116(4,6)=globalaims(intersect(intersect(CG07,TP116),T060)); end
try Animals_TP116(5,6)=globalaims(intersect(intersect(CG08,TP116),T060)); end
try Animals_TP116(6,6)=globalaims(intersect(intersect(CG09,TP116),T060)); end
try Animals_TP116(7,6)=globalaims(intersect(intersect(CG10,TP116),T060)); end

Animals_TP116(1:7,7)=0;
try Animals_TP116(1,7)=globalaims(intersect(intersect(CG04,TP116),T080)); end
try Animals_TP116(2,7)=globalaims(intersect(intersect(CG05,TP116),T080)); end
try Animals_TP116(3,7)=globalaims(intersect(intersect(CG06,TP116),T080)); end
try Animals_TP116(4,7)=globalaims(intersect(intersect(CG07,TP116),T080)); end
try Animals_TP116(5,7)=globalaims(intersect(intersect(CG08,TP116),T080)); end
try Animals_TP116(6,7)=globalaims(intersect(intersect(CG09,TP116),T080)); end
try Animals_TP116(7,7)=globalaims(intersect(intersect(CG10,TP116),T080)); end

Animals_TP116(1:7,8)=0;
try Animals_TP116(1,8)=globalaims(intersect(intersect(CG04,TP116),T100)); end
try Animals_TP116(2,8)=globalaims(intersect(intersect(CG05,TP116),T100)); end
try Animals_TP116(3,8)=globalaims(intersect(intersect(CG06,TP116),T100)); end
try Animals_TP116(4,8)=globalaims(intersect(intersect(CG07,TP116),T100)); end
try Animals_TP116(5,8)=globalaims(intersect(intersect(CG08,TP116),T100)); end
try Animals_TP116(6,8)=globalaims(intersect(intersect(CG09,TP116),T100)); end
try Animals_TP116(7,8)=globalaims(intersect(intersect(CG10,TP116),T100)); end

Animals_TP116(1:7,9)=0;
try Animals_TP116(1,9)=globalaims(intersect(intersect(CG04,TP116),T120)); end
try Animals_TP116(2,9)=globalaims(intersect(intersect(CG05,TP116),T120)); end
try Animals_TP116(3,9)=globalaims(intersect(intersect(CG06,TP116),T120)); end
try Animals_TP116(4,9)=globalaims(intersect(intersect(CG07,TP116),T120)); end
try Animals_TP116(5,9)=globalaims(intersect(intersect(CG08,TP116),T120)); end
try Animals_TP116(6,9)=globalaims(intersect(intersect(CG09,TP116),T120)); end
try Animals_TP116(7,9)=globalaims(intersect(intersect(CG10,TP116),T120)); end

Animals_TP116(1:7,10)=0;
try Animals_TP116(1,10)=globalaims(intersect(intersect(CG04,TP116),T140)); end
try Animals_TP116(2,10)=globalaims(intersect(intersect(CG05,TP116),T140)); end
try Animals_TP116(3,10)=globalaims(intersect(intersect(CG06,TP116),T140)); end
try Animals_TP116(4,10)=globalaims(intersect(intersect(CG07,TP116),T140)); end
try Animals_TP116(5,10)=globalaims(intersect(intersect(CG08,TP116),T140)); end
try Animals_TP116(6,10)=globalaims(intersect(intersect(CG09,TP116),T140)); end
try Animals_TP116(7,10)=globalaims(intersect(intersect(CG10,TP116),T140)); end

Animals_TP116(1:7,11)=0;
try Animals_TP116(1,11)=globalaims(intersect(intersect(CG04,TP116),T160)); end
try Animals_TP116(2,11)=globalaims(intersect(intersect(CG05,TP116),T160)); end
try Animals_TP116(3,11)=globalaims(intersect(intersect(CG06,TP116),T160)); end
try Animals_TP116(4,11)=globalaims(intersect(intersect(CG07,TP116),T160)); end
try Animals_TP116(5,11)=globalaims(intersect(intersect(CG08,TP116),T160)); end
try Animals_TP116(6,11)=globalaims(intersect(intersect(CG09,TP116),T160)); end
try Animals_TP116(7,11)=globalaims(intersect(intersect(CG10,TP116),T160)); end


Animals_TP116(1:7,12)=0;
try Animals_TP116(1,12)=globalaims(intersect(intersect(CG04,TP116),T180)); end
try Animals_TP116(2,12)=globalaims(intersect(intersect(CG05,TP116),T180)); end
try Animals_TP116(3,12)=globalaims(intersect(intersect(CG06,TP116),T180)); end
try Animals_TP116(4,12)=globalaims(intersect(intersect(CG07,TP116),T180)); end
try Animals_TP116(5,12)=globalaims(intersect(intersect(CG08,TP116),T180)); end
try Animals_TP116(6,12)=globalaims(intersect(intersect(CG09,TP116),T180)); end
try Animals_TP116(7,12)=globalaims(intersect(intersect(CG10,TP116),T180)); end

%%

Animals_TP121(1:7,1)=0;
try Animals_TP121(1,1)=globalaims(intersect(intersect(CG04,TP121),T000)); end
try Animals_TP121(2,1)=globalaims(intersect(intersect(CG05,TP121),T000)); end
try Animals_TP121(3,1)=globalaims(intersect(intersect(CG06,TP121),T000)); end
try Animals_TP121(4,1)=globalaims(intersect(intersect(CG07,TP121),T000)); end
try Animals_TP121(5,1)=globalaims(intersect(intersect(CG08,TP121),T000)); end
try Animals_TP121(6,1)=globalaims(intersect(intersect(CG09,TP121),T000)); end
try Animals_TP121(7,1)=globalaims(intersect(intersect(CG10,TP121),T000)); end
    
Animals_TP121(1:7,2)=0;
try Animals_TP121(1,2)=globalaims(intersect(intersect(CG04,TP121),T005)); end
try Animals_TP121(2,2)=globalaims(intersect(intersect(CG05,TP121),T005)); end
try Animals_TP121(3,2)=globalaims(intersect(intersect(CG06,TP121),T005)); end
try Animals_TP121(4,2)=globalaims(intersect(intersect(CG07,TP121),T005)); end
try Animals_TP121(5,2)=globalaims(intersect(intersect(CG08,TP121),T005)); end
try Animals_TP121(6,2)=globalaims(intersect(intersect(CG09,TP121),T005)); end
try Animals_TP121(7,2)=globalaims(intersect(intersect(CG10,TP121),T005)); end        
    
Animals_TP121(1:7,3)=0;
try Animals_TP121(1,3)=globalaims(intersect(intersect(CG04,TP121),T020)); end
try Animals_TP121(2,3)=globalaims(intersect(intersect(CG05,TP121),T020)); end
try Animals_TP121(3,3)=globalaims(intersect(intersect(CG06,TP121),T020)); end
try Animals_TP121(4,3)=globalaims(intersect(intersect(CG07,TP121),T020)); end
try Animals_TP121(5,3)=globalaims(intersect(intersect(CG08,TP121),T020)); end
try Animals_TP121(6,3)=globalaims(intersect(intersect(CG09,TP121),T020)); end
try Animals_TP121(7,3)=globalaims(intersect(intersect(CG10,TP121),T020)); end

Animals_TP121(1:7,4)=0;
try Animals_TP121(1,4)=globalaims(intersect(intersect(CG04,TP121),T030)); end
try Animals_TP121(2,4)=globalaims(intersect(intersect(CG05,TP121),T030)); end
try Animals_TP121(3,4)=globalaims(intersect(intersect(CG06,TP121),T030)); end
try Animals_TP121(4,4)=globalaims(intersect(intersect(CG07,TP121),T030)); end
try Animals_TP121(5,4)=globalaims(intersect(intersect(CG08,TP121),T030)); end
try Animals_TP121(6,4)=globalaims(intersect(intersect(CG09,TP121),T030)); end
try Animals_TP121(7,4)=globalaims(intersect(intersect(CG10,TP121),T030)); end

Animals_TP121(1:7,5)=0;
try Animals_TP121(1,5)=globalaims(intersect(intersect(CG04,TP121),T040)); end
try Animals_TP121(2,5)=globalaims(intersect(intersect(CG05,TP121),T040)); end
try Animals_TP121(3,5)=globalaims(intersect(intersect(CG06,TP121),T040)); end
try Animals_TP121(4,5)=globalaims(intersect(intersect(CG07,TP121),T040)); end
try Animals_TP121(5,5)=globalaims(intersect(intersect(CG08,TP121),T040)); end
try Animals_TP121(6,5)=globalaims(intersect(intersect(CG09,TP121),T040)); end
try Animals_TP121(7,5)=globalaims(intersect(intersect(CG10,TP121),T040)); end

Animals_TP121(1:7,6)=0;
try Animals_TP121(1,6)=globalaims(intersect(intersect(CG04,TP121),T060)); end
try Animals_TP121(2,6)=globalaims(intersect(intersect(CG05,TP121),T060)); end
try Animals_TP121(3,6)=globalaims(intersect(intersect(CG06,TP121),T060)); end
try Animals_TP121(4,6)=globalaims(intersect(intersect(CG07,TP121),T060)); end
try Animals_TP121(5,6)=globalaims(intersect(intersect(CG08,TP121),T060)); end
try Animals_TP121(6,6)=globalaims(intersect(intersect(CG09,TP121),T060)); end
try Animals_TP121(7,6)=globalaims(intersect(intersect(CG10,TP121),T060)); end

Animals_TP121(1:7,7)=0;
try Animals_TP121(1,7)=globalaims(intersect(intersect(CG04,TP121),T080)); end
try Animals_TP121(2,7)=globalaims(intersect(intersect(CG05,TP121),T080)); end
try Animals_TP121(3,7)=globalaims(intersect(intersect(CG06,TP121),T080)); end
try Animals_TP121(4,7)=globalaims(intersect(intersect(CG07,TP121),T080)); end
try Animals_TP121(5,7)=globalaims(intersect(intersect(CG08,TP121),T080)); end
try Animals_TP121(6,7)=globalaims(intersect(intersect(CG09,TP121),T080)); end
try Animals_TP121(7,7)=globalaims(intersect(intersect(CG10,TP121),T080)); end

Animals_TP121(1:7,8)=0;
try Animals_TP121(1,8)=globalaims(intersect(intersect(CG04,TP121),T100)); end
try Animals_TP121(2,8)=globalaims(intersect(intersect(CG05,TP121),T100)); end
try Animals_TP121(3,8)=globalaims(intersect(intersect(CG06,TP121),T100)); end
try Animals_TP121(4,8)=globalaims(intersect(intersect(CG07,TP121),T100)); end
try Animals_TP121(5,8)=globalaims(intersect(intersect(CG08,TP121),T100)); end
try Animals_TP121(6,8)=globalaims(intersect(intersect(CG09,TP121),T100)); end
try Animals_TP121(7,8)=globalaims(intersect(intersect(CG10,TP121),T100)); end

Animals_TP121(1:7,9)=0;
try Animals_TP121(1,9)=globalaims(intersect(intersect(CG04,TP121),T120)); end
try Animals_TP121(2,9)=globalaims(intersect(intersect(CG05,TP121),T120)); end
try Animals_TP121(3,9)=globalaims(intersect(intersect(CG06,TP121),T120)); end
try Animals_TP121(4,9)=globalaims(intersect(intersect(CG07,TP121),T120)); end
try Animals_TP121(5,9)=globalaims(intersect(intersect(CG08,TP121),T120)); end
try Animals_TP121(6,9)=globalaims(intersect(intersect(CG09,TP121),T120)); end
try Animals_TP121(7,9)=globalaims(intersect(intersect(CG10,TP121),T120)); end

Animals_TP121(1:7,10)=0;
try Animals_TP121(1,10)=globalaims(intersect(intersect(CG04,TP121),T140)); end
try Animals_TP121(2,10)=globalaims(intersect(intersect(CG05,TP121),T140)); end
try Animals_TP121(3,10)=globalaims(intersect(intersect(CG06,TP121),T140)); end
try Animals_TP121(4,10)=globalaims(intersect(intersect(CG07,TP121),T140)); end
try Animals_TP121(5,10)=globalaims(intersect(intersect(CG08,TP121),T140)); end
try Animals_TP121(6,10)=globalaims(intersect(intersect(CG09,TP121),T140)); end
try Animals_TP121(7,10)=globalaims(intersect(intersect(CG10,TP121),T140)); end

Animals_TP121(1:7,11)=0;
try Animals_TP121(1,11)=globalaims(intersect(intersect(CG04,TP121),T160)); end
try Animals_TP121(2,11)=globalaims(intersect(intersect(CG05,TP121),T160)); end
try Animals_TP121(3,11)=globalaims(intersect(intersect(CG06,TP121),T160)); end
try Animals_TP121(4,11)=globalaims(intersect(intersect(CG07,TP121),T160)); end
try Animals_TP121(5,11)=globalaims(intersect(intersect(CG08,TP121),T160)); end
try Animals_TP121(6,11)=globalaims(intersect(intersect(CG09,TP121),T160)); end
try Animals_TP121(7,11)=globalaims(intersect(intersect(CG10,TP121),T160)); end


Animals_TP121(1:7,12)=0;
try Animals_TP121(1,12)=globalaims(intersect(intersect(CG04,TP121),T180)); end
try Animals_TP121(2,12)=globalaims(intersect(intersect(CG05,TP121),T180)); end
try Animals_TP121(3,12)=globalaims(intersect(intersect(CG06,TP121),T180)); end
try Animals_TP121(4,12)=globalaims(intersect(intersect(CG07,TP121),T180)); end
try Animals_TP121(5,12)=globalaims(intersect(intersect(CG08,TP121),T180)); end
try Animals_TP121(6,12)=globalaims(intersect(intersect(CG09,TP121),T180)); end
try Animals_TP121(7,12)=globalaims(intersect(intersect(CG10,TP121),T180)); end

%%

Animals_TP200(1:7,1)=0;
try Animals_TP200(1,1)=globalaims(intersect(intersect(CG04,TP200),T000)); end
try Animals_TP200(2,1)=globalaims(intersect(intersect(CG05,TP200),T000)); end
try Animals_TP200(3,1)=globalaims(intersect(intersect(CG06,TP200),T000)); end
try Animals_TP200(4,1)=globalaims(intersect(intersect(CG07,TP200),T000)); end
try Animals_TP200(5,1)=globalaims(intersect(intersect(CG08,TP200),T000)); end
try Animals_TP200(6,1)=globalaims(intersect(intersect(CG09,TP200),T000)); end
try Animals_TP200(7,1)=globalaims(intersect(intersect(CG10,TP200),T000)); end
    
Animals_TP200(1:7,2)=0;
try Animals_TP200(1,2)=globalaims(intersect(intersect(CG04,TP200),T005)); end
try Animals_TP200(2,2)=globalaims(intersect(intersect(CG05,TP200),T005)); end
try Animals_TP200(3,2)=globalaims(intersect(intersect(CG06,TP200),T005)); end
try Animals_TP200(4,2)=globalaims(intersect(intersect(CG07,TP200),T005)); end
try Animals_TP200(5,2)=globalaims(intersect(intersect(CG08,TP200),T005)); end
try Animals_TP200(6,2)=globalaims(intersect(intersect(CG09,TP200),T005)); end
try Animals_TP200(7,2)=globalaims(intersect(intersect(CG10,TP200),T005)); end        
    
Animals_TP200(1:7,3)=0;
try Animals_TP200(1,3)=globalaims(intersect(intersect(CG04,TP200),T020)); end
try Animals_TP200(2,3)=globalaims(intersect(intersect(CG05,TP200),T020)); end
try Animals_TP200(3,3)=globalaims(intersect(intersect(CG06,TP200),T020)); end
try Animals_TP200(4,3)=globalaims(intersect(intersect(CG07,TP200),T020)); end
try Animals_TP200(5,3)=globalaims(intersect(intersect(CG08,TP200),T020)); end
try Animals_TP200(6,3)=globalaims(intersect(intersect(CG09,TP200),T020)); end
try Animals_TP200(7,3)=globalaims(intersect(intersect(CG10,TP200),T020)); end

Animals_TP200(1:7,4)=0;
try Animals_TP200(1,4)=globalaims(intersect(intersect(CG04,TP200),T030)); end
try Animals_TP200(2,4)=globalaims(intersect(intersect(CG05,TP200),T030)); end
try Animals_TP200(3,4)=globalaims(intersect(intersect(CG06,TP200),T030)); end
try Animals_TP200(4,4)=globalaims(intersect(intersect(CG07,TP200),T030)); end
try Animals_TP200(5,4)=globalaims(intersect(intersect(CG08,TP200),T030)); end
try Animals_TP200(6,4)=globalaims(intersect(intersect(CG09,TP200),T030)); end
try Animals_TP200(7,4)=globalaims(intersect(intersect(CG10,TP200),T030)); end

Animals_TP200(1:7,5)=0;
try Animals_TP200(1,5)=globalaims(intersect(intersect(CG04,TP200),T040)); end
try Animals_TP200(2,5)=globalaims(intersect(intersect(CG05,TP200),T040)); end
try Animals_TP200(3,5)=globalaims(intersect(intersect(CG06,TP200),T040)); end
try Animals_TP200(4,5)=globalaims(intersect(intersect(CG07,TP200),T040)); end
try Animals_TP200(5,5)=globalaims(intersect(intersect(CG08,TP200),T040)); end
try Animals_TP200(6,5)=globalaims(intersect(intersect(CG09,TP200),T040)); end
try Animals_TP200(7,5)=globalaims(intersect(intersect(CG10,TP200),T040)); end

Animals_TP200(1:7,6)=0;
try Animals_TP200(1,6)=globalaims(intersect(intersect(CG04,TP200),T060)); end
try Animals_TP200(2,6)=globalaims(intersect(intersect(CG05,TP200),T060)); end
try Animals_TP200(3,6)=globalaims(intersect(intersect(CG06,TP200),T060)); end
try Animals_TP200(4,6)=globalaims(intersect(intersect(CG07,TP200),T060)); end
try Animals_TP200(5,6)=globalaims(intersect(intersect(CG08,TP200),T060)); end
try Animals_TP200(6,6)=globalaims(intersect(intersect(CG09,TP200),T060)); end
try Animals_TP200(7,6)=globalaims(intersect(intersect(CG10,TP200),T060)); end

Animals_TP200(1:7,7)=0;
try Animals_TP200(1,7)=globalaims(intersect(intersect(CG04,TP200),T080)); end
try Animals_TP200(2,7)=globalaims(intersect(intersect(CG05,TP200),T080)); end
try Animals_TP200(3,7)=globalaims(intersect(intersect(CG06,TP200),T080)); end
try Animals_TP200(4,7)=globalaims(intersect(intersect(CG07,TP200),T080)); end
try Animals_TP200(5,7)=globalaims(intersect(intersect(CG08,TP200),T080)); end
try Animals_TP200(6,7)=globalaims(intersect(intersect(CG09,TP200),T080)); end
try Animals_TP200(7,7)=globalaims(intersect(intersect(CG10,TP200),T080)); end

Animals_TP200(1:7,8)=0;
try Animals_TP200(1,8)=globalaims(intersect(intersect(CG04,TP200),T100)); end
try Animals_TP200(2,8)=globalaims(intersect(intersect(CG05,TP200),T100)); end
try Animals_TP200(3,8)=globalaims(intersect(intersect(CG06,TP200),T100)); end
try Animals_TP200(4,8)=globalaims(intersect(intersect(CG07,TP200),T100)); end
try Animals_TP200(5,8)=globalaims(intersect(intersect(CG08,TP200),T100)); end
try Animals_TP200(6,8)=globalaims(intersect(intersect(CG09,TP200),T100)); end
try Animals_TP200(7,8)=globalaims(intersect(intersect(CG10,TP200),T100)); end

Animals_TP200(1:7,9)=0;
try Animals_TP200(1,9)=globalaims(intersect(intersect(CG04,TP200),T120)); end
try Animals_TP200(2,9)=globalaims(intersect(intersect(CG05,TP200),T120)); end
try Animals_TP200(3,9)=globalaims(intersect(intersect(CG06,TP200),T120)); end
try Animals_TP200(4,9)=globalaims(intersect(intersect(CG07,TP200),T120)); end
try Animals_TP200(5,9)=globalaims(intersect(intersect(CG08,TP200),T120)); end
try Animals_TP200(6,9)=globalaims(intersect(intersect(CG09,TP200),T120)); end
try Animals_TP200(7,9)=globalaims(intersect(intersect(CG10,TP200),T120)); end

Animals_TP200(1:7,10)=0;
try Animals_TP200(1,10)=globalaims(intersect(intersect(CG04,TP200),T140)); end
try Animals_TP200(2,10)=globalaims(intersect(intersect(CG05,TP200),T140)); end
try Animals_TP200(3,10)=globalaims(intersect(intersect(CG06,TP200),T140)); end
try Animals_TP200(4,10)=globalaims(intersect(intersect(CG07,TP200),T140)); end
try Animals_TP200(5,10)=globalaims(intersect(intersect(CG08,TP200),T140)); end
try Animals_TP200(6,10)=globalaims(intersect(intersect(CG09,TP200),T140)); end
try Animals_TP200(7,10)=globalaims(intersect(intersect(CG10,TP200),T140)); end

Animals_TP200(1:7,11)=0;
try Animals_TP200(1,11)=globalaims(intersect(intersect(CG04,TP200),T160)); end
try Animals_TP200(2,11)=globalaims(intersect(intersect(CG05,TP200),T160)); end
try Animals_TP200(3,11)=globalaims(intersect(intersect(CG06,TP200),T160)); end
try Animals_TP200(4,11)=globalaims(intersect(intersect(CG07,TP200),T160)); end
try Animals_TP200(5,11)=globalaims(intersect(intersect(CG08,TP200),T160)); end
try Animals_TP200(6,11)=globalaims(intersect(intersect(CG09,TP200),T160)); end
try Animals_TP200(7,11)=globalaims(intersect(intersect(CG10,TP200),T160)); end


Animals_TP200(1:7,12)=0;
try Animals_TP200(1,12)=globalaims(intersect(intersect(CG04,TP200),T180)); end
try Animals_TP200(2,12)=globalaims(intersect(intersect(CG05,TP200),T180)); end
try Animals_TP200(3,12)=globalaims(intersect(intersect(CG06,TP200),T180)); end
try Animals_TP200(4,12)=globalaims(intersect(intersect(CG07,TP200),T180)); end
try Animals_TP200(5,12)=globalaims(intersect(intersect(CG08,TP200),T180)); end
try Animals_TP200(6,12)=globalaims(intersect(intersect(CG09,TP200),T180)); end
try Animals_TP200(7,12)=globalaims(intersect(intersect(CG10,TP200),T180)); end

%%

Animals_TP300(1:7,1)=0;
try Animals_TP300(1,1)=globalaims(intersect(intersect(CG04,TP300),T000)); end
try Animals_TP300(2,1)=globalaims(intersect(intersect(CG05,TP300),T000)); end
try Animals_TP300(3,1)=globalaims(intersect(intersect(CG06,TP300),T000)); end
try Animals_TP300(4,1)=globalaims(intersect(intersect(CG07,TP300),T000)); end
try Animals_TP300(5,1)=globalaims(intersect(intersect(CG08,TP300),T000)); end
try Animals_TP300(6,1)=globalaims(intersect(intersect(CG09,TP300),T000)); end
try Animals_TP300(7,1)=globalaims(intersect(intersect(CG10,TP300),T000)); end
    
Animals_TP300(1:7,2)=0;
try Animals_TP300(1,2)=globalaims(intersect(intersect(CG04,TP300),T005)); end
try Animals_TP300(2,2)=globalaims(intersect(intersect(CG05,TP300),T005)); end
try Animals_TP300(3,2)=globalaims(intersect(intersect(CG06,TP300),T005)); end
try Animals_TP300(4,2)=globalaims(intersect(intersect(CG07,TP300),T005)); end
try Animals_TP300(5,2)=globalaims(intersect(intersect(CG08,TP300),T005)); end
try Animals_TP300(6,2)=globalaims(intersect(intersect(CG09,TP300),T005)); end
try Animals_TP300(7,2)=globalaims(intersect(intersect(CG10,TP300),T005)); end        
    
Animals_TP300(1:7,3)=0;
try Animals_TP300(1,3)=globalaims(intersect(intersect(CG04,TP300),T020)); end
try Animals_TP300(2,3)=globalaims(intersect(intersect(CG05,TP300),T020)); end
try Animals_TP300(3,3)=globalaims(intersect(intersect(CG06,TP300),T020)); end
try Animals_TP300(4,3)=globalaims(intersect(intersect(CG07,TP300),T020)); end
try Animals_TP300(5,3)=globalaims(intersect(intersect(CG08,TP300),T020)); end
try Animals_TP300(6,3)=globalaims(intersect(intersect(CG09,TP300),T020)); end
try Animals_TP300(7,3)=globalaims(intersect(intersect(CG10,TP300),T020)); end

Animals_TP300(1:7,4)=0;
try Animals_TP300(1,4)=globalaims(intersect(intersect(CG04,TP300),T030)); end
try Animals_TP300(2,4)=globalaims(intersect(intersect(CG05,TP300),T030)); end
try Animals_TP300(3,4)=globalaims(intersect(intersect(CG06,TP300),T030)); end
try Animals_TP300(4,4)=globalaims(intersect(intersect(CG07,TP300),T030)); end
try Animals_TP300(5,4)=globalaims(intersect(intersect(CG08,TP300),T030)); end
try Animals_TP300(6,4)=globalaims(intersect(intersect(CG09,TP300),T030)); end
try Animals_TP300(7,4)=globalaims(intersect(intersect(CG10,TP300),T030)); end

Animals_TP300(1:7,5)=0;
try Animals_TP300(1,5)=globalaims(intersect(intersect(CG04,TP300),T040)); end
try Animals_TP300(2,5)=globalaims(intersect(intersect(CG05,TP300),T040)); end
try Animals_TP300(3,5)=globalaims(intersect(intersect(CG06,TP300),T040)); end
try Animals_TP300(4,5)=globalaims(intersect(intersect(CG07,TP300),T040)); end
try Animals_TP300(5,5)=globalaims(intersect(intersect(CG08,TP300),T040)); end
try Animals_TP300(6,5)=globalaims(intersect(intersect(CG09,TP300),T040)); end
try Animals_TP300(7,5)=globalaims(intersect(intersect(CG10,TP300),T040)); end

Animals_TP300(1:7,6)=0;
try Animals_TP300(1,6)=globalaims(intersect(intersect(CG04,TP300),T060)); end
try Animals_TP300(2,6)=globalaims(intersect(intersect(CG05,TP300),T060)); end
try Animals_TP300(3,6)=globalaims(intersect(intersect(CG06,TP300),T060)); end
try Animals_TP300(4,6)=globalaims(intersect(intersect(CG07,TP300),T060)); end
try Animals_TP300(5,6)=globalaims(intersect(intersect(CG08,TP300),T060)); end
try Animals_TP300(6,6)=globalaims(intersect(intersect(CG09,TP300),T060)); end
try Animals_TP300(7,6)=globalaims(intersect(intersect(CG10,TP300),T060)); end

Animals_TP300(1:7,7)=0;
try Animals_TP300(1,7)=globalaims(intersect(intersect(CG04,TP300),T080)); end
try Animals_TP300(2,7)=globalaims(intersect(intersect(CG05,TP300),T080)); end
try Animals_TP300(3,7)=globalaims(intersect(intersect(CG06,TP300),T080)); end
try Animals_TP300(4,7)=globalaims(intersect(intersect(CG07,TP300),T080)); end
try Animals_TP300(5,7)=globalaims(intersect(intersect(CG08,TP300),T080)); end
try Animals_TP300(6,7)=globalaims(intersect(intersect(CG09,TP300),T080)); end
try Animals_TP300(7,7)=globalaims(intersect(intersect(CG10,TP300),T080)); end

Animals_TP300(1:7,8)=0;
try Animals_TP300(1,8)=globalaims(intersect(intersect(CG04,TP300),T100)); end
try Animals_TP300(2,8)=globalaims(intersect(intersect(CG05,TP300),T100)); end
try Animals_TP300(3,8)=globalaims(intersect(intersect(CG06,TP300),T100)); end
try Animals_TP300(4,8)=globalaims(intersect(intersect(CG07,TP300),T100)); end
try Animals_TP300(5,8)=globalaims(intersect(intersect(CG08,TP300),T100)); end
try Animals_TP300(6,8)=globalaims(intersect(intersect(CG09,TP300),T100)); end
try Animals_TP300(7,8)=globalaims(intersect(intersect(CG10,TP300),T100)); end

Animals_TP300(1:7,9)=0;
try Animals_TP300(1,9)=globalaims(intersect(intersect(CG04,TP300),T120)); end
try Animals_TP300(2,9)=globalaims(intersect(intersect(CG05,TP300),T120)); end
try Animals_TP300(3,9)=globalaims(intersect(intersect(CG06,TP300),T120)); end
try Animals_TP300(4,9)=globalaims(intersect(intersect(CG07,TP300),T120)); end
try Animals_TP300(5,9)=globalaims(intersect(intersect(CG08,TP300),T120)); end
try Animals_TP300(6,9)=globalaims(intersect(intersect(CG09,TP300),T120)); end
try Animals_TP300(7,9)=globalaims(intersect(intersect(CG10,TP300),T120)); end

Animals_TP300(1:7,10)=0;
try Animals_TP300(1,10)=globalaims(intersect(intersect(CG04,TP300),T140)); end
try Animals_TP300(2,10)=globalaims(intersect(intersect(CG05,TP300),T140)); end
try Animals_TP300(3,10)=globalaims(intersect(intersect(CG06,TP300),T140)); end
try Animals_TP300(4,10)=globalaims(intersect(intersect(CG07,TP300),T140)); end
try Animals_TP300(5,10)=globalaims(intersect(intersect(CG08,TP300),T140)); end
try Animals_TP300(6,10)=globalaims(intersect(intersect(CG09,TP300),T140)); end
try Animals_TP300(7,10)=globalaims(intersect(intersect(CG10,TP300),T140)); end

Animals_TP300(1:7,11)=0;
try Animals_TP300(1,11)=globalaims(intersect(intersect(CG04,TP300),T160)); end
try Animals_TP300(2,11)=globalaims(intersect(intersect(CG05,TP300),T160)); end
try Animals_TP300(3,11)=globalaims(intersect(intersect(CG06,TP300),T160)); end
try Animals_TP300(4,11)=globalaims(intersect(intersect(CG07,TP300),T160)); end
try Animals_TP300(5,11)=globalaims(intersect(intersect(CG08,TP300),T160)); end
try Animals_TP300(6,11)=globalaims(intersect(intersect(CG09,TP300),T160)); end
try Animals_TP300(7,11)=globalaims(intersect(intersect(CG10,TP300),T160)); end


Animals_TP300(1:7,12)=0;
try Animals_TP300(1,12)=globalaims(intersect(intersect(CG04,TP300),T180)); end
try Animals_TP300(2,12)=globalaims(intersect(intersect(CG05,TP300),T180)); end
try Animals_TP300(3,12)=globalaims(intersect(intersect(CG06,TP300),T180)); end
try Animals_TP300(4,12)=globalaims(intersect(intersect(CG07,TP300),T180)); end
try Animals_TP300(5,12)=globalaims(intersect(intersect(CG08,TP300),T180)); end
try Animals_TP300(6,12)=globalaims(intersect(intersect(CG09,TP300),T180)); end
try Animals_TP300(7,12)=globalaims(intersect(intersect(CG10,TP300),T180)); end

%%

Animals_TP400(1:7,1)=0;
try Animals_TP400(1,1)=globalaims(intersect(intersect(CG04,TP400),T000)); end
try Animals_TP400(2,1)=globalaims(intersect(intersect(CG05,TP400),T000)); end
try Animals_TP400(3,1)=globalaims(intersect(intersect(CG06,TP400),T000)); end
try Animals_TP400(4,1)=globalaims(intersect(intersect(CG07,TP400),T000)); end
try Animals_TP400(5,1)=globalaims(intersect(intersect(CG08,TP400),T000)); end
try Animals_TP400(6,1)=globalaims(intersect(intersect(CG09,TP400),T000)); end
try Animals_TP400(7,1)=globalaims(intersect(intersect(CG10,TP400),T000)); end
    
Animals_TP400(1:7,2)=0;
try Animals_TP400(1,2)=globalaims(intersect(intersect(CG04,TP400),T005)); end
try Animals_TP400(2,2)=globalaims(intersect(intersect(CG05,TP400),T005)); end
try Animals_TP400(3,2)=globalaims(intersect(intersect(CG06,TP400),T005)); end
try Animals_TP400(4,2)=globalaims(intersect(intersect(CG07,TP400),T005)); end
try Animals_TP400(5,2)=globalaims(intersect(intersect(CG08,TP400),T005)); end
try Animals_TP400(6,2)=globalaims(intersect(intersect(CG09,TP400),T005)); end
try Animals_TP400(7,2)=globalaims(intersect(intersect(CG10,TP400),T005)); end        
    
Animals_TP400(1:7,3)=0;
try Animals_TP400(1,3)=globalaims(intersect(intersect(CG04,TP400),T020)); end
try Animals_TP400(2,3)=globalaims(intersect(intersect(CG05,TP400),T020)); end
try Animals_TP400(3,3)=globalaims(intersect(intersect(CG06,TP400),T020)); end
try Animals_TP400(4,3)=globalaims(intersect(intersect(CG07,TP400),T020)); end
try Animals_TP400(5,3)=globalaims(intersect(intersect(CG08,TP400),T020)); end
try Animals_TP400(6,3)=globalaims(intersect(intersect(CG09,TP400),T020)); end
try Animals_TP400(7,3)=globalaims(intersect(intersect(CG10,TP400),T020)); end

Animals_TP400(1:7,4)=0;
try Animals_TP400(1,4)=globalaims(intersect(intersect(CG04,TP400),T030)); end
try Animals_TP400(2,4)=globalaims(intersect(intersect(CG05,TP400),T030)); end
try Animals_TP400(3,4)=globalaims(intersect(intersect(CG06,TP400),T030)); end
try Animals_TP400(4,4)=globalaims(intersect(intersect(CG07,TP400),T030)); end
try Animals_TP400(5,4)=globalaims(intersect(intersect(CG08,TP400),T030)); end
try Animals_TP400(6,4)=globalaims(intersect(intersect(CG09,TP400),T030)); end
try Animals_TP400(7,4)=globalaims(intersect(intersect(CG10,TP400),T030)); end

Animals_TP400(1:7,5)=0;
try Animals_TP400(1,5)=globalaims(intersect(intersect(CG04,TP400),T040)); end
try Animals_TP400(2,5)=globalaims(intersect(intersect(CG05,TP400),T040)); end
try Animals_TP400(3,5)=globalaims(intersect(intersect(CG06,TP400),T040)); end
try Animals_TP400(4,5)=globalaims(intersect(intersect(CG07,TP400),T040)); end
try Animals_TP400(5,5)=globalaims(intersect(intersect(CG08,TP400),T040)); end
try Animals_TP400(6,5)=globalaims(intersect(intersect(CG09,TP400),T040)); end
try Animals_TP400(7,5)=globalaims(intersect(intersect(CG10,TP400),T040)); end

Animals_TP400(1:7,6)=0;
try Animals_TP400(1,6)=globalaims(intersect(intersect(CG04,TP400),T060)); end
try Animals_TP400(2,6)=globalaims(intersect(intersect(CG05,TP400),T060)); end
try Animals_TP400(3,6)=globalaims(intersect(intersect(CG06,TP400),T060)); end
try Animals_TP400(4,6)=globalaims(intersect(intersect(CG07,TP400),T060)); end
try Animals_TP400(5,6)=globalaims(intersect(intersect(CG08,TP400),T060)); end
try Animals_TP400(6,6)=globalaims(intersect(intersect(CG09,TP400),T060)); end
try Animals_TP400(7,6)=globalaims(intersect(intersect(CG10,TP400),T060)); end

Animals_TP400(1:7,7)=0;
try Animals_TP400(1,7)=globalaims(intersect(intersect(CG04,TP400),T080)); end
try Animals_TP400(2,7)=globalaims(intersect(intersect(CG05,TP400),T080)); end
try Animals_TP400(3,7)=globalaims(intersect(intersect(CG06,TP400),T080)); end
try Animals_TP400(4,7)=globalaims(intersect(intersect(CG07,TP400),T080)); end
try Animals_TP400(5,7)=globalaims(intersect(intersect(CG08,TP400),T080)); end
try Animals_TP400(6,7)=globalaims(intersect(intersect(CG09,TP400),T080)); end
try Animals_TP400(7,7)=globalaims(intersect(intersect(CG10,TP400),T080)); end

Animals_TP400(1:7,8)=0;
try Animals_TP400(1,8)=globalaims(intersect(intersect(CG04,TP400),T100)); end
try Animals_TP400(2,8)=globalaims(intersect(intersect(CG05,TP400),T100)); end
try Animals_TP400(3,8)=globalaims(intersect(intersect(CG06,TP400),T100)); end
try Animals_TP400(4,8)=globalaims(intersect(intersect(CG07,TP400),T100)); end
try Animals_TP400(5,8)=globalaims(intersect(intersect(CG08,TP400),T100)); end
try Animals_TP400(6,8)=globalaims(intersect(intersect(CG09,TP400),T100)); end
try Animals_TP400(7,8)=globalaims(intersect(intersect(CG10,TP400),T100)); end

Animals_TP400(1:7,9)=0;
try Animals_TP400(1,9)=globalaims(intersect(intersect(CG04,TP400),T120)); end
try Animals_TP400(2,9)=globalaims(intersect(intersect(CG05,TP400),T120)); end
try Animals_TP400(3,9)=globalaims(intersect(intersect(CG06,TP400),T120)); end
try Animals_TP400(4,9)=globalaims(intersect(intersect(CG07,TP400),T120)); end
try Animals_TP400(5,9)=globalaims(intersect(intersect(CG08,TP400),T120)); end
try Animals_TP400(6,9)=globalaims(intersect(intersect(CG09,TP400),T120)); end
try Animals_TP400(7,9)=globalaims(intersect(intersect(CG10,TP400),T120)); end

Animals_TP400(1:7,10)=0;
try Animals_TP400(1,10)=globalaims(intersect(intersect(CG04,TP400),T140)); end
try Animals_TP400(2,10)=globalaims(intersect(intersect(CG05,TP400),T140)); end
try Animals_TP400(3,10)=globalaims(intersect(intersect(CG06,TP400),T140)); end
try Animals_TP400(4,10)=globalaims(intersect(intersect(CG07,TP400),T140)); end
try Animals_TP400(5,10)=globalaims(intersect(intersect(CG08,TP400),T140)); end
try Animals_TP400(6,10)=globalaims(intersect(intersect(CG09,TP400),T140)); end
try Animals_TP400(7,10)=globalaims(intersect(intersect(CG10,TP400),T140)); end

Animals_TP400(1:7,11)=0;
try Animals_TP400(1,11)=globalaims(intersect(intersect(CG04,TP400),T160)); end
try Animals_TP400(2,11)=globalaims(intersect(intersect(CG05,TP400),T160)); end
try Animals_TP400(3,11)=globalaims(intersect(intersect(CG06,TP400),T160)); end
try Animals_TP400(4,11)=globalaims(intersect(intersect(CG07,TP400),T160)); end
try Animals_TP400(5,11)=globalaims(intersect(intersect(CG08,TP400),T160)); end
try Animals_TP400(6,11)=globalaims(intersect(intersect(CG09,TP400),T160)); end
try Animals_TP400(7,11)=globalaims(intersect(intersect(CG10,TP400),T160)); end


Animals_TP400(1:7,12)=0;
try Animals_TP400(1,12)=globalaims(intersect(intersect(CG04,TP400),T180)); end
try Animals_TP400(2,12)=globalaims(intersect(intersect(CG05,TP400),T180)); end
try Animals_TP400(3,12)=globalaims(intersect(intersect(CG06,TP400),T180)); end
try Animals_TP400(4,12)=globalaims(intersect(intersect(CG07,TP400),T180)); end
try Animals_TP400(5,12)=globalaims(intersect(intersect(CG08,TP400),T180)); end
try Animals_TP400(6,12)=globalaims(intersect(intersect(CG09,TP400),T180)); end
try Animals_TP400(7,12)=globalaims(intersect(intersect(CG10,TP400),T180)); end

%%

Animals_TP500(1:7,1)=0;
try Animals_TP500(1,1)=globalaims(intersect(intersect(CG04,TP500),T000)); end
try Animals_TP500(2,1)=globalaims(intersect(intersect(CG05,TP500),T000)); end
try Animals_TP500(3,1)=globalaims(intersect(intersect(CG06,TP500),T000)); end
try Animals_TP500(4,1)=globalaims(intersect(intersect(CG07,TP500),T000)); end
try Animals_TP500(5,1)=globalaims(intersect(intersect(CG08,TP500),T000)); end
try Animals_TP500(6,1)=globalaims(intersect(intersect(CG09,TP500),T000)); end
try Animals_TP500(7,1)=globalaims(intersect(intersect(CG10,TP500),T000)); end
    
Animals_TP500(1:7,2)=0;
try Animals_TP500(1,2)=globalaims(intersect(intersect(CG04,TP500),T005)); end
try Animals_TP500(2,2)=globalaims(intersect(intersect(CG05,TP500),T005)); end
try Animals_TP500(3,2)=globalaims(intersect(intersect(CG06,TP500),T005)); end
try Animals_TP500(4,2)=globalaims(intersect(intersect(CG07,TP500),T005)); end
try Animals_TP500(5,2)=globalaims(intersect(intersect(CG08,TP500),T005)); end
try Animals_TP500(6,2)=globalaims(intersect(intersect(CG09,TP500),T005)); end
try Animals_TP500(7,2)=globalaims(intersect(intersect(CG10,TP500),T005)); end        
    
Animals_TP500(1:7,3)=0;
try Animals_TP500(1,3)=globalaims(intersect(intersect(CG04,TP500),T020)); end
try Animals_TP500(2,3)=globalaims(intersect(intersect(CG05,TP500),T020)); end
try Animals_TP500(3,3)=globalaims(intersect(intersect(CG06,TP500),T020)); end
try Animals_TP500(4,3)=globalaims(intersect(intersect(CG07,TP500),T020)); end
try Animals_TP500(5,3)=globalaims(intersect(intersect(CG08,TP500),T020)); end
try Animals_TP500(6,3)=globalaims(intersect(intersect(CG09,TP500),T020)); end
try Animals_TP500(7,3)=globalaims(intersect(intersect(CG10,TP500),T020)); end

Animals_TP500(1:7,4)=0;
try Animals_TP500(1,4)=globalaims(intersect(intersect(CG04,TP500),T030)); end
try Animals_TP500(2,4)=globalaims(intersect(intersect(CG05,TP500),T030)); end
try Animals_TP500(3,4)=globalaims(intersect(intersect(CG06,TP500),T030)); end
try Animals_TP500(4,4)=globalaims(intersect(intersect(CG07,TP500),T030)); end
try Animals_TP500(5,4)=globalaims(intersect(intersect(CG08,TP500),T030)); end
try Animals_TP500(6,4)=globalaims(intersect(intersect(CG09,TP500),T030)); end
try Animals_TP500(7,4)=globalaims(intersect(intersect(CG10,TP500),T030)); end

Animals_TP500(1:7,5)=0;
try Animals_TP500(1,5)=globalaims(intersect(intersect(CG04,TP500),T040)); end
try Animals_TP500(2,5)=globalaims(intersect(intersect(CG05,TP500),T040)); end
try Animals_TP500(3,5)=globalaims(intersect(intersect(CG06,TP500),T040)); end
try Animals_TP500(4,5)=globalaims(intersect(intersect(CG07,TP500),T040)); end
try Animals_TP500(5,5)=globalaims(intersect(intersect(CG08,TP500),T040)); end
try Animals_TP500(6,5)=globalaims(intersect(intersect(CG09,TP500),T040)); end
try Animals_TP500(7,5)=globalaims(intersect(intersect(CG10,TP500),T040)); end

Animals_TP500(1:7,6)=0;
try Animals_TP500(1,6)=globalaims(intersect(intersect(CG04,TP500),T060)); end
try Animals_TP500(2,6)=globalaims(intersect(intersect(CG05,TP500),T060)); end
try Animals_TP500(3,6)=globalaims(intersect(intersect(CG06,TP500),T060)); end
try Animals_TP500(4,6)=globalaims(intersect(intersect(CG07,TP500),T060)); end
try Animals_TP500(5,6)=globalaims(intersect(intersect(CG08,TP500),T060)); end
try Animals_TP500(6,6)=globalaims(intersect(intersect(CG09,TP500),T060)); end
try Animals_TP500(7,6)=globalaims(intersect(intersect(CG10,TP500),T060)); end

Animals_TP500(1:7,7)=0;
try Animals_TP500(1,7)=globalaims(intersect(intersect(CG04,TP500),T080)); end
try Animals_TP500(2,7)=globalaims(intersect(intersect(CG05,TP500),T080)); end
try Animals_TP500(3,7)=globalaims(intersect(intersect(CG06,TP500),T080)); end
try Animals_TP500(4,7)=globalaims(intersect(intersect(CG07,TP500),T080)); end
try Animals_TP500(5,7)=globalaims(intersect(intersect(CG08,TP500),T080)); end
try Animals_TP500(6,7)=globalaims(intersect(intersect(CG09,TP500),T080)); end
try Animals_TP500(7,7)=globalaims(intersect(intersect(CG10,TP500),T080)); end

Animals_TP500(1:7,8)=0;
try Animals_TP500(1,8)=globalaims(intersect(intersect(CG04,TP500),T100)); end
try Animals_TP500(2,8)=globalaims(intersect(intersect(CG05,TP500),T100)); end
try Animals_TP500(3,8)=globalaims(intersect(intersect(CG06,TP500),T100)); end
try Animals_TP500(4,8)=globalaims(intersect(intersect(CG07,TP500),T100)); end
try Animals_TP500(5,8)=globalaims(intersect(intersect(CG08,TP500),T100)); end
try Animals_TP500(6,8)=globalaims(intersect(intersect(CG09,TP500),T100)); end
try Animals_TP500(7,8)=globalaims(intersect(intersect(CG10,TP500),T100)); end

Animals_TP500(1:7,9)=0;
try Animals_TP500(1,9)=globalaims(intersect(intersect(CG04,TP500),T120)); end
try Animals_TP500(2,9)=globalaims(intersect(intersect(CG05,TP500),T120)); end
try Animals_TP500(3,9)=globalaims(intersect(intersect(CG06,TP500),T120)); end
try Animals_TP500(4,9)=globalaims(intersect(intersect(CG07,TP500),T120)); end
try Animals_TP500(5,9)=globalaims(intersect(intersect(CG08,TP500),T120)); end
try Animals_TP500(6,9)=globalaims(intersect(intersect(CG09,TP500),T120)); end
try Animals_TP500(7,9)=globalaims(intersect(intersect(CG10,TP500),T120)); end

Animals_TP500(1:7,10)=0;
try Animals_TP500(1,10)=globalaims(intersect(intersect(CG04,TP500),T140)); end
try Animals_TP500(2,10)=globalaims(intersect(intersect(CG05,TP500),T140)); end
try Animals_TP500(3,10)=globalaims(intersect(intersect(CG06,TP500),T140)); end
try Animals_TP500(4,10)=globalaims(intersect(intersect(CG07,TP500),T140)); end
try Animals_TP500(5,10)=globalaims(intersect(intersect(CG08,TP500),T140)); end
try Animals_TP500(6,10)=globalaims(intersect(intersect(CG09,TP500),T140)); end
try Animals_TP500(7,10)=globalaims(intersect(intersect(CG10,TP500),T140)); end

Animals_TP500(1:7,11)=0;
try Animals_TP500(1,11)=globalaims(intersect(intersect(CG04,TP500),T160)); end
try Animals_TP500(2,11)=globalaims(intersect(intersect(CG05,TP500),T160)); end
try Animals_TP500(3,11)=globalaims(intersect(intersect(CG06,TP500),T160)); end
try Animals_TP500(4,11)=globalaims(intersect(intersect(CG07,TP500),T160)); end
try Animals_TP500(5,11)=globalaims(intersect(intersect(CG08,TP500),T160)); end
try Animals_TP500(6,11)=globalaims(intersect(intersect(CG09,TP500),T160)); end
try Animals_TP500(7,11)=globalaims(intersect(intersect(CG10,TP500),T160)); end


Animals_TP500(1:7,12)=0;
try Animals_TP500(1,12)=globalaims(intersect(intersect(CG04,TP500),T180)); end
try Animals_TP500(2,12)=globalaims(intersect(intersect(CG05,TP500),T180)); end
try Animals_TP500(3,12)=globalaims(intersect(intersect(CG06,TP500),T180)); end
try Animals_TP500(4,12)=globalaims(intersect(intersect(CG07,TP500),T180)); end
try Animals_TP500(5,12)=globalaims(intersect(intersect(CG08,TP500),T180)); end
try Animals_TP500(6,12)=globalaims(intersect(intersect(CG09,TP500),T180)); end
try Animals_TP500(7,12)=globalaims(intersect(intersect(CG10,TP500),T180)); end

GlobalAIMmatrix=cat(3,Animals_TP101,Animals_TP104,Animals_TP110,Animals_TP116,...
    Animals_TP121,Animals_TP200,Animals_TP300,Animals_TP400,Animals_TP500);
GlobalAIMmatrix_info="animals (CG04 bis 10) x minute (0,5,20...) x TP(101,...,TP500)";
save('VAR_Global_AIM_matrix','GlobalAIMmatrix','GlobalAIMmatrix_info');