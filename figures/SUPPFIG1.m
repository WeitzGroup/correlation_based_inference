% Supp fig 1 - AUC results for spearman and kendall correlation

clear;
fig_setup;
load('data/results_supp_metrics/analysis_setup');
dir_results_all = {'results_main','results_supp_metrics','results_supp_metrics'};

f = figure('Units','inches');
f.Position(3:4) = [4 3];

L = {'nestedness (NODF)','modularity (Q_b)'}; % axis labels
AB = {'A)','B)'};

for c = 1:3
    for s = 1:length(S)
        for n = 1:length(N)
            
            load(sprintf('data/networks/S%d_N%d',s,n));
            load(sprintf('data/%s/%s_S%d_N%d',dir_results_all{c},C{c},s,n));
                
            k = n+(s-1)*3;
            subplot(length(S),length(N),k);
            if c==1; plot([0 1],[.5 .5],'--','Color',[.5 .5 .5],'LineWidth',lw); end
            hold on;
            set(gca,'ColorOrderIndex',c);
            plot(Q,AUC','o','LineWidth',lw,'MarkerSize',ms);
            hold off;
            if c==1
                text(.05,.9,(sprintf('N=%d',N(n))),'FontSize',fs);
                ylim([0 1]);
                if n==2; xlabel(L{s}); end
                if n==1; ylabel('AUC'); end
                if n==1; text(-.5,1.1,AB{s},'FontSize',Fs,'FontWeight','bold'); end
                if n==2 && s==1; title('standard correlation (varying correlation metric)','FontSize',Fs,'FontWeight','normal'); end
                set(gca,'FontSize',fs,'LineWidth',lw);
                box on;
            end

        end
    end
end


save_fig(sprintf('%s/suppfig1',save_dir));
