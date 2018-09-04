function behaviorResult = AnalyticValueExtractor(ParsedData, isSeparateEscape, isKeepOnlyAE)
%% AnalyticValueExtractor
% Returns Analytic Value(ie. avoid, escape) of each trials based on the
% variable "ParsedData"

%% Constants
% MIN_LICK_CLUSTER_INTERVAL = 0.3; % ������׷� �м��� 97.6035% �� ���ϴ� 0.3�ʷ� ����.
% MIN_IR_CLUSTER_INTERVAL = 1.3; % ������׷� �м��� 67.8255% �� ���ϴ� 1.3�ʷ� ����.
MIN_1MIN_TIMEOUT_DURATION = 55; % 1min timeout���� �����ϱ� ���� �ּ��� �ð�.
SEPARATE_3SEC_6SEC_ESCAPE = isSeparateEscape; % 3�� escape�� 6�� escape�� ��������.
KEEP_ONLY_A_AND_E = isKeepOnlyAE; % Avoid�� Escape�� �ƴ� trial�� ��� ����.

%% AnalyticValues
numTrial = size(ParsedData,1);
% Clusters
% numLickClusters = zeros(numTrial,1);
% numIRClusters = zeros(numTrial,1);
% Avoid / Escape
behaviorResult = char(zeros(numTrial,1)); % A : Avoid | E : Escape | M : 1min timeout | G : Give up| N : No Lick
% for every trials
for trial = 1 : size(ParsedData,1)
%     %% IR Cluster
%     IRs = ParsedData{trial,2};
%     if isempty(IRs) % IR �� �ϳ��� ������,
%         numIRClusters(trial) = 0;
%         %continue;
%     elseif numel(IRs) == 2 % IR�� �� �ѹ��� ����
%         numIRClusters(trial) = 1;
%     else
%         IIRI = IRs(2:end,1) - IRs(1:end-1,2);
%         numIRClusters(trial) = sum(IIRI > MIN_IR_CLUSTER_INTERVAL) + 1;
%     end
%         
%     %% Lick Cluster
%     Licks = ParsedData{trial,3};
%     if isempty(Licks) % Lick �� �ϳ��� ������,
%         numLickClusters(trial) = 0;
%         %continue;
%     elseif numel(Licks) == 2 % Lick�� �� �ѹ��� �ϸ�
%         numLickClusters(trial) = 1;
%     else
%         ILicksI = Licks(2:end,1) - Licks(1:end-1,2);
%         numLickClusters(trial) = sum(ILicksI > MIN_LICK_CLUSTER_INTERVAL) + 1;
%     end
    
    %% Avoid / Escape
    Trial = ParsedData{trial,1};
    Attack = ParsedData{trial,4};
    if isempty(Attack) % Attack�� ������. 
        if diff(Trial) > MIN_1MIN_TIMEOUT_DURATION % 1�� �ð��ʰ� 
            behaviorResult(trial) = 'M';
        else % Give up
            behaviorResult(trial) = 'G';
        end
    else % Attack �� �־��� : Avoid / Escape �� �� �ϳ�
        % parameter selection���� ���ҵ��� 0.5�� ���ķ� �ִ� ������ Attack�� ���� �ٷ� ���� �ʾƼ�
        % ����� ��
        IAttackIROFI = IRs(end,2) - Attack(1); % Attack�� ������ IR OFF ������ �ð�. +�ΰ�� Escape, -�ΰ�� Avoid
        k = 1;
        while IAttackIROFI > 0.5 % IAttackIROFI�� 0.5�� �̻��̶�� ���� ������ IR�� Attack �Ŀ� ���� IR �̶�� �ǹ�.
            IAttackIROFI = IRs(end-k,2) - Attack(1);
            k = k + 1;
        end
        clearvars i
        
        if IAttackIROFI >= 0 % Escape
            if SEPARATE_3SEC_6SEC_ESCAPE 
                % true �� ��� First Lick�� Attack ���� �ð��� ����ؼ�
                % Escape�� C�� D�� ����. 
                % C : Escape on 3sec trial
                % D : Escape on 6sec trial
                if Attack(1) - Licks(1) >= 4.5 % ù Lick�� Attack�� ���̰� 4.5�� �����ΰ��
                    behaviorResult(trial) = 'C'; % 6�� Escape
                else
                    behaviorResult(trial) = 'D'; % 3�� Escape
                end
            else
                behaviorResult(trial) = 'E';
            end
        else % Avoid
            behaviorResult(trial) = 'A';
        end
    end
end

if KEEP_ONLY_A_AND_E
    behaviorResult(behaviorResult == 'G') = [];
    behaviorResult(behaviorResult == 'M') = [];
end


clearvars Attack Attacks IAttackIROFI IIRI ILicksI IRs k KEEP_ONLY_A_AND_E SEPARATE_3SEC_6SEC_ESCAPE Licks MIN_1MIN_TIMEOUT_DURATION MIN_IR_CLUSTER_INTERVAL MIN_LICK_CLUSTER_INTERVAL numTrial trial Trials Trial
        
end