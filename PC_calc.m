classdef PC_calc < Si
    %PC_CALC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static)
         function cond = conductivityQUAD(vpc, vdark, varargin)
    %              obj = conductivity(vpc, varargin)
    %              obj = conductivity(obj, [B varB] | [B] | [A B C])
    %              converts the measured voltage to conductivity
    %              the mean DELTA conductivity is
    %              V = [obj.vpc.^2 obj.vpc ones(size(obj.vpc))];
    %              cond = V*B
    %              varCond = sqrt(diag(V*PC_settings.varB*V'));
    %             V = obj.vpc;
            if nargin == 4
    %                 full normal case where there is a B and VarB
                b = varargin{1};
                varB = varargin {2};
            elseif nargin == 3
    %                 no error 
                b = varargin{1}
                varB = zeros(3);
            elseif nargin == 5
    %                 A, B, C are inputted
                b(1) = varargin{1};
                b(2) = varargin{2};
                b(3) = varargin{3};
                varB = zeros(3);
                b = b'
            end

    %             lookint at doing it without arrays of struct
    %             Cond = V.*V*b(1) + V*b(2) + ones(size(V))*b(3);
    %               concuctivity stderr
            cond = zeros (size(vpc))
            parfor i = 1:MCM_calc.cols(vpc)
                V = [vpc(:,i).^2 vpc(:,i) ones(size(vpc(:,i)))];
                V0 = [vdark(:,i).^2 vdark(:,i) ones(size(vdark(:,i)))];
                CondTemp = V*b ;
                delCond =  V*b - V0*b;
                varCond = sqrt(diag(V*varB*V'));
                MC_delta_Cond = delCond + randn(1).* varCond.*delCond./CondTemp;

    %                 MC_delta_Cond = delta_Cond + randn(1).* muCond.* delta_Cond ./Cond;
               cond(:,i) = MC_delta_Cond;
           end
        end
        function cond = conductivityOFF(vpc, vdark, A, B, Coff)
%     cond = conductivityOFF(vpc, A, B, coff)
%     calculates the conductivity for the newer version of the SSS
%     cond = (V-Coff)^2*A + (V-Coff)*B
            
            cond = (vpc-Coff).^2*A + (vpc-Coff)*B - (vdark-Coff).^2*A - (vdark-Coff)*B;
        end  
        function [suns, gen] = generation(vref, vref_to_suns, OC, width)
%             [suns, gen] = generation(vref, vref_to_suns, OC, width)
            %function j0_o = gen_cal(j0_i)
            %Andrew Thomson v2 17/05/12
            %Function calculates generation for generalised or qss tau calculations

            %calculate suns from reference cell
            suns = vref ./ vref_to_suns;
            %assuming an optical reference of 0.038 mA
            gen = suns*0.038*OC/Si.q/width;

        end
        function dN = carriers(cond, width, N_A, N_D, mu_mode)
%             dN = carriers(cond, width, N_A, N_D, mu_mode)
            mu_s = Si.mobility_sum(1, N_A, N_D, 298, mu_mode);
            mu_s = ones(length(cond),1)*mu_s; % expand mu_sum so that it is the same size as the conductivity vector
            %NOTE you should code in  a convergece test and perhaps reduce calc time. 
            %This is a newton method approximation.
%             [~, N_At, N_Dt] = MCM_calc.pad_arrays(cond, N_A, N_D);
            for i = 1:10
                dN = cond ./(width * Si.q .* mu_s);
                %a = j0.dN;    
                mu_s = Si.mobility_sum(dN, N_A, N_D, 298, mu_mode);
            end
        end
        
        function tau = lifetime(time, dN, Gen, mode)
%             tau = lifetime(time, dN, Gen, mode)
%             filtersettings
        fr = 5;
           if strcmpi(mode, 'PCD')   
%                the following has inbuilt filtering that works well for in
%                previous version
%                Here the data is re-interoplated logarithmcally, this
%                helps with preventing amplification of noise.
                slope = zeros(size(dN));
                
                %interpolate time
                %there is faffing around to sort out end points with
                %regards to the filtering.
                timet = exp((log(min(time)):(log(max(time))-log(min(time)))/(length(time)+10):log(max(time))));
                dNt = interp1(time,dN, timet, 'linear');
%                 time = timet(6:end-6)';
%                 dN = dNt(6:end-6)';   

                slope = PC_calc.smoothDiff(timet(6:end-6)', dNt(6:end-6)', fr);
                taut = -dNt(6:end-6)'./(slope);
                tau = interp1(timet(6:end-6)',taut, time, 'linear');
            elseif strcmpi(mode,'QSS')
                error('Do not to qss mode any more use GEN')
            elseif strcmpi(mode, 'GEN')
            
                timet = exp((log(min(time)):(log(max(time))-log(min(time)))/(length(time)+10):log(max(time))));
                dNt = interp1(time,dN, timet, 'linear');
                Gt = interp1(time,Gen, timet, 'linear');
% 
%                 % drop end in order to avoid nan
                timet = timet(6:end-6)';
                dNt = dNt(6:end-6)';
                Gt = Gt(6:end-6)';
                
                
                slope = gradient (dNt, timet);
%                 NOT AN INBUILT MATLAB FUNCTION
                slope = fastsmooth(slope,5,3,1);
% 
% 
%                 % slope = slope %(6:end);
                taut = dNt./(Gt - slope);
                tau = interp1(timet,taut, time, 'linear');
                
%                 
           end
            
        end
        function itau = inversetau (dN, tau, N_A, N_D, mode)
%             itau = inversetau (dN, tau, N_A, N_D, mode)
            %remove auger recombination
            itau = 1./tau- 1./Si.auger(dN, N_A, N_D, mode);

        end
        function [j0e, tau_b] = emittersat(dN, itau, width, N_A, N_D)
%             [j0e, tau_b] = emittersat(dN, itau, width, N_A, N_D)
            slope = gradient(itau, dN);
%             AN IN BUILT MATLAB FUNCTION
            slope = sgolayfilt(slope , 1, 25);
            
            Ndop_int = (itau) + slope.*(-(N_A + N_D));

            %calculate the emitter and bulk recombinations
            j0e = slope .* width * Si.ni^2 * Si.q / 2;
            tau_b = 1./Ndop_int;

        end
        
        function [dydx, x] = smoothDiff (x, y,fr)
%           [dydx, x] = smoothDiff (x, y,fr)
%             padds the vector for which the derivative will be taken
            slope = gradient (y,x);
            slope = [-max(abs(slope)).*ones(50,1)' slope'];
            slope = fastsmooth(slope,fr,3,1); %(slope(end:-1:1)
            dydx = slope(51:end)'; 
        
        end
%         function obj = emittersatReichel(obj, PC_settings, varargin)
%             if nargin > 1
% %                 deal with an input bulk lifetime
%             end
%             
%             invtaub = 1./Si.auger(obj.dN, obj.N_A, obj.N_D, PC_settings.auger_mode);
%             [N_Dt, N_At, widtht , ~] = MCM_calc.pad_arrays (obj.N_D, obj.N_A, obj.width, invtaub);            
%             obj.j0eRei = (1./obj.tau - invtaub).*widtht * Si.ni^2 * Si.q / 2 ./ (N_Dt + N_At)     
%         end
    end
    
end

