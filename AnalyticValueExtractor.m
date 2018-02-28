%% AnalyticValueExtractor
% Parsed ������ ���� Ȯ��
if ~exist('ParsedData')
    error('Error.\nBehavDataParser�� ���� �����ּ���.');
end

%% Constants
MIN_LICK_CLUSTER_INTERVAL = 0.3; % ������׷� �м��� 97.6035% �� ���ϴ� 0.3�ʷ� ����.
MIN_IR_CLUSTER_INTERVAL = 1.3; % % ������׷� �м��� 67.8255% �� ���ϴ� 1.3�ʷ� ����.

%% AnalyticValues
numTrial = size(ParsedData,1);
% Clusters
numLickClusters = zeros(numTrial,1);
numIRClusters = zeros(numTrial,1);
% Avoid / Escape
behaviorResult = string(numTrial,1); % A : Avoid | E : Escape | M : 1min timeout | G : Give up| N : No Lick
for trial = 1 : size(ParsedData,1)
    %% IR Cluster
    IRs = ParsedData{trial,2};
    if isempty(IRs) % IR �� �ϳ��� ������,
        numIRClusters(trial) = 0;
        continue;
    elseif numel(IRs) == 2 % IR�� �� �ѹ��� ����
        numIRClusters(trial) = 1;
    else
        IIRI = IRs(2:end,1) - IRs(1:end-1,2);
        numIRClusters(trial) = sum(IIRI > MIN_IR_CLUSTER_INTERVAL) + 1;
    end
        
    %% Lick Cluster
    Licks = ParsedData{trial,3};
    if isempty(Licks) % Lick �� �ϳ��� ������,
        numLickClusters(trial) = 0;
        continue;
    elseif numel(Licks) == 2 % Lick�� �� �ѹ��� �ϸ�
        numLickClusters(trial) = 1;
    else
        ILicksI = Licks(2:end,1) - Licks(1:end-1,2);
        numLickClusters(trial) = sum(ILicksI > MIN_LICK_CLUSTER_INTERVAL) + 1;
    end
    
end
        


