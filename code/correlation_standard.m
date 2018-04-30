function R = correlation_standard(sH, sV, corr_str)
% Simple correlation analysis for host samples sH and virus samples sV.

[~, N, NQ] = size(sH);

% set negative values -> 0
sH(sH<0) = 0;
sV(sV<0) = 0;

R = zeros(N,N,NQ);
for q = 1:NQ
    sHq = sH(:,:,q);
    sVq = sV(:,:,q);
    R(:,:,q) = corr(log10(sHq),log10(sVq),'type',corr_str);
end

end
    