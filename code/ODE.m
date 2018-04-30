function dydt = ODE(t, y, pars)
% Differential equations for microbe-virus dynamics

H = y(1:pars.NH);
V = y(pars.NH+1:end);

dH = pars.r.*H.*(1-pars.a*H/pars.K) - H.*((pars.M.*pars.phi)*V);
dV = V.*(pars.Mpb'*H) - pars.m.*V;

dydt = [dH; dV];

end