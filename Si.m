classdef Si
% A collection of methods that model aspects of silicon for userd by 
% various simulators. 
    properties (Access = private)
        
    end
    
    properties (Constant)
        ni = 8.6e9
        q = 1.6042e-19
    end
    
    methods (Static)
        function [mu_s] = mobility_sum (dN, Na, Nd, temp, mode)
            %[mu_s] = mobility_sum (dN, Na, Nd, temp, mode)
            %mode {dorkel|sint|klaasen}
            %11/05/12 Andrew Thomson

            if strcmpi (mode, 'dorkel')
                [mu_N, mu_P] = Si.mu_dorkel (Na, Nd, dN, temp, 1);
                mu_s =  (mu_N + mu_P);
            elseif strcmpi (mode, 'sint')
                mu_s = Si.mu_sinton (Na, Nd, dN);
            elseif strcmpi (mode, 'klaassen')
                [mu_N, mu_P] = Si.klaassen (temp, Na, Nd, dN);
                 mu_s =  (mu_N + mu_P);
            else
                error ('What mobility model to you want to used, choose sint, dorkel or klaasen for .mu_mod');
            end
        end
        function [mu_N, mu_P] = mu_dorkel (Na, Nd, dN, T, simp)
            %function [mu_N, mu_P] = mu_dorkel (Na, Nd, dN, T, simp)
            %Na, Nd, T are constants, dN can be a constant or a vector
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Dorkel mobility is calculated corresponing to proceedure outlined in:
            %"Carrier mobilities in silicon semi-empirically related to temperature, 
            %doping and injection level", Solid-State Electronics, Vol 24, page 821
            %Andy Thomson
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%NOTES%%%
            %Include calcuations for the full method and the sinton spreadsheet. 
            %Assumes complete ionisation
            %Reformat ccs so they are the same and easy to understand for both n and p




            %TO DO
            %Add warnings regarding physics of the inputs.

            %working the program to varied length inputs
            %Variables for silicon
            mu_L0_N = 1430;       % (cm^2.v^-1.S-1) lattice scattering constant for silicon
            mu_L0_P = 495;
            alpha_L0 = 2.2;     % (1) lattice scattering alpha parameter for silicon 
            A_I_N = 4.61e17;      % (cm^-1.V^-1.S^-1.K^-(3/2)) impurity mobility parameter
            A_I_P = 1.00e17;
            B_I_N = 1.52e15;      % (cm^-3.K^-2) impurity mobility parameter
            B_I_P = 6.25e14;


            %
            if simp    
                mu_L_N = mu_L0_N*(T/300)^(-alpha_L0);
                mu_I_N = ((A_I_N*T^(3/2))/(Na + Nd))/(log(1 + (B_I_N*T^2)/(Na + Nd))-(B_I_N*T^2)/((Na + Nd)+B_I_N*T^2));
            %     here = ((Na + Nd)+dN).*dN
            %     here2 = log(1+8.28e8.*T^2.*((((Na + Nd)+dN).*dN).^(-1/3)))
            %     here3 = 2e17*T^(3/2)./(sqrt(((Na + Nd)+dN).*dN))
                mu_ccs = 2e17.*T^(3/2)./(sqrt(((Na + Nd)+dN).*dN).*(log(1+8.28e8.*T^2.*((((Na + Nd)+dN).*dN).^(-1/3))))); % there is an error here
                X_N = sqrt((6*mu_L_N*(mu_I_N + mu_ccs))./(mu_I_N*mu_ccs));
                mu_N = mu_L_N*((1.025./(1+(X_N/1.68).^1.43))-.025);    

                mu_L_P = mu_L0_P*(T/300)^(-alpha_L0);
                mu_I_P = ((A_I_P*T^(3/2))/(Na + Nd))/(log(1 + (B_I_P*T^2)/(Na + Nd))-(B_I_P*T^2)/((Na + Nd)+B_I_P*T^2));
                %mu_ccs_P = (2e17*T^(3/2)./(sqrt(((Na + Nd)+dN).*dN)))./(log(1+8.28e8*T^2*(((Na + Nd)+dN).*dN).^(-1/3)));
                X_P = sqrt((6*mu_L_P*(mu_I_P + mu_ccs))./(mu_I_P*mu_ccs));
                mu_P = mu_L_P*((1.025./(1+(X_P/1.68).^1.43))-.025)    ;
            else
                %yet to make exact calculation by dorkel
            end 
        end
        function [MU_E,MU_H]=klaassen(T,N_A,N_D,delta_n)
            %[MU_E,MU_H]=klaassen(T,N_A,N_D,delta_n)
            % F. Rougieux, A. Cuevas, D. MacDonald
            % ANU 2009

            % Normalized Temperature
            Tn=T./300;

            % Carrier concentration
            [n,p]=dopant_injection_carrier(T,N_A,N_D);
            n=n+delta_n;
            p=p+delta_n;
            c=p+n;

            % Clustering efect at high doping
            C_D=0.21;
            C_A=0.5;
            N_REF_D=4.00E+20;
            N_REF_A=7.20E+20;
            Z_D=1+1./(C_D+(N_REF_D./N_D).^2);
            Z_A=1+1./(C_A+(N_REF_A./N_A).^2);

            N_D=N_D.*Z_D;
            N_A=N_A.*Z_A;

            % Screening Parameters
            MH_ME=1.258;
            ME_M0=1;
            N_N_SC=N_A+N_D+p;
            N_P_SC=N_A+N_D+n;
            FCW=2.459;
            FBH=3.828;
            PCW_N=3.97E13.*(1./(Z_D.^3.*N_N_SC).*((Tn).^(3))).^(2/3);
            PCW_P=3.97E13.*(1./(Z_A.^3.*N_P_SC).*((Tn).^(3))).^(2/3);
            PBH_N=1.36E20./c.*ME_M0.*(Tn).^2;
            PBH_P=1.36E20./c.*MH_ME.*(Tn).^2;

            P_N=1./(FCW./PCW_N+FBH./PBH_N);
            P_P=1./(FCW./PCW_P+FBH./PBH_P);

            % Acceptor scattering
            S1=0.89233;
            S2=0.41372;
            S3=0.19778;
            S4=0.28227;
            S5=0.005978;
            S6=1.80618;
            S7=0.72169;

            G_P_N=1-S1./((S2+(1./ME_M0.*Tn).^S4.*P_N).^S3)+S5./(((ME_M0.*1./Tn).^S7.*P_N).^S6);
            G_P_P=1-S1./((S2+(1./(ME_M0.*MH_ME).*Tn).^S4.*P_N).^S3)+S5./(((ME_M0.*MH_ME.*1./Tn).^S7.*P_N).^S6);

            % Donor Scattering
            R1=0.7643;
            R2=2.2999;
            R3=6.5502;
            R4=2.367;
            R5=-0.01552;
            R6=0.6478;

            F_P_N=(R1.*P_N.^R6+R2+R3./MH_ME)./(P_N.^R6+R4+R5./MH_ME);
            F_P_P=(R1.*P_P.^R6+R2+R3.*MH_ME)./(P_P.^R6+R4+R5.*MH_ME);

            % Effective scattering
            N_N_SC_EFF=N_D+G_P_N.*N_A+p./F_P_N;
            N_P_SC_EFF=N_A+G_P_P.*N_D+n./F_P_P;

            % Model Parameters
            MU_MAX_N=1414;
            MU_MAX_P=470.5;
            MU_MIN_N=68.5;
            MU_MIN_P=44.9;
            N_REF_1_N=9.20E+16;
            N_REF_1_P=2.23E+17;
            ALPHA_1_N=0.711;
            ALPHA_1_P=0.719;
            THETA_N=2.285;
            THETA_P=2.247;

            % Carrier Carrier Scattering
            MU_E_C=MU_MAX_N.*MU_MIN_N./(MU_MAX_N-MU_MIN_N).*(1./Tn).^(0.5);
            MU_H_C=MU_MAX_P.*MU_MIN_P./(MU_MAX_P-MU_MIN_P).*(1./Tn).^(0.5);

            % Impurity Scattering
            MU_E_N=MU_MAX_N.^2/(MU_MAX_N-MU_MIN_N).*(Tn).^(3.*ALPHA_1_N-1.5);
            MU_H_P=MU_MAX_P.^2/(MU_MAX_P-MU_MIN_P).*(Tn).^(3.*ALPHA_1_P-1.5);

            % Impurity Carrier Scattering
            MU_E_C_N=MU_E_N.*N_N_SC./N_N_SC_EFF.*(N_REF_1_N./N_N_SC).^ALPHA_1_N+MU_E_C.*((n+p)./N_N_SC_EFF);
            MU_H_C_P=MU_H_P.*N_P_SC./N_P_SC_EFF.*(N_REF_1_P./N_P_SC).^ALPHA_1_P+MU_H_C.*((n+p)./N_P_SC_EFF);

            % Lattice Scattering
            MU_E_L=MU_MAX_N.*(1./Tn).^THETA_N;
            MU_H_L=MU_MAX_P.*(1./Tn).^THETA_P;

            % ELECTRON MOBILITY
            MU_E=1./(1./MU_E_L+1./MU_E_C_N);

            % HOLE MOBILITY
            MU_H=1./(1./MU_H_L+1./MU_H_C_P);
        end
        function mu_s =  mu_sinton (Na, Nd, dN)
            %function mu_s =  mu_sinton (Na, Nd, dN)
            %Andrew Thomson v1 17/05/2012
            %Calculate mobility sum as in the sinton spreadsheet

            f = ((dN + (Na+Nd))./1.2e18).^0.8431;
            mu_s = 1800*((1 + f)./(1 + 8.36 .* f));
        end
        function tauInt = auger(dN, Na, Nd, mode)
%             tauInt = auger(dN, Na, Nd, mode)
%             mode {sint|kerr|richter}
            if strcmpi(mode, 'sint')
                tauInt = Si.aug_sint(dN); 
            elseif strcmpi(mode, 'kerr')
                tauInt = Si.aug_kerr(dN, Na, Nd);
            elseif strcmpi(mode, 'richter')
                tauInt = Si.aug_richter(dN, Na, Nd);
            else
                error('Requsted unknown intrisic recombination model. Please ensure that mode is, sint, kerr or richter, not "%s" as entered', mode)
            end
        end
        function tauInt = aug_sint(dN)
           %makes the same calcuation as the spreadsheet
            Ca = 1.66e-30;
            tauInt = 1./(dN.^2*Ca);
        end
        function tauInt = aug_kerr(dN, Na, Nd)
            [n0, p0] = Si.equlib_carriers (Na, Nd);
            p = p0 + dN;
            n = n0 + dN;
            %Equation 24 from Kerr2002 full intrinsic recombianation
            %Rint = Rauger + Rrad = np(1.8e-24*n0^(.65) + 6e-25*p0^(.65) + 3e-27* dN^(.8)+ 9.5e-15)
            Rint = n.*p.*(1.8e-24*n0^(.65) + 6e-25*p0^(.65) + 3e-27*dN.^(.8)+ 9.5e-15);  
            %here I am only considering transient method for the conversiont of
            %rate to lifetime, this needs modigyin for generalised
            tauInt = dN./Rint;
        end
        function tauInt = aug_richter(dN, Na, Nd)
             % From DOI:1098-0121/2012/86(16)/165202(14) A. Richter et al. Improved quantitative description of Auger recombination in crystalline silicon
             % Equation 20 is use given justificatiion in appendix
                 
            [n0, p0] = Si.equlib_carriers (Na, Nd);

%             [p0, n0, dN] = MCM_calc.pad_arrays (p0, n0, dN);
            
            p = p0 + dN;
            n = n0 + dN;
            
            N0eeh = 3.3e17; %/cm3
            N0ehh = 7.0e17; %/cm3
            geeh = 1 + 13*(1 -tanh((n0/N0eeh).^0.66));
            gehh = 1 + 7.5*(1 -tanh((n0/N0ehh).^0.63));
            Blow = 4.73e-15; %cm3/s
            Brel = 1;
            Rint = (n.*p).*(2.5e-31.*geeh.*n0 + 8.5e-32.*gehh.*p0 + 3.0e-29.*dN.^0.92 + Brel.*Blow);
            tauInt = dN./Rint;
        end
        function [n0, p0] = equlib_carriers (Na, Nd)
            if Nd > Na
                p0 = Nd;
                n0 = Si.ni^2/Nd;
            else
                n0 = Na;
                p0 = Si.ni^2./Na;
            end
        end
        function [dope] = res2dopSint (rho_cm, type)
            if strcmpi(type, 'n-type')
                dope = 10^(-0.000634661*log10(rho_cm)^6+0.000820326*log10(rho_cm)^5+0.01243*log10(rho_cm)^4-0.04571*log10(rho_cm)^3+0.07246*log10(rho_cm)^2-1.07969*log10(rho_cm)+15.69691);
            elseif strcmpi(type, 'p-type')
                dope = 10^(-0.0006543*log10(rho_cm)^6+0.000754055*log10(rho_cm)^5+0.0093332*log10(rho_cm)^4-0.03469*log10(rho_cm)^3+0.06473*log10(rho_cm)^2-1.08286*log10(rho_cm)+16.17944);
            else
                error('Incorrect silicon type entered "%s", should be {p-type|n-type}', type)
            end       
        end
    end
end

