% This script is run before all analyses -- it sets the network sizes, sampling period, number of timepoints to sample, etc.


% results directory
dir_results_choices = {'results_main','results_supp_metrics',...
    'results_supp_delta/delta1','results_supp_delta/delta3',...
    'results_supp_samplefreq/samplefreq1','results_supp_samplefreq/samplefreq3'};
dir_results = 'results_main';

% simulation parameters (values may be modified)
N = [10 25 50];              % network sizes (N=NH=NV)
NQ = 10;                     % number of networks in each network-size/network-structure group (total # of networks = NQ*3*2)
sim_dt = 15/60/24;           % timestep (days) for simulation, e.g. 15/60/24=15 min
delta = [0.1 0.3 0.5];       % initial condition perturbations

% sampling parameters (values may be modified)
sample_dt = [0.5 2 4]/24;    % sampling frequencies (days), e.g. 2/24=every 2 hrs
sample_N = 100;              % number of timepoints to sample
max_delay = sample_N/2;      % maximum allowed time delay (# sample points) for time-delayed correlation networks



% default analysis setup (modification not recommended)
CID = 1;                     % which correlation metric(s) to use (1=pearson, 2=spearman, 3=kendall)
deltaID = 2;                 % which timeseries to sample from the possible deltas (delta(2)=0.3)
sample_dtID = 2;             % which sampling frequency to implement (sample_dt(2)=2hrs)
write_files = 1;             % write files for elsa and sparcc? (1=yes, 0=no)

% -- DO NOT MODIFY BELOW --

% if running scripts for supplemental figures, default parameters need to be tweaked
tmpdir = split(dir_results,'/');
switch tmpdir{1}
    case 'results_supp_metrics'
        CID = [1 2 3];
        write_files = 0;     
    case 'results_supp_delta'
        deltaID = str2double(tmpdir{2}(end));
    case 'results_supp_samplefreq'
        sample_dtID = str2double(tmpdir{2}(end));
end
clear tmpdir;

% number of timepoints to simulate
sim_N = ceil(max(sample_dt)/sim_dt*(sample_N+max_delay));
dir_timeseries = sprintf('timeseries/delta%d',deltaID);

% measures of network structure
S = {'nested','modular'};
Slabel = {'nestedness (NODF)','modularity (Q_b)'};

% correlation metrics
C = {'pearson','spearman','kendall'};
Clabel = {'Pearson','Spearman','Kendall'};

% additional correlation-based inference methods
M = {'elsa','sparcc'};
Mlabel = {'eLSA','SparCC'};
