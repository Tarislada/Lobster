%% ������ ��
[filename, pathname] = uigetfile('*.mat','Select Neuron .mat file');
if isequal(filename,0) % �������� ���� ��� ���
    return;
end
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

%% A2
ts = A2function(Paths{1});
fprintf('A2 Complete\n');

%% EVENT data ��� ���� �� �ҷ�����
if exist(strcat(pathname,'EVENTS'),'dir') == 7 % ���� ��ġ�� EVENTS ������ ����
    targetdir = strcat(pathname,'EVENTS');
else
    targetdir = uigetdir('','Select EVENT Folder'); % ���� ��ġ�� EVENT ������ ������ ����ڿ��� ���.
    if isequal(targetdir,0)
        return;
    end
end

[TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF]=GambleRatsBehavParser(targetdir);
[ParsedData, Trials, IRs, Licks, Attacks ] = BehavDataParser(targetdir);
AnalyticValueExtractor; % Avoid Escape ����

%% TRON�� TROF�� Avoid�� Escape�ĸ� �������� ����
TRON_A = [];
TROF_A = [];
TRON_E = [];
TROF_E = [];

for tr = 1 : numel(TRON) % ��� trial �� ���ؼ�
    if behaviorResult(tr) == 'A'
        TRON_A = [TRON_A;TRON(tr)];
        TROF_A = [TROF_A;TROF(tr)];
    elseif behaviorResult(tr) == 'E'
        TRON_E = [TRON_E;TRON(tr)];
        TROF_E = [TROF_E;TROF(tr)];
    end
end

%% Avoid�� �ش��ϴ� �� ���� A3�� ����.
TRON = TRON_A;
TROF = TROF_A;
A3function(ts, TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF);
        
%% Escape�� �ش��ϴ� ���� A3�� ����.
TRON = TRON_E;
TROF = TROF_E;
A3function(ts, TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF);
fprintf('Avoid : %d | Escape : %d | Total : %d\n',sum(behaviorResult == 'A'), sum(behaviorResult == 'E'), numel(behaviorResult));   
