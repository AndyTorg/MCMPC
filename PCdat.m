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
        index       % indicate file type chosen in uiget file, whether is .xls.xlsx.xlm
        multipleFiles  % indicate multiple files selected in uigetfiles
        dataselected 
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
                [obj.file,obj.path obj.index] =  uigetfile({'*.xlsm'; '*.xls'; '*.xlsx'}, 'Choose a Sinton SS','MultiSelect','on');
                if (ischar(obj.file))
                    obj.multipleFiles = 0
                else
                    obj.multipleFiles = 1
                end
                
            elseif nargin == 1
%               starts the folder poingening from and initial sub folder,
%               less clicks hopefully. 
                curdir = cd;
                cd (varargin{1})
                [obj.file,obj.path obj.index] =  uigetfile({'*.xlsm'; '*.xls'; '*.xlsx'}, 'Choose a Sinton SS','MultiSelect','on');
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
        
        
        function obj = getxls(varargin)
         if nargin == 1    
              obj = varargin{1}
            [obj.width, obj.N_A, obj.N_D, obj.OC, ~, ~, obj.time, obj.vpc, obj.vref, obj.dN, obj.tau, ~, obj.suns, obj.a, obj.b, obj.c, obj.vdark, obj.gref]...
                = PCdat.sint_3_2_extract ([obj.path obj.file]);
         end
         if nargin > 1
             obj = varargin{1}
             n = varargin{2}
             [obj.width, obj.N_A, obj.N_D, obj.OC, ~, ~, obj.time, obj.vpc, obj.vref, obj.dN, obj.tau, ~, obj.suns, obj.a, obj.b, obj.c, obj.vdark, obj.gref]...
                = PCdat.sint_3_2_extract ([obj.path obj.file{n}]);
         end
         
        end
        
        function obj = getxlsx(varargin)
            
        end
        function obj = getxlsm(varargin)
           if nargin == 1 
               obj = varargin{1}
            pthfil = [obj.path obj.file];
%             size({obj.width, obj.N_A, obj.N_D, obj.OC, 1, 2, obj.time, obj.vpc, obj.vref, obj.dN, obj.tau, 3, obj.suns, obj.a, obj.b, obj.c, obj.vdark})
            [obj.width, obj.N_A, obj.N_D, obj.OC, x, y, obj.time, obj.vpc, obj.vref, obj.dN, obj.tau, z, obj.suns, obj.a, obj.b, obj.c, obj.vdark, obj.gref]...
                = PCdat.sint_3_4_extract ([obj.path obj.file]);
           end
           
           if nargin > 1  
             obj = varargin{1}
             n = varargin{2}
             pthfil = [obj.path obj.file];
%             size({obj.width, obj.N_A, obj.N_D, obj.OC, 1, 2, obj.time, obj.vpc, obj.vref, obj.dN, obj.tau, 3, obj.suns, obj.a, obj.b, obj.c, obj.vdark})
            [obj.width, obj.N_A, obj.N_D, obj.OC, x, y, obj.time, obj.vpc, obj.vref, obj.dN, obj.tau, z, obj.suns, obj.a, obj.b, obj.c, obj.vdark, obj.gref]...
                = PCdat.sint_3_4_extract ([obj.path obj.file{n}]);
           end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = TTrangesel (obj, varargin)
%             obj = TTrangesel (obj, varargin)
%             Tau time range select. Here we select the data form the tau
%             time plot
%             clf
%             plot (obj.time, obj.vref, 'xr')
%             hold on
            [x,y,index] = PCdat.rangesel(obj.time, obj.vpc)   ;           
%             hold off
            obj = PCdat.objRangeSel(obj,index);
            clf
%             plotyy (obj.time, [obj.vpc, obj.vref], '+')
            
        end
        function obj = measrange(obj)
            
        end
    end
    methods (Static)
        function [w, N_Ai, N_Di, OC, mode, ohmsq, t, vpc, vref, dN, tau, voc, suns, a, b, c, vdark, gref]...
                = sint_3_4_extract (file)
%              [w, N_Ai, N_Di, OC, mode, ohmsq, t, vpc, vref, dN, tau, voc, suns, a, b, c, vdark, gref]...
%                 = sint_3_4_extract (file)
%             Perhaps I can come up with a better output. This way makes it
%             more usabel I think? 
% %           Find a better method for handelling the xlsread errors
            % allows user ot shut down file while opening
            try 
                [SummaryN, SummaryT] = xlsread(file, 'Summary', 'D2:W2');
            catch err
                input ('There has been an error opening the file, try closing all open SS, press enter to continue','s')
                [SummaryN, SummaryT] = xlsread(file, 'Summary', 'D2:W2');
            end

            w = SummaryN(1,1);
            
            [UserN, UserT]  = xlsread(file, 'User', 'D6');

            if strcmp (UserT, 'p-type')
                N_Ai = SummaryN(1,2); 
                N_Di = 0; 
            else
                N_Di = SummaryN(1,2);
                N_Ai = 0;
            end

            OC = SummaryN(1,3);
            mode = SummaryT(1,8);
            ohmsq = SummaryN(1,10);
            gref = SummaryN(1,end-3);
            a = SummaryN(1,end - 2);
            b = SummaryN(1,end - 1);
            c = SummaryN(1,end);
            
            
            as = a;
            bs = b-2*c*a;
            cs = c^2*a-c*b-1/ohmsq;
            
            vdark = (-bs + sqrt(bs^2-4*as*cs))/(2*as);
            
            [RawDN, RawDT] = xlsread(file, 'RawData', 'A2:I126');

            t = RawDN(1:end,1);
            vpc = RawDN(1:end,2);
            vpc = vpc + vdark;
            vref = RawDN(1:end,3);
            dN = RawDN(1:end,7);
            tau = RawDN(1:end,5);
            voc = RawDN(1:end,8);
            suns = RawDN(1:end,9);
        end
        function [width, N_A, N_D, OC, mode, ohmsq, time, vpc, vref, dN, tau, voc, suns, a, b, c, vdark, gref]...
                = sint_3_2_extract (file)
%             [w, N_Ai, N_Di, OC, mode, ohmsq, t, vpc, vref, dN, tau, voc, suns, a, b, c, vdark, gref]...
%                 = sint_3_2_extract (file)
%            Version 3_2 is is still in xls format. 
            [calc, modetext] = xlsread(file, 'Calc', 'A6:X166');
            
%             RAW DATA
            time = calc(7:end-33,1);
            vpc = calc(7:end-33, 2);
            vref = calc(7:end-33, 3);
            vdark = calc(end,2);
            vpc = vpc + vdark;

%             MEAS PARAS
            a = calc(2,19);
            b = calc(2,20);
            c = calc(2,21);
            off = calc(2,22);
            gref = calc(1,19);
            
%             SAMPLE PARAS
            width = calc(1,1);
            OC = calc(1,3);
            if calc(16,end) == calc(15,end)
                N_D = calc(16,end);
                N_A = 0;
            elseif calc(16,end) == calc(14,end)
                N_D = 0;
                N_A = calc(16,end);
            else
                warning('Can not extract the doping')
            end 
            mode = '';
            ohmsq = '';
            voc = ''
            
%             CALCULATED DATA
            dN = calc(7:end-33, 19);
%             itau = calc(7:end-33, 13);
            tau = calc(7:end-33, 12);
%             G = calc(7:end-33, 11);     
            suns = calc(7:end-33, 5);  
        end
        function [x,y, index] = rangesel (xaxis, yaxis, varargin)
%             [x,y] = rangesel (xaxis, yaxis, varargin)
% Function to interface with the wonderful select data gui interface
% varargin can be loglog, semilogx, semilogy or plot. default plot is plot
% with no input argument it is assumed the plot has already been made
        if nargin == 3
                if strcmpi(varargin{1}, 'loglog')
                    loglog(xaxis, yaxis, '+');
                elseif strcmpi(varargin{1}, 'semilogx')
                    semilogx(xaxis, yaxis, '+');
                elseif strcmpi(varargin{1}, 'semilogy')
                    semilogy(xaxis, yaxis, '+');
                elseif strcmpi(varargin{1}, 'plot')
                    plot(xaxis, yaxis, '+');
                end
%             elseif nargin == 2
%                 plot(xaxis, yaxis, '+');
           end
            
            [index,x,y] = selectdata ( 'SelectionMode', 'Rect','Verify', 'on');
            
        end
        
        function [arObjO] = objRangeSel (arObj, selvec)
%           [arObjO] = objRangeSel (arObj, selvec)
%           Resizes all the vectors in the object to the selvec, i.e. keeps
%           the index of the chosen files. 
           fields = fieldnames(arObj);
           
           for i = 1:length (fields)
               if isnumeric(arObj.(char(fields(i))))
                   if length (arObj.(char(fields(i)))) > 1
                       arObj.(char(fields(i))) = arObj.(char(fields(i)))(selvec);
                   end
               end
           end
           arObjO = arObj;
            
        end
%         function 
%         end
    end
end

