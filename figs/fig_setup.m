% Every figure script runs this script first. Sets the plot and font sizing
% and the load/save directories.

% plot sizing
L = 2; % plot size
lw = .75; % linewidth
fs = 6; % fontsize
Fs = 2*fs; % big fontsize for labels
dL = L/10; % plot spacing
fL = 1/3; % font margins
cL = L/11; % colorbar width
bL = L/20; % colorbar spacing
ms = 5; % markersize
aL = L/2; % arrow spacing

% data directories and filepaths
dir_data = {'data/parsnest/', 'data/parsmod/'};
delta_str = 'delta3';
freqID_str = '6'; % sampling frequency
fp_pars = strcat(dir_data,'pars');
fp_ts = strcat(dir_data,delta_str,'_ts');
fp_sample = strcat(dir_data,delta_str,'_sample',freqID_str);
fp_corr = strcat(dir_data,delta_str,'_corr',freqID_str);

% save directory
dir_figs = 'figs/';

% save resolution/file type
res = '-r600';
prn = '-dpdf'; % save as a pdf


