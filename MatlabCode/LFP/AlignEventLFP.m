%% AlignEventLFP
% Align LFP data to first LICK, last LOFF, last IROF, first ATTK
% 2018-AUG-20 Knowblesse

%% PARAMETERS
TIMEWINDOW_LEFT = -4; % 이벤트를 기점으로 몇초 전 데이터까지 사용할지.
TIMEWINDOW_RIGHT = +4; % 이벤트를 기점으로 몇포 후 데이터를 사용할지.
fs = 1018;

%% Get EVENT Folder Location
if ~exist('targetdir','var')
    targetdir = uigetdir('','EVENT file location'); 
end
[ParsedData, ~, ~, ~, ~] = BehavDataParser(targetdir);

clearvars targetdir;

%% Find Time window in each trial
numTrial = size(ParsedData,1); % 총 trial 수
timepoint_LICK = zeros(numTrial,1); % LICK 시점의 정보를 담는 변수
timepoint_LOFF = zeros(numTrial,1); % LOFF 시점의 정보를 담는 변수
timepoint_IROF = zeros(numTrial,1); % IROF 시점의 정보를 담는 변수
timepoint_ATTK = zeros(numTrial,1); % ATTK 시점의 정보를 담는 변수
for t = 1 : numTrial
    %% LICK
    if ~isempty(ParsedData{t,3}) %LICK 정보가 비어있지 않으면,
        temp = ParsedData{t,3};
        timepoint_LICK(t) = temp(1) + ParsedData{t,1}(1); % 가장 처음의 LICK 데이터 = first LICK을 대입.
        clearvars temp;
    else %LICK 정보가 비어있으면
        timepoint_LICK(t) = 0;
    end
    
    %% LOFF
    if ~isempty(ParsedData{t,3}) %LICK 정보가 비어있지 않으면,
        temp = ParsedData{t,3};
        timepoint_LOFF(t) = temp(end) + ParsedData{t,1}(1); % 가장 마지막 LICK 데이터 = last LOFF 를 대입.
        clearvars temp;
    else %LICK 정보가 비어있으면
        timepoint_LOFF(t) = 0;
    end
    
    %% IROF
    if ~isempty(ParsedData{t,2}) %IR 정보가 비어있지 않으면,
        temp = ParsedData{t,2};
        timepoint_IROF(t) = temp(end) + ParsedData{t,1}(1); % 가장 마지막 IR 데이터 = last IROF 를 대입.
        clearvars temp;
    else %IR 정보가 비어있으면
        timepoint_IROF(t) = 0;  
    end
    
    %% ATTK
    if ~isempty(ParsedData{t,4}) %LICK 정보가 비어있지 않으면,
        temp = ParsedData{t,4};
        timepoint_ATTK(t) = temp(1) + ParsedData{t,1}(1); % ATTK 데이터 = first ATTK 를 대입.
        clearvars temp;
    else %ATTK 정보가 비어있으면
        timepoint_ATTK(t) = 0;
    end
    
end
clearvars t numTrial
timepoint_LICK(timepoint_LICK == 0) = []; % Lick 데이터가 없는(LICK이 없는) trial은 날림.
timepoint_LOFF(timepoint_LOFF == 0) = []; % Lick 데이터가 없는(LICK이 없는) trial은 날림.
timepoint_IROF(timepoint_IROF == 0) = []; % IR 데이터가 없는(IRON이 없는) trial은 날림.
timepoint_ATTK(timepoint_ATTK == 0) = []; % Attack 데이터가 없는(ATTK가 없는) trial은 날림.

%% Load LFP mat file
if ~exist('LFPmatPath','var')
    [filename, pathname] = uigetfile('*.mat','LFP.mat File Location');
    LFPmatPath = strcat(pathname,filename);
end
load(LFPmatPath);
clearvars LFPmatPath;

%% 각 timewindow 마다 해당 구간에 속하는 lfp data들을 모조리 확인.

lfp_LICK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_LICK),16);
lfp_LOFF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_LOFF),16);
lfp_IROF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_IROF),16);
lfp_ATTK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_ATTK),16);

% LICK
for tw = 1 : numel(timepoint_LICK) % 매 timepoint마다 
    [~,ind] = min(abs(TIME - (timepoint_LICK(tw)+TIMEWINDOW_LEFT)));
    for ch = 1 : 16
        lfp_LICK(:,tw,ch) = LFP(ind:ind+size(lfp_LICK,1)-1,ch);
    end
end
% LOFF
for tw = 1 : numel(timepoint_LOFF) % 매 timepoint마다 
    [~,ind] = min(abs(TIME - (timepoint_LOFF(tw)+TIMEWINDOW_LEFT)));
    for ch = 1 : 16
        lfp_LOFF(:,tw,ch) = LFP(ind:ind+size(lfp_LOFF,1)-1,ch);
    end
end
% IROF
for tw = 1 : numel(timepoint_IROF) % 매 timepoint마다 
    [~,ind] = min(abs(TIME - (timepoint_IROF(tw)+TIMEWINDOW_LEFT)));
    for ch = 1 : 16
        lfp_IROF(:,tw,ch) = LFP(ind:ind+size(lfp_IROF,1)-1,ch);
    end
end
% ATTK
for tw = 1 : numel(timepoint_ATTK) % 매 timepoint마다 
    [~,ind] = min(abs(TIME - (timepoint_ATTK(tw)+TIMEWINDOW_LEFT)));
    for ch = 1 : 16
        lfp_ATTK(:,tw,ch) = LFP(ind:ind+size(lfp_ATTK,1)-1,ch);
    end
end

clearvars filename ch fs FS ind LFP pathname TIME timepoint_* TIME* tw
