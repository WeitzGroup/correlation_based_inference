% Figure 5 - Examples of time-delayed correlation networks.


clear
fig_setup
load('data/results_main/analysis_setup');


% PLOT SETUP
xi = [2*fL+dL, L+bL+cL+4*fL+dL, L+bL+cL+4*fL+dL];
yi = [fL+dL, L+2*dL+2*fL];
xpos = cumsum(xi);
ypos = cumsum(yi);

totwidth = xpos(end)+L+bL+cL+3*fL+dL;
totheight = ypos(end)+L+fL+dL;

fig = figure('Units','centimeters');
fig.Position(3:4) = [totwidth totheight];
make_ax = @(i,j) axes('Units','centimeters','Position',[xpos(i) ypos(j) L L]);
make_cbar = @(i,j) colorbar('Units','centimeters','Position',[xpos(i)+L+bL ypos(j) cL L],...
    'Location','manual','FontSize',fs,'LineWidth',lw);
add_label = @(str) text(-3,0,str,'FontSize',Fs,'FontWeight','bold');

AB = {'A','B'};
tmpM = {'local similarity score','estimated correlation'};

for s = 1:length(S)
    load(sprintf('data/networks/S%d_N1',s));
    load(sprintf('data/results_main/pearsondelayed_S%d_N1',s));
    
    make_ax(1,3-s);
    plot_network(Mtilde(:,:,qID),[],'interaction network','jet');
    cbar = make_cbar(1,3-s);
    cbar.Label.String = 'interaction strength';
    add_label(sprintf('%s1)',AB{s}));

    make_ax(2,3-s);
    plot_network(delay(:,:,qID),[],'tau',[]);
    colormap(gca,'default');
    cbar = make_cbar(2,3-s);
    cbar.Label.String = 'time-delay (hours)';
    add_label(sprintf('%s%d)',AB{s},2));
        
    make_ax(3,3-s);
    plot_network(R(:,:,qID),[-1 +1],'correlation network',redbluecmap());
    cbar = make_cbar(3,3-s);
    cbar.Label.String = 'correlation';
    add_label(sprintf('%s%d)',AB{s},3));

end

save_fig(sprintf('%s/fig5ab',save_dir));