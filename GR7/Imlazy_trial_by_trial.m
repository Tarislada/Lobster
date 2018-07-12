%% Imlazy_trial_by_trial
% Imlazy ó�� ���� ���ֵ��� �ѹ��� �ҷ��鿩�� �� trial �ൿ Ÿ�Ժ��� �����͸� ������.
% ���� : E : Escape | A : Avoid | M : 1M time out | G : Give up

%% �м��� recording �����͸� ����ٿ�.
[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

%% EVENT ������ �ִ� ���� ��������.
[ParsedData, Trials, IRs, Licks, Attacks ] = BehavDataParser();
AnalyticValueExtractor;

%% Behavior type chart �׷��ֱ�.
tabulate(behaviorResult);

%% ���� �����Ϳ��� � behaviorResult �� �������� ����
BEHAV_TYPE = 'A';

%% ���� ���ּ��谡 ¥�ν� ��Ŀ� ���߱� ���ؼ� ���ο� ������ ����.
% BehavDataParser�� ��� ParsedData �ȿ� ��� �����͸� ��µ�,
% ���ּ��谡 ����Ͻô� GambleRatsBehavParser�� ���
% �� TRON TROF � ������ ����.
TRON = [];
TROF = [];
IRON = [];
IROF = [];
LICK = [];
LOFF = [];
ATTK = [];
ATOF = [];

for i = 1 : size(ParsedData,1)
    if strcmp(behaviorResult(i),BEHAV_TYPE) % behaviorResult �� ������ ������ BEHAV_TYPE�� ���� ��츸 ������.
        TRON = [TRON;ParsedData{i,1}(1)];
        TROF = [TROF;ParsedData{i,1}(2)];
        IRON = [IRON;ParsedData{i,2}(:,1)+TRON(end)];
        IROF = [IROF;ParsedData{i,2}(:,2)+TRON(end)];
        LICK = [LICK;ParsedData{i,3}(:,1)+TRON(end)];
        LOFF = [LOFF;ParsedData{i,3}(:,2)+TRON(end)];
        ATTK = [ATTK;ParsedData{i,4}(:,1)+TRON(end)];
        ATOF = [ATOF;ParsedData{i,4}(:,2)+TRON(end)];
    end
end

% �̷��� ������� TRON, TROF, ... �� ������ BEHAV_TYPE�� �ش�Ǵ� trial��θ� �����Ǹ�,
% �� �������� ���� A3�� ���� �� �м��� ����.

%% Imlazy�� ����.
for f = 1 : numel(Paths)
    load(Paths{f});
    neuronname = filename{f};
    donotdrawA2 = true; % A2���� �� ��Ʈ�� ������ �ڿ��� �׷����� �׸��� ����.
    noBehavParser = true; % A3���� �� ��Ʈ�� ������ �ڿ��� GambleRatBehavParser�� ������ ����.
    A2_GR_singleUnit_anlyzer_JH;
    A3_GR_PSTH_v3_JH;
    clearvars -except filename pathname Paths targetdir f Z BEHAV_TYPE TRON TROF IRON IROF LICK LOFF ATTK ATOF
    save([filename{f}(1:end-4),'_',BEHAV_TYPE,'___aligned.mat'],'Z');
    clearvars Z
end