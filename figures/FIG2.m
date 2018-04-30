% Figure 2 - Examples of simple correlation networks.

clear;
fig_setup;
load('data/results_main/analysis_setup');

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
add_label = @(xpos,str) text(xpos,1.1,str,'FontSize',Fs,'FontWeight','bold');

AB = {'A','B'};



for s = 1:length(S)
    
    % load data
    load(sprintf('data/networks/S%d_N1',s));
    load(sprintf('data/timeseries/delta3/S%d_N1',s));
    load(sprintf('data/results_main/samples/S%d_N1',s));
    load(sprintf('data/results_main/pearson_S%d_N1',s));
    load('data/results_main/analysis_setup');
    
    yj = -2*s+6; % put nested on top and modular on bottom

    
    
    ax = make_ax(1,yj);
    ax.Visible = 'off';
    add_label(-.4,strcat(AB{s},'1)'));
    
    % Mtilde
    ax = make_ax(1,yj);
    plot_network(Mtilde(:,:,qID),[],'interaction network','jet');
    cbar = make_cbar(1,yj);
    cbar.Label.String = 'interaction strength';
    
    
    
    ax = make_ax(2,yj);
    ax.Visible = 'off';
    add_label(-.6,strcat(AB{s},'2)'));
    
    tlim = [0 floor(st(end))];
    
    % host timeseries
    make_ax(2,yj)
    semilogy(t,H(:,:,qID),'LineWidth',lw);
    xlim(tlim);
    ylabel(sprintf('microbe\ndensity (mL^{-1})'),'FontSize',fs);
    title('time-series','FontSize',fs,'FontWeight','normal');
    set(gca,'LineWidth',lw,'FontSize',fs,'XTick',[]);
 
    % virus timeseries
    make_ax(2,yj-1)
    semilogy(t,V(:,:,qID),'LineWidth',lw);
    xlim(tlim);
    xlabel('time (days)','FontSize',fs);
    ylabel(sprintf('virus\ndensity (mL^{-1})'),'FontSize',fs);
    set(gca,'LineWidth',lw,'FontSize',fs);
    

    
    
    ax = make_ax(3,yj);
    ax.Visible = 'off';
    add_label(-.4,strcat(AB{s},'3)')); 
    
    tmpID = [0 .5 1]*sample_N(1)+[1 0 0];
    tmptick = tmpID-.5;
    tmpticklabel = round(st(tmpID));
 
    % host sample
    make_ax(3,yj);
    imagesc(log10(sH(:,:,qID))');
    colormap(gca,'gray');
    set(gca,'YTick',[],'LineWidth',lw,'FontSize',fs);
    ylabel('microbes','FontSize',fs);
    title('samples','FontSize',fs,'FontWeight','normal');
    set(gca,'XTick',tmptick,'XTickLabel',[]);
    cbar = make_cbar(3,yj);
    cbar.Label.String = 'log_{10} density';

    % virus sample
    make_ax(3,yj-1);
    imagesc(log10(sV(:,:,qID))');
    colormap(gca,'gray');
    hold on;
    set(gca,'YTick',[],'LineWidth',lw,'FontSize',fs);
    xlabel('time (days)','FontSize',fs);
    ylabel('viruses','FontSize',fs);
    set(gca,'XTick',tmptick,'XTickLabel',tmpticklabel);
    cbar = make_cbar(3,yj-1);
    cbar.Label.String = 'log_{10} density';
    
    
       
    
    ax = make_ax(4,yj);
    ax.Visible = 'off';
    add_label(-.4,strcat(AB{s},'4)')); 

    % correlation network
    ax = make_ax(4,yj);
    plot_network(R(:,:,qID),[-1 +1],'correlation network',redbluecmap());
    cbar = make_cbar(4,yj);
    cbar.Limits = [-1 1];
    cbar.Ticks = [-1 0 1];
    cbar.Label.String = 'correlation';
end


% SAVE
save_fig(sprintf('%s/fig2',save_dir));
