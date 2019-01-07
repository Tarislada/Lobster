dTrial = cell(24,1);
for i = 1 : 24
    dTrial{i} = Behav(i).Trials(2:end,1) - Behav(i).Trials(1:end-1,2);
end

figure
dTrial_All = [];
dTrial_Line = [0];
for i = 1 : 24
    dTrial_All = [dTrial_All;dTrial{i}];
    dTrial_Line = [dTrial_Line, dTrial_Line(end) + numel(dTrial{i})];
end
dTrial_Line = dTrial_Line(2:end);
figure
plot(dTrial_All);
hold on;
for i = 1 : 24
    line([dTrial_Line(i), dTrial_Line(i)], ylim, 'Color','r');
end

numLicks = zeros(24,1);
for i = 1 : 24
    numLicks(i) = size(Behav(i).Licks,1);
end


%% BehaviorDataParser Batch

