%% AlignEvent
% A2-3 JiHoon Version
% Ư�� �̺�Ʈ ���� ���ķ� spike �����͸� ������ �� zscore�� ���, aligned_new ������ ����.

%% PARAMETERS
TIMEWINDOW_LEFT = -4; % �̺�Ʈ�� �������� ���� �� �����ͱ��� �������.
TIMEWINDOW_RIGHT = +4; % �̺�Ʈ�� �������� ���� �� �����͸� �������.
TIMEWINDOW_BIN = 0.1; % TIMEWINDOW�� ������ bin ũ��� �󸶷� ������.


%% Unit data ��� ����
[filename, pathname] = uigetfile('C:\VCF\Lobster\data\rawdata\*.mat', 'MultiSelect', 'on');
if isequal(filename,0) % �������� ���� ��� ���
    return;
end
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

%% EVENT data ��� ���� �� �ҷ�����
if exist(strcat(pathname,'EVENTS'),'dir') == 7 % ���� ��ġ�� EVENTS ������ ����
    targetdir = strcat(pathname,'EVENTS');
else
    targetdir = uigetdir(); % ���� ��ġ�� EVENT ������ ������ ����ڿ��� ���.
    if isequal(targetdir,0)
        return;
    end
end

[ParsedData, ~, ~, ~, ~] = BehavDataParser(targetdir);

clearvars targetdir;

%% Find Time window in each trial
numTrial = size(ParsedData,1); % �� trial ��
timepoint_LOFF = zeros(numTrial,1); % LOFF ������ ������ ��� ����
timepoint_IROF = zeros(numTrial,1); % IROF ������ ������ ��� ����
timepoint_ATTK = zeros(numTrial,1); % ATTK ������ ������ ��� ����
for t = 1 : numTrial
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
    if ~isempty(ParsedData{t,4}) %LICK ������ ������� ������,
        temp = ParsedData{t,4};
        timepoint_ATTK(t) = temp(1) + ParsedData{t,1}(1); % ATTK ������ = first ATTK �� ����.
        clearvars temp;
    else %ATTK ������ ���������
        timepoint_ATTK(t) = 0;
    end
    
end
clearvars t numTrial
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
    
    if exist(strcat(pathname,'aligned_new'),'dir') == 0 % aligned ������ �������� ������
        mkdir(strcat(pathname,'aligned_new')); % �������
    end
    % parse filename
    filename_date = filename{f}(strfind(filename{1},'GR7-')+6:strfind(filename{1},'GR7-')+9);
    temp1 = strfind(filename{f},'_');
    temp2 = strfind(filename{f},'.mat');
    filename_cellnum = filename{f}(temp1(end)+1:temp2-1);
    save([pathname,'\aligned_new\',filename_date,'_',filename_cellnum,'_aligned.mat'],'Z');
    clearvars filename_date temp1 temp2 filename_cellnum Z 
end

fprintf('====================================================\n');
fprintf('%d ���� ������ %s�� �����Ǿ����ϴ�.\n',f,strcat(pathname,'aligned_new'));

%AlignEvent_separateAE;

clearvars f time* TIME* filename pathname Paths ParsedData