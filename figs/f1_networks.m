
clear
fig_setup


% GENERATE NETWORKS
nest = [1 .8 .3];
titlesA = {'perfectly nested','high nestedness','low nestedness'};
networksA = generate_networks('nest',nest,10);

mod = [.5 .4 .2];
titlesB = {'perfectly modular','high modularity','low modularity'};
networksB = generate_networks('mod',mod,10);


% PLOT SETUP
totwidth = (L+dL+fL)*length(nest)+dL+2*fL;
totheight = (L+dL+2*fL)*2+dL;

figure('Units','centimeters','Position',[10 10 totwidth totheight]);
xpos = @(i) i*(L+dL+fL)+dL+2*fL;
ypos = @(j) j*(L+dL+2*fL)+dL+fL;
make_ax = @(i,j) axes('Units','centimeters','Position',[xpos(i) ypos(j) L L]);
add_label = @(str) text(-.3,1,str,'FontSize',Fs,'FontWeight','bold');

axA = make_ax(0,1);
axA.Visible = 'off';
add_label('A)');

axB = make_ax(0,0);
axB.Visible = 'off';
add_label('B)');


% PLOT NETWORKS
for i = 1:length(nest);
    ax = make_ax(i-1,1);
    plot_network(ax,networksA.M{i},[-1 +1],titlesA{i},redbluecmap());
end

for i = 1:length(mod);
    ax = make_ax(i-1,0);
    plot_network(ax,networksB.M{i},[-1 +1],titlesB{i},redbluecmap());
end


% SAVE FIGURE
save_fig(gcf,strcat(dir_figs,'f1_networks'),res,prn);
