function plotSingleBarSEM(x)
bar(nanmean(x,1),'BarWidth',0.8,'EdgeColor','none','FaceColor','black');
hold on
errorbar([],nanmean(x,1),[],(nanstd(x,1)./sqrt(size(x,1))),'k','LineStyle','none');
hold off

end