function plot_network(cdata, clims, title_str, cmap_str)
% Helper function for plotting interaction and correlation networks.

fig_setup;
ax = gca;

if exist('clims','var') && ~isempty(clims)
    imagesc(cdata,clims); 
else
    imagesc(cdata);
end

set(ax,'XTick',[],'YTick',[],'LineWidth',lw,'FontSize',fs);
xlabel('viruses','FontSize',fs);
ylabel('microbes','FontSize',fs);
ax.XLabel.Position(2) = 10.5;
ax.YLabel.Position(1) = .4;

if exist('title_str','var') && ~isempty(title_str)
    title(title_str,'FontSize',fs,'FontWeight','normal');
end

if exist('cmap_str','var') && ~isempty(cmap_str)
    colormap(ax,zerocmap(colormap(cmap_str))); 
end
    
end
