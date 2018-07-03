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

%% behavior type chart 그려주기.


%% 나온 데이터에서 어떤 behaviorResult 만 선택할지 결정
BEHAV_TYPE = 'A';




%% Imlazy를 돌림.
for f = 1 : numel(Paths)
    load(Paths{f});
    neuronname = filename{f};
    donotdrawA2 = true; % A2에서 이 파트가 있으면 뒤에서 그래프를 그리지 않음.
    A2_GR_singleUnit_anlyzer_JH;
    
    
    
    A3_GR_PSTH_v3_JH;
    clearvars -except filename pathname Paths targetdir f Z
    save([filename{f}(1:end-4),'___aligned.mat'],'Z');
    clearvars Z
end


%% AnalyticValueExtractor 를 돌려서 각각 label을 뽑아냄.

%% A2? A3 를 돌려서 해당 trial 별로 묶어줌.

