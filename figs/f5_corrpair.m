
clear
fig_setup


% PLOT SETUP
totwidth = 2*(L+dL+cL+bL+2*fL)+dL+5*fL;
totheight = 4*(L+dL+1.5*fL)+3*fL+2*dL;

figure('Units','centimeters','Position',[10 10 totwidth totheight]);
xpos = @(i,k) 2*fL+dL+i*(L+dL+bL+cL+5*fL);
ypos = @(j,m) j*(L+dL+1.5*fL)+2*fL+dL+m*(2*fL+dL);
make_ax = @(i,j,k,m) axes('Units','centimeters','Position',[xpos(i,k) ypos(j,m) L L]);
make_cbar = @(i,j,k,m) colorbar('Units','centimeters','Position',[xpos(i,k)+L+bL ypos(j,m) cL L],...
    'Location','manual','FontSize',fs,'LineWidth',lw);
add_label = @(str) text(-.4,1,str,'FontSize',Fs,'FontWeight','bold');

AB = {'A','B'};



for j = 1:length(dir_data)
    
    load(fp_corr{j});
    load(fp_pars{j});
    
    m = 2-j;
    yj = 5-2*j;
    
    
    ax = make_ax(0,yj,0,m);
    ax.Visible = 'off';
    add_label(strcat(AB{j},'1)'));
    
    % original interaction network
    ax = make_ax(0,yj,0,m);
    plot_network(ax,pars.Mpb,[],'interaction network','jet');
    cbar = make_cbar(0,yj,0,m);
    cbar.Label.String = 'interaction strength';


    
    ax = make_ax(1,yj,1,m);
    ax.Visible = 'off';
    add_label(strcat(AB{j},'3)'));
    
    % correlation network 
    ax = make_ax(1,yj,1,m);
    plot_network(ax,corrs.pair.R{1},[-1 1],'correlation network',redbluecmap());
    cbar = make_cbar(1,yj,1,m);
    cbar.Limits = [-1 1];
    cbar.Ticks = [-1 0 1];
    cbar.Label.String = 'correlation';
    
    
    
    ax = make_ax(1,yj-1,1,m);
    ax.Visible = 'off';
    add_label(strcat(AB{j},'4)'));
    
    % roc curve
    fpr = corrs.pair.fpr{1};
    tpr = corrs.pair.tpr{1};
    T = corrs.pair.thresholds{1};
    Jstat = corrs.pair.Jstat(1);
    Jstat_ID = corrs.pair.Jstat_ID(1);
    Jstat_pval = corrs.pair.Jstat_pval(1);
    
    ax = make_ax(1,yj-1,1,m);
    plot_roc(ax,fpr,tpr,T,Jstat,Jstat_ID,Jstat_pval)



    ax = make_ax(0,yj-1,1,m);
    ax.Visible = 'off';
    add_label(strcat(AB{j},'2)'));
    
    % pairwise time-delays
    ax = make_ax(0,yj-1,1,m);
    plot_network(ax,corrs.pair.offsetT{1},[],'pairwise time-delays','parula');
    colormap(ax,'parula');
    cbar = make_cbar(0,yj-1,1,m);
    cbar.Label.String = 'delay (days)';

    

end


% SAVE
save_fig(gcf,strcat(dir_figs,'f5_corrpair'),res,prn);


