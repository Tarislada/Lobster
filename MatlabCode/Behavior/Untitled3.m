%% Initialize
t = 1;
Behav = struct();


%% Run
[ParsedData, Trials, IRs, Licks, Attacks ] = BehavDataParser();

%% Avoid / Escape �����͸� ����.
behaviorResult = AnalyticValueExtractor(ParsedData,false,false);

%% Struct ������ �����͸� ���. 
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