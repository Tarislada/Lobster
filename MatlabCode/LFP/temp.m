targetdir = uigetdir(); % ���� ��ġ�� EVENT ������ ������ ����ڿ��� ���.
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


load('C:\VCF\Lobster\data\processedData\lfp\0613.mat');

%% �� timewindow ���� �ش� ������ ���ϴ� spike���� ������ Ȯ��.

%% PARAMETERS
TIMEWINDOW_LEFT = -4; % �̺�Ʈ�� �������� ���� �� �����ͱ��� �������.
TIMEWINDOW_RIGHT = +4; % �̺�Ʈ�� �������� ���� �� �����͸� �������.
TIMEWINDOW_BIN = 0.1; % TIMEWINDOW�� ������ bin ũ��� �󸶷� ������.

fs = sum(TIME<1); % ���� fs�� ����.
ltp_LICK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_LICK),16);
ltp_LOFF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_LOFF),16);
ltp_IROF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_IROF),16);
ltp_ATTK = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)*fs,numel(timepoint_ATTK),16);

% LICK
for tw = 1 : numel(timepoint_LICK) % �� timepoint���� 
    for ch = 1 : 16
        [~,ind] = min(abs(TIME - (timepoint_LICK(1)+TIMEWINDOW_LEFT)));
        ltp_LICK(:,tw,ch) = LFP(ind:ind+size(ltp_LICK,1)-1,ch);
    end
end
% LOFF
for tw = 1 : numel(timepoint_LOFF) % �� timepoint���� 
    for ch = 1 : 16
        [~,ind] = min(abs(TIME - (timepoint_LOFF(1)+TIMEWINDOW_LEFT)));
        ltp_LOFF(:,tw,ch) = LFP(ind:ind+size(ltp_LOFF,1)-1,ch);
    end
end
% IROF
for tw = 1 : numel(timepoint_IROF) % �� timepoint���� 
    for ch = 1 : 16
        [~,ind] = min(abs(TIME - (timepoint_IROF(1)+TIMEWINDOW_LEFT)));
        ltp_IROF(:,tw,ch) = LFP(ind:ind+size(ltp_IROF,1)-1,ch);
    end
end
% ATTK
for tw = 1 : numel(timepoint_ATTK) % �� timepoint���� 
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
