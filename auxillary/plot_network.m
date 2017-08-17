function plot_network(ax, data, clims, title_str, cmap_str)
% Helper function for plotting interaction and correlation networks.

fig_setup

if ~isempty(clims); imagesc(data,clims); else imagesc(data); end
set(ax,'XTick',[],'YTick',[],'LineWidth',lw,'FontSize',fs);
xlabel('viruses','FontSize',fs);
ylabel('hosts','FontSize',fs);
ax.XLabel.Position(2) = 10.5;
ax.YLabel.Position(1) = .4;
title(title_str,'FontSize',fs,'FontWeight','normal');
colormap(ax,zerocmap(colormap(cmap_str)));
    
end
