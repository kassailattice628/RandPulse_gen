function TTLStim
%%%%TTL Pulse Gen%%%%%
% randamize pulse patterns
global dio

global count_n
global cycle_n
global stim_n
global pulsepatterns
global rand_set

global ui

global filename
global pathname

global stim_ms
global train_n

global savedata
global stim_order
global logdata
%% GUI
figure;
%ui.start= uicontrol('string','START','position',[10 300 100 30],'callback','[cycle_n, stim_n] = SetRand(count_n);DispUpdate; count_n = count_n + 1;','fontsize',12);
ui.start= uicontrol('string','ON','position',[10 300 100 30],'callback',@PulseON,'fontsize',12);


ui.reset = uicontrol('string','Reset Cycle','position',[10 200 100 30],'callback',@ResetCycle,'fontsize',12);


ui.open = uicontrol('string','Open Log','position',[10 130 100 30],'callback',@OpenLog,'fontsize',12);


uicontrol('style','text','string','Next #Trial','position',[130 310 100 20],'fontsize',12);
ui.trial = uicontrol('style','text','string', count_n,'position',[130 280 100 30],'fontsize',15,'BackGroundColor','w');

uicontrol('style','text','string','Pulse Pattern','position',[245 310 100 20],'fontsize',12);
ui.pulsepattern = uicontrol('style','text','string', pulsepatterns(stim_n),'position',[245 280 100 30],'fontsize',15,'BackGroundColor','w');

uicontrol('style','text','string','#Cycle','position',[350 310 50 20],'fontsize',12);
ui.cycle = uicontrol('style','text','string', cycle_n,'position',[350 280 50 30],'fontsize',15,'BackGroundColor','w');

uicontrol('style','text','string','#Stim','position',[405 310 50 20],'fontsize',12);
ui.stim = uicontrol('style','text','string', stim_n,'position',[405 280 50 30],'fontsize',15,'BackGroundColor','w');

ui.setfname = uicontrol('string','File Nmae','position',[10 350 100 30],'callback',@Setfname,'fontsize',12);
ui.fname = uicontrol('style','text','string', filename, 'position',[130 350 200 30],'fontsize',15,'BackGroundColor','w');

%ui.table = uitable('Data', stim_order,'ColumnName','stim', 'position',[130,100,150,250]);

%%
    function PulseON(hObject,callbackdata)
        % generate TTL pulse with set params
        TTLON;
        % save #trial and #stim
        savedata = [savedata;[count_n, stim_n]];
        stim_order = [stim_order;pulsepatterns(stim_n)];
        csvwrite([pathname filename],savedata);

        %set(ui.table, 'Data', stim_order);
        %set next stim
        SetRand;

    end

%%
    function SetRand
        amari = rem(count_n, 6);
        switch amari
            case 0 %set next set
                %amari = 6;
                rand_set = randperm(6);
                stim_n = rand_set(1);
            case {1,2,3,4,5}
                stim_n = rand_set(amari+1);
        end
        %

        cycle_n = ceil(count_n/6); %cycle_n
        %stim_n = rand_set(amari)+1; %stim_n


        count_n = count_n + 1;
        DispUpdate;
    end

%%
    function ResetCycle(hObject,callbackdata)
        count_n = 1;
        cycle_n = 1;
        rand_set = randperm(6);
        stim_n = rand_set(1);
        DispUpdate;
    end


%%
    function Setfname(hObject,callbackdata)
        if pathname ==  0
            [filename, pathname] = uiputfile('.csv', 'Select File');
        else
            [filename, pathname] = uiputfile('.csv', 'Select File',pathname);
        end
        savedata = [];
        stim_order = [];
        set(ui.fname,'string',filename)

        ResetCycle;
    end


%%
    function DispUpdate%(hObject,callbackdata)
        set(ui.trial,'string',count_n)
        set(ui.pulsepattern,'string',pulsepatterns(stim_n));
        set(ui.cycle,'string',cycle_n);
        set(ui.stim,'string',stim_n);
    end

%%
    function OpenLog(hobject, callbackdata)
        [logname, logpathname] = uigetfile('.csv', 'Select Log');
        logdata = csvread([logpathname,logname]);
        log_stim = cell(length(logdata(:,2)),1);
        for n = 1:length(logdata(:,2))
            log_stim(n) = pulsepatterns(logdata(n,2));
        end
        figure;
        uitable('Data', log_stim);
    end
%% NI DAQ

%for 64bit DAQ toolbox
    function TTLON
      % For DAQ devices without CTR output
      % pulse repetetion is set by tic, toc timer
      %(,thus the pulse cycles might not be precise)
        for n = 1:train_n(stim_n)
            tic;
            outputSingleScan(dio, 1);
            while toc <= stim_ms(stim_n)/1000
            end

            outputSingleScan(dio, 0);
            while toc <= 2*stim_ms(stim_n)/1000
            end
            toc
        end
    end
%{
    function TTLON
        for n = 1:train_n(stim_n)
            tic;
            putvalue(dio,1);
            while toc <= stim_ms(stim_n)/1000
            end
            %pause(stim_ms(stim_n)/1000);
            putvalue(dio,0);
            while toc <= 2*stim_ms(stim_n)/1000
            end
            toc
            %pause(stim_ms(stim_n)/1000);
        end
    end
%}
%%

end
