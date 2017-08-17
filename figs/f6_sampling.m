
clear
fig_setup


% PLOT SETUP
xi = [3*fL+dL, 3*fL+L+dL, 3*fL+L+dL];
yi = [dL+2*fL, L+4*fL+2*dL];
xpos = cumsum(xi);
ypos = cumsum(yi);

totwidth = xpos(end)+L+dL;
totheight = ypos(end)+L+1.5*fL+dL;

figure('Units','centimeters','Position',[10 10 totwidth totheight]);
make_ax = @(i,j) axes('Units','centimeters','Position',[xpos(i) ypos(j) L L]);
make_cbar = @(i,j) colorbar('Units','centimeters','Position',[xpos(i)+L+bL ypos(j) cL L],...
    'Location','manual','FontSize',fs,'LineWidth',lw);
add_label = @(str) text(-.4,1,str,'FontSize',Fs,'FontWeight','bold');

AB = {'A','B'};
corr_str = {'simple','community-wide\ntime-delays','pairwise\ntime-delays'};


for j = 1:length(dir_data)

    % grab all the pre-generated correlation results
    pat = strcat(delta_str,'_corr');
    fns = what(dir_data{j});
    corrID = strncmp(pat,fns.mat,length(pat));
    fns_corr = fns.mat(corrID);
    
    % i = sample freq ID
    % 1,2,3 = simple, comm, pair
    for i = 1:length(fns_corr)
        load(strcat(dir_data{j},fns_corr{i}));
        freq_hrs(i) = info.freq_hrs;
        
        J{1}(i) = corrs.comm.Jstat(1);
        [J{2}(i), ID] = max(corrs.comm.Jstat);
        J{3}(i) = corrs.pair.Jstat(1);
        
        p{1}(i) = corrs.comm.Jstat_pval(1);
        p{2}(i) = corrs.comm.Jstat_pval(ID);
        p{3}(i) = corrs.pair.Jstat_pval(1);
    end
    
    % sort by increasing sampling frequency
    [freq_hrs, sortID] = sort(freq_hrs);
    for i = 1:3
        J{i} = J{i}(sortID);
        p{i} = p{i}(sortID);
    end
    
    % for reporting only
    % j = 1,2 for nested,modular
    % i = 1,2,3 for simple,comm,pair
    results(1).network = 'nested';
    results(2).network = 'modular';
    results(j).method = {'simple','comm','pair'};
    for i = 1:3
        [results(j).J(i), ID] = max(J{i});
        results(j).p(i) = p{i}(ID);
        results(j).freq(i) = freq_hrs(ID);
    end
    
    % plot
    for i = 1:3
        ax = make_ax(i,3-j);
        ax.Visible = 'off';
        add_label(sprintf('%s%d)',AB{j},i));
    
        % plot J-score vs frequency
        make_ax(i,3-j);
        hold on;
        plot(freq_hrs,J{i},'o-','MarkerSize',ms*.7,'LineWidth',lw);
        stem(freq_hrs(6),J{i}(6),'*','MarkerSize',ms,'LineWidth',lw);
        plot([0 freq_hrs(end)],[1 1],'--','Color',[.5 .5 .5],'LineWidth',lw);
        hold off;
        ylim([0 1.3]);
        xlim([0 freq_hrs(end)]);
        set(gca,'XTick',linspace(0,freq_hrs(end),3));
        ylabel('J score');
        if i==2; xlabel('sample frequency (hours)','FontSize',fs); end
        set(gca,'LineWidth',lw,'FontSize',fs);
        box on;
        title(sprintf(corr_str{i}),'FontSize',fs,'FontWeight','normal')
    end   
    
end

% SAVE
save_fig(gcf,strcat(dir_figs,'f6_sampling'),res,prn);