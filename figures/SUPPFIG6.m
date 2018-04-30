% Supp fig 6 - AUC results for time-delayed (pearson) correlation with
% different sampling frequencies

clear
fig_setup
load('data/results_supp_samplefreq/samplefreq1/analysis_setup');
dir_results_all = {'results_supp_samplefreq/samplefreq1','results_main','results_supp_samplefreq/samplefreq3'};

f = figure('Units','inches');
f.Position(3:4) = [4 3];

L = {'nestedness (NODF)','modularity (Q_b)'}; % axis labels
AB = {'A)','B)'};

for d = 1:length(dir_results_all)
    for s = 1:length(S)
        for n = 1:length(N)

            load(sprintf('data/%s/pearsondelayed_S%d_N%d',dir_results_all{d},s,n));
            load(sprintf('data/networks/S%d_N%d',s,n));

            k = n+(s-1)*3;
            subplot(length(S),length(N),k);
            if d==1; plot([0 1],[.5 .5],'--','Color',[.5 .5 .5],'LineWidth',lw); end
            hold on;
            set(gca,'ColorOrderIndex',d);
            plot(Q,AUC','o','LineWidth',lw,'MarkerSize',ms);
            hold off;
            if d==1
                text(.05,.9,(sprintf('N=%d',N(n))),'FontSize',fs);
                ylim([0 1]);
                if n==2; xlabel(L{s}); end
                if n==1; ylabel('AUC'); end
                if n==1; text(-.5,1.1,AB{s},'FontSize',Fs,'FontWeight','bold'); end
                if n==2 && s==1; title('time-delayed Pearson correlation (varying sampling frequency)','FontSize',Fs,'FontWeight','normal'); end
                set(gca,'FontSize',fs,'LineWidth',lw);
                box on;
            end


        end
    end
end


save_fig(sprintf('%s/suppfig6',save_dir));
