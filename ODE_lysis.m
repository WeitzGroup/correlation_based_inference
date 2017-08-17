function dydt = ODE_lysis(t, y, pars)
% Nonlinear differential equations for the host-virus dynamical system. 
% The struct 'pars' should be created with the script 'generate_pars'.

H = y(1:pars.nH);
V = y(pars.nH+1:end);

dH = pars.r.*H.*(1-pars.aK*H) - H.*(pars.Mp*V);
dV = V.*(pars.Mpb'*H) - pars.m.*V;

dydt = [dH; dV];

end