function [pars, Mtilde] = generate_parameters(M)
% Generates parameters for an existing network M using the 
% feasibility-based approach described in Jover 2016, RoySci.
% Parameter ranges drawn from Jover 2015, SciRep.
% Inputs:
%   M = virus-host interaction network (0s and 1s), may contain multiple
%   networks along 3rd dimension
% Outputs:
%   pars = struct containing all parameters & steady states for each
%   network
%   Mtilde = matrix containing weighted interaction networks (for
%   convenience)

% number of host/virus types (does not need to be square)
[NH, NV, NQ] = size(M);
Mtilde = zeros(size(M));

% parameter ranges
betamin=10;     betamax=100;    % burst size            (virus/microbe)
phimin=1e-7;    phimax=1e-6;    % adsorption rate       (mL/(virus*day))
amin=0;         amax=1;         % host competition      (dimensionless)
Hmin=1e3;       Hmax=1e4;       % host steady state     (microbe/mL)
H0min=1e3;      H0max=1e5;      % virus-free host steady state (microbe/mL)
Vmin=1e6;       Vmax=1e7;       % virus steady state    (virus/mL)
K = 1e5;                        % carry capacity        (microbe/mL)

for q = 1:NQ % if multiple networks are passed
    
    % uniformly distributed beta, phi, and steady states
    beta = betamin+(betamax-betamin)*rand(NH,NV);
    phi = phimin+(phimax-phimin)*rand(NH,NV);
    Hstar = Hmin+(Hmax-Hmin)*rand(NH,1);
    Vstar = Vmin+(Vmax-Vmin)*rand(NV,1);
    H0star = H0min+(H0max-H0min)*rand(NH,1);

    % host-host interaction network
    a = amax*eye(NH); % initialize with diagonal=amax and everything else=0
    for i = 1:NH
        r = randperm(NH); % random order for adjusting a_ii' values
        r = r(r~=i); % omit the diagonal term
        j = 1;
        while a(i,:)*H0star < K % condition for coexisistence
            a(i,r(j)) = amin+(amax-amin)*rand();
            j = j+1;
        end   
        % adjust the most recently changed a_ii' to satisfy coexisistence exactly
        j0 = 1:NH~=r(j-1);
        a(i,r(j-1)) = (K-a(i,j0)*H0star(j0))/H0star(r(j-1)); % a(i,:)*H0star=K
    end

    % solve for decay rates and growth rates
    m = (M(:,:,q).*phi.*beta)'*Hstar;
    r = (M(:,:,q).*phi)*Vstar./(1-a*Hstar/K);

    % record parameters
    pars(q).NH = NH;
    pars(q).NV = NV;
    pars(q).M = M(:,:,q);
    pars(q).beta = beta;
    pars(q).phi = phi;
    pars(q).a = a;
    pars(q).m = m;
    pars(q).r = r;
    pars(q).K = K;
    pars(q).Hstar = Hstar;
    pars(q).Vstar = Vstar;
    pars(q).H0star = H0star;
    pars(q).Mpb = M(:,:,q).*phi.*beta; % weighted interaction network

    % compute nestedness and modularity of the virus-host network
    bp = Bipartite(M(:,:,q));
    bp.community.Detect();
    bp.nestedness.Detect();
    pars(q).modularity = bp.community.Qb;
    pars(q).nestedness = bp.nestedness.N;
    
    Mtilde(:,:,q) = M(:,:,q).*phi.*beta;
    
end

end






