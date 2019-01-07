%% Behavior Analysis Batch
% Behavior �����͸� �ѹ��� �м�. 

% Automation
loc0 = 'C:\VCF\Lobster\data\rawdata\';
loc1 = dir(loc0);
loc2 = {loc1.name};
loc2 = loc2(3:end);

% Data Storage
Behav = struct();
t = 1;

for i = 1 : numel(loc2) % ��� ������ ���ؼ�
    if contains(loc2{i}, 'suc') % suc ������ ���
        continue;
    end
    
    % ���� ��� ����
    pathname = strcat(loc0,loc2{i},'\');
    
    %% EVENT data ��� ���� �� �ҷ�����
    if exist(strcat(pathname,'EVENTS'),'dir') == 7 % ���� ��ġ�� EVENTS ������ ����
        targetdir = strcat(pathname,'EVENTS');
    else
        error('EVENT ���� ����');
    end

    %% BehavDataParser�� ����.
    [ParsedData, Trials, IRs, Licks, Attacks ] = BehavDataParser(targetdir);
    
    clearvars targetdir;
    
    %% Avoid / Escape �����͸� ����.
    behaviorResult = AnalyticValueExtractor(ParsedData,false,false);
    
    %% Struct ������ �����͸� ���. 
    Behav(t).name = loc2{i};
    Behav(t).ParsedData = ParsedData;
    Behav(t).Trials = Trials;
    Behav(t).IRs = IRs;
    Behav(t).Licks = Licks;
    Behav(t).Attacks = Attacks;
    Behav(t).numA = sum(behaviorResult == 'A');
    Behav(t).numE = sum(behaviorResult == 'E');
    t = t + 1;
    
    
    clearvars -except loc0 loc1 loc2 i t Behav;
end