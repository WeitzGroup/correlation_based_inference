%% generate NEW parameter set
% will overwrite existing parameter files
% if new parameter set is chosen, need to re-generate the timeseries too
dirs = {'data/parsnest','data/parsmod'};
network_mode = {'nest','mod'};
target_val = 0.8; % NODF for nest, Q for mod

for j = 1:length(dirs)
    network = generate_networks(network_mode{j},target_val);
    generate_pars(network.M{1}, dirs{j});
end



%% generate NEW timeseries
% will overwrite existing timeseries files
% in general, generating new timeseries will change the correlation
% networks and results (intial conditions are randomly chosen)
dirs = {'data/parsnest','data/parsmod'};
delta = .3;

for j = 1:length(dirs)
    dyn = generate_ts(delta, dirs{j});
end



%% generate ALL correlation data for the figures 
% (this can take a long time to run -- set Nnullperms to 0 for fast runs)
% compute correlation networks for multiple sample frequencies
% simple, community-wide time-delays, and pairwise time-delays
dirs = {'data/parsnest','data/parsmod'};
delta_str = '3';
sample_freq_hrs = [.25 .5 1 2 4 8 12 24 36 48];
Nnullperms = 0;

for j = 1:length(dirs)
    for i = 1:length(sample_freq_hrs);
        
        % filepaths
        fp_ts = sprintf('%s/delta%s_ts',dirs{j},delta_str);
        fp_sample = sprintf('%s/delta%s_sample%d',dirs{j},delta_str,i);
        
        % sampling
        freq_hrs = sample_freq_hrs(i);
        initial_hrs = 12;
        numsamples = 100;
        generate_sample(fp_ts,fp_sample,initial_hrs,freq_hrs,numsamples);

        % correlation networks and pvalues
        threshold_mode = 'minus2plus';
        corr_inference(fp_sample,Nnullperms,threshold_mode);
    end
end


