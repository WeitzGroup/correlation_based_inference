% Figure 4 - AUC results for simple correlation.

clear
fig_setup
load('data/results_main/analysis_setup');

c = 1;

f = figure('Units','inches');
f.Position(3:4) = [4 3];

L = {'nestedness (NODF)','modularity (Q_b)'}; % axis labels
AB = {'A)','B)'};

for s = 1:length(S)
    for n = 1:length(N)

        load(sprintf('data/networks/S%d_N%d',s,n));
        load(sprintf('data/results_main/pearson_S%d_N%d',s,n));

        k = n+(s-1)*3;
        subplot(length(S),length(N),k);
        plot([0 1],[.5 .5],'--','Color',[.5 .5 .5],'LineWidth',lw);
        hold on;
        set(gca,'ColorOrderIndex',1);
        plot(Q,AUC','o','LineWidth',lw,'MarkerSize',ms);
        hold off;
        text(.05,.9,(sprintf('N=%d',N(n))),'FontSize',fs);
        ylim([0 1]);
        if n==2; xlabel(L{s}); end
        if n==1; ylabel('AUC'); end
        if n==1; text(-.5,1.1,AB{s},'FontSize',Fs,'FontWeight','bold'); end
        set(gca,'FontSize',fs,'LineWidth',lw);

    end
end


save_fig(sprintf('%s/fig4',save_dir));
