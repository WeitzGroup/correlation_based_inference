% Figure 1 - Examples of varying network structure.

clear;
fig_setup;
load('data/results_main/analysis_setup');

% Load example networks (N=10)
qID = [1 5 10];

load('data/networks/S1_N1');
titlesA = {'maximally nested','high nestedness','low nestedness'};
for i = 1:3; titlesA{i} = sprintf('%s\n(NODF=%.2f)',titlesA{i},Q(qID(i))); end
networksA = logical(Mtilde(:,:,qID));

load('data/networks/S2_N1');
titlesB = {'maximally modular','high modularity','low modularity'};
for i = 1:3; titlesB{i} = sprintf('%s\n(Qb=%.2f)',titlesB{i},Q(qID(i))); end
networksB = logical(Mtilde(:,:,qID));

% PLOT SETUP
totwidth = (L+dL+fL)*length(qID)+dL+2*fL;
totheight = (L+dL+3*fL)*2+dL;

figure('Units','centimeters','Position',[10 10 totwidth totheight]);
xpos = @(i) i*(L+dL+fL)+dL+2*fL;
ypos = @(j) j*(L+dL+3*fL)+dL+fL;
make_ax = @(i,j) axes('Units','centimeters','Position',[xpos(i) ypos(j) L L]);
add_label = @(str) text(-.3,1.2,str,'FontSize',Fs,'FontWeight','bold');

axA = make_ax(0,1);
axA.Visible = 'off';
add_label('A)');

axB = make_ax(0,0);
axB.Visible = 'off';
add_label('B)');


% PLOT NETWORKS
for i = 1:length(qID)
    ax = make_ax(i-1,1);
    plot_network(networksA(:,:,i),[-1 +1],titlesA{i},redbluecmap());
end

for i = 1:length(qID)
    ax = make_ax(i-1,0);
    plot_network(networksB(:,:,i),[-1 +1],titlesB{i},redbluecmap());
end


% SAVE FIGURE
save_fig(sprintf('%s/fig1',save_dir));
