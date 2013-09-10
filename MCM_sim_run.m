v_cal = [1.1859
-0.3250
2.8332
-0.5197
-0.7274
-0.8270
5.3697
7.7983
2.1091
-0.1963
0.4006
5.9035
2.7629
0.1407
1.1857

];

s_cal = [0.0608
0.0142
0.1138
0.0075
0.0022
0.0008
0.1848
0.2684
0.0837
0.0163
0.0360
0.2036
0.1055
0.0279
0.0600

]





%%
clear all
%%
% vpc = vpc + -0.856230288

% input the vdark manually....
 m = MCM_PC_meas(498, 10, 100, 0, 'p-type', [1], [1], [1], 0.61, 0,  1.68196);

 %%
 s = MCM_PC_settings (v_cal, s_cal, 0.1, 'GEN'); 

%  s.varB = 0;
%% 
 c = MCM_calc(m,s,4000);
 c = c.conductivity(s);
 c = c.generation(s);
 c = c.carriers (s);
 c = c.lifetime(s);
 c = c.inversetau(s);
 c = c.emittersat();
 c = c.statistics();
 
 %%
 m = MCM_PC_meas(433, 10, 100, 0, 'p-type', time, vpc, vref, 0.65, 0, vdark)
 
 %%
 
 tic
 c = MCM_calc(m,s,4000);
 
 toc
 
 %%
 tic
 c = c.MC_sim(s);
 toc
 
 
