%% A2, A3 를 돌린 후 특정 행동 타입의 trial 만 뽑아낸뒤 align된 firing 데이터를 저장하는 스크립트.
% uigetfile 함수를 통해서 여러개의 뉴런 데이터(.mat)형식을 선택.
% 행동 데이터가 들어있는 EVENT 폴더를 선택.
% (뉴런 데이터와 같은 위치에 EVENT 폴더가 있으면 묻지 않고 해당 폴더를 사용)
% 각 trial 행동 타입별로 데이터를 묶음.
% align된 firing data를 선택한 뉴런 파일 끝에 ___aligned 를 붙여서 저장.
% 향후 PCA 분석을 위함.

% 참고 : E : Escape | A : Avoid | M : 1M time out | G : Give up

%% PARAMETERS
BEHAV_TYPE = 'E'; %나온 데이터에서 어떤 behaviorResult 만 선택할지 결정. A, E, G, M 입력 가능.

%% 분석할 recording 데이터를 끌어다옴.
[filename, pathname] = uigetfile('C:\VCF\Lobster\data\rawdata\*.mat', 'MultiSelect', 'on');
if isequal(filename,0)
    return;
end
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

%% EVENT 파일이 있는 곳을 선택해줌.
if exist(strcat(pathname,'EVENTS'),'dir') == 7 % 같은 위치에 EVENTS 폴더가 있음
    targetdir = strcat(pathname,'EVENTS');
else
    targetdir = uigetdir(); % 같은 위치에 EVENT 폴더가 없으면 사용자에게 물어봄.
    if isequal(targetdir,0)
        return;
    end
end
[ParsedData, Trials, IRs, Licks, Attacks ] = BehavDataParser(targetdir);
AnalyticValueExtractor;

%% Behavior type chart 그려주기.
tabulate(behaviorResult);

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

%% A2와 A3를 돌림.
for f = 1 : numel(Paths)
    load(Paths{f});
    neuronname = filename{f};
    donotdrawA2 = true; % A2에서 이 파트가 있으면 뒤에서 그래프를 그리지 않음.
    noBehavParser = true; % A3에서 이 파트가 있으면 뒤에서 GambleRatBehavParser를 돌리지 않음.
    A2_GR_singleUnit_anlyzer_JH;
    A3_GR_PSTH_v3_JH;
    clearvars -except filename pathname Paths targetdir f Z BEHAV_TYPE TRON TROF IRON IROF LICK LOFF ATTK ATOF
    if exist(strcat(pathname,'aligned_',BEHAV_TYPE),'dir') == 0 % aligned 폴더가 존재하지 않으면
        mkdir(strcat(pathname,'aligned_',BEHAV_TYPE)); % 만들어줌
    end
    save([pathname,'\aligned_',BEHAV_TYPE,'\',filename{f}(1:end-4),'_',BEHAV_TYPE,'___aligned.mat'],'Z');
    clearvars Z
end
fprintf('====================================================\n');
fprintf('%d 개의 파일이 %s에 생성되었습니다.\n',f,strcat(pathname,'aligned_',BEHAV_TYPE));