
clear
fig_setup


% PLOT SETUP
xi = [4*fL+dL, 4*fL+dL+L, dL+L, dL+L, 4*fL+dL+L];
yi = [2*fL+dL, 2*dL+(L+4*fL+dL)];
xpos = cumsum(xi);
ypos = cumsum(yi);

totwidth = xpos(end)+L+dL;
totheight = ypos(end)+L+2*fL+dL;

figure('Units','centimeters','Position',[10 10 totwidth totheight]);
make_ax = @(i,j) axes('Units','centimeters','Position',[xpos(i) ypos(j) L L]);
add_label = @(str) text(-.6,1,str,'FontSize',Fs,'FontWeight','bold');

AB = {'A','B'};


dirs = {'data/parsnest','data/parsmod'};
filenum = 6;

for j = 1:length(dirs)
    fp_corrs = sprintf('%s/delta3_corr%d',dirs{j},filenum);
    load(fp_corrs);
    
    % community offsets to display
    offset_ID = 1:25:100;
    title_str = {...
        'simple',...
        '\\tau = 200 hours',...
        'community-wide  time-delays\n\\tau = 400 hours',...
        '\\tau = 600 hours',...
        'pairwise\ntime-delays'};
    
    % put nested on top and modular on bottom
    yj = j*-1+3;
    
    for i = 1:5
        
        % grab J values
        if i<5
            Jstat = corrs.comm.Jstat(offset_ID(i));
            Jstat_pval = corrs.comm.Jstat_pval(offset_ID(i));
            Jstat_dist = corrs.comm.Jstat_dist{offset_ID(i)};
        else
            Jstat = corrs.pair.Jstat(1);
            Jstat_pval = corrs.pair.Jstat_pval(1);
            Jstat_dist = corrs.pair.Jstat_dist{1};
        end
        [Jcounts, Jbins] = hist(Jstat_dist);
        Jcounts = Jcounts/sum(Jcounts);         
        
        % label A/B
        if i==1 || i==2 || i==5
            if i==5; k=3; else k=i; end
            ax = make_ax(i,yj);
            ax.Visible = 'off';
            add_label(sprintf('%s%d)',AB{j},k));
        end

        % plot
        make_ax(i,yj);
        hold on;
        plot(Jbins, Jcounts,'-','LineWidth',lw)
        plot(Jstat*ones(1,2),[0 1],'r--','LineWidth',lw)
        hold off;
        xlim([0 1]);
        ylim([0 .4]);
        if i==1 || i==3 || i==5; xlabel('J score'); end
        if i==1 || i==2 || i==5; 
            ylabel('frequency')
        else
            set(gca,'YTickLabel',[]);
        end
        title(sprintf(title_str{i}),'FontWeight','normal');
        text(.95,0.01,sprintf('p=%.1g',Jstat_pval),...
            'FontSize',fs,'HorizontalAlignment','right','VerticalAlignment','bottom');
        set(gca,'LineWidth',lw,'FontSize',fs);
        box on;
    end
end


% SAVE FIGURE
save_fig(gcf,strcat(dir_figs,'fs1_pvalues'),res,prn);
