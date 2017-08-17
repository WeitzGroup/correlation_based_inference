function [dyn, info] = generate_ts(delta, dir_pars)
% Generates a timeseries for the parameter set located in 'dir_pars'
% directory.
    % delta - distance (multiplicative) from equilibrium for initial conditions
% Intial conditions are perturbed by delta, but the direction (plus or
% minus) is random. In general, every timeseries will be different even for
% the same delta and parameter set.

% default timestep is 15 minutes / units are days
dt = 15/60/24;
tlim = 0:dt:1000;
reltol = 1e-8;

% filepaths
fp_pars = sprintf('%s/pars',dir_pars);
fp_ts = sprintf('%s/delta%d_ts',dir_pars,delta*10);
load(fp_pars);

% perturb steady states for initial conditions
pm = randi(2,pars.nH+pars.nV,1)*2-3;
y0 = [pars.Hstar; pars.Vstar].*(1+pm*delta);

% integrate
opts = odeset('RelTol',reltol);
[t, y] = ode45(@ODE_lysis, tlim, y0, opts, pars);

% save
dyn.t = t;
dyn.H = y(:,1:pars.nH);
dyn.V = y(:,pars.nH+1:end);
info.dt = dt;
info.delta = delta;
info.reltol = reltol;
info.fp_pars = fp_pars;
info.fp_ts = fp_ts;
save(fp_ts,'dyn','info');

end