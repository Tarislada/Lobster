%% Cut_Spikes_by_EVENT
% Using specific EVNET, Cut Spike data and save it to rawfile location

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

[ParsedData, ~, ~, ~, ~ ] = BehavDataParser(targetdir);

clearvars targetdir;

%% Find Time window in each trial
window = zeros(0,2);
for t = 1 : size(ParsedData,1)
    if isempty(ParsedData{t,3}) % No Lick
        continue % exclude data
    end
    window = [window;...
        [ParsedData{t,1}(1),... % Trial Onset
        ParsedData{t,3}(end) + ParsedData{t,1}(1)]]; % Last Lick(absolute) = Last Lick(relative) + Trial Onset
end

numTrial = size(window,1);

%% 각 Unit data 별로 데이터를 뽑아냄. 
for f = 1 : numel(Paths) % 선택한 각각의 Unit Data에 대해서...
    %% Unit Data Load
    load(Paths{f}); % Unit data를 로드. SU 파일이 존재.
    spikes = table2array(SU(:,1)); % spike timestamp 들을 저장.
    clearvars SU;
    
    %% timewindow 내에 해당하는 rawdata를 저장하기 위한 cell
    raw_LOFF = cell(size(window,1),1);
    
    %IROF
    for tw = 1 : size(window,1) % 매 window마다 
        % rawdata를 그냥 저장
        raw_LOFF{tw,1} = spikes(and(spikes >= window(tw,1), spikes < window(tw,2)));
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