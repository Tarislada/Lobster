%% Cut_Spikes_by_EVENT
% Using specific EVNET, Cut Spike data and save it to rawfile location

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

%% �� Unit data ���� �����͸� �̾Ƴ�. 
for f = 1 : numel(Paths) % ������ ������ Unit Data�� ���ؼ�...
    %% Unit Data Load
    load(Paths{f}); % Unit data�� �ε�. SU ������ ����.
    spikes = table2array(SU(:,1)); % spike timestamp ���� ����.
    clearvars SU;
    
    %% timewindow ���� �ش��ϴ� rawdata�� �����ϱ� ���� cell
    raw_LOFF = cell(size(window,1),1);
    
    %IROF
    for tw = 1 : size(window,1) % �� window���� 
        % rawdata�� �׳� ����
        raw_LOFF{tw,1} = spikes(and(spikes >= window(tw,1), spikes < window(tw,2)));
    end
    
    clearvars tw twb tempbin spikes
    
    if exist(strcat(pathname,'aligned_raw'),'dir') == 0 % ������ �������� ������
        mkdir(strcat(pathname,'aligned_raw')); % �������
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