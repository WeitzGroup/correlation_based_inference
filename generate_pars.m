function pars = generate_pars(M, dir_pars)
% Generates parameters for an existing network M (which should be boolean) 
% using the feasibility-based approach described in Jover 2016, RoySci.
% Parameter ranges drawn from Jover 2015, SciRep.
% If dir_pars is passed, saves a .mat file with the pars struct in that
% directory.

% checks on the interaction matrix
check.singular = (1/cond(M) <= eps); % matrix is invertible
check.extraneous = (~all(sum(M,1)) || ~all(sum(M,2))); % no all-zero rows or cols
check.nonbinary = ~all(all(M==0 + M==1)); % entries are only 0s and 1s
if check.singular || check.extraneous || check.nonbinary
    fprintf('warning: M poorly defined\n');
    check
end

% number of host/virus types
[nH, nV] = size(M);
pars.nH = nH;
pars.nV = nV;
pars.M = M;

% biologically plausible parameter ranges
betamin=10;     betamax=100;    % burst size            (virus/microbe)
phimin=1e-8;    phimax=1e-7;    % adsorption rate       (mL/(virus*day))
amin=0;         amax=1;         % host competition      (dimensionless)
Hmin=1e3;       Hmax=1e4;       % host steady state     (microbe/mL)
Vmin=1e6;       Vmax=1e7;       % virus steady state    (virus/mL)
K = Hmax*10;                    % carry capacity        (microbe/mL)

% alternate host steady state (when no virus present)
H0min=Hmin;     H0max=K;




% generate parameters using feasibility-based approach

% uniformly distributed beta and phi
beta = betamin+(betamax-betamin)*rand(nH,nV);
phi = phimin+(phimax-phimin)*rand(nH,nV);

% steady states H* and V*
Hstar = Hmin+(Hmax-Hmin)*rand(nH,1);
Vstar = Vmin+(Vmax-Vmin)*rand(nV,1);

% host-host interaction network (diagonals=amax, rows*hstar=K)
if amin==amax
    a = amax*eye(nH);
else
    H0star = H0min+(H0max-H0min)*rand(nH,1);
    V0star = zeros(nV,1);  

    % initialize with a_ii = amax and a_ii' = amin
    a = eye(nH)*(amax-amin)+amin;
    for i = 1:nH % for each host i
        r = randperm(nH);
        r = r(r~=i); % omit the diagonal term a_ii
        j = 1;
        while a(i,:)*H0star < K
            a(i,r(j)) = rand();
            j = j+1;
        end   
        % adjust the most recently changed a_ii'
        tmpID = 1:nH~=r(j-1);
        a(i,r(j-1)) = (K-a(i,tmpID)*H0star(tmpID))/H0star(r(j-1));
    end
    % alternate steady states H0* and V0*

end

% solve for decay rates and growth rates
m = (M.*phi.*beta)'*Hstar;
r = (M.*phi)*Vstar ./ (1-a*Hstar/K);




% record all the parameters
pars.beta = beta;
pars.phi = phi;
pars.a = a;
pars.m = m;
pars.r = r;
pars.K = K;

% record steady states
pars.Hstar = Hstar;
pars.Vstar = Vstar;
if exist('H0star','var')
    pars.H0star = H0star;
    pars.V0star = V0star;
end

% compute weighted interaction networks
pars.Mp = pars.M.*pars.phi;
pars.Mpb = pars.Mp.*pars.beta;
pars.aK = pars.a/pars.K;
pars.ar = pars.a .* (pars.r*ones(1,pars.nH));
pars.arK = pars.a/pars.K .* (pars.r*ones(1,pars.nH));

% compute network statistics
bp = Bipartite(pars.M);
bp.community.Detect();
bp.nestedness.Detect();
pars.modularity = bp.community.Qb;
pars.nestedness = bp.nestedness.N;

% save
if exist('dir_pars','var') && ~isempty(dir_pars)
    save(sprintf('%s/pars',dir_pars),'pars','dir_pars');
end

end






