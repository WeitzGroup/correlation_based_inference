% Gathers results from existing data files. These are the numbers reported
% in the correlation manuscript.

clear
fig_setup

results.networks = dir_data;
results.delta = delta_str;
results.freqID = freqID_str;

% for both in silico communities
for j = 1:length(dir_data)
    
    load(strcat(dir_data{j},delta_str,'_corr',freqID_str));
    
    % simple correlation
    results.Jsimple(j) = corrs.comm.Jstat(1);
    results.Psimple(j) = corrs.comm.Jstat_pval(1);
    
    % community-wide time-delay -- the 'best' offset (hrs)
    [~,ID] = max(corrs.comm.Jstat);
    results.Jcomm(j) = corrs.comm.Jstat(ID);
    results.Pcomm(j) = corrs.comm.Jstat_pval(ID);
    results.Tcomm(j) = corrs.comm.offsetT(ID)*24;
    
    % pairwise time-delays -- such that correlation is maximized
    results.Jpair(j) = corrs.pair.Jstat(1);
    results.Ppair(j) = corrs.pair.Jstat_pval(1);
    
end

clc;
results

