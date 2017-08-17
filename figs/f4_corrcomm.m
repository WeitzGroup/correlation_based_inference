
clear
fig_setup


% PLOT SETUP
xi = [2*fL+dL, L+bL+cL+5*fL+dL, L+fL, L+fL, L+bL+cL+5*fL+dL];
yi = [2*fL+dL, L+fL, 2*dL+(L+3*fL+dL), L+fL];
xpos = cumsum(xi);
ypos = cumsum(yi);

totwidth = xpos(end)+L+dL;
totheight = ypos(end)+L+fL+dL;



figure('Units','centimeters','Position',[10 10 totwidth totheight]);
make_ax = @(i,j) axes('Units','centimeters','Position',[xpos(i) ypos(j) L L]);
make_cbar = @(i,j) colorbar('Units','centimeters','Position',[xpos(i)+L+bL ypos(j) cL L],...
    'Location','manual','FontSize',fs,'LineWidth',lw);
add_label = @(str) text(-.4,1,str,'FontSize',Fs,'FontWeight','bold');

AB = {'A','B'};



for j = 1:length(dir_data)
    
    % load data
    load(fp_corr{j});
    load(fp_pars{j});
    yj = -2*j+6; % put nested on top and modular on bottom
    
    oT_hrs = linspace(info.length_hrs_actual*.25,info.length_hrs_actual*.75,3);
    oT = oT_hrs/24;
    oT_str = cellstr(num2str(oT_hrs'));
    for i = 1:length(oT)
        oID(i) = find(corrs.comm.offsetT >= oT(i),1);
    end
    
    
    
    ax = make_ax(1,yj);
    ax.Visible = 'off';
    add_label(strcat(AB{j},'1)'));
    
    % original interaction network
    ax = make_ax(1,yj);
    plot_network(ax,pars.Mpb,[],'interaction network','jet');
    cbar = make_cbar(1,yj);
    cbar.Label.String = 'interaction strength';


    
    
    
    ax = make_ax(2,yj);
    ax.Visible = 'off';
    add_label(strcat(AB{j},'2)'));
    
    % correlation networks  
    for i = 1:3
        ax = make_ax(i+1,yj);
        title_str = sprintf('\\tau = %s hours',oT_str{i});
        plot_network(ax,corrs.comm.R{oID(i)},[-1 1],title_str,redbluecmap());
    end
    cbar = make_cbar(4,yj);
    cbar.Limits = [-1 1];
    cbar.Ticks = [-1 0 1];
    cbar.Label.String = 'correlation';
    
    % roc curves
    for i = 1:3
        fpr = corrs.comm.fpr{oID(i)};
        tpr = corrs.comm.tpr{oID(i)};
        T = corrs.comm.thresholds{oID(i)};
        J = corrs.comm.Jstat(oID(i));
        cID = corrs.comm.Jstat_ID(oID(i));
        pval = corrs.comm.Jstat_pval(oID(i));
        
        ax = make_ax(i+1,yj-1);
        plot_roc(ax,fpr,tpr,T,J,cID,pval);
        if i~=1; set(gca,'YLabel',[],'YTickLabel',[]); end
        if i~=2; set(gca,'XLabel',[]); end
        title([]);
    end
    
    
    
        
    
    ax = make_ax(5,yj);
    ax.Visible = 'off';
    add_label(strcat(AB{j},'3)'));
    
    % J for all possible offsets
    make_ax(5,yj);
    hold on;
    plot([corrs.comm.offsetT(1) corrs.comm.offsetT(end)]*24,[1 1],'--','Color',[.5 .5 .5],'LineWidth',lw);
    plot(corrs.comm.offsetT*24,corrs.comm.Jstat_pval,'Color',[.7 .7 .7],'LineWidth',lw);
    set(gca,'ColorOrderIndex',1);
    plot(corrs.comm.offsetT*24,corrs.comm.Jstat,'LineWidth',lw);
    stem(corrs.comm.offsetT(oID)*24,corrs.comm.Jstat(oID),'*','LineWidth',lw);
    hold off;
    ylim([0 1.3]);
    xlim([0 info.length_hrs_actual]);
    xlabel('delay (hours)','FontSize',fs);
    ylabel('J score','FontSize',fs);
    tticks = linspace(0,info.length_hrs_actual,3);
    set(gca,'LineWidth',lw,'FontSize',fs,'XTick',tticks);
    box on;


    
end


% SAVE
save_fig(gcf,strcat(dir_figs,'f4_corrcomm'),res,prn);


