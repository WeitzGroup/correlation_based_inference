function [score] = score_reconstructions(M, R, threshold_mode)
% Scores a reconstruction (R) against the original network (M). If R is a 
% cell (containing multiple matrices), resulting scores are vectors.

if ~exist('threshold_mode','var') || isempty(threshold_mode)
    threshold_mode='minus2plus'; 
end

% wrap R in a cell if needed
if ~iscell(R)
    R = {R};
end

% count the positives and negatives
Mbool = logical(M);
posID = find(Mbool==1); npos = numel(posID);
negID = find(Mbool==0); nneg = numel(negID);

% which thresholding mode to use
if strcmp(threshold_mode,'minus2plus');
    make_thresholds = @(Ri) unique([-1; Ri(:); +1]);
    apply_threshold = @(Ri,Tj) Ri > Tj;
else
    make_thresholds = @(Ri) unique([0; abs(Ri(:)); +1]);
    apply_threshold = @(Ri,Tj) abs(Ri) > Tj;
end

% for each correlation matrix
for i = 1:numel(R)
    
    % generate a vector of thresholds
    T = make_thresholds(R{i});
    for j = 1:length(T)
        
        % apply the threshold rule
        Rbool = apply_threshold(R{i},T(j));
        
        % count the number of true & false positives
        tp(j) = numel(find(Rbool(posID)==1));
        fp(j) = numel(find(Rbool(negID)==1));
        
        % count the number of true & false negatives
        tn(j) = numel(find(Rbool(negID)==0));
        fn(j) = numel(find(Rbool(posID)==0));
        
    end

    % convert to rates
    tpr{i} = tp/npos;
    fpr{i} = fp/nneg;
    
    % compute AUC
    auc(i) = -trapz(fpr{i},tpr{i});
    
    % compute Youden's J statistic
    [Jstat(i), Jstat_ID(i)] = max(tpr{i} - fpr{i});
    Jstat_thresh(i) = T(Jstat_ID(i));
    
    % record threshold values
    thresholds{i} = T;
    
end

% bundle
score.auc = auc;
score.fpr = fpr;
score.tpr = tpr;
score.Jstat = Jstat;
score.Jstat_ID = Jstat_ID;
score.Jstat_thresh = Jstat_thresh;
score.thresholds = thresholds;
score.threshold_mode = threshold_mode;

end


