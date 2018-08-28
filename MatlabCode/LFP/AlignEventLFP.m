%% AlignEventLFP
% Align LFP data to first LICK, last LOFF, last IROF, first ATTK
% 2018-AUG-20 Knowblesse

%% PARAMETERS
TIMEWINDOW_LEFT = -4; % �̺�Ʈ�� �������� ���� �� �����ͱ��� �������.
TIMEWINDOW_RIGHT = +4; % �̺�Ʈ�� �������� ���� �� �����͸� �������.
fs = 1018;

%% Get EVENT Folder Location
if ~exist('targetdir','var')
    targetdir = uigetdir('','EVENT file location'); 
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
    if ~isempty(ParsedData{t,4}) %LICK ������ ������� ������,
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

%% Load LFP mat file
if ~exist('LFPmatPath','var')
    [filename, pathname] = uigetfile('*.mat','LFP.mat File Location');
    LFPmatPath = strcat(pathname,filename);
end
load(LFPmatPath);
clearvars LFPmatPath;

%% �� timewindow ���� �ش� ������ ���ϴ� lfp data���� ������ Ȯ��.

lfp_LICK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_LICK),16);
lfp_LOFF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_LOFF),16);
lfp_IROF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_IROF),16);
lfp_ATTK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_ATTK),16);

% LICK
for tw = 1 : numel(timepoint_LICK) % �� timepoint���� 
    [~,ind] = min(abs(TIME - (timepoint_LICK(tw)+TIMEWINDOW_LEFT)));
    for ch = 1 : 16
        lfp_LICK(:,tw,ch) = LFP(ind:ind+size(lfp_LICK,1)-1,ch);
    end
end
% LOFF
for tw = 1 : numel(timepoint_LOFF) % �� timepoint���� 
    [~,ind] = min(abs(TIME - (timepoint_LOFF(tw)+TIMEWINDOW_LEFT)));
    for ch = 1 : 16
        lfp_LOFF(:,tw,ch) = LFP(ind:ind+size(lfp_LOFF,1)-1,ch);
    end
end
% IROF
for tw = 1 : numel(timepoint_IROF) % �� timepoint���� 
    [~,ind] = min(abs(TIME - (timepoint_IROF(tw)+TIMEWINDOW_LEFT)));
    for ch = 1 : 16
        lfp_IROF(:,tw,ch) = LFP(ind:ind+size(lfp_IROF,1)-1,ch);
    end
end
% ATTK
for tw = 1 : numel(timepoint_ATTK) % �� timepoint���� 
    [~,ind] = min(abs(TIME - (timepoint_ATTK(tw)+TIMEWINDOW_LEFT)));
    for ch = 1 : 16
        lfp_ATTK(:,tw,ch) = LFP(ind:ind+size(lfp_ATTK,1)-1,ch);
    end
end

clearvars filename ch fs FS ind LFP pathname TIME timepoint_* TIME* tw
