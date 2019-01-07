%% Initialize
t = 1;
Behav = struct();


%% Run
[ParsedData, Trials, IRs, Licks, Attacks ] = BehavDataParser();

%% Avoid / Escape 데이터를 추출.
behaviorResult = AnalyticValueExtractor(ParsedData,false,false);

%% Struct 구조로 데이터를 출력. 
Behav(t).name = 'GR7_0615';
Behav(t).ParsedData = ParsedData;
Behav(t).Trials = Trials;
Behav(t).IRs = IRs;
Behav(t).Licks = Licks;
Behav(t).Attacks = Attacks;
Behav(t).BehaviorResult = behaviorResult;
Behav(t).numA = sum(behaviorResult == 'A');
Behav(t).numE = sum(behaviorResult == 'E');
t = t + 1;