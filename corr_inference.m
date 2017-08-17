function [corrs, info] = corr_inference(fp_sample, Nnullperms, threshold_mode)
% Correlation over offsets for potentially multiple timeseries.
% fp_sample is the filepath of the timeseries sample.

load(fp_sample);
load(info.fp_pars);

if ~exist('threshold_mode','var') || isempty(threshold_mode)
    threshold_mode = 'minus2plus';
end

% cut samples in half so that we can use extra points for offsets
end2 = length(info.sID);

% possibly multiple timeseries
for i = 1:length(sample)

    % for each offset, compute correlation (store in a 3D array)
    Rdata = zeros(pars.nH,pars.nV,end2);
    Pdata = zeros(pars.nH,pars.nV,end2);
    Vsample = log10(sample(i).V(1:end2,:));
    for j = 1:end2
        Hsample = log10(sample(i).H(j:end2+j-1,:));
        [Rdata(:,:,j), Pdata(:,:,j)] = corr(Hsample,Vsample,'type','Pearson');
    end   


    
    
    % COMMUNITY-WIDE DELAY
    corrs(i).comm.R = squeeze(num2cell(Rdata,[1,2]));
    corrs(i).comm.P = squeeze(num2cell(Pdata,[1,2]));
    corrs(i).comm.offsetID = 1:end2;
    corrs(i).comm.offsetT = sample(i).t(1:end2) - sample(i).t(1);
    corrs(i).comm.sampleT = sample(i).t(1:end2);

    % score and record
    score = score_reconstructions(pars.M,corrs(i).comm.R,threshold_mode);
    score_str = fieldnames(score);
    for k = 1:length(score_str)
        corrs(i).comm.(score_str{k}) = score.(score_str{k});
    end
    

    

    % PAIRWISE DELAYS
    corrs(i).pair.modes = {'pairwise maxima','positive closest match'};
    
    % pairwise maxima
    [corrs(i).pair.R{1}, rID] = max(Rdata,[],3);
    corrs(i).pair.P{1} = index3D(Pdata, rID);
    corrs(i).pair.offsetID{1} = rID;
    corrs(i).pair.offsetT{1} = sample(i).t(rID) - sample(i).t(1);
    corrs(i).pair.sampleT{1} = sample(i).t(rID);

    % "normalize" the weighted interaction matrix
    M = bsxfun(@rdivide, pars.Mpb, sqrt(sum(pars.Mpb.^2,2)));

    % closest match to the normalized interaction matrix
    diff = bsxfun(@minus, Rdata, M);
    [~, rID] = min(abs(diff),[],3);
    corrs(i).pair.R{2} = index3D(Rdata, rID);
    corrs(i).pair.P{2} = index3D(Pdata, rID);
    corrs(i).pair.offsetID{2} = rID;
    corrs(i).pair.offsetT{2} = sample(i).t(rID) - sample(i).t(1);
    corrs(i).pair.offsetT{2} = sample(i).t(rID);
    
    % score and record
    score = score_reconstructions(pars.M,corrs(i).pair.R,threshold_mode);
    score_str = fieldnames(score);
    for k = 1:length(score_str)
        corrs(i).pair.(score_str{k}) = score.(score_str{k});
    end
    
    
    
 
    % NULL SET (pvalues for Jstat)
    if ~exist('Nnullperms','var') || isempty(Nnullperms); Nnullperms = 100; end
    Jstat_comm = zeros(Nnullperms,end2); % column index = corrs.comm.offsetID
    Jstat_pair = zeros(Nnullperms,2); % column index = corrs.pair.modes
    for p = 1:Nnullperms
        Rnull = zeros(pars.nH,pars.nV,end2);
        Pnull = zeros(pars.nH,pars.nV,end2);
        for j = 1:end2
            vID = randperm(pars.nV);
            hID = randperm(pars.nH);
            Vsample = log10(sample(i).V(1:end2,vID));
            Hsample = log10(sample(i).H(j:end2+j-1,hID));
            [Rnull(:,:,j), Pnull(:,:,j)] = corr(Hsample,Vsample,'type','Pearson');
        end
        
        % community-wide delay (correlation + scoring)
        Rnull_comm = squeeze(num2cell(Rnull,[1,2]));
        score_comm = score_reconstructions(pars.M,Rnull_comm,threshold_mode);
        Jstat_comm(p,:) = score_comm.Jstat;
        
        % pairwise delays (correlation + scoring)
        [Rnull_pair{1}, ~] = max(Rnull,[],3);
        diff = bsxfun(@minus, Rnull, M);
        [~, rID] = min(abs(diff),[],3);
        Rnull_pair{2} = index3D(Rnull, rID);
        score_pair = score_reconstructions(pars.M,Rnull_pair,threshold_mode);
        Jstat_pair(p,:) = score_pair.Jstat;
    end
    
    % community-wide delay (pvalues)
    for j = 1:end2
        Jstat_dist = [corrs(i).comm.Jstat(j); Jstat_comm(:,j)];
        [~, sortID] = sort(Jstat_dist,'descend');
        focalID = find(sortID==1);
        Jstat_pval = focalID/(Nnullperms+1);
        
        % record
        corrs(i).comm.Jstat_dist{j} = Jstat_dist;
        corrs(i).comm.Jstat_pval(j) = Jstat_pval;
    end
    
    % pairwise delay (pvalues)
    for j = 1:length(corrs(i).pair.modes)
        Jstat_dist = [corrs(i).pair.Jstat(j); Jstat_pair(:,j)];
        [~, sortID] = sort(Jstat_dist,'descend');
        focalID = find(sortID==1);
        Jstat_pval = focalID/(Nnullperms+1);
        
        % record
        corrs(i).pair.Jstat_dist{j} = Jstat_dist;
        corrs(i).pair.Jstat_pval(j) = Jstat_pval;
    end
    

    
end

corrs.pair.Jstat_nperms = Nnullperms;

% save
save(strrep(fp_sample,'sample','corr'),'corrs','info');

end