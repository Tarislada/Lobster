%% AlignEvent
% A2-3 JiHoon Version
% 특정 이벤트 시점 전후로 spike 데이터를 정렬한 후 zscore를 계산, aligned_new 폴더에 저장.

%% PARAMETERS
TIMEWINDOW_LEFT = -4; % 이벤트를 기점으로 몇초 전 데이터까지 사용할지.
TIMEWINDOW_RIGHT = +4; % 이벤트를 기점으로 몇포 후 데이터를 사용할지.
TIMEWINDOW_BIN = 0.1; % TIMEWINDOW의 각각의 bin 크기는 얼마로 잡을지.

%% Unit data 경로 선택
if exist('targetfiles','var') == 0 % 미리 targetfiles를 정하지 않은 경우
    [filename, pathname] = uigetfile('*.mat', 'MultiSelect', 'on');
    if isequal(filename,0) % 선택하지 않은 경우 취소
        return;
    end
    Paths = strcat(pathname,filename);
    if (ischar(Paths))
        Paths = {Paths};
        filename = {filename};
    end
    if contains(pathname,'suc') % 'suc'을 폴더경로가 가지고 있으면 sucrose training 데이터로 간주
        isSuc = true;
    else
        isSuc = false;
    end
end

%% EVENT data 경로 선택 및 불러오기
if exist(strcat(pathname,'EVENTS'),'dir') == 7 % 같은 위치에 EVENTS 폴더가 있음
    targetdir = strcat(pathname,'EVENTS');
else
    targetdir = uigetdir(); % 같은 위치에 EVENT 폴더가 없으면 사용자에게 물어봄.
    if isequal(targetdir,0)
        return;
    end
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
%---- 주의 ----% 이 때문에 trial 갯수와 안맞거나 서로 다른 Event 끼리는 데이터가 밀릴 수 있음.
timewindow_LICK = [timepoint_LICK+TIMEWINDOW_LEFT,timepoint_LICK+TIMEWINDOW_RIGHT];
timewindow_LOFF = [timepoint_LOFF+TIMEWINDOW_LEFT,timepoint_LOFF+TIMEWINDOW_RIGHT];
timewindow_IROF = [timepoint_IROF+TIMEWINDOW_LEFT,timepoint_IROF+TIMEWINDOW_RIGHT];
timewindow_ATTK = [timepoint_ATTK+TIMEWINDOW_LEFT,timepoint_ATTK+TIMEWINDOW_RIGHT];

%% 각 Unit data 별로 timewindow에 들어가는 데이터를 뽑아냄.
for f = 1 : numel(Paths) % 선택한 각각의 Unit Data에 대해서...
    %% Unit Data Load
    load(Paths{f}); % Unit data를 로드. SU 파일이 존재.
    spikes = table2array(SU(:,1)); % spike timestamp 들을 저장.
    clearvars SU;

    %% 각 timewindow 마다 해당 구간에 속하는 spike들을 모조리 확인.
    timebin_LICK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
    timebin_LOFF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
    timebin_IROF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
    timebin_ATTK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
    % LICK
    for tw = 1 : numel(timepoint_LICK) % 매 window마다 
        % window를 bin으로 나눈 tempbin을 만들고
        tempbin = linspace(timewindow_LICK(tw,1),timewindow_LICK(tw,2),numel(timebin_LICK)+1);
        for twb = 1 : numel(tempbin)-1 % 각 bin에 들어가는 spike의 수를 센다
            timebin_LICK(twb) = timebin_LICK(twb) + sum(and(spikes >= tempbin(twb), spikes < tempbin(twb+1)));
        end
    end
    % LOFF
    for tw = 1 : numel(timepoint_LOFF) % 매 window마다 
        % window를 bin으로 나눈 tempbin을 만들고
        tempbin = linspace(timewindow_LOFF(tw,1),timewindow_LOFF(tw,2),numel(timebin_LOFF)+1);
        for twb = 1 : numel(tempbin)-1 % 각 bin에 들어가는 spike의 수를 센다
            timebin_LOFF(twb) = timebin_LOFF(twb) + sum(and(spikes >= tempbin(twb), spikes < tempbin(twb+1)));
        end
    end
    %IROF
    for tw = 1 : numel(timepoint_IROF) % 매 window마다 
        % window를 bin으로 나눈 tempbin을 만들고
        tempbin = linspace(timewindow_IROF(tw,1),timewindow_IROF(tw,2),numel(timebin_IROF)+1);
        for twb = 1 : numel(tempbin)-1 % 각 bin에 들어가는 spike의 수를 센다
            timebin_IROF(twb) = timebin_IROF(twb) + sum(and(spikes >= tempbin(twb), spikes < tempbin(twb+1)));
        end
    end
    %ATTK
    for tw = 1 : numel(timepoint_ATTK) % 매 window마다 
        % window를 bin으로 나눈 tempbin을 만들고
        tempbin = linspace(timewindow_ATTK(tw,1),timewindow_ATTK(tw,2),numel(timebin_ATTK)+1);
        for twb = 1 : numel(tempbin)-1 % 각 bin에 들어가는 spike의 수를 센다
            timebin_ATTK(twb) = timebin_ATTK(twb) + sum(and(spikes >= tempbin(twb), spikes < tempbin(twb+1)));
        end
    end
    
    clearvars tw twb tempbin spikes
    
    %% calculate Zscore
    Z.LICK = zscore(timebin_LICK ./ numel(timepoint_LICK)); 
    Z.LOFF = zscore(timebin_LOFF ./ numel(timepoint_LOFF)); 
    Z.IROF = zscore(timebin_IROF ./ numel(timepoint_IROF));
    Z.ATTK = zscore(timebin_ATTK ./ numel(timepoint_ATTK)); 
    
    if exist(strcat(pathname,'aligned_new'),'dir') == 0 % aligned 폴더가 존재하지 않으면
        mkdir(strcat(pathname,'aligned_new')); % 만들어줌
    end
    % parse filename
    filename_date = filename{f}(strfind(filename{1},'GR7-')+6:strfind(filename{1},'GR7-')+9);
    temp1 = strfind(filename{f},'_');
    temp2 = strfind(filename{f},'.mat');
    filename_cellnum = filename{f}(temp1(end)+1:temp2-1);
    
    %% Save Data
    % save data : original data location
    save([pathname,'\aligned_new\',filename_date,'_',filename_cellnum,'_aligned.mat'],'Z');
    % save data : outer 'processed data' location
    p1 = find(pathname=='\');
    p2 = p1(end-2);
    p3 = pathname(1:p2);
    
    if isSuc 
        p = strcat(p3,'processedData','\Suc');
        clearvars p1 p2 p3
        if exist(p,'dir') == 0 % 폴더가 존재하지 않으면
            mkdir(p); % 만들어줌
        end
        save(strcat(p,'\',filename_date,'_',filename_cellnum,'_aligned.mat'),'Z');
    else
        p = strcat(p3,'processedData','\All');
        clearvars p1 p2 p3
        if exist(p,'dir') == 0 % 폴더가 존재하지 않으면
            mkdir(p); % 만들어줌
        end
        save(strcat(p,'\',filename_date,'_',filename_cellnum,'_aligned.mat'),'Z');
    end
    clearvars filename_date temp1 temp2 filename_cellnum Z 
end

fprintf('1. %d 개의 파일이 %s에 생성되었습니다.\n',f,strcat(pathname,'aligned_new'));
fprintf('2. %d 개의 파일이 %s에 생성되었습니다.\n',f,p);
fprintf('-----------------------------------------------------------------------------\n');

if ~isSuc
    subAlignEvent_separateAE
end
fprintf('==============================================================================\n');
clearvars f time* TIME* filename pathname Paths ParsedData