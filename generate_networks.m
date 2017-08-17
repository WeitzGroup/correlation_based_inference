function [networks] = generate_networks(mode, targets, dim, Nreps, dir_networks)
% Generates square interaction networks of size 'dim'.
%   mode (optional) - either 'nest' or 'mod', default is 'nest'
% 	targets - Nestedness (NODF) or modularity (Qb) targets, can be a 
%       vector. The script will generate an ensemble of networks and choose 
%       the ones closest to the targets.
%   dim (optional) - a single number with dimensions of the square network,
%       default is 10
%   Nreps (optional) - Number of unique networks to return for a single
%       value of measure_goal.
%   dir_networks (optional) - Save directory. If no value is passed, does
%       not save a .mat file.
%
% Returns a struct 'networks' with these fields:
%   M - A cell containing the networks. Each network is sorted in its most
%       nested or most modular configuration, depending on measure_str.
%   nestedness - A vector with measured nestedness (NODF) values.
%   nestedness_zscore - A vector with nestedness (NODF) z-scores.
%   modularity - A vector with measured modularity (Qb) values.
%   modularity_zscore - A vector with modularity (Qb) z-scores.



% default mode is nested
if ~exist('mode','var') || isempty(mode); mode='nest'; end

% default network size
if ~exist('dim','var') || isempty(dim); dim=10; end

% number of interactions (default -> 50%)
if ~exist('Nfill','var') || isempty(Nfill); Nfill=round(dim^2/2); end

% how many matrices for each value?
if ~exist('Nreps','var') || isempty(Nreps); Nreps=1; end



% base network structure (perfectly nested)
Mnest = MatrixFunctions.NESTED_MATRIX(dim);

% base network structure (perfectly modular)
Nmods = factor(dim);
Nmods = Nmods(1);
Mmod = MatrixFunctions.BLOCK_MATRIX(Nmods,dim/Nmods);

% base network structure (random) for the mod case
Mrand = MatrixFunctions.CHECKERBOARD(dim,dim);

% use a different random network for the nest case to preserve number of interactions
Mrand2 = Mrand;
for i = 1:floor(dim/2)
    Mrand2(2*i,2*i)=0;
end


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
    function Qmax = norm_Qb(bp)
        rdeg = bp.row_degrees;
        cdeg = bp.col_degrees;
        rmod = bp.community.row_modules;
        cmod = bp.community.col_modules;
        tmpN = bp.n_edges;
        delta = repmat(rmod,1,length(rmod))==repmat(cmod',length(cmod),1);
        Qmax = 1 - sum(sum((rdeg*cdeg').*delta))/tmpN^2;
    end


% mode-specific setup
if strcmp(mode,'nest')
    Mbase = {Mnest, Mrand2};
    measure_val = @(M) Nestedness.NODF(M).N;
    sort_network = @(M) sort_nested(M);
    
elseif strcmp(mode,'mod')
    Mbase = {Mmod, Mrand};
    measure_val = @(M) BipartiteModularity.LEADING_EIGENVECTOR(M).Qb;
    sort_network = @(M) sort_modular(M);
    
end



% run a few random-swap permutations on each base network
M_ensemble = Mbase;
V_ensemble = [measure_val(Mbase{1}) measure_val(Mbase{2})];
for i = 1:length(Mbase)
    
    [ox, oy] = find(Mbase{i}==1); % IDs for ones
	[zx, zy] = find(Mbase{i}==0); % IDs for zeros
    
    for k = 1:2*Nreps
        
    	Mi = Mbase{i};
        ro = randperm(length(ox)); % turn these ones into zeros
        rz = randperm(length(zx)); % turn these zeros into ones
    
        for p = 1:min(length(ro),length(rz))

            % swap a random 0-1 pair
            Mi(ox(ro(p)),oy(ro(p))) = 0;
            Mi(zx(rz(p)),zy(rz(p))) = 1;
            
            % make sure we haven't "broken" the network
            % (no all-zero rows or columns)
            if all(all(sum(Mi,1))) && all(all(sum(Mi,2)))

                % record the sorted network and its score
                M_ensemble{end+1} = sort_network(Mi);
                V_ensemble(end+1) = measure_val(Mi);
                
            end
        end
    end
end

% grab the best results
M = {};
for i = 1:length(targets)
    
    % which matrices are closest to the goals?
    [~, sortID] = sort(abs(V_ensemble-targets(i)));
    
    % grab replicates for each nestedness goal
    M_reps = {};
    unique_j = 0;
    for j = 1:Nreps
        unique = 0;
        while ~all(unique)
        
            % grab the next candidate matrix
            Mj = M_ensemble{sortID(j+unique_j)};

            % check if it's "unique"
            % some questions about this -- is the arrangement unique? if
            % not, we could be getting duplicates
            if i==1 && j==1
                unique = 1;
            else
                for k = 1:length(M) % check over other nest/mod values
                    if ~all(all(Mj==M{k}))
                        unique(k) = 1;
                    else
                        unique(k) = 0;
                    end
                end
                for k = 1:length(M_reps) % check over other replicates
                    if ~all(all(Mj==M_reps{k}))
                        unique(k+length(M)) = 1;
                    else
                        unique(k+length(M)) = 0;
                    end
                end
            end
            
            % record if unique; try next candidate if not
            if all(unique)
                M_reps{j} = Mj;
            else
                unique_j = unique_j+1;
            end

        end
    end

    % record replicates
    ID1 = (i-1)*Nreps+1;
    ID2 = i*Nreps;
    M(ID1:ID2) = M_reps;
    
end

networks.mode = mode;
networks.M = M;
networks.fill = Nfill;

% loop thru chosen networks and calculate stats
for i = 1:length(M)
    bp = Bipartite(M{i});
    bp.print_results = 0;
    bp.statistics.print_status = 0;
    bp.statistics.TestNestedness;
    bp.statistics.TestCommunityStructure;
    networks.nestedness(i) = bp.nestedness.N;
    networks.nestedness_zscore(i) = bp.statistics.N_values.zscore;
    networks.modularity(i) = bp.community.Qb;
    networks.modularity_max(i) = norm_Qb(bp);
    networks.modularity_norm(i) = networks.modularity(i)/networks.modularity_max(i);
    networks.modularity_zscore(i) = bp.statistics.Qb_values.zscore;
end



% save
if exist('dir_networks','var') && ~isempty(dir_networks)
    save(sprintf('%s/networks_%s',dir_networks,mode),'networks');
end

    
end

