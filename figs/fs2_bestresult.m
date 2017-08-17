

f0_results;
load(strcat(dir_data{2},delta_str,'_corr',freqID_str));
load(strcat(dir_data{2},'pars'));

tau = results.Tcomm(2);
tauID = find(corrs.comm.offsetT*24==tau);
fpr = corrs.comm.fpr{tauID};
tpr = corrs.comm.tpr{tauID};
T = corrs.comm.thresholds{tauID};
J = corrs.comm.Jstat(tauID);
cID = corrs.comm.Jstat_ID(tauID);
pval = corrs.comm.Jstat_pval(tauID);
[Jcounts, Jbins] = hist(corrs.comm.Jstat_dist{tauID});
Jcounts = Jcounts/sum(Jcounts);  


% PLOT SETUP
xi = [2*fL+dL, L+4*fL+dL+cL+bL, L+5*fL+dL+cL+bL, L+5*fL+dL];
yi = [fL+dL, .5*fL+L+dL];
xpos = cumsum(xi);
ypos = cumsum(yi);

totwidth = xpos(end)+L+dL;
totheight = ypos(end)+L+fL+dL;

figure('Units','centimeters','Position',[10 10 totwidth totheight]);
make_ax = @(i,j) axes('Units','centimeters','Position',[xpos(i) ypos(j) L L]);
make_cbar = @(i,j) colorbar('Units','centimeters','Position',[xpos(i)+L+bL ypos(j) cL L],...
    'Location','manual','FontSize',fs,'LineWidth',lw);
add_label = @(str,xpos) text(xpos,1,str,'FontSize',Fs,'FontWeight','bold');



ax = make_ax(1,2);
ax.Visible = 'off';
add_label('A)',-.3);

% original interaction network
ax = make_ax(1,2);
plot_network(ax,pars.Mpb,[],'interaction network','jet');
cbar = make_cbar(1,2);
cbar.Label.String = 'interaction strength';

% binarized interaction network
ax = make_ax(1,1);
plot_network(ax,pars.M,[],'',redbluecmap());



ax = make_ax(2,2);
ax.Visible = 'off';
add_label('B)',-.3);

% correlation network  
ax = make_ax(2,2);
%title_str = sprintf('\\tau = %d hours',tau);
title_str = 'correlation network';
plot_network(ax,corrs.comm.R{tauID},[-1 1],title_str,redbluecmap());
cbar = make_cbar(2,2);
cbar.Limits = [-1 1];
cbar.Ticks = [-1 0 1];
cbar.Label.String = 'correlation';

% binarized correlation network  
ax = make_ax(2,1);
plot_network(ax,corrs.comm.R{tauID}>T(cID),[-1 1],'',redbluecmap());



ax = make_ax(3,2);
ax.Visible = 'off';
add_label('C)',-.4);

% roc curve
ax = make_ax(3,2);
plot_roc(ax,fpr,tpr,T,J,cID,pval);



ax = make_ax(4,2);
ax.Visible = 'off';
add_label('D)',-.5);

% J distribution
ax = make_ax(4,2);
hold on;
plot(Jbins, Jcounts,'-','LineWidth',lw)
plot(J*ones(1,2),[0 1],'r--','LineWidth',lw)
hold off;
xlim([0 1]);
ylim([0 .4]);
xlabel('J score','FontSize',fs)
ylabel('frequency','FontSize',fs)
title('distribution','FontWeight','normal','FontSize',fs);
text(.95,0.01,sprintf('p=%.1g',pval),...
    'FontSize',fs,'HorizontalAlignment','right','VerticalAlignment','bottom');
set(gca,'LineWidth',lw,'FontSize',fs);
box on;



% SAVE FIGURE
save_fig(gcf,strcat(dir_figs,'fs2_bestresult'),res,prn);

