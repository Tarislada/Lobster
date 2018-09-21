%% TreeFertilizer
% Generate X,y dataset for selected sessionfolder.

%% Select Session Folder (ex. 0704)
dir_sess = uigetdir('','Select Session folder');

%% Find Event Folder
if exist(strcat(dir_sess,'\EVENTS'),'dir') == 7 
    dir_even = strcat(pathname,'EVENTS');
else
    error('EVENT folder is not in the sessiondir location');
end

%% Find Unit Data
loc0 = dir(strcat(dir_sess,'\*.mat'));
name_neur = {loc0.name}; % neuron names
for l = 1 : numel(name_neur)
    if contains(name_neur, 'UNIT') % delete *UNIT.mat file
        name_neur(l) = [];
    end
end
clear loc0 l
fprintf('%d Units are found',numel(name_neur));

%% Parse Event
[ParsedData, ~, ~, ~, ~ ] = BehavDataParser(dir_even);
numTrial = size(ParsedData,1);
IR_window = zeros(0,2);
for t = 1 : numTrial
    if isempty(ParsedData{t,3}) % No Lick
        continue % exclude data
    end
    absoluteTime = ParsedData{t,1}(1);
    tempIR_window = [ParsedData{t,2}(1), ParsedData{t,2}(end)] + absoluteTime;
    IR_window = [IR_window;tempIR_window];
end
clearvars t absoluteTime tempIR_window

%% Sort Neurons
% calculate fr and zscore
% check criterion
% Select Neurons

%% 


for f = 1 : numel(name_neur) % for each selected units, 
    %% Unit Data Load
    load(strcat(dir_sess,'\',name_neur{f})); % load Unit data
    spikes = table2array(SU(:,1)); % spike timestamp
    clearvars SU;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %% timewindow 내에 해당하는 rawdata를 저장하기 위한 cell
    raw_LOFF = cell(size(IR_window,1),1);
    
    %IROF
    for tw = 1 : size(IR_window,1) % 매 window마다 
        % rawdata를 그냥 저장
        raw_LOFF{tw,1} = spikes(and(spikes >= IR_window(tw,1), spikes < IR_window(tw,2)));
    end
    
    clearvars tw twb tempbin spikes
    
    if exist(strcat(pathname,'aligned_raw'),'dir') == 0 % 폴더가 존재하지 않으면
        mkdir(strcat(pathname,'aligned_raw')); % 만들어줌
    end
    % parse filename
    temp1 = strfind(filename{f},'_');
    temp2 = strfind(filename{f},'.mat');
    filename_cellnum = filename{f}(temp1(end)+1:temp2-1);
    
    %% Save Data
    % save data : original data location
    save([pathname,'\aligned_raw\',filename_cellnum,'_aligned_raw.mat'],'raw_LOFF');
    
    clearvars filename_date temp1 temp2 filename_cellnum Z 
end