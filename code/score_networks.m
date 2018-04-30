function [AUC, ROC] = score_networks(M, R)
% Scores reconstruction R against the original network M. Both M and R
% may be single networks or 3D matrices that hold multiple networks.

NQ = size(R,3);
AUC = zeros(NQ,1);

% if only a single M network is passed, score each R against that M
if size(M,3)==1; M = repmat(M,[1,1,NQ]); end
M0 = logical(M);

for q = 1:NQ
    
    % networks of interest
    Rq = R(:,:,q);
    M0q = M0(:,:,q);

    % thresholds
    T = [-1; sort(Rq(:)); +1];

    % TPR and FPR vectors
    TPR = zeros(length(T),1);
    FPR = zeros(length(T),1);

    % positives and negatives of the original network
    pID = find(M0q==1); 
    nID = find(M0q==0);
    Np = numel(pID); 
    Nn = numel(nID);
    
    for t = 1:length(T)
        R0q = Rq > T(t);
        
        % count true positives and false positives
        TPR(t) = sum(sum(R0q(pID)==1))/Np;
        FPR(t) = sum(sum(R0q(nID)==1))/Nn;
    end
    
    AUC(q) = -trapz(FPR,TPR);
    
    ROC(q).T = T;
    ROC(q).TPR = TPR;
    ROC(q).FPR = FPR;
end

end

