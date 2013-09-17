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
            
            cond = (vpc-Coff).^2*A + (vpc-Coff)*B - (vdark-Coff).^2*A + (vdark-Coff)*B;
        end
        
        function [suns, gen] = generation(vref, vref_to_suns, OC)
            %function j0_o = gen_cal(j0_i)
            %Andrew Thomson v2 17/05/12
            %Function calculates generation for generalised or qss tau calculations

            %calculate suns from reference cell
            suns = vref ./ vref_to_suns;
            %assuming an optical reference of 0.038 mA
            gen = suns*0.038*OC/Si.q;

        end
        
        function dN = carriers(cond, width, N_A, N_D, mu_mode)
            mu_s = Si.mobility_sum(1, N_A, N_D, 298, mu_mode);
            mu_s = ones(MCM_calc.rows(cond),1)*mu_s; % expand mu_sum so that it is the same size as the conductivity vector
            %NOTE you should code in  a convergece test and perhaps reduce calc time. 
            %This is a newton method approximation.
%             [~, N_At, N_Dt] = MCM_calc.pad_arrays(cond, N_A, N_D);
            for i = 1:10
                dN = cond ./((ones(MCM_calc.rows(cond),1)*width) * Si.q .* mu_s);
                %a = j0.dN;    
                mu_s = Si.mobility_sum(dN, N_A, N_D, 298, mu_mode);
            end
        end
        
        function obj = lifetime(obj, PC_settings)
%             filtersettings
        fr = 5;
           if strcmpi(PC_settings.pc_mode, 'PCD')   
%                the following has inbuilt filtering that works well for in
%                previous version
                slope = zeros(size(obj.dN));
                for i = 1:MCM_calc.cols(obj.time)
                    timet = exp((log(min(obj.time(:,i))):(log(max(obj.time(:,i)))-log(min(obj.time(:,i))))/(MCM_calc.rows(obj.time)+10):log(max(obj.time(:,i)))));
                    dNt = interp1(obj.time(:,i),obj.dN(:,i), timet, 'linear');
                    obj.time(:,i) = timet(6:end-6)';
                    obj.dN(:,i) = dNt(6:end-6)';    
                    slope(:,i) = smoothDiff(obj.time(:,i), obj.dN(:,i), fr);
                end


                obj.tau = -obj.dN./(slope);
            elseif strcmpi(PC_settings.pc_mode,'QSS')
%                 j0.tau = j0.dN*j0.w./(j0.G);
            elseif strcmpi(PC_settings.pc_mode, 'GEN')
            
                for i = 1:MCM_calc.cols(obj.time)
                    timet = exp((log(min(obj.time(:,i))):(log(max(obj.time(:,i)))-log(min(obj.time(:,i))))/(MCM_calc.rows(obj.time(:,i))+10):log(max(obj.time(:,i)))));
                    dN = interp1(obj.time(:,i),obj.dN(:,i), timet, 'linear');
                    G = interp1(obj.time(:,i),obj.Gen(:,i), timet, 'linear');
    % 
    %                 % drop end in order to avoid nan
                    timet = timet(6:end-6)';
                    dN = dN(6:end-6)';
                    G = G(6:end-6)';
                    slope = gradient (dN, timet);
    % 
    %                 %  slope = gradient (obj.dN,obj.time);
                    slope = fastsmooth(slope,5,3,1);
    % 
    % 
    %                 % slope = slope %(6:end);
                    obj.time(:,i) = timet;%(6:end);
                    obj.dN(:,i) = dN;%(6:end);
                    obj.Gen(:,i) = G;
%                     slope = gradient (obj.dN, obj.time);
                    obj.tau(:,i) = obj.dN(:,i)./(obj.Gen(:,i)/obj.width(:,i) - slope);
                end
%                 obj.tau = obj.dN./(obj.Gen/obj.width - slope);
           end
            
        end
        function obj = inversetau (obj, PC_settings)
            
            %remove auger recombination
            obj.itau = 1./obj.tau- 1./Si.auger(obj.dN, obj.N_A, obj.N_D, PC_settings.auger_mode);

        end
        function obj = emittersat(obj)
            slope = zeros (size(obj.itau));
            for i = 1:MCM_calc.cols(obj.itau)
                slope(:,i) = gradient (obj.itau(:,i), obj.dN(:,i));
            end
            slope = sgolayfilt(slope , 1, 25);
            
            %makes the matrices all multiplyable 
            [N_Dt, N_At, widtht , ~] = MCM_calc.pad_arrays (obj.N_D, obj.N_A, obj.width, slope); 
            
            Ndop_int = (obj.itau) + slope.*(-(N_At + N_Dt));

            %calculate the emitter and bulk recombinations
            obj.j0e = slope .* widtht * Si.ni^2 * Si.q / 2;
            obj.tau_b = 1./Ndop_int;

        end
        function obj = emittersatReichel(obj, PC_settings, varargin)
            if nargin > 1
%                 deal with an input bulk lifetime
            end
            
            invtaub = 1./Si.auger(obj.dN, obj.N_A, obj.N_D, PC_settings.auger_mode);
            [N_Dt, N_At, widtht , ~] = MCM_calc.pad_arrays (obj.N_D, obj.N_A, obj.width, invtaub);            
            obj.j0eRei = (1./obj.tau - invtaub).*widtht * Si.ni^2 * Si.q / 2 ./ (N_Dt + N_At)     
        end
    end
    
end

