%TTLStimGUI

%%
clear all;
close all;

global dio

global count_n
global cycle_n
global stim_n
global pulsepatterns
global rand_set

global ui
ui=[];

global filename
global pathname

global stim_ms
global train_n

global savedata
global stim_order
global logdata

%% NI-USB-6501 is recognized "Dev6" at Sakatani san's PC
%
dio = digitalio('nidaq','dev6'); %digital object for trigger output
addline(dio,0,0,'out'); %Use port0/line0
putvalue(dio, 0); %reset TTL level
%}

%% set filename
[filename, pathname] = uiputfile('.csv', 'Select File to Write');


%% initialize params

count_n = 1;
cycle_n = 1;


%stim_set = 1:6; %randamize this vector
pulsepatterns = cell(6,1);
pulsepatterns{1,1} = '50 ms';
pulsepatterns{2,1} = '100 ms';
pulsepatterns{3,1} = '200 ms';
pulsepatterns{4,1} = '50 ms * 5';
pulsepatterns{5,1} = '50 ms * 10';
pulsepatterns{6,1} = '50 ms * 20';

rand_set = randperm(6);
stim_n = rand_set(1);

stim_ms = [50, 100, 200, 50, 50, 50];
train_n = [1, 1, 1, 5, 10, 20];

savedata = [];
stim_order = [];
logdata = [];
%% function TTLStim åƒÇ—èoÇµ
TTLStim