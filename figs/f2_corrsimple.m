
clear
fig_setup


% PLOT SETUP
xi = [2*fL+dL, L+bL+cL+7*fL+dL, L+dL+3*fL, L+dL+bL+cL+5*fL];  %left->right
yi = [2*fL+dL, L+dL, 2*dL+(L+3*fL+dL), L+dL]; %bottom->top
xpos = cumsum(xi);
ypos = cumsum(yi);

totwidth = xpos(end)+L+dL+bL+cL+2*fL;
totheight = ypos(end)+L+fL+dL;

figure('Units','centimeters','Position',[10 10 totwidth totheight]);
make_ax = @(i,j) axes('Units','centimeters','Position',[xpos(i) ypos(j) L L]);
make_cbar = @(i,j) colorbar('Units','centimeters','Position',[xpos(i)+L+bL ypos(j) cL L],...
    'Location','manual','FontSize',fs,'LineWidth',lw);
add_label = @(xpos,str) text(xpos,1,str,'FontSize',Fs,'FontWeight','bold');

AB = {'A','B'};


for j = 1:length(dir_data)
    
    % load data
    load(fp_pars{j});
    load(fp_ts{j});
    load(fp_sample{j});
    load(fp_corr{j});
    yj = -2*j+6; % put nested on top and modular on bottom

    
    
    ax = make_ax(1,yj);
    ax.Visible = 'off';
    add_label(-.4,strcat(AB{j},'1)'));
    
    % Mtilde
    ax = make_ax(1,yj);
    plot_network(ax,pars.Mpb,[],'interaction network','jet');
    cbar = make_cbar(1,yj);
    cbar.Label.String = 'interaction strength';
    
    
    
    ax = make_ax(2,yj);
    ax.Visible = 'off';
    add_label(-.6,strcat(AB{j},'2)'));     
    
    tlims = [0 info.length_hrs_actual];
    tticks = [0 info.length_hrs_actual/2 info.length_hrs_actual];
    ylims = @(y) [.4*min(y(:)) 1.7*max(y(:))];
    
    % host timeseries
    make_ax(2,yj)
    semilogy(dyn.t*24,dyn.H,'LineWidth',lw);
    xlim(tlims);
    ylim(ylims(dyn.H));
    ylabel(sprintf('host\ndensity (mL^{-1})'),'FontSize',fs);
    title('time-series','FontSize',fs,'FontWeight','normal');
    set(gca,'LineWidth',lw,'FontSize',fs,'XTick',[]);
 
    % virus timeseries
    make_ax(2,yj-1)
    semilogy(dyn.t*24,dyn.V,'LineWidth',lw);
    xlim(tlims);
    ylim(ylims(dyn.V));
    xlabel('time (hours)','FontSize',fs);
    ylabel(sprintf('virus\ndensity (mL^{-1})'),'FontSize',fs);
    set(gca,'LineWidth',lw,'FontSize',fs,'XTick',tticks);
    

    
    
    ax = make_ax(3,yj);
    ax.Visible = 'off';
    add_label(-.4,strcat(AB{j},'3)')); 
    
    sID = info.sID;     
    xticks = [0 length(sID)/2 length(sID)]+.5;
    xlabels = [0 info.length_hrs_actual/2 info.length_hrs_actual];
 
    % host sample
    make_ax(3,yj);
    imagesc(log10(dyn.H(sID,:))');
    colormap(gca,'gray');
    set(gca,'YTick',[],'LineWidth',lw,'FontSize',fs);
    ylabel('hosts','FontSize',fs);
    title('samples','FontSize',fs,'FontWeight','normal');
    set(gca,'XTick',xticks,'XTickLabel',[]);
    cbar = make_cbar(3,yj);
    cbar.Label.String = 'log_{10} density';

    % virus sample
    make_ax(3,yj-1);
    imagesc(log10(dyn.V(sID,:))');
    colormap(gca,'gray');
    hold on;
    set(gca,'YTick',[],'LineWidth',lw,'FontSize',fs);
    xlabel('time (hours)','FontSize',fs);
    ylabel('viruses','FontSize',fs);
    set(gca,'XTick',xticks,'XTickLabel',xlabels);
    cbar = make_cbar(3,yj-1);
    cbar.Label.String = 'log_{10} density';
    
    
       
    
    ax = make_ax(4,yj);
    ax.Visible = 'off';
    add_label(-.4,strcat(AB{j},'4)')); 

    % correlation network
    ax = make_ax(4,yj);
    plot_network(ax,corrs.comm.R{1},[-1 +1],'correlation network',redbluecmap());
    cbar = make_cbar(4,yj);
    cbar.Limits = [-1 1];
    cbar.Ticks = [-1 0 1];
    cbar.Label.String = 'correlation';
end


% SAVE
save_fig(gcf,strcat(dir_figs,'f2_corrsimple'),res,prn);
