%% AlignEvent
% A2-3 JiHoon Version
% Ư�� �̺�Ʈ ���� ���ķ� spike �����͸� ������ �� zscore�� ���, aligned_new ������ ����.

%% PARAMETERS
TIMEWINDOW_LEFT = -4; % �̺�Ʈ�� �������� ���� �� �����ͱ��� �������.
TIMEWINDOW_RIGHT = +4; % �̺�Ʈ�� �������� ���� �� �����͸� �������.
TIMEWINDOW_BIN = 0.1; % TIMEWINDOW�� ������ bin ũ��� �󸶷� ������.

%% Unit data ��� ����
if exist('targetfiles','var') == 0 % �̸� targetfiles�� ������ ���� ���
    [filename, pathname] = uigetfile('*.mat', 'Select Unit Data .mat', 'MultiSelect', 'on');
    if isequal(filename,0) % �������� ���� ��� ���
        clearvars filename pathname
        return;
    end
    Paths = strcat(pathname,filename);
    if (ischar(Paths))
        Paths = {Paths};
        filename = {filename};
    end
    if contains(pathname,'suc') % 'suc'�� ������ΰ� ������ ������ sucrose training �����ͷ� ����
        isSuc = true;
    else
        isSuc = false;
    end
end

%% EVENT data ��� ���� �� �ҷ�����
if exist(strcat(pathname,'EVENTS'),'dir') == 7 % ���� ��ġ�� EVENTS ������ ����
    targetdir = strcat(pathname,'EVENTS');
else
    targetdir = uigetdir('','Select EVENT folder'); % ���� ��ġ�� EVENT ������ ������ ����ڿ��� ���.
    if isequal(targetdir,0)
        clearvars targetdir
        return;
    end
end

[ParsedData, ~, ~, ~, ~] = BehavDataParser(targetdir);

clearvars targetdir;

%% Find Time window in each trial
numTrial = size(ParsedData,1); % �� trial ��
timepoint_LICK = zeros(numTrial,1); % LICK ������ ������ ��� ����
timepoint_LOFF = zeros(numTrial,1); % LOFF ������ ������ ��� ����
timepoint_IROF = zeros(numTrial,1); % IROF ������ ������ ��� ����
timepoint_ATTK = zeros(numTrial,1); % ATTK ������ ������ ��� ����
for t = 1 : numTrial
    %% LICK
    if ~isempty(ParsedData{t,3}) %LICK ������ ������� ������,
        temp = ParsedData{t,3};
        timepoint_LICK(t) = temp(1) + ParsedData{t,1}(1); % ���� ó���� LICK ������ = first LICK�� ����.
        clearvars temp;
    else %LICK ������ ���������
        timepoint_LICK(t) = 0;
    end
    
    %% LOFF
    if ~isempty(ParsedData{t,3}) %LICK ������ ������� ������,
        temp = ParsedData{t,3};
        timepoint_LOFF(t) = temp(end) + ParsedData{t,1}(1); % ���� ������ LICK ������ = last LOFF �� ����.
        clearvars temp;
    else %LICK ������ ���������
        timepoint_LOFF(t) = 0;
    end
    
    %% IROF
    if ~isempty(ParsedData{t,2}) %IR ������ ������� ������,
        temp = ParsedData{t,2};
        timepoint_IROF(t) = temp(end) + ParsedData{t,1}(1); % ���� ������ IR ������ = last IROF �� ����.
        clearvars temp;
    else %IR ������ ���������
        timepoint_IROF(t) = 0;  
    end
    
    %% ATTK
    if ~isempty(ParsedData{t,4}) %ATTK ������ ������� ������,
        temp = ParsedData{t,4};
        timepoint_ATTK(t) = temp(1) + ParsedData{t,1}(1); % ATTK ������ = first ATTK �� ����.
        clearvars temp;
    else %ATTK ������ ���������
        timepoint_ATTK(t) = 0;
    end
    
end
clearvars t numTrial
timepoint_LICK(timepoint_LICK == 0) = []; % Lick �����Ͱ� ����(LICK�� ����) trial�� ����.
timepoint_LOFF(timepoint_LOFF == 0) = []; % Lick �����Ͱ� ����(LICK�� ����) trial�� ����.
timepoint_IROF(timepoint_IROF == 0) = []; % IR �����Ͱ� ����(IRON�� ����) trial�� ����.
timepoint_ATTK(timepoint_ATTK == 0) = []; % Attack �����Ͱ� ����(ATTK�� ����) trial�� ����.
%---- ���� ----% �� ������ trial ������ �ȸ°ų� ���� �ٸ� Event ������ �����Ͱ� �и� �� ����.
timewindow_LICK = [timepoint_LICK+TIMEWINDOW_LEFT,timepoint_LICK+TIMEWINDOW_RIGHT];
timewindow_LOFF = [timepoint_LOFF+TIMEWINDOW_LEFT,timepoint_LOFF+TIMEWINDOW_RIGHT];
timewindow_IROF = [timepoint_IROF+TIMEWINDOW_LEFT,timepoint_IROF+TIMEWINDOW_RIGHT];
timewindow_ATTK = [timepoint_ATTK+TIMEWINDOW_LEFT,timepoint_ATTK+TIMEWINDOW_RIGHT];

%% �� Unit data ���� �����͸� �̾Ƴ�. 
for f = 1 : numel(Paths) % ������ ������ Unit Data�� ���ؼ�...
    %% Unit Data Load
    load(Paths{f}); % Unit data�� �ε�. SU ������ ����.
    spikes = table2array(SU(:,1)); % spike timestamp ���� ����.
    clearvars SU;
    
    % Get sudo session firing rate
    Z.FR = numel(spikes) / (spikes(end) - spikes(1));
    % Since this script uses Unit data.mat's SU variable,
    % the starting point and the ending point of the session can not be
    % retrived. So instead of using {(num spike) / (total exp time)},
    % this script uses {(num spike) / (last spike time - first spike time)}.
    
    %% timewindow�� TIMEWINDOW_BIN���� ���� timebin_* ������ ����.
    timebin_LICK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
    timebin_LOFF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
    timebin_IROF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
    timebin_ATTK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
    
    % LICK
    for tw = 1 : numel(timepoint_LICK) % �� window���� 
        % window�� bin���� ���� tempbin�� �����
        tempbin = linspace(timewindow_LICK(tw,1),timewindow_LICK(tw,2),numel(timebin_LICK)+1);
        for twb = 1 : numel(tempbin)-1 % �� bin�� ���� spike�� ���� ����
            timebin_LICK(twb) = timebin_LICK(twb) + sum(and(spikes >= tempbin(twb), spikes < tempbin(twb+1)));
        end
    end
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
    Z.LICK = zscore(timebin_LICK ./ numel(timepoint_LICK)); 
    Z.LOFF = zscore(timebin_LOFF ./ numel(timepoint_LOFF)); 
    Z.IROF = zscore(timebin_IROF ./ numel(timepoint_IROF));
    Z.ATTK = zscore(timebin_ATTK ./ numel(timepoint_ATTK)); 
    
    %% Calculate firing rate
    Z.LICK_fr = sum(timebin_LICK) ./ ((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*numel(timepoint_LICK));
    Z.LOFF_fr = sum(timebin_LOFF) ./ ((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*numel(timepoint_LOFF));
    Z.IROF_fr = sum(timebin_IROF) ./ ((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*numel(timepoint_IROF));
    Z.ATTK_fr = sum(timebin_ATTK) ./ ((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*numel(timepoint_ATTK));
    
    if exist(strcat(pathname,'aligned_new'),'dir') == 0 % aligned ������ �������� ������
        mkdir(strcat(pathname,'aligned_new')); % �������
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
    
    if isSuc % Sucrose trial �̸�
        p = strcat(p3,'processedData','\Suc'); % Suc�� ����
        clearvars p1 p2 p3
        if exist(p,'dir') == 0 % ������ �������� ������
            mkdir(p); % �������
        end
        save(strcat(p,'\',filename_date,'_',filename_cellnum,'_aligned.mat'),'Z');
    else % Sucrose trial�� �ƴϸ�
        p = strcat(p3,'processedData','\All'); % All�� ����
        clearvars p1 p2 p3
        if exist(p,'dir') == 0 % ������ �������� ������
            mkdir(p); % �������
        end
        save(strcat(p,'\',filename_date,'_',filename_cellnum,'_aligned.mat'),'Z');
    end
    clearvars filename_date temp1 temp2 filename_cellnum Z 
end

fprintf('1. %d ���� ������ %s�� �����Ǿ����ϴ�.\n',f,strcat(pathname,'aligned_new'));
fprintf('2. %d ���� ������ %s�� �����Ǿ����ϴ�.\n',f,p);
fprintf('-----------------------------------------------------------------------------\n');

if ~isSuc
    subAlignEvent_separateAE
end
fprintf('==============================================================================\n');
clearvars f time* TIME* filename pathname Paths ParsedData