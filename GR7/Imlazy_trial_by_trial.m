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

TRON

%% Imlazy�� ����.
for f = 1 : numel(Paths)
    load(Paths{f});
    neuronname = filename{f};
    donotdrawA2 = true; % A2���� �� ��Ʈ�� ������ �ڿ��� �׷����� �׸��� ����.
    A2_GR_singleUnit_anlyzer_JH;
    
    % A3�� �� �׸����� ���� �����͸� �������.
    
    TRON
    TROF
    IRON
    IROF
    LICK
    LOFF
    ATTK
    ATOF
    
    A3_GR_PSTH_v3_JH;
    clearvars -except filename pathname Paths targetdir f Z
    save([filename{f}(1:end-4),'___aligned.mat'],'Z');
    clearvars Z
end


%% AnalyticValueExtractor �� ������ ���� label�� �̾Ƴ�.

%% A2? A3 �� ������ �ش� trial ���� ������.

