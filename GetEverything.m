%% GetEverything
cumTrials = [];
cumIRs = [];
cumLicks = [];
cumAttacks = [];
for i = 1 : 12
    [ParsedData, Trials, IRs, Licks,Attacks ] = BehavDataParser
    cumTrials = [cumTrials;Trials];
    cumIRs = [cumIRs; IRs];
    cumLicks = [cumLicks; Licks];
    cumAttacks = [cumAttacks; Attacks];
end