%TTLStimGUI

%%
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


%% for 64bit DAQ toolbox
dev = daq.getDevices; %Device information is acquired from getDevices method.
dio = daq.createSession(dev.Vendor.ID); 
addDigitalChannel(dio, dev.ID, 'port0/line0', 'OutputOnly'); %Use port0/line0
outputSingleScan(dio, 0); %reset TTL level

%% set filename
[filename, pathname] = uiputfile('.csv', 'Select File to Write');


%% initialize params

count_n = 1;
cycle_n = 1;

pulsepatterns = cell(3,1);
pulsepatterns{1,1} = '50 ms * 1';
pulsepatterns{2,1} = '50 ms * 5';
pulsepatterns{3,1} = '50 ms * 20';

rand_set = randperm(size (pulsepatterns,1));
stim_n = rand_set(1);

stim_ms = [50, 50, 50];
train_n = [1, 5, 20];

savedata = [];
stim_order = [];
logdata = [];
%% function TTLStim
TTLStim_Sara
