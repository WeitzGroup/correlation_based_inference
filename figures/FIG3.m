% Figure 3 - Examples of ROC scoring.

clear;
fig_setup;
load('data/results_main/analysis_setup');

% PLOT SETUP
xi = [2*fL+dL, L+bL+cL+3*fL+dL+aL, L+dL, L+dL, L+dL+5*fL];
yi = [dL+fL, L+1.5*fL+dL, 2*dL+(L+1.5*fL+dL), L+1.5*fL+dL];
xpos = cumsum(xi);
ypos = cumsum(yi);

totwidth = xpos(end)+L+dL;
totheight = ypos(end)+L+fL+dL;

figure('Units','centimeters','Position',[10 10 totwidth totheight]);
make_ax = @(i,j) axes('Units','centimeters','Position',[xpos(i),ypos(j),L,L]);
make_cbar = @(i,j) colorbar('Units','centimeters','Position',[xpos(i)+L+bL ypos(j) cL L],...
    'Location','manual','FontSize',fs,'LineWidth',lw);
add_label = @(pos,str) text(pos,1.1,str,'FontSize',Fs,'FontWeight','bold');
add_arrow = @(i,j) annotation('arrow',...
    ([0 aL]+xpos(i+1)-aL-dL)/totwidth,([ypos(j) ypos(j)]+L/2)/totheight);

AB = {'A','B'};


for s = 1:length(S)
    
    % load data
    load(sprintf('data/networks/S%d_N1',s));
    load(sprintf('data/results_main/pearson_S%d_N1',s));
    %load('data/results_main/analysis_setup');
    yj = -2*s+6; % put nested on top and modular on bottom
    
    % threshold setup
    thresh = {-.5, 0, .5};
    thresh_str = {'-0.5','0','+0.5'};
    thresh_c = {[.6 0 0],[1 1 1],[0 0 .6]};

    
    ax = make_ax(1,yj);
    ax.Visible = 'off';
    add_label(-0.4,strcat(AB{s},'1)'));
    add_arrow(1,yj);

    % original correlation network
    R = R(:,:,qID);
    ax = make_ax(1,yj);
    plot_network(R,[-1 1],'correlation network',redbluecmap());
    cbar = make_cbar(1,yj);
    cbar.Limits = [-1 1];
    cbar.Ticks = [-1 0 1];
    cbar.Label.String = 'correlation';
    
    % thresholded and binarized correlation networks
    for i = 1:length(thresh)
        Rbool = R>thresh{i};
        ax = make_ax(i+1,yj);
        imagesc(Rbool,[-1 1]);
        set(gca,'XTick',[],'YTick',[],'LineWidth',lw);
        colormap(gca, zerocmap(redbluecmap()));
        title(sprintf('c = %s',thresh_str{i}),'FontSize',fs,'FontWeight','normal');
        hold on;
        plot(8.5,-.5,'o','LineWidth',lw,...
            'MarkerFaceColor',thresh_c{i},'MarkerEdgeColor','k','MarkerSize',ms);
        ax.Clipping = 'off';
        hold off;
    end
    
    
    
    
    ax = make_ax(1,yj-1);
    ax.Visible = 'off';
    add_label(-0.4,strcat(AB{s},'2)'));
    add_arrow(1,yj-1);
    
    % original interaction network
    ax = make_ax(1,yj-1);
    plot_network(Mtilde(:,:,qID),[],'interaction network','jet');
    cbar = make_cbar(1,yj-1);
    cbar.Label.String = 'interaction strength';
    
    % binarized interaction network
    make_ax(2,yj-1);
    imagesc(logical(Mtilde(:,:,qID)));
    set(gca,'XTick',[],'YTick',[],'LineWidth',lw);
    colormap(gca, zerocmap(redbluecmap()));

    
    
    
    ax = make_ax(5,yj);
    ax.Visible = 'off';
    add_label(-0.55,strcat(AB{s},'3)'));
    
    % roc curve
    fpr = ROC(qID).FPR;
    tpr = ROC(qID).TPR;
    T = ROC(qID).T;
    AUC = AUC(qID);
    AUCp = [];
    
    ax = make_ax(5,yj);
    plot_roc(ax,fpr,tpr,T,AUC,AUCp);
    
end


% SAVE
save_fig(sprintf('%s/fig3',save_dir));
    


