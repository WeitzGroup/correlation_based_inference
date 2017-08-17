function plot_roc(ax, fpr, tpr, thresh, J, cID, pval)
% Helper function for plotting ROC curves.

fig_setup

plot([0 1],[0 1],'k--','LineWidth',lw,'Color',[.5 .5 .5]);
hold on;
area(ax,fpr,tpr,'FaceColor',[.8 .8 .8],'LineWidth',lw);

% mark .5/0 thresholds
tval = [-.5, 0, .5];
tstr = {'-0.5','0','+0.5'};
tcol = {[.6 0 0],[1 1 1],[0 0 .6]};
for k = 1:3
    ID = find(thresh>=tval(k),1);
    plot(fpr(ID),tpr(ID),'o','LineWidth',lw,'MarkerFaceColor',tcol{k},...
        'MarkerEdgeColor','k','MarkerSize',ms)
end

% mark optimal threshold
plot(fpr(cID),tpr(cID),'v','LineWidth',lw,'MarkerFaceColor','green',...
    'MarkerEdgeColor','k','MarkerSize',ms);

% formatting
xlabel('FPR','FontSize',fs);
ylabel('TPR','FontSize',fs);
Jstr = sprintf('J=%.1g\n(p=%.1g)',J,pval);
text(.97,.02,Jstr,'FontSize',fs,...
'HorizontalAlignment','right','VerticalAlignment','bottom');
title('ROC curve','FontSize',fs,'FontWeight','normal');
set(gca,'LineWidth',lw,'FontSize',fs);
hold off;

end