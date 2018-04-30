function [t, H, V] = generate_timeseries(pars, delta, dt, NT)
% Generates a timeseries for the parameter set 'pars'
% Inputs:
%   pars    parameter struct (possibly with multiple parameter sets)
%   delta   perturbation from equilibrium for initial conditions
%   dt      timestep (days)
%   NT      number of timepoints to generate
% Intial conditions are perturbed by delta, but the direction (plus or
% minus) is random. In general, every timeseries will be different even for
% the same delta and parameter set.

tvec = (0:NT-1)*dt;
reltol = 1e-8;
NQ = length(pars); % possibly multiple parameter sets
NH = pars(1).NH;
NV = pars(1).NV;
H = zeros(NT,NH,NQ);
V = zeros(NT,NV,NQ);

for q = 1:length(pars) 

    % perturb steady states for initial conditions
    pm = randi(2,NH+NV,1)*2-3;
    y0 = [pars(q).Hstar; pars(q).Vstar].*(1+pm*delta);

    % integrate
    opts = odeset('RelTol',reltol);
    [t, y] = ode45(@ODE, tvec, y0, opts, pars(q));
    H(:,:,q) = y(:,1:NH);
    V(:,:,q) = y(:,NH+1:end);
    
end

end