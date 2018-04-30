% Figure 7 - Examples of eLSA and SparCC networks.

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
clim = {[-1 +1],[-.1 +.1]};

for s = 1:length(S)
    load(sprintf('data/networks/S%d_N1',s));
    
    make_ax(1,3-s);
    plot_network(Mtilde(:,:,qID),[],'interaction network','jet');
    cbar = make_cbar(1,3-s);
    cbar.Label.String = 'interaction strength';
    add_label(sprintf('%s1)',AB{s}));
    for m = 1:length(M)
        load(sprintf('data/results_main/%s_S%d_N1',M{m},s));
        make_ax(m+1,3-s);
        plot_network(R(:,:,qID),clim{m},Mlabel{m},redbluecmap());
        cbar = make_cbar(m+1,3-s);
        cbar.Label.String = tmpM{m};
        add_label(sprintf('%s%d)',AB{s},m+1));
    end
end

save_fig(sprintf('%s/fig6ab',save_dir));