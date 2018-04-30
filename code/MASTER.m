%% MASTER.m
% MASTER is used for generating synthetic networks and time-series data, 
% implementing correlation-based inference (standard & time-delayed), and 
% writing/reading data files for use with eLSA and SparCC scripts (which 
% must be run externally via python).
% Manuscript figures are generated via scripts in the 'figures' directory.


%% Generate networks, parameter sets, & time-series
% Once these are generated, they should remain fixed for the entire
% analysis (i.e. only run this cell once to generate the synthetic data)

clear;
analysis_setup;
for s = 1:length(S)
    for n = 1:length(N)
  
        % networks & parameters
        [M, Q, F] = generate_networks(N(n),S{s},NQ);
        [pars, Mtilde] = generate_parameters(M);
        save(sprintf('data/networks/S%d_N%d',s,n),'pars','Mtilde','Q','F');
        
        % time-series for all delta values specified in analysis_setup.m
        for d = 1:length(delta)
            dir_timeseries = sprintf('timeseries/delta%d',deltaID);
            [t, H, V] = generate_timeseries(pars, delta, sim_dt, sim_N);
            save(sprintf('data/%s/S%d_N%d',dir_timeseries,s,n),'t','H','V');
        end
 
    end
end


%% Sample the time-series, implement simple correlation analysis (standard & time-delayed)
% and write data to .txt files for use with elsa and sparcc

clear;
analysis_setup;
save(sprintf('data/%s/analysis_setup',dir_results));
if write_files==1
    save('elsa/analysis_setup');
    save('sparcc/analysis_setup');
end
%{
for s = 1:length(S)
    for n = 1:length(N)

        % load the network & the timeseries
        load(sprintf('data/networks/S%d_N%d',s,n));
        load(sprintf('data/%s/S%d_N%d',dir_timeseries,s,n));

        % sample timeseries
        sID = (1:sample_N)*ceil(sample_dt(sample_dtID)/sim_dt);
        st = t(sID);
        sH = H(sID,:,:);
        sV = V(sID,:,:);
        save(sprintf('data/%s/samples/S%d_N%d',dir_results,s,n),'st','sH','sV');

        % write files for elsa and sparcc
        if write_files==1
            write_elsa(sH,sV,s);
            write_sparcc(sH,sV,s);
            fprintf('elsa and sparcc files written (%s N=%d)\n',S{s},N(n));
        end

        % standard correlation
        for c = CID
            R = correlation_standard(sH, sV, C{c});
            [AUC, ROC] = score_networks(Mtilde, R);
            save(sprintf('data/%s/%s_S%d_N%d',dir_results,C{c},s,n),'R','AUC','ROC');
        end

        % sample for time-delayed correlation (requires additional timepoints)
        sID = (1:sample_N+max_delay)*ceil(sample_dt(sample_dtID)/sim_dt);
        st = t(sID);
        sH = H(sID,:,:);
        sV = V(sID,:,:);
        save(sprintf('data/%s/samples/S%d_N%d_delayed',dir_results,s,n),'st','sH','sV');

        % time-delayed correlation
        for c = CID
            [R, delay] = correlation_delayed(sH, sV, st, sample_N, max_delay, C{c});
            [AUC, ROC] = score_networks(Mtilde, R);
            save(sprintf('data/%s/%sdelayed_S%d_N%d',dir_results,C{c},s,n),'R','AUC','ROC','delay');
        end

    end
end
%}

%% Read & score eLSA and SparCC results
% After running elsa and sparcc analysis (must be done externally in
% python), imports results into matlab and scores predicted networks

clear;
load('elsa/analysis_setup');
for s = 1:length(S)
    for n = 1:length(N)
        
        load(sprintf('data/networks/S%d_N%d',s,n));
        
        % elsa
        R = read_elsa(s,n);
        [AUC, ROC] = score_networks(Mtilde, R);
        save(sprintf('data/%s/elsa_S%d_N%d',dir_results,s,n),'R','AUC','ROC');
        
        % sparcc
        R = read_sparcc(s,n);
        [AUC, ROC] = score_networks(Mtilde, R);
        save(sprintf('data/%s/sparcc_S%d_N%d',dir_results,s,n),'R','AUC','ROC');
        
    end
end



