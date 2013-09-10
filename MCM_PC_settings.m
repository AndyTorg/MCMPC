classdef MCM_PC_settings
%     Measurement input parameters for MCM simulations of uncertainty in PC
%     measurements of recombination
    properties (SetAccess = private)
        v_cal                   % (Volt) The vector of voltates from the WCT calibration
        s_cal                   % (Siemens) The corresponding vector of conductances for the WCT calibration
        vref_to_suns            % (Suns/V) The conversion factor for the reference voltage to suns illumination
%       Note the following are default settings. 
        pc_mode = 'PCD'         % The PC mode PCD, QSS, or GEN
        mu_mode = 'SINT'        % 'SINT', 'KLAASSEN', 'DORKEL'
        auger_mode = 'RICHTER'  % [] [] [] KERR SINT RICHTER Auger model used in the calculations 
        auger_err = .2          % [] percentage error estimated from Richter Paper
    end
    properties (Dependent)
        B               % (S/V2 S/V S) regressed calibration coefficients for the pc measurement, from the regression Vb = S
        varB            % Variance in the calibration coefficients
    end
    properties (Constant)
        ni = 8.598e9    % (/cm3) [] intrinsic carrier concentration
        q = 1.6042e-19  % (C/e)
    end
    methods
        function obj = MCM_PC_settings (v_cal, s_cal, vref_to_suns, varargin)
            if ~isvector(v_cal)
                error('please enter the calibartion voltage vector')
            end
            
            if ~isvector(v_cal)
                error('Please enter the calibartion voltage vector')
            elseif size (v_cal) ~= size (s_cal)
                error('Please check the calibration data and ensure they are the same size')
            end
            if ~isnumeric(vref_to_suns)
                error('Please enter a numerical value for the ref cell calbration')
            end
            
            for i = 1:nargin - 3 
                if ischar(varargin{i})
                    if max(strcmpi (varargin{i}, {'PCD' 'QSS' 'GEN'}))
                            obj.pc_mode = varargin(i);
                    elseif max(strcmpi (varargin{i}, {'KERR' 'SINT' 'RICHTER'}))
                            obj.auger_mode = varargin(i);
                    elseif max(strcmpi (varargin{i}, {'SINT' 'KLAASSEN' 'DORKEL'}))
                            obj.mu_mode = varargin(i);
                    else    
                            error ('Mode selection input not valid PCD|QSS|GEN KERR|SINT|RICHTER SINT|KLAASSEN|DORKEL')
                    end
                                
                else
                    error('Please enter strings that chose the PC mode, Aug mode, and Mu_mode')
                end
            end
            obj.v_cal = v_cal;
            obj.s_cal = s_cal;
            obj.vref_to_suns = vref_to_suns;
        end 
        function B = get.B(obj)
            % [Thomson2013]
            % V = [V^2 V 1]
            V = [obj.v_cal.^2 obj.v_cal ones(length(obj.v_cal),1)];
            B = inv(V'*V)*V'*obj.s_cal;
        end
        function varB = get.varB(obj)
            V = [obj.v_cal.^2 obj.v_cal ones(length(obj.v_cal),1)];
            varS = (obj.s_cal - V*obj.B)'*(obj.s_cal - V*obj.B)/(length(obj.s_cal)-3);
            varB = varS*inv(V'*V);
        end
    end
end