%% AlignEvent
% A2-3 JiHoon Version
% Ư�� �̺�Ʈ ���� ���ķ� spike �����͸� ������ �� zscore�� ���, aligned_new ������ ����.

%% PARAMETERS
TIMEWINDOW_LEFT = -4; % �̺�Ʈ�� �������� ���� �� �����ͱ��� �������.
TIMEWINDOW_RIGHT = +4; % �̺�Ʈ�� �������� ���� �� �����͸� �������.
TIMEWINDOW_BIN = 0.05; % TIMEWINDOW�� ������ bin ũ��� �󸶷� ������.

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

[ParsedData, Trials, IRs, Licks, Attacks ] = BehavDataParser(targetdir);

clearvars targetdir;

%% Find Time window in each trial
numTrial = size(ParsedData,1); % �� trial ��
timepoint_LICK = zeros(numTrial,1); % LICK ������ ������ ��� ����
timepoint_IROF = zeros(numTrial,1); % IROF ������ ������ ��� ����
for t = 1 : numTrial
     %% LICK
    if ~isempty(ParsedData{t,3}) %LICK ������ ������� ������,
        temp = ParsedData{t,3};
        timepoint_LICK(t) = temp(1) + ParsedData{t,1}(1); % ���� ó���� LICK ������ = first LICK�� ����.
        clearvars temp;
    else %LICK ������ ���������
        timepoint_LICK(t) = 0;
    end
    %% IROF
    if ~isempty(ParsedData{t,2}) %IR ������ ������� ������,
        temp = ParsedData{t,2};
        timepoint_IROF(t) = temp(end) + ParsedData{t,1}(1); % ���� ������ IR ������ = last IROF �� ����.
        clearvars temp;
    else %IR ������ ���������
        timepoint_IROF(t) = 0;  
    end    
end
clearvars t numTrial

timepoint_IROF(timepoint_LICK == 0) = []; % IR �����Ͱ� ����(IRON�� ����) trial�� ����.

timewindow_IROF = [timepoint_IROF+TIMEWINDOW_LEFT,timepoint_IROF+TIMEWINDOW_RIGHT];

%% �� Unit data ���� �����͸� �̾Ƴ�. 
for f = 1 : numel(Paths) % ������ ������ Unit Data�� ���ؼ�...
    %% Unit Data Load
    load(Paths{f}); % Unit data�� �ε�. SU ������ ����.
    spikes = table2array(SU(:,1)); % spike timestamp ���� ����.
    clearvars SU;
    
    %% timewindow�� TIMEWINDOW_BIN���� ���� timebin_* ������ ����.
    timebin_IROF = zeros((TIMEWINDOW_RIGHT-TIMEWINDOW_LEFT)/TIMEWINDOW_BIN,1);
    
    %% timewindow ���� �ش��ϴ� rawdata�� �����ϱ� ���� cell
    raw_IROF = cell(numel(timepoint_IROF),1);
    
    %IROF
    for tw = 1 : numel(timepoint_IROF) % �� window���� 
        % rawdata�� �׳� ����
        raw_IROF{tw,1} = spikes(and(spikes >= timewindow_IROF(tw,1), spikes < timewindow_IROF(tw,2)))...
            - timewindow_IROF(tw,1);
    end
    
    clearvars tw twb tempbin spikes
    
    %% Calculate raw firingrate with moving window
    Z.raw_IROF = raw_IROF;
    
    if exist(strcat(pathname,'aligned_raw'),'dir') == 0 % aligned ������ �������� ������
        mkdir(strcat(pathname,'aligned_raw')); % �������
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

fprintf('%d ���� ������ %s�� �����Ǿ����ϴ�.\n',f,strcat(pathname,'aligned_new'));

fprintf('==============================================================================\n');
clearvars f time* TIME* filename pathname Paths ParsedData