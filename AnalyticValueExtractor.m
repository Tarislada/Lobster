%% AnalyticValueExtractor
% Parsed 데이터 존재 확인
if ~exist('ParsedData')
    error('Error.\nBehavDataParser를 먼저 돌려주세요.');
end

%% Constants
MIN_LICK_CLUSTER_INTERVAL = 0.3; % 히스토그램 분석후 97.6035% 가 속하는 0.3초로 정함.
MIN_IR_CLUSTER_INTERVAL = 1.3; % % 히스토그램 분석후 67.8255% 가 속하는 1.3초로 정함.

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
    if isempty(IRs) % IR 이 하나도 없으면,
        numIRClusters(trial) = 0;
        continue;
    elseif numel(IRs) == 2 % IR이 딱 한번만 끊김
        numIRClusters(trial) = 1;
    else
        IIRI = IRs(2:end,1) - IRs(1:end-1,2);
        numIRClusters(trial) = sum(IIRI > MIN_IR_CLUSTER_INTERVAL) + 1;
    end
        
    %% Lick Cluster
    Licks = ParsedData{trial,3};
    if isempty(Licks) % Lick 이 하나도 없으면,
        numLickClusters(trial) = 0;
        continue;
    elseif numel(Licks) == 2 % Lick을 딱 한번만 하면
        numLickClusters(trial) = 1;
    else
        ILicksI = Licks(2:end,1) - Licks(1:end-1,2);
        numLickClusters(trial) = sum(ILicksI > MIN_LICK_CLUSTER_INTERVAL) + 1;
    end
    
end
        


