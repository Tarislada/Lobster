%% AlignEvent_Separate Avoid and Escape
% A2-3 JiHoon Version
% trial�� Avoid Escape���� ������ Ư�� �̺�Ʈ ���� ���ķ� spike �����͸� ������ �� zscore�� ���, aligned_new_Avoid, aligned_new_Escape ������ ����.

AnalyticValueExtractor;

for trialtype = ['A','E']
    %% Separate ParsedData into trialtype
    ParsedData_separated = cell(sum(behaviorResult == trialtype),size(ParsedData,2));
    cellentered = 1;
    for i = 1 : size(ParsedData,1) % ��� Parsed Data�� �ϳ��� ���Ǹ鼭
        if strcmp(behaviorResult(i),trialtype) % ������ trialtype�� �´� trial �̸�, 
            for j = 1 : size(ParsedData,2) % cell�� �� �׸���� �Է�
                ParsedData_separated{cellentered,j} = ParsedData{i,j};
            end
            cellentered = cellentered + 1;
        end
    end
    clearvars cellentered i j cellentered
    %% Find Time window in each trial
    numTrial = size(ParsedData_separated,1); % �� trial ��
    timepoint_LOFF = zeros(numTrial,1); % LOFF ������ ������ ��� ����
    timepoint_IROF = zeros(numTrial,1); % IROF ������ ������ ��� ����
    timepoint_ATTK = zeros(numTrial,1); % ATTK ������ ������ ��� ����
    for t = 1 : numTrial
        %% LOFF
        if ~isempty(ParsedData_separated{t,3}) %LICK ������ ������� ������,
            temp = ParsedData_separated{t,3};
            timepoint_LOFF(t) = temp(end) + ParsedData_separated{t,1}(1); % ���� ������ LICK ������ = last LOFF �� ����.
            clearvars temp;
        else %LICK ������ ���������
            timepoint_LOFF(t) = 0;
        end

        %% IROF
        if ~isempty(ParsedData_separated{t,2}) %IR ������ ������� ������,
            temp = ParsedData_separated{t,2};
            timepoint_IROF(t) = temp(end) + ParsedData_separated{t,1}(1); % ���� ������ IR ������ = last IROF �� ����.
            clearvars temp;
        else %IR ������ ���������
            timepoint_IROF(t) = 0;  
        end

        %% ATTK
        if ~isempty(ParsedData_separated{t,4}) %LICK ������ ������� ������,
            temp = ParsedData_separated{t,4};
            timepoint_ATTK(t) = temp(1) + ParsedData_separated{t,1}(1); % ATTK ������ = first ATTK �� ����.
            clearvars temp;
        else %ATTK ������ ���������
            timepoint_ATTK(t) = 0;
        end

    end
    clearvars t ParsedData_separated numTrial
    timepoint_LOFF(timepoint_LOFF == 0) = []; % Lick �����Ͱ� ����(LICK�� ����) trial�� ����.
    timepoint_IROF(timepoint_IROF == 0) = []; % IR �����Ͱ� ����(IRON�� ����) trial�� ����.
    timepoint_ATTK(timepoint_ATTK == 0) = []; % Attack �����Ͱ� ����(ATTK�� ����) trial�� ����.
    %---- ���� ----% �� ������ trial ������ �ȸ°ų� ���� �ٸ� Event ������ �����Ͱ� �и� �� ����.
    timewindow_LOFF = [timepoint_LOFF+TIMEWINDOW_LEFT,timepoint_LOFF+TIMEWINDOW_RIGHT];
    timewindow_IROF = [timepoint_IROF+TIMEWINDOW_LEFT,timepoint_IROF+TIMEWINDOW_RIGHT];
    timewindow_ATTK = [timepoint_ATTK+TIMEWINDOW_LEFT,timepoint_ATTK+TIMEWINDOW_RIGHT];

    %% �� Unit data ���� timewindow�� ���� �����͸� �̾Ƴ�.
    for f = 1 : numel(Paths) % ������ ������ Unit Data�� ���ؼ�...
        %% Unit Data Load
        load(Paths{f}); % Unit data�� �ε�. SU ������ ����.
        spikes = table2array(SU(:,1)); % spike timestamp ���� ����.
        clearvars SU;

        %% �� timewindow ���� �ش� ������ ���ϴ� spike���� ������ Ȯ��.
        timebin_LOFF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
        timebin_IROF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
        timebin_ATTK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
        % LOFF
        for tw = 1 : numel(timepoint_LOFF) % �� window���� 
            % window�� bin���� ���� tempbin�� �����
            tempbin = linspace(timewindow_LOFF(tw,1),timewindow_LOFF(tw,2),numel(timebin_LOFF)+1);
            for twb = 1 : numel(tempbin)-1 % �� bin�� ���� spike�� ���� ����
                timebin_LOFF(twb) = timebin_LOFF(twb) + sum(and(spikes >= tempbin(twb), spikes < tempbin(twb+1)));
            end
        end
        %IROF
        for tw = 1 : numel(timepoint_IROF) % �� window���� 
            % window�� bin���� ���� tempbin�� �����
            tempbin = linspace(timewindow_IROF(tw,1),timewindow_IROF(tw,2),numel(timebin_IROF)+1);
            for twb = 1 : numel(tempbin)-1 % �� bin�� ���� spike�� ���� ����
                timebin_IROF(twb) = timebin_IROF(twb) + sum(and(spikes >= tempbin(twb), spikes < tempbin(twb+1)));
            end
        end
        %ATTK
        for tw = 1 : numel(timepoint_ATTK) % �� window���� 
            % window�� bin���� ���� tempbin�� �����
            tempbin = linspace(timewindow_ATTK(tw,1),timewindow_ATTK(tw,2),numel(timebin_ATTK)+1);
            for twb = 1 : numel(tempbin)-1 % �� bin�� ���� spike�� ���� ����
                timebin_ATTK(twb) = timebin_ATTK(twb) + sum(and(spikes >= tempbin(twb), spikes < tempbin(twb+1)));
            end
        end

        clearvars tw twb tempbin spikes

        %% calculate Zscore
        Z.LOFF = zscore(timebin_LOFF ./ numel(timepoint_LOFF)); 
        Z.IROF = zscore(timebin_IROF ./ numel(timepoint_IROF));
        Z.ATTK = zscore(timebin_ATTK ./ numel(timepoint_ATTK)); 

        if exist(strcat(pathname,'aligned_new_',trialtype),'dir') == 0 % aligned ������ �������� ������
            mkdir(strcat(pathname,'aligned_new_',trialtype)); % �������
        end
        % parse filename
        filename_date = filename{f}(strfind(filename{1},'GR7-')+6:strfind(filename{1},'GR7-')+9);
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
        if exist(p,'dir') == 0 % ������ �������� ������
            mkdir(p); % �������
        end
        save(strcat(p,'\',filename_date,'_',filename_cellnum,'_',trialtype,'_aligned.mat'),'Z');

        clearvars filename_date temp1 temp2 filename_cellnum Z
    end
    
    fprintf('1. %d ���� ������ %s�� �����Ǿ����ϴ�.\n',f,strcat(pathname,'aligned_new'));
    fprintf('2. %d ���� ������ %s�� �����Ǿ����ϴ�.\n',f,p);
    fprintf('-----------------------------------------------------------------------------\n');
end

fprintf('Avoid : %d | Escape : %d | Total : %d\n',sum(behaviorResult == 'A'), sum(behaviorResult == 'E'), numel(behaviorResult));   
fprintf('-----------------------------------------------------------------------------\n');
clearvars numIRClusters numLickClusters behaviorResult