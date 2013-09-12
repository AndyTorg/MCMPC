classdef PCdat
    %PCDAT importa all forms fo PC data that we have tried to use todate
    %   Manytimes have we rehashed this. Here hopefully will be a
    %   continually updated extraction tool mostly for the sinton spread
    %   sheets but can be expanded to other formats
    
    properties (Access = public)
        path
        file
    end
    properties (Dependent, Access = public)
        version
    end
    
    properties (Access = public)
        %             RAW DATA
        time        % (s) time for this sepcific MCM sim   
        vpc         % (V) vpc for this specific MCM sim may include uncertainty
        vref        % (V) vref for this specific MCM sim may include uncertainty
        vdark
        
        %             SAMPLE PARAS
        width       % (cm) the quasi-neutral region often estimated by the total thickness of the sample
        N_A         % (/cm3) the concentration of acceptors in the quasi-neutal region
        N_D         % (/cm3) the concentration of donors in the quasi-neutal region
        OC          % (ratio) the optical constant of a wafer 0.65 for bare siliocn and 1 for a solar cell
        
        %             MEAS PARAS    
        a
        b
        c
        off
        gref
        
        %             CALCULATED DATA
        cond        % (S) calculated conductivity 
        G           % (e/cm3) concentration of e-h pairs generated
        mu          % (/cm3/rho) mobility for carriers iteratively determined
        suns        % (suns) calculated from vref and vref_to_suns
        dN          % (/cm3)excess carrier density             
        tau         % (s) minority carrier effective lifetime 
        itau        % (1/s) inverse auger corrected lifetime 
        j0e         % (A/cm2) what we are estimating 
    end
    
    methods
        function obj = PCdat(varargin)
%               obj = PCdat()                 will use the window thingo
%               obj = PCdat('path')           will use the window thingo
%               obj = PCdat('path', 'name')
            if nargin < 1
                [obj.file,obj.path] =  uigetfile({'*.xls'; '*.xlsx'; '*.xlsm'}, 'Choose a Sinton SS','MultiSelect','on');
            elseif nargin == 1
%               starts the folder poingening from and initial sub folder,
%               less clicks hopefully. 
                curdir = cd;
                cd (varargin{1})
                [obj.file,obj.path] =  uigetfile({'*.xls'; '*.xlsx'; '*.xlsm'}, 'Choose a Sinton SS','MultiSelect','on');
                cd (curdir)
            elseif nargin == 2
                obj.path = varargin{1};
                obj.file = varargin{2};
            else
                error('too many input arguments')
            end            
        end
        function obj = getdat(obj)
            switch obj.version
                case 1
                1
                case 2
                2   
                case 3
                 3  
            end
        end
        function version = get.version(obj)
%       Determines the version of the Spreadsheet. 
            ident = obj.file(end-3:end);
            switch ident 
                case '.xls'
                    version = 1;
                case 'xlsx'
                    version = 2;
                case 'xlsm'
                    version = 3;
                case other
                    error ('somehow you selected an incorrect file format')
            end
        end
        function obj = getxls(obj)
            pthfil = [obj.path obj.file]
            [calc, modetext] = xlsread(pthfil, 'Calc', 'A6:X166');
            
%             RAW DATA
            obj.time = calc(7:end-33,1);
            obj.vpc = calc(7:end-33, 2);
            obj.vref = calc(7:end-33, 3);
            obj.vdark = calc(end,2);

%             MEAS PARAS
            obj.a = calc(2,19);
            obj.b = calc(2,20);
            obj.c = calc(2,21);
            obj.off = calc(2,22);
            obj.gref = calc(1,19);
            
%             SAMPLE PARAS
            obj.width = calc(1,1);
            obj.OC = calc(1,3);
            if calc(16,end) == calc(15,end)
                obj.N_D = calc(16,end);
                obj.N_A = 0;
            elseif calc(16,end) == calc(14,end)
                obj.N_D = 0;
                obj.N_A = calc(16,end);
            else
                warning('Can not extract the doping')
            end 
            
            
%             CALCULATED DATA
            obj.dN = calc(7:end-33, 19);
            obj.itau = calc(7:end-33, 13);
            obj.tau = calc(7:end-33, 12);
            obj.G = calc(7:end-33, 11);     
            obj.suns = calc(7:end-33, 5);  
        end
        
        function obj = getxlsx(obj)
            
        end
        
        function obj = getxlsm(obj)
            pthfil = [obj.path obj.file]
            [obj.w, obj.N_A, obj.N_D, obj.OC, ~, ~, obj.time, obj.vpc,...
                obj.vref, obj.dN, obj.tau, ~, obj.suns]...
                = sint_3_4_extract (file)
        end
        
        function [t_o, dN_o, suns_o, tau_o, simIn] = j0datExtract (obj, varargin)
            % [t_o, dN_o, tau_o, simIn] = j0datExtract (file, varargin)
            % to additional inputs N_A, N_D
            %%%%% Import Relevent Data into Matlab Model %%%%%

            % the number of points measured by this iteration of the spread sheet
            set(0,'DefaultFigureWindowStyle','docked')
            close all
            points = 122;

            if nargin > 1 
                N_A = varargin{1};
                N_D = varargin{2};
            end
            if nargin > 2
                mode = 'gen'
            else 
                mode = 'trans'
            end

            [calc, modetext] = xlsread(file, 'Calc', 'A6:W133');
            time = calc(7:end,1);
            w = calc(1,1);
            dN = calc(7:end, 19)
            itau = calc(7:end, 13);
            tau = calc(7:end, 12);
            G = calc(7:end, 11);     
            suns = calc(7:end, 5);  
            OC = calc (1,3);

            if ~isvar('N_A')
                [num text] = xlsread(file, 'User', 'D6');
                if strcmp (text, 'p-type')
                    N_A = calc(1,2); 
                    N_D = 0; 
                else
                    N_D= calc(1,2);
                    N_A = 0;
                end
            end

            i = 1
            if strcmp(mode, 'trans')
                while G(i) > 2e12
                    i = i + 1;
                    if i > points
                        s = warning
                        warning on 
                        warning('Generalised measurement>');
                      s = warning
                        warning on 
                %         t_o= NaN; dN_o= NaN; tau_o = NaN; simIn = NaN;
                %         return
                        i = points
                        break
                    end
                end
            else
                % It is not necessary to filter the data with the generation
                i = 1
            end

            j = 10 
            while dN(j) == dN(2)
                j = j + 1;
                if j > points
                    error ('data too clipped')
                end
            end

            k = length (dN)
            while dN < max(N_D, N_A)
            k = k - 1;
                if k - max(i,j) < 10
                    s = warning
                    warning on 
                    warning('Low injection measurement only');
                    s = warning
                    warning on 
                    break;
                end
            end

            plotdNdata (time, dN, G, i, j, k)




            accept = 0;
            while accept == 0
                dataOK = input(['do you want to procced with this data?\n'...
                                '*enter to proceed\n' ...
                                '*b to use the black line and the first data point\n' ...
                                '*r to use the red line as the first data point\n' ...
                                '*n if the data is no good\n'...
                                '*lp low dN add 3 more points\n'...
                                '*lm low dN remove 3 ponts\n'...
                                '*hp high dN add 3 points\n'...
                                '*hm low dN remove 3 points\n'], 's')

                switch dataOK
                    case ''
                        t_o = time (max(i,j):k);
                        dN_o = dN (max(i,j):k);
                        tau_o = tau (max(i,j):k);
                        G_o = G (max(i,j):k);
                        suns_o = suns (max(i,j):k);
                        accept = 1;
                    case 'r'|'R'
                        t_o = time (max(j):k);
                        dN_o = dN (max(j):k);
                        tau_o = tau (max(j):k);
                        G_o = G (max(j):k);
                        suns_o = suns (max(j):k);
                        accept = 1;
                    case 'b'|'B'
                        t_o = time (max(i):k);
                        dN_o = dN (max(i):k);
                        tau_o = tau (max(i):k);
                         G_o = G (max(i):k);
                         suns_o = suns (max(i):k);
                        accept = 1;
                    case 'n'|'N'
                        t_o = nan;
                        dN_o = nan;
                        tau_o = nan;
                        accept = 1;
                        G_o = nan;
                    case 'lp'
                        if k < points - 3
                            k = k + 3;
                        else
                            k = points;
                        end
                    case 'lm'
                        if k > 1 + 3
                            k = k - 3;
                        else
                            k = 1;
                        end
                    case 'hp'
                        if i > 1 + 3
                            i = i - 3;
                        else
                            i = 1;
                        end
                        if j > 1 + 3
                            j = j - 3;
                        else
                            j = 1;
                        end
                    case 'hm'
                        if i < points - 3
                            i = i + 3;
                        else
                            i = points;
                        end
                        if j < points - 3
                            j = j + 3;
                        else
                            j = points;
                        end
                    otherwise
                        disp('INCORRECTOR INPUT')
                end 

            plotdNdata (time, dN, G, i, j, k)
            set(0,'DefaultFigureWindowStyle','normal')

            end


            simIn.w = w;
            simIn.N_A = N_A;
            simIn.N_D = N_D;
            simIn.OC = OC;
            % j0.vt = calc(7:end, 2);
            % j0.vr = calc(7:end, 3);
            % j0.v0 = xlsread(file, 'Calc', 'B166');

            warning('Retrieving all the input parameters from the Sinton spreadsheets')
            %####have removed the the input parameters. 
            % j0.a = calc(2,19);
            % j0.b = calc(2,20);
            % j0.c = calc(2,21);
            % j0.off = calc(2,22);
            % j0.off = 0;
            % j0.gref = calc(1,19);
            % j0.OC = calc(1,3);

        end
        
        function plotdNdata (time, dN, G, i, j, k)
            % clf
            [ax, h1, h2] = plotyy (time, dN, time, G);
            set (h1, 'Marker', 'x')
            set (h1, 'Color', 'b')
            set (h2, 'Marker', 'o')
            set (h2, 'Color', 'g')
            % set ((get(ax(1), 'Color')), 'g')
            % set ((get(ax(2), 'Ylabel')),  'Generation (cm^{-3})')

            xlabel('time (s)')
            ylabel('\Delta \it{n} \rm{cm^{-3}}')
            set ((get(ax(2), 'Ylabel')), 'String', 'Generation (cm^{-3})')

            hold on 
            if i > 0
            plot ([time(i)*1.0001  time(i)*.9999], [0 1e18],'k','linewidth', 3);
            end
            if j>0
            plot ([time(j)*1.0001  time(j)*.9999], [0 1e18],'r','linewidth', 3);
            end
            if k>0
            plot ([time(k)*1.0001  time(k)*.9999], [0 1e18],'m','linewidth', 3);
            end
            hold off
        end
    end
    methods (Static)
        function [w, N_Ai, N_Di, opt, mode, ohmsq, t, vpc, vref, dN, tau, voc, suns]...
                = sint_3_4_extract (file)
            % Find a better method for handelling the xlsread errors
            % allows user ot shut down file while opening
            try 
                [SummaryN, SummaryT] = xlsread(file, 'Summary', 'A2:W2');
            catch err
                input ('There has been an error opening the file, try closing all open SS, press enter to continue','s')
                [SummaryN, SummaryT] = xlsread(file, 'Summary', 'A2:W2');
            end


            w = SummaryN(1,4);



            [UserN, UserT]  = xlsread(file, 'User', 'D6');

            if strcmp (UserT, 'p-type')
                N_Ai = SummaryN(1,5); 
                N_Di = 0; 
            else
                N_Di = SummaryN(1,5);
                N_Ai = 0;
            end

            opt = SummaryN(1,6);
            mode = SummaryT(1,8);
            ohmsq = SummaryN(1,11);

            [RawDN, RawDT] = xlsread(file, 'RawData', 'A2:I126');

            t = RawDN(1:end,1);
            vpc = RawDN(1:end,2);
            vref = RawDN(1:end,3);
            dN = RawDN(1:end,7);
            tau = RawDN(1:end,5);
            voc = RawDN(1:end,8);
            suns = RawDN(1:end,9);
        end
    end
end

