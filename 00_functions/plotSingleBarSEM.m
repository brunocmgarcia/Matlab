function plotSingleBarSEM(x)
bar(mean(x,1),'BarWidth',0.8,'EdgeColor','none','FaceColor','black');
hold on
errorbar([],mean(x,1),[],(std(x,1)./sqrt(size(x,1))),'k','LineStyle','none');
hold off

end