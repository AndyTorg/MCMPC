classdef MCM_calc < Si
    % Calculated data from MCM for PC measurement uncertainty
    properties (Access = public)
        width
        N_A
        N_D
        OC
        time        % (s) time for this sepcific MCM sim   
        vpc         % (V) vpc for this specific MCM sim may include uncertainty
        vref        % (V) vref for this specific MCM sim may include uncertainty
        vdark
        cond        % (S) calculated conductivity 
    end
    
    properties (Access = public)
        Gen
        mu          % (/cm3/rho) mobility for carriers iteratively determined
        sun         % (suns) calculated from vref and vref_to_suns
        G           % (/cm3) average generation in the wafer 
        dN          % (/cm3)excess carrier density             
        tau         % (s) minority carrier effective lifetime 
        tau_a       % (s) model determiend Auger lifetime
        itau        % (1/s) inverse auger corrected lifetime 
        j0e         % (A/cm2) what we are estimating
        j0eRei      % (A/cm2) determined from the low injection method
        tau_b       % (s) bulk lifetime from the kane and swanson method
        dNS
        tauS
        j0eS
        j0eReiS
        itauS
        tau_bS
    end
    
    properties (Constant)
%         q = 1.6042e-19
        MA_oc_1 = 0.038
    end
    
    methods
        function obj = MCM_calc (PC_meas, PC_settings, iterations)
%             obj = MCM_calc (PC_meas, PC_settings, iterations)
            % Set up the MCM_calculation from the input sample data and the
            % measurement settings
            if ~isa(PC_meas, 'MCM_PC_meas') 
                error ('The input PC_meas is not of class MCM_PC_meas');
            end
            
            if ~isa(PC_settings, 'MCM_PC_settings') 
                error ('The input PC_settings is not of class MCM_PC_settings');
            end
            
            if isinteger(iterations)
                error('You must call for an interger number of MCM iterations');
            end
%             obj.PC_meas = PC_meas
%             obj.PC_settings = PC_settings
%             obj(1:iterations) = obj;
            
% ############## HERE WOULD BE A GOOD SPOT FOR PARFOR LOOP.
%           Set all of the inputs
%             for i = 1:iterations
%                 obj.width(i) = PC_meas.width + PC_meas.width_err*randn(1);
%                 obj.N_A(i) = PC_meas.N_A + PC_meas.N_A_err*randn(1);
%                 obj.N_D(i) = PC_meas.N_D + PC_meas.N_D_err*randn(1);
%                 obj.OC(i) = PC_meas.opt_const + PC_meas.opt_const_err*randn(1);
%                 obj.time(:,i) = PC_meas.time_est + PC_meas.time_err.*randn(1, length(PC_meas.time_err))';
%                 obj.vpc(:,i) = PC_meas.vpc_est + PC_meas.vpc_err.*randn(1,length(PC_meas.vpc_err))';
%                 obj.vref(:,i) = PC_meas.vref_est + PC_meas.vref_err.*randn(1,length(PC_meas.vref_err))';
%                 obj.vdark(:,i)= PC_meas.vdark;
% % % % % % % % % % %             end
% % % % % % % % % % w = zeros(iterations,1)
% % % % % % % % % % wid = PC_meas.width;
% % % % % % % % % % wid_err = PC_meas.width_err;
% % % % % % % % % % parfor i = 1:iterations
% % % % % % % % % %     w = wid + wid_err*randn(1);
% % % % % % % % % % end
% % % % % % % % % % obj.width = w;
spmd
            for i = 1:iterations
                obj.width(i) = PC_meas.width + PC_meas.width_err*randn(1);
                obj.N_A(i) = PC_meas.N_A + PC_meas.N_A_err*randn(1);
                obj.N_D(i) = PC_meas.N_D + PC_meas.N_D_err*randn(1);
                obj.OC(i) = PC_meas.opt_const + PC_meas.opt_const_err*randn(1);
                obj.time(:,i) = PC_meas.time_est + PC_meas.time_err.*randn(1, length(PC_meas.time_err))';
                obj.vpc(:,i) = PC_meas.vpc_est + PC_meas.vpc_err.*randn(1,length(PC_meas.vpc_err))';
                obj.vref(:,i) = PC_meas.vref_est + PC_meas.vref_err.*randn(1,length(PC_meas.vref_err))';
                obj.vdark(:,i)= PC_meas.vdark;
            end
end        
            
        end
        
        function obj = MC_sim (obj, PC_settings)
            obj = obj.conductivity(PC_settings);
            obj = obj.generation(PC_settings);
            obj = obj.carriers (PC_settings);
            obj = obj.lifetime(PC_settings);
            obj = obj.inversetau(PC_settings);
            obj = obj.emittersat();
            obj = obj.emittersatReichel(PC_settings);
            obj = obj.statistics();
        end
        
        function obj = conductivity(obj, PC_settings)
%             obj = conductivity(obj, PC_settings)
%             converts the measured voltage to conductivity
%             the mean DELTA conductivity is
%             V = [obj.vpc.^2 obj.vpc ones(size(obj.vpc))];
%              cond = V*B
%              varCond = sqrt(diag(V*PC_settings.varB*V'));
%             V = obj.vpc;
            b = PC_settings.B;
            varB = PC_settings.varB;
%             lookint at doing it without arrays of struct
%             Cond = V.*V*b(1) + V*b(2) + ones(size(V))*b(3);
%               concuctivity stderr

            for i = 1:MCM_calc.cols(obj.vpc)
                V = [obj.vpc(:,i).^2 obj.vpc(:,i) ones(size(obj.vpc(:,i)))];
                V0 = [obj.vdark(:,i).^2 obj.vdark(:,i) ones(size(obj.vdark(:,i)))];
                Cond = V*b ;
                delCond =  V*b - V0*b;
                varCond = sqrt(diag(V*varB*V'));
                MC_delta_Cond = delCond + randn(1).* varCond.*delCond./Cond;
                
%                 MC_delta_Cond = delta_Cond + randn(1).* muCond.* delta_Cond ./Cond;
                obj.cond(:,i) = MC_delta_Cond;
            end
        end
        
        function obj = generation(obj, PC_settings)
            %function j0_o = gen_cal(j0_i)
            %Andrew Thomson v2 17/05/12
            %Function calculates generation for generalised or qss tau calculations

            %calculate suns from reference cell
            suns = obj.vref ./ PC_settings.vref_to_suns;
            %assuming an optical reference of 0.038 mA
            
            obj.Gen = suns * obj.MA_oc_1 .* (ones(obj.rows(suns),1)*obj.OC) / Si.q;

        end
        
        function obj = carriers(obj, PC_settings)
            mu_s = Si.mobility_sum(1, obj.N_A, obj.N_D, 298, PC_settings.mu_mode);
            mu_s = ones(obj.rows(obj.cond),1)*mu_s; % expand mu_sum so that it is the same size as the conductivity vector
            %NOTE you should code in  a convergece test and perhaps reduce calc time. 
            %This is a newton method approximation.
            [~, N_At, N_Dt] = MCM_calc.pad_arrays(obj.vpc, obj.N_A, obj.N_D);
            for i = 1:10
                obj.dN = obj.cond ./((ones(obj.rows(obj.cond),1)*obj.width) * Si.q .* mu_s);
                %a = j0.dN;    
                mu_s = Si.mobility_sum(obj.dN, N_At, N_Dt, 298, PC_settings.mu_mode);
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
            
        function obj = statistics (obj)
            % Andrew Thomson 23/05/2012
            % Calculates the statistics of the outputted MC simulations
            % J0 stat is a single structre that instead of holding n simulations's data
            % it holds the statistics of the n_simulations
            % here we will increase the complexity of the structures hopefully it works
            % nicely!


            
            %j0_stat = j0;
            vec = {'dN', 'tau','tau_b','itau', 'j0e', 'j0eRei'};
            vecS = {'dNS', 'tauS','tau_bS','itauS', 'j0eS', 'j0eReiS'};
            %vec = {'vr','vt','time'}; % Use this one for voltage measurements

            %NOTE at some state I should learn to use the array fun method. This could
            %remove the for loop. Don't know how it would help. It may be more readable

            %j0_stat.cond.mean = arrayfun(@(x) mean([x.cond]'), j0_i, 'UniformOutput',
            %false);

            %NOTE this first method takes the statistics for each voltage-time point,
            %hence the statistics are underpinned by that comparison. However it may be
            %more logical to do a comparison by dN, for which we usually associate
            %these variables being a function of. 

            methd2 = 1; %Set to zero for voltage measurements
            %interpolats all values to same dN
            %now removes non uniqe dN values...
            if methd2
                for j = 2 : MCM_calc.cols (obj.dN) 
                    [~,nonrep,~]=unique(real(obj.dN(:,j)));
                    for i = 2 : length (vec) 
                        if ~strcmp(vec(i), 'vpc')
                            obj.(char(vec(i)))(nonrep,j) = interp1(real(obj.dN(nonrep,j)), (obj.(char(vec(i)))(nonrep,j)),real(obj.dN(nonrep,1)),'linear', 'extrap');
                        end
                    end
                end
            end



           
            for i = 1:length(vec)
            %these commants rake statistics for all vectors listed above. Here the
            %structre is extended to another level to include all the necessary
            %stats. 
            %Note the .() input must be of type char not a cell, hence the
            %confusing char command. Using this format the the statistics vector
            %can easliy be modified and other statistical metrics be easily added. 
            obj.(char(vecS(i))).ave = mean(obj.(char(vec(i))),2);
            obj.(char(vecS(i))).sdev = std(obj.(char(vec(i))),1,2);
%             j0_stat.(char(vec(i))).mn = min([j0.(char(vec(i)))],2);
%             j0_stat.(char(vec(i))).mx = max([j0.(char(vec(i)))],2);
%             j0_stat.(char(vec(i))).rng = range([j0.(char(vec(i)))],2);
%             j0_stat.(char(vec(i))).vr = var([j0.(char(vec(i)))],1,2);    
            obj.(char(vecS(i))).sdp = std([obj.(char(vec(i)))],1,2)./obj.(char(vecS(i))).ave*100;
%             j0_stat.(char(vec(i))).rp = range([j0.(char(vec(i)))],2)./j0_stat.(char(vec(i))).ave*100;
%             j0_stat.lab = '';
            end

        %Method 2 standardises the statistis to fixed DN, the method above
        %correlats points in time to each other, not carrier density. 
        end
    
        function obj = plotSS(obj)
            subplot (2, 2, 1)
            plot (obj.time,obj.vpc, obj.time, obj.vref)
            xlabel('time')
            ylabel ('Vpc and Vref')
            
            subplot(2,2,2)
            plot (obj.dN,obj.itau)
            xlabel('dN')
            ylabel ('Inverse Auger corrected lifetime')
            
            
            subplot(2,2,3)
            semilogx (obj.dN,obj.j0e)
            xlabel('dN')
            ylabel ('j0e*')
            
            subplot(2,2,4)
            loglog (obj.dN,obj.tau)
            xlabel('dN')
            ylabel ('tau') 
        end
   
        function obj = plotS(obj)
            clf
            subplot (2, 2, 4)
            i = obj.dNS.ave>0 & obj.j0eS.sdp > 0 & obj.j0eS.sdp < 40
            semilogx (obj.dNS.ave(i), obj.j0eS.sdp(i))
            xlabel('\Delta\it{n} \rm{(cm^{-3})}')
            ylabel ('Uncertainty in the \it{J}\rm{_{0e} (%)}')
            
            subplot(2,2,3)
             i = obj.dNS.ave>0 & obj.tauS.sdp > 0 & obj.tauS.sdp < 20
            semilogx (obj.dNS.ave(i), obj.tauS.sdp(i))
            xlabel('\Delta\it{n} \rm{(cm^{-3})}')
            ylabel ('Uncertainty in \tau_{eff} (%)')
            
            subplot(2,2,2)
            i = obj.dNS.ave>0 & obj.j0eS.ave > 0
            loglog(-1,-1)
            hold on 
            eloglog([obj.dNS.ave(i) obj.dNS.sdev(i)], [obj.j0eS.ave(i) obj.j0eS.sdev(i)], 'b', 1,1)
            hold off
            xlabel('\Delta\it{n} \rm{(cm^{-3})}')
            ylabel ('\it{J}\rm{_{0e}^* (A/cm^{-3})}')
            
            subplot(2,2,1)
            i = obj.dNS.ave>0 & obj.tauS.ave > 0
            loglog(-1,-1)
            hold on 
            eloglog([obj.dNS.ave(i) obj.dNS.sdev(i)], [obj.tauS.ave(i) obj.tauS.sdev(i)], 'b', 1,1)
            hold off
            xlabel('\Delta\it{n} \rm{(cm^{-3})}')
            ylabel (' \tau_{eff} (s)')           
        end 
        
        function report(obj, PC_meas, PC_settings , SSname, dN)
%         report(obj, PC_meas, PC_settings , SSname, dN)    
            
%             output summary data
            folder = cd;
            output_cell = {'dN est' 'dN std dev' 'dN std %' 'tau est' 'tau std' 'tau std %' 'j0e est' 'j0e std' 'j0e std %'};
            xlswrite([folder '\' SSname], output_cell,'summary', 'A1');
            output_cell = [obj.dNS.ave obj.dNS.sdev obj.dNS.sdp obj.tauS.ave obj.tauS.sdev obj.tauS.sdp obj.j0eS.ave obj.j0eS.sdev obj.j0eS.sdp];
            xlswrite([folder '\' SSname], num2cell(output_cell.*(output_cell > 0)),'summary', 'A2');
            
%             measuremen summary 
            
            s_dark = [PC_meas.vdark^2 PC_meas.vdark 1]*PC_settings.B
            res_ohmcm = 1/s_dark*PC_meas.width
            ohm_side = 1/s_dark*2
            
            
            
            summary = {'width' '' '' PC_meas.width ; 'width error' '' '' PC_meas.width_err ; 'restivity_input' '' '' PC_meas.resistivity ; 'total restivity measured' '' '' res_ohmcm ; 'sheetRho *2' '' '' ohm_side ;'optical constant input' '' '' PC_meas.opt_const ;'optical constant error' '' '' PC_meas.opt_const_err}
            xlswrite([folder '\' SSname], summary,'summary', 'k1');
            
            
            try
%         interp may not work if you have the wrong dN
                tau = interp1(obj.dNS.ave, obj.tauS.ave, dN, 'linear');
            catch    
                tau = '-';
            end
                
            try
                tau_err = interp1(obj.dNS.ave, obj.tauS.sdev, dN, 'linear');
            catch
                tau_err = '-';
            end
            
            try
                tau_errp = interp1(obj.dNS.ave, obj.tauS.sdp, dN, 'linear');
            catch
                tau_errp = '-'
            end
            
            try
                j0e = interp1(obj.dNS.ave, obj.j0eS.ave, dN, 'linear');
            catch
                j0e = '-'
            end
            
            try
                j0e_err = interp1(obj.dNS.ave, obj.j0eS.sdev, dN, 'linear');
            catch
                j0e_err = '-'
            end
            
            try
                j0e_errp = interp1(obj.dNS.ave, obj.j0eS.sdp, dN, 'linear');
            catch 
                j0e_errp = '-'
            end
            
            summary = {'tau_eff' '' tau; 'tau sd' '' tau_err; 'tau sd%' '' tau_errp;...
                        'j0e' '' j0e; 'j0e sd' '' j0e_err; 'j0e sd%' '' j0e_errp};
            xlswrite([folder '\' SSname], summary,'summary', 'p1');


        end
    end
    methods (Static)      
        function r = rows(array)
            a = size(array);
            r = a(1);
        end       
        function c = cols (array)
            a = size(array);
            c = a(2);
        end
        function varargout = pad_arrays (varargin)
%             function padds arrays and vectors such that the are the same
%             sized as the largest array. This will enable calculations to
%             be done in parallel element by element. 
            rows = max(cellfun('size', varargin, 1));
%             cols = max(cellfun('size', varargin, 2));
            
%             varargout = 1
            
            for i = 1:length(varargin)
               if MCM_calc.cols(varargin{i}) == 1
%                    Padd cols
                   varargin{i} = varargin{i}*ones(1,rows);
               else
                   varargin{i} = varargin{i};
               end
            
               if MCM_calc.rows(varargin{i}) == 1
                   varargin{i} = (varargin{i}'*ones(rows,1)')';
               else
                   varargin{i} = varargin{i};
               end
            end  
            varargout = varargin;
        end
        function j0e = j0e_KS (dN, tau, N_A, N_D, w, tauB)
%       function j0e = j0e_KS (dN, tau, N_A, N_D, w, tauB)
            % Applies the same transformations as emitter sat but to arbitary data.  
            if ischar(tauB)
                taug = Si.auger(dN, N_A, N_D, tauB)
                itau = 1./tau- 1./taug(:,1);
            else
                itau = 1./tau - 1/tauB
            end 
            
            slope = gradient (itau, dN);
                                  
            j0e = slope * w * Si.ni^2 * Si.q / 2;
        end
        function j0e = j0e_Rei (dN, tau, N_A, N_D, w , tauB)
%       function j0e = j0e_Rei (dN, tau, N_A, N_D, w , tauB)
            
            if ischar(tauB)
                invtaub = 1./Si.auger(dN, N_A, N_D, 'Richter');
            end
            
            j0e = (1./tau - invtaub(:,1)).*w * Si.ni^2 * Si.q / 2 ./ (N_D + N_A)
            
            
        end
        
        function itau = invTau (dN, tau, N_A, N_D, tauB)
%       function j0e = j0e_Rei (dN, tau, N_A, N_D, w , tauB)
            
            if ischar(tauB)
                invtaub = 1./Si.auger(dN, N_A, N_D, 'Richter');
            end
            
            itau = (1./tau - invtaub(:,1));
            
            
        end
        

    end
end