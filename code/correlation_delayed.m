function [R, D] = correlation_delayed(sH, sV, st, sample_N, max_delay, corr_str)

[~, N, NQ] = size(sH);

% set negative values -> 0
sH(sH<0) = 0;
sV(sV<0) = 0;

R = zeros(N,N,NQ);
D = zeros(N,N,NQ);
for q = 1:NQ
    
    % compute correlation networks across all possible time delays
    sHq = sH(1:sample_N,:,q);
    Rq = zeros(N,N,max_delay+1);
    for delayID = 1:(max_delay+1)
        sVq = sV((1:sample_N)+delayID-1,:,q);
        Rq(:,:,delayID) = corr(log10(sHq),log10(sVq),'type',corr_str);
    end
    
    % choose maximum correlations for each pair
    [~,maxID3] = max(abs(Rq),[],3); % delayID -> 3rd dimension
    tmpID = repmat((1:N)',1,N);
    maxIDlin = sub2ind(size(Rq),tmpID,tmpID',maxID3); % need linear indexing to grab correct R values
    R(:,:,q) = Rq(maxIDlin);
    D(:,:,q) = st(maxID3); % delay in units of time (instead of indices)

end

end
    