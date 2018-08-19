targetdir = uigetdir(); % 같은 위치에 EVENT 폴더가 없으면 사용자에게 물어봄.
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


load('C:\VCF\Lobster\data\processedData\lfp\0613.mat');

%% 각 timewindow 마다 해당 구간에 속하는 spike들을 모조리 확인.

%% PARAMETERS
TIMEWINDOW_LEFT = -4; % 이벤트를 기점으로 몇초 전 데이터까지 사용할지.
TIMEWINDOW_RIGHT = +4; % 이벤트를 기점으로 몇포 후 데이터를 사용할지.
TIMEWINDOW_BIN = 0.1; % TIMEWINDOW의 각각의 bin 크기는 얼마로 잡을지.

fs = sum(TIME<1); % 정수 fs를 만듦.
ltp_LICK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_LICK),16);
ltp_LOFF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_LOFF),16);
ltp_IROF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_IROF),16);
ltp_ATTK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_ATTK),16);

% LICK
for tw = 1 : numel(timepoint_LICK) % 매 timepoint마다 
    for ch = 1 : 16
        [~,ind] = min(abs(TIME - (timepoint_LICK(1)+TIMEWINDOW_LEFT)));
        ltp_LICK(:,tw,ch) = LFP(ind:ind+size(ltp_LICK,1)-1,ch);
    end
end
% LOFF
for tw = 1 : numel(timepoint_LOFF) % 매 timepoint마다 
    for ch = 1 : 16
        [~,ind] = min(abs(TIME - (timepoint_LOFF(1)+TIMEWINDOW_LEFT)));
        ltp_LOFF(:,tw,ch) = LFP(ind:ind+size(ltp_LOFF,1)-1,ch);
    end
end
% IROF
for tw = 1 : numel(timepoint_IROF) % 매 timepoint마다 
    for ch = 1 : 16
        [~,ind] = min(abs(TIME - (timepoint_IROF(1)+TIMEWINDOW_LEFT)));
        ltp_IROF(:,tw,ch) = LFP(ind:ind+size(ltp_IROF,1)-1,ch);
    end
end
% ATTK
for tw = 1 : numel(timepoint_ATTK) % 매 timepoint마다 
    for ch = 1 : 16
        [~,ind] = min(abs(TIME - (timepoint_ATTK(1)+TIMEWINDOW_LEFT)));
        ltp_ATTK(:,tw,ch) = LFP(ind:ind+size(ltp_ATTK,1)-1,ch);
    end
end

figure(2)
for i = 1 : 5
    subplot(5,1,i);
    plot(mean(ltp_IROF(:,:,i),2));
    hold on;
    line([size(ltp_IROF,1)/2,size(ltp_IROF,1)/2],ylim);
end
