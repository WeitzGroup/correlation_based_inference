function [Mmat, Q, F] = generate_networks(N, nested_or_modular, NQ)
% Generates square interaction networks of size N of varying nestedness/modularity.

% Inputs:
%   N = network size
%   nested_or_modular = the measure of interest (nestedness or modularity)
%   NQ = number of networks to return

% Outputs:
%   Mmat = 3D matrix (NxNx10) containing the networks
%       networks are ordered from most nested/modular to least
%       each network is sorted in its most nested/modular arrangement
%   Q = 1D vector (1x10) containing nestedness(NODF)/modularity(Qb) values
%   F = fill value (fraction of interacting pairs)

if ~exist('NQ','var') || isempty(NQ); NQ=10; end

% base network structures (perfectly nested/modular)
Mnest = MatrixFunctions.NESTED_MATRIX(N);
Nmods = factor(N);
if N < 25; Nmods = Nmods(1); else Nmods = Nmods(end); end
Mmod = MatrixFunctions.BLOCK_MATRIX(Nmods,N/Nmods);

% helper functions for sorting matrices in their most nested/modular arrangements
    function Msort = sort_nested(M)
        [~, sortX] = sort(sum(M,2),'descend');
        [~, sortY] = sort(sum(M,1),'descend');
        Msort = M(sortX,sortY);
    end
    function Msort = sort_modular(M)
        mod_tmp = BipartiteModularity.LEADING_EIGENVECTOR(M);
        sortX = mod_tmp.index_rows;
        sortY = mod_tmp.index_cols;
        Msort = M(sortX,sortY);
    end

% helper function to normalize modularity
    function Qmax = norm_Qb(M)
        bptmp = Bipartite(M);
        %bptmp.statistics.print_status = 0; % silence
        bptmp.statistics.TestCommunityStructure;
        rdeg = bptmp.row_degrees;
        cdeg = bptmp.col_degrees;
        rmod = bptmp.community.row_modules;
        cmod = bptmp.community.col_modules;
        tmpN = bptmp.n_edges;
        delta = repmat(rmod,1,length(rmod))==repmat(cmod',length(cmod),1);
        Qmax = 1 - sum(sum((rdeg*cdeg').*delta))/tmpN^2;
    end

% mode-specific setup
switch nested_or_modular
    case 'nested'
        M0 = Mnest;
        measure_Qval = @(M) Nestedness.NODF(M).N;
        norm_Qval = @(M) 1;
        sort_network = @(M) sort_nested(M);
    case 'modular'
        M0 = Mmod;
        measure_Qval = @(M) BipartiteModularity.LEADING_EIGENVECTOR(M).Qb;
        norm_Qval = @(M) norm_Qb(M);
        sort_network = @(M) sort_modular(M);
end

% calculate fill (F) and Qvalue of the base network
F = sum(M0(:))/N^2;
Q0 = measure_Qval(M0);

% run random-swap permutations on the base network
Mswap = zeros(N,N,N^2); % ensemble of swaps
Qswap = zeros(1,N^2);   % and their nestedness/modularity values

% number of swaps to perform on the base matrix
S = min(sum(M0(:)),N^2-sum(M0(:)));

% initialize base network
Mswap(:,:,1) = M0;
Qswap(1) = Q0;
[ox, oy] = find(M0==1); % IDs for 1s
[zx, zy] = find(M0==0); % IDs for 0s
k = 2;

% swap 0-1 pairs in random order (until there are at least N^2 candidates)
while k < N^2+1

    ro = randperm(length(ox)); % 1->0 swap order
    rz = randperm(length(zx)); % 0->1 swap order

    Mi = M0; % start from base network

    % perform swaps and record matrix/Qval after each swap
    for i = 1:S
        Mi(ox(ro(i)),oy(ro(i))) = 0;
        Mi(zx(rz(i)),zy(rz(i))) = 1;
        Mswap(:,:,k) = Mi;
        Qswap(k) = measure_Qval(Mi);
        k = k+1;
    end

end

% set target Q values
Qmax = max(Qswap);
Qmin = min(Qswap);
Qstep = (Qmax-Qmin)/(NQ-1);
Qtarget = Qmax:-Qstep:Qmin;

% initialize output data
Mmat = zeros(N,N,10);
Q = zeros(1,10);

% initialize with perfect network
Mmat(:,:,1) = M0;
Q(1) = Q0;

for i = 2:10

    % which networks have Q values that are closest to the targets?
    [~, sortID] = sort(abs(Qswap-Qtarget(i)));

    % grab one candidate
    k = 1;
    Mtmp = Mswap(:,:,sortID(k));
    Qtmp = Qswap(sortID(k));

    % check that (1) no zero nodes and (2) not a duplicate of previous network
    while ~all(sum(Mtmp,1)) || ~all(sum(Mtmp,2)) || all(all(Mtmp==Mmat(:,:,i-1))) || Qtmp==Q(i-1) 
        k = k+1;
        Mtmp = Mswap(:,:,sortID(k));
        Qtmp = Qswap(sortID(k));
    end

    % record the sorted network and its Q value
    Mmat(:,:,i) = sort_network(Mtmp);
    Q(i) = Qtmp;

end

% normalize modularity values
for i = 1:10
    Q(i) = Q(i) / norm_Qval(Mmat(:,:,i));
end
    


end
