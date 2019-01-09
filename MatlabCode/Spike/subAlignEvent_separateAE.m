%% AlignEvent_Separate Avoid and Escape
% Subscript of AlignEvent script
% trial을 Avoid Escape으로 나누고 특정 이벤트 시점 전후로 spike 데이터를 정렬한 후 zscore를 계산, aligned_new_Avoid, aligned_new_Escape 폴더에 저장.
% 2018 Knowblesse

behaviorResult = AnalyticValueExtractor(ParsedData,false, false);
TYPE = ['A','E'];
for trialtype = TYPE
    %% Separate ParsedData into trialtype
    ParsedData_separated = cell(sum(behaviorResult == trialtype),size(ParsedData,2));
    cellentered = 1;
    for i = 1 : size(ParsedData,1) % 모든 Parsed Data를 하나씩 살피면서
        if strcmp(behaviorResult(i),trialtype) % 선택한 trialtype에 맞는 trial 이면, 
            for j = 1 : size(ParsedData,2) % cell의 각 항목들을 입력
                ParsedData_separated{cellentered,j} = ParsedData{i,j};
            end
            cellentered = cellentered + 1;
        end
    end
    clearvars cellentered i j cellentered
    %% Find Time window in each trial
    numTrial = size(ParsedData_separated,1); % 총 trial 수
    timepoint_IRON = zeros(numTrial,1); % IRON 시점의 정보를 담는 변수
    timepoint_LICK = zeros(numTrial,1); % LICK 시점의 정보를 담는 변수
    timepoint_LOFF = zeros(numTrial,1); % LOFF 시점의 정보를 담는 변수
    timepoint_IROF = zeros(numTrial,1); % IROF 시점의 정보를 담는 변수
    timepoint_ATTK = zeros(numTrial,1); % ATTK 시점의 정보를 담는 변수
    for t = 1 : numTrial
       %% IRON
        if ~isempty(ParsedData{t,2}) %IR 정보가 비어있지 않으면,
            temp = ParsedData{t,2};
            timepoint_IRON(t) = temp(1) + ParsedData{t,1}(1); % 가장 처음의 LICK 데이터 = first LICK을 대입.
            clearvars temp;
        else %IR 정보가 비어있으면
            timepoint_IRON(t) = 0;
        end
        %% LICK
        if ~isempty(ParsedData{t,3}) %LICK 정보가 비어있지 않으면,
            temp = ParsedData{t,3};
            timepoint_LICK(t) = temp(1) + ParsedData{t,1}(1); % 가장 처음의 LICK 데이터 = first LICK을 대입.
            clearvars temp;
        else %LICK 정보가 비어있으면
            timepoint_LICK(t) = 0;
        end
        %% LOFF
        if ~isempty(ParsedData_separated{t,3}) %LICK 정보가 비어있지 않으면,
            temp = ParsedData_separated{t,3};
            timepoint_LOFF(t) = temp(end) + ParsedData_separated{t,1}(1); % 가장 마지막 LICK 데이터 = last LOFF 를 대입.
            clearvars temp;
        else %LICK 정보가 비어있으면
            timepoint_LOFF(t) = 0;
        end

        %% IROF
        if ~isempty(ParsedData_separated{t,2}) %IR 정보가 비어있지 않으면,
            temp = ParsedData_separated{t,2};
            timepoint_IROF(t) = temp(end) + ParsedData_separated{t,1}(1); % 가장 마지막 IR 데이터 = last IROF 를 대입.
            clearvars temp;
        else %IR 정보가 비어있으면
            timepoint_IROF(t) = 0;  
        end

        %% ATTK
        if ~isempty(ParsedData_separated{t,4}) %LICK 정보가 비어있지 않으면,
            temp = ParsedData_separated{t,4};
            timepoint_ATTK(t) = temp(1) + ParsedData_separated{t,1}(1); % ATTK 데이터 = first ATTK 를 대입.
            clearvars temp;
        else %ATTK 정보가 비어있으면
            timepoint_ATTK(t) = 0;
        end

    end
    clearvars t ParsedData_separated numTrial
    % Lick 데이터가 없는(LICK이 없는) trial은 날림.
    timepoint_IRON(timepoint_LICK == 0) = [];
    timepoint_LICK(timepoint_LICK == 0) = []; 
    timepoint_LOFF(timepoint_LICK == 0) = [];
    timepoint_IROF(timepoint_LICK == 0) = [];
    timepoint_ATTK(timepoint_LICK == 0) = [];
    %---- 주의 ----% 이 때문에 trial 갯수와 안맞거나 서로 다른 Event 끼리는 데이터가 밀릴 수 있음.
    timewindow_IRON = [timepoint_IRON+TIMEWINDOW_LEFT,timepoint_IRON+TIMEWINDOW_RIGHT];
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
        
        % Get sudo session firing rate
        Z.FR = numel(spikes) / (spikes(end) - spikes(1));
        % Since this script uses Unit data.mat's SU variable,
        % the starting point and the ending point of the session can not be
        % retrived. So instead of using {(num spike) / (total exp time)},
        % this script uses {(num spike) / (last spike time - first spike time)}.
        
        %% 각 timewindow 마다 해당 구간에 속하는 spike들을 모조리 확인.
        timebin_IRON = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
        timebin_LICK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
        timebin_LOFF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
        timebin_IROF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
        timebin_ATTK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
        
        %% timewindow 내에 해당하는 rawdata를 저장하기 위한 cell
        raw_IRON = cell(numel(timepoint_IRON),1);
        raw_IROF = cell(numel(timepoint_IROF),1);
    
        % IRON
        for tw = 1 : numel(timepoint_IRON) % 매 window마다 
            % window를 bin으로 나눈 tempbin을 만들고
            tempbin = linspace(timewindow_IRON(tw,1),timewindow_IRON(tw,2),numel(timebin_IRON)+1);
            for twb = 1 : numel(tempbin)-1 % 각 bin에 들어가는 spike의 수를 센다
                timebin_IRON(twb) = timebin_IRON(twb) + sum(and(spikes >= tempbin(twb), spikes < tempbin(twb+1)));
            end
            % rawdata를 그냥 저장
            raw_IRON{tw,1} = spikes(and(spikes >= timewindow_IRON(tw,1), spikes < timewindow_IRON(tw,2)))...
                - timewindow_IRON(tw,1);
        end
        
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
            % rawdata를 그냥 저장
            raw_IROF{tw,1} = spikes(and(spikes >= timewindow_IROF(tw,1), spikes < timewindow_IROF(tw,2)))...
                - timewindow_IROF(tw,1);
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
        Z.IRON = zscore(timebin_IRON ./ numel(timepoint_IRON)); 
        Z.LICK = zscore(timebin_LICK ./ numel(timepoint_LICK));
        Z.LOFF = zscore(timebin_LOFF ./ numel(timepoint_LOFF)); 
        Z.IROF = zscore(timebin_IROF ./ numel(timepoint_IROF));
        Z.ATTK = zscore(timebin_ATTK ./ numel(timepoint_ATTK)); 
       
        %% Calculate raw firingrate with moving window
        Z.raw_IRON = raw_IRON;
        Z.raw_IROF = raw_IROF;
        
        %% Calculate firing rate
        Z.LICK_fr = sum(timebin_LICK) ./ ((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*numel(timepoint_LICK));
        Z.LOFF_fr = sum(timebin_LOFF) ./ ((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*numel(timepoint_LOFF));
        Z.IROF_fr = sum(timebin_IROF) ./ ((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*numel(timepoint_IROF));
        Z.ATTK_fr = sum(timebin_ATTK) ./ ((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*numel(timepoint_ATTK));

        if exist(strcat(pathname,'aligned_new_',trialtype),'dir') == 0 % aligned 폴더가 존재하지 않으면
            mkdir(strcat(pathname,'aligned_new_',trialtype)); % 만들어줌
        end
        % find subject name of the file
        sname = regexp(filename{f}, 'GR\d(\d)?-','match');
        % parse filename
        filename_date = filename{f}(strfind(filename{f},sname)+6:strfind(filename{f},sname)+9);
        temp1 = strfind(filename{f},'_');
        temp2 = strfind(filename{f},'.mat');
        filename_cellnum = filename{f}(temp1(end)+1:temp2-1);
        
       %% Save Data
        % save data : original data location
        save([pathname,'\aligned_new_',trialtype,'\',filename_date,'_',filename_cellnum,'_',trialtype,'_aligned.mat'],'Z');
        % save data : outer 'processed data' location
        p1 = find(pathname=='\');
        p2 = p1(end-2);
        p3 = pathname(1:p2);

        p = strcat(p3,'processedData','\',trialtype);
        clearvars p1 p2 p3
        if exist(p,'dir') == 0 % 폴더가 존재하지 않으면
            mkdir(p); % 만들어줌
        end
        save(strcat(p,'\',filename_date,'_',filename_cellnum,'_',trialtype,'_aligned.mat'),'Z');

        clearvars filename_date temp1 temp2 filename_cellnum Z
    end
    
    fprintf('1. %d 개의 파일이 %s에 생성되었습니다.\n',f,strcat(pathname,'aligned_new'));
    fprintf('2. %d 개의 파일이 %s에 생성되었습니다.\n',f,p);
    fprintf('-----------------------------------------------------------------------------\n');
end
for ev = TYPE
    fprintf('%c : %d | ', ev, sum(behaviorResult == ev));
end
fprintf('Total : %d\n',numel(behaviorResult));   
fprintf('-----------------------------------------------------------------------------\n');
clearvars numIRClusters numLickClusters behaviorResult