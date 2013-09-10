classdef MCM_PC_meas
%     Sample input parameters for MCM simulation of uncertainty in PC measurements
%     of recombination in semiconductors. 
    properties 
        width           % (um) Sample width in um. More typically used
        width_err       % (um) Standard deviation in multiple measurents of wafer thickness. 
        resistivity     % (Ohm-cm) Wafer doping 
        doping_err      % (%/cm3) Wafer doping uncertainty estimated /cm3
        bulk_type       % Bulk doping type n or p
        time            % (s) Time data from the PC measurement
        vpc             % (Volt) Measured PC voltage
        vref            % (Volt) Measured reference voltage 
        vdark
        opt_const       % Factor used to evaluate the generation in the sample from the incident intensity
        opt_const_err   % Error in this constant, if determined by comparision ~the error the trans technqie, or if measured less. 
    end
    properties (Dependent, SetAccess = private)
        N_A
        N_A_err
        N_D
        N_D_err
        
        % If a matrix of multiple time measuremetns are entered then they average time will be assess otherwise the estimated is the input
        time_est
        
        vpc_est
        vref_est
        time_err
        vpc_err         % (Volt) Standard error in vpc from multiple measurements
        vref_err        % (Volt) Standard error in vref from multiple measurements
    end
    
    methods
        function obj = MCM_PC_meas (width, width_err, resistivity, doping_err, bulk_type, time, vpc, vref, OC, OC_err, vdark)
            if nargin > 0
                if isnumeric(width)
                    if width > 20 && width < 1000
                        obj.width = width/10000;          % Conver to CM as is typically used
                    else
                        error ('Please enter the with in um')
                    end
                else
                    error('Please enter a numeric width in um')
                end
                if isnumeric(width_err)
                    if width_err >= 0 && width < 1000
                        obj.width_err = width_err/10000;         % Conver to CM as is typically used
                    else
                        error ('Please enter the with in um')
                    end
                else
                    error('Please enter a numeric width error in um')
                end

                if max(strcmpi(bulk_type, {'n-type' 'p-type'}))
                    obj.bulk_type = bulk_type;
                else
                    error('Please enter the bulk type as n or p-type, compensated is not accepted at this time')
                end

                if isnumeric(resistivity)
                    if resistivity > .01 && resistivity < 5000
                        obj.resistivity  = resistivity; 
                    else
                        error('Please check restivity is in ohm-cm. Me thinks it should be between 0.01 and 5000 ohm-cm')
                    end
                else
                    error('Please ensure the restivity is numeric')
                end

                if isnumeric(doping_err) 
                    obj.doping_err = doping_err;
                else 
                    error ('Please enter a doping error that is numeric it can be zero it is a proportion, zero being zero and 1 being 100%')
                end
                if isnumeric(time) && isnumeric(vpc) && isnumeric(vref)
                    if ~min(size(time) & size(vpc) & size(vref))
                        error ('pease ensure the size of the time vpc and vref is the same')
                    else
                       obj.time = time;
                       obj.vpc = vpc;
                       obj.vref = vref;
                       
                    end
                else
                    error('Please ensure time, vpc and vref are all numeric and of same size')
                end
                obj.opt_const = OC;
                obj.opt_const_err = OC_err;
                obj.vdark = vdark;
                obj.vpc = obj.vpc + vdark;
            end
        end
        function obj = ext_sss_folder (obj, folder)
%          will open and vectorise all voltage time and vref data from
%          version 3_4 Sinton Spread Sheets. 

            file = dir(folder)

            % will import data from any file with the suffix .xlsm
            j=1;
            for i = 1:length(file)
                if length(file(i).name) > 5
                    if strcmp (file(i).name(end-4:end),'.xlsm')
%                         obj.name = file(i).name
                        path = [folder '\' file(i).name ]
                        [~, ~, ~, ~, ~, ~, a.time(:,j), a.vpc(:,j), a.vref(:,j), ~, ~, ~, ~]...
                            = sint_3_4_extract (path);
%                         [obj.w, obj.N_Ai, obj.N_Di, obj.opt, obj.mode, obj.ohmsq, obj.t, obj.vpc, obj.vref, obj.dN, obj.tau, obj.voc, obj.suns]...
%                             = sint_3_4_extract (path)
                        
                        j = j + 1;
                    end
                end
            end
            obj.vpc = a.vpc + obj.vdark
            obj.vref = a.vref
            obj.time = a.time
        end
        
        function N_A = get.N_A(obj)
            if strcmpi(obj.bulk_type, 'p-type')
                rho_cm = obj.resistivity;
                N_A = Si.res2dopSint (rho_cm, obj.bulk_type);
            else
                N_A = 0;
            end       
        end
        function N_D = get.N_D(obj) 
            if strcmpi(obj.bulk_type, 'n-type')
                rho_cm = obj.resistivity;
                N_D = Si.res2dopSint (rho_cm, obj.bulk_type);
            else
                N_D = 0;
            end       
        end
        function N_A_err = get.N_A_err(obj)
            N_A_err = obj.N_A*obj.doping_err;
        end
        function N_D_err = get.N_D_err(obj)
            N_D_err = obj.N_D*obj.doping_err;
        end
        function vpc_est = get.vpc_est(obj)
           % assumes the measurements are in vector form. 
            vpc_est = mean(obj.vpc,2);
        end
        function vref_est = get.vref_est(obj)
            vref_est = mean(obj.vref,2);
        end
        function time_est = get.time_est(obj)
            time_est = mean(obj.time,2);
        end
        function vpc_err = get.vpc_err(obj)
            n = size(obj.vpc)*5;
            vpc_err = std(obj.vpc,0,2)/sqrt(n(2));
        end
        function vref_err = get.vref_err(obj)
            n = size(obj.vref)*5;
            vref_err = std(obj.vpc,0,2)/sqrt(n(2)); 
        end
        function time_err = get.time_err(obj)
            n = size(obj.vref);
            time_err = std(obj.time,0,2)/sqrt(n(2));
        end
    end
end



