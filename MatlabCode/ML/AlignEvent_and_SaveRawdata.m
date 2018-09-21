%% AlignEvent
% A2-3 JiHoon Version
% 특정 이벤트 시점 전후로 spike 데이터를 정렬한 후 zscore를 계산, aligned_new 폴더에 저장.

%% PARAMETERS
TIMEWINDOW_LEFT = -4; % 이벤트를 기점으로 몇초 전 데이터까지 사용할지.
TIMEWINDOW_RIGHT = +4; % 이벤트를 기점으로 몇포 후 데이터를 사용할지.
TIMEWINDOW_BIN = 0.05; % TIMEWINDOW의 각각의 bin 크기는 얼마로 잡을지.

%% Unit data 경로 선택
if exist('targetfiles','var') == 0 % 미리 targetfiles를 정하지 않은 경우
    [filename, pathname] = uigetfile('*.mat', 'Select Unit Data .mat', 'MultiSelect', 'on');
    if isequal(filename,0) % 선택하지 않은 경우 취소
        clearvars filename pathname
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
    targetdir = uigetdir('','Select EVENT folder'); % 같은 위치에 EVENT 폴더가 없으면 사용자에게 물어봄.
    if isequal(targetdir,0)
        clearvars targetdir
        return;
    end
end

[ParsedData, Trials, IRs, Licks, Attacks ] = BehavDataParser(targetdir);

clearvars targetdir;

%% Find Time window in each trial
numTrial = size(ParsedData,1); % 총 trial 수
timepoint_LICK = zeros(numTrial,1); % LICK 시점의 정보를 담는 변수
timepoint_IROF = zeros(numTrial,1); % IROF 시점의 정보를 담는 변수
for t = 1 : numTrial
     %% LICK
    if ~isempty(ParsedData{t,3}) %LICK 정보가 비어있지 않으면,
        temp = ParsedData{t,3};
        timepoint_LICK(t) = temp(1) + ParsedData{t,1}(1); % 가장 처음의 LICK 데이터 = first LICK을 대입.
        clearvars temp;
    else %LICK 정보가 비어있으면
        timepoint_LICK(t) = 0;
    end
    %% IROF
    if ~isempty(ParsedData{t,2}) %IR 정보가 비어있지 않으면,
        temp = ParsedData{t,2};
        timepoint_IROF(t) = temp(end) + ParsedData{t,1}(1); % 가장 마지막 IR 데이터 = last IROF 를 대입.
        clearvars temp;
    else %IR 정보가 비어있으면
        timepoint_IROF(t) = 0;  
    end    
end
clearvars t numTrial

timepoint_IROF(timepoint_LICK == 0) = []; % IR 데이터가 없는(IRON이 없는) trial은 날림.

timewindow_IROF = [timepoint_IROF+TIMEWINDOW_LEFT,timepoint_IROF+TIMEWINDOW_RIGHT];

%% 각 Unit data 별로 데이터를 뽑아냄. 
for f = 1 : numel(Paths) % 선택한 각각의 Unit Data에 대해서...
    %% Unit Data Load
    load(Paths{f}); % Unit data를 로드. SU 파일이 존재.
    spikes = table2array(SU(:,1)); % spike timestamp 들을 저장.
    clearvars SU;
    
    %% timewindow를 TIMEWINDOW_BIN으로 나눈 timebin_* 변수를 생성.
    timebin_IROF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
    
    %% timewindow 내에 해당하는 rawdata를 저장하기 위한 cell
    raw_IROF = cell(numel(timepoint_IROF),1);
    
    %IROF
    for tw = 1 : numel(timepoint_IROF) % 매 window마다 
        % rawdata를 그냥 저장
        raw_IROF{tw,1} = spikes(and(spikes >= timewindow_IROF(tw,1), spikes < timewindow_IROF(tw,2)))...
            - timewindow_IROF(tw,1);
    end
    
    clearvars tw twb tempbin spikes
    
    %% Calculate raw firingrate with moving window
    Z.raw_IROF = raw_IROF;
    
    if exist(strcat(pathname,'aligned_raw'),'dir') == 0 % aligned 폴더가 존재하지 않으면
        mkdir(strcat(pathname,'aligned_raw')); % 만들어줌
    end
    % parse filename
    temp1 = strfind(filename{f},'_');
    temp2 = strfind(filename{f},'.mat');
    filename_cellnum = filename{f}(temp1(end)+1:temp2-1);
    
    %% Save Data
    % save data : original data location
    save([pathname,'\aligned_raw\',filename_cellnum,'_aligned_raw.mat'],'Z');
    
    clearvars filename_date temp1 temp2 filename_cellnum Z 
end

fprintf('%d 개의 파일이 %s에 생성되었습니다.\n',f,strcat(pathname,'aligned_new'));

fprintf('==============================================================================\n');
clearvars f time* TIME* filename pathname Paths ParsedData