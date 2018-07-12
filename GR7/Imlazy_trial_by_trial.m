%% Imlazy_trial_by_trial
% Imlazy 처럼 여러 유닛들을 한번에 불러들여서 각 trial 행동 타입별로 데이터를 묶어줌.
% 참고 : E : Escape | A : Avoid | M : 1M time out | G : Give up

%% 분석할 recording 데이터를 끌어다옴.
[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

%% EVENT 파일이 있는 곳을 선택해줌.
[ParsedData, Trials, IRs, Licks, Attacks ] = BehavDataParser();
AnalyticValueExtractor;

%% Behavior type chart 그려주기.
tabulate(behaviorResult);

%% 나온 데이터에서 어떤 behaviorResult 만 선택할지 결정
BEHAV_TYPE = 'A';

%% 기존 선휘선배가 짜두신 양식에 맞추기 위해서 새로운 변수를 생성.
% BehavDataParser의 경우 ParsedData 안에 모든 데이터를 담는데,
% 선휘선배가 사용하시던 GambleRatsBehavParser의 경우
% 각 TRON TROF 등에 변수를 담음.
TRON = [];
TROF = [];
IRON = [];
IROF = [];
LICK = [];
LOFF = [];
ATTK = [];
ATOF = [];

for i = 1 : size(ParsedData,1)
    if strcmp(behaviorResult(i),BEHAV_TYPE) % behaviorResult 가 위에서 설정한 BEHAV_TYPE과 같은 경우만 합쳐줌.
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

% 이렇게 만들어진 TRON, TROF, ... 은 설정한 BEHAV_TYPE에 해당되는 trial들로만 구성되며,
% 이 변수들은 이후 A3에 넣은 후 분석에 사용됨.

%% Imlazy를 돌림.
for f = 1 : numel(Paths)
    load(Paths{f});
    neuronname = filename{f};
    donotdrawA2 = true; % A2에서 이 파트가 있으면 뒤에서 그래프를 그리지 않음.
    noBehavParser = true; % A3에서 이 파트가 있으면 뒤에서 GambleRatBehavParser를 돌리지 않음.
    A2_GR_singleUnit_anlyzer_JH;
    A3_GR_PSTH_v3_JH;
    clearvars -except filename pathname Paths targetdir f Z BEHAV_TYPE TRON TROF IRON IROF LICK LOFF ATTK ATOF
    save([filename{f}(1:end-4),'_',BEHAV_TYPE,'___aligned.mat'],'Z');
    clearvars Z
end