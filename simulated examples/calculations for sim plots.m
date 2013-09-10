%% Sim data
dNsimInLoSB.suns = I_suns/100
dNsimInLoSB.suns = I_suns/300
[t_3a, x_3a, dN_3a, tau_3a, dNx_3a] =  sim_dN_G(1000e-15, dNsimInLoS, max(dNsimIn.t_m))
[t_2a, x_2a, dN_2a, tau_2a, dNx_2a] =  sim_dN_G(100e-15, dNsimInLoS, max(dNsimIn.t_m))
[t_1a, x_1a, dN_1a, tau_1a, dNx_1a] =  sim_dN_G(10e-15, dNsimInLoS, max(dNsimIn.t_m))
[t_1b, x_1b, dN_1b, tau_1b, dNx_1b] =  sim_dN_G(10e-15, dNsimInLoSb, max(dNsimIn.t_m))
[t_1b, x_1b, dN_1b, tau_1b, dNx_1b] =  sim_dN_G(10e-15, dNsimInLoSB, max(dNsimIn.t_m))
[t_1a, x_1a, dN_1a, tau_1a, dNx_1a] =  sim_dN_G(10e-15, dNsimInLoS, max(dNsimIn.t_m))
[t_2a, x_2a, dN_2a, tau_2a, dNx_2a] =  sim_dN_G(100e-15, dNsimInLoS, max(dNsimIn.t_m))
[t_3a, x_3a, dN_3a, tau_3a, dNx_3a] =  sim_dN_G(1000e-15, dNsimInLoS, max(dNsimIn.t_m))
[t_1a, x_1a, dN_1a, tau_1a, dNx_1a] =  sim_dN_G(10e-15, dNsimInLoS, max(dNsimIn.t_m))
[t_1b, x_1b, dN_1b, tau_1b, dNx_1b] =  sim_dN_G(10e-15, dNsimInLoSB, max(dNsimIn.t_m))

dNsimInLoSB.suns = I_suns/100
[t_1b, x_1b, dN_1b, tau_1b, dNx_1b] =  sim_dN_G(10e-15, dNsimInLoSB, max(dNsimIn.t_m))
dNsimInLoSB.suns = I_suns/50
[t_1b, x_1b, dN_1b, tau_1b, dNx_1b] =  sim_dN_G(10e-15, dNsimInLoSB, max(dNsimIn.t_m))
dNsimIn.tauB = 5e-4
[t_4, x_4, dN_4, tau_4, dNx_4] =  sim_dN_G(1000e-15, dNsimIn, max(dNsimIn.t_m))
[t_5, x_5, dN_5, tau_5, dNx_5] =  sim_dN_G(1000e-15, dNsimIn, max(dNsimIn.t_m))
dNsimIn.tauB = 5e-5
[t_5, x_5, dN_5, tau_5, dNx_5] =  sim_dN_G(1000e-15, dNsimIn, max(dNsimIn.t_m))
dNsimInLoS.tauB = 5e-4
[t_4a, x_4a, dN_4a, tau_4a, dNx_4a] =  sim_dN_G(1000e-15, dNsimIn, max(dNsimIn.t_m))
[t_4a, x_4a, dN_4a, tau_4a, dNx_4a] =  sim_dN_G(1000e-15, dNsimInLoS, max(dNsimIn.t_m))
dNsimInLoS.tauB = 5e-5

%% itau calc

itau_5a = MCM_calc.invTau (dN_5a, tau_5a, dNsimIn.N_A, dNsimIn.N_D, 'Richter')
itau_4a = MCM_calc.invTau (dN_4a, tau_4a, dNsimIn.N_A, dNsimIn.N_D, 'Richter')
itau_3a = MCM_calc.invTau (dN_3a, tau_3a, dNsimIn.N_A, dNsimIn.N_D, 'Richter')
itau_2a = MCM_calc.invTau (dN_2a, tau_2a, dNsimIn.N_A, dNsimIn.N_D, 'Richter')
itau_1a = MCM_calc.invTau (dN_1a, tau_1a, dNsimIn.N_A, dNsimIn.N_D, 'Richter')
itau_1b = MCM_calc.invTau (dN_1b, tau_1b, dNsimIn.N_A, dNsimIn.N_D, 'Richter')
itau_5 = MCM_calc.invTau (dN_5, tau_5, dNsimIn.N_A, dNsimIn.N_D, 'Richter')
itau_4 = MCM_calc.invTau (dN_4, tau_4, dNsimIn.N_A, dNsimIn.N_D, 'Richter')
itau_3 = MCM_calc.invTau (dN_3, tau_3, dNsimIn.N_A, dNsimIn.N_D, 'Richter')
itau_2 = MCM_calc.invTau (dN_2, tau_2, dNsimIn.N_A, dNsimIn.N_D, 'Richter')
itau_1 = MCM_calc.invTau (dN_1, tau_1, dNsimIn.N_A, dNsimIn.N_D, 'Richter')

%% K&S calc
j0eKS_1 = MCM_calc.j0e_KS (dN_1, tau_1, 1, 5e15, 0.03, 'Richter')
j0eKS_2 = MCM_calc.j0e_KS (dN_2, tau_2, 1, 5e15, 0.03, 'Richter')
j0eKS_3 = MCM_calc.j0e_KS (dN_3, tau_3, 1, 5e15, 0.03, 'Richter')
j0eKS_1 = MCM_calc.j0e_KS (dN_1, tau_1, 1, 5e13, 0.03, 'Richter')
j0eKS_3 = MCM_calc.j0e_KS (dN_3, tau_3, 1, 5e13, 0.03, 'Richter')
j0eKS_2 = MCM_calc.j0e_KS (dN_2, tau_2, 1, 5e13, 0.03, 'Richter')
j0eKS_4 = MCM_calc.j0e_KS (dN_4, tau_4, 1, 5e13, 0.03, 'Richter')
j0eKS_5 = MCM_calc.j0e_KS (dN_5, tau_5, 1, 5e13, 0.03, 'Richter')
j0eKS_5a = MCM_calc.j0e_KS (dN_5a, tau_5a, 1, 5e13, 0.03, 'Richter')
j0eKS_4a = MCM_calc.j0e_KS (dN_4a, tau_4a, 1, 5e13, 0.03, 'Richter')
j0eKS_3a = MCM_calc.j0e_KS (dN_3a, tau_3a, 1, 5e13, 0.03, 'Richter')
j0eKS_2a = MCM_calc.j0e_KS (dN_2a, tau_2a, 1, 5e13, 0.03, 'Richter')
j0eKS_1a = MCM_calc.j0e_KS (dN_1a, tau_1a, 1, 5e13, 0.03, 'Richter')

%% Reichel calc
j0eR_2 = MCM_calc.j0e_Rei (dN_2, tau_2, dNsimIn.N_A, dNsimIn.N_D, 0.03, 'Richter')
j0eR_1 = MCM_calc.j0e_Rei (dN_1, tau_1, dNsimIn.N_A, dNsimIn.N_D, 0.03, 'Richter')
j0eR_3 = MCM_calc.j0e_Rei (dN_3, tau_3, dNsimIn.N_A, dNsimIn.N_D, 0.03, 'Richter')
j0eR_4 = MCM_calc.j0e_Rei (dN_4, tau_4, dNsimIn.N_A, dNsimIn.N_D, 0.03, 'Richter')
j0eR_5 = MCM_calc.j0e_Rei (dN_5, tau_5, dNsimIn.N_A, dNsimIn.N_D, 0.03, 'Richter')
j0eR_5a = MCM_calc.j0e_Rei (dN_5a, tau_5a, dNsimIn.N_A, dNsimIn.N_D, 0.03, 'Richter')
j0eR_4a = MCM_calc.j0e_Rei (dN_4a, tau_4a, dNsimIn.N_A, dNsimIn.N_D, 0.03, 'Richter')
j0eR_3a = MCM_calc.j0e_Rei (dN_3a, tau_3a, dNsimIn.N_A, dNsimIn.N_D, 0.03, 'Richter')
j0eR_2a = MCM_calc.j0e_Rei (dN_2a, tau_2a, dNsimIn.N_A, dNsimIn.N_D, 0.03, 'Richter')
j0eR_1a = MCM_calc.j0e_Rei (dN_1a, tau_1a, dNsimIn.N_A, dNsimIn.N_D, 0.03, 'Richter')
%% J0e1dsim

% CHECK INPUT DOPING AND TAUB
% simInJ.N_D = 5e13
[j0e1d_5, sim] = j0genSimFit(50e-15, t_5, dN_5, sunsOut, simInJ)
[j0e1d_4, sim] = j0genSimFit(50e-15, t_4, dN_4, sunsOut, simInJ)
[j0e1d_3, sim] = j0genSimFit(50e-15, t_3, dN_3, sunsOut, simInJ)
[j0e1d_2, sim] = j0genSimFit(50e-15, t_2, dN_2, sunsOut, simInJ)
[j0e1d_1, sim] = j0genSimFit(1e-15, t_1, dN_1, sunsOut, simInJ)

%% Median K&S
j0eKS_1m = median(j0eKS_1)
j0eKS_2m = median(j0eKS_2)
j0eKS_3m = median(j0eKS_3)
j0eKS_4m = median(j0eKS_4)
j0eKS_5m = median(j0eKS_5)