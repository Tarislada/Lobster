%% GaussainKernelBin
% Using "Neurons" variable from <LoadAlginedData.m>, generate matrix with 
%% PARAMETERS
TIMEWINDOW_LEFT = -4; % 이벤트를 기점으로 몇초 전 데이터까지 사용할지.
TIMEWINDOW_RIGHT = 4; % 이벤트를 기점으로 몇포 후 데이터를 사용할지.
TIMEWINDOW_BIN = 0.05; % TIMEWINDOW의 각각의 bin 크기는 얼마로 잡을지.
fs = 1000; % 
stdev = 150; % ms
kernel_size = 1500;

%% Find data parameters
numTrial = numel(Neurons{1}.raw_IROF);
numWindow = ((TIMEWINDOW_RIGHT - TIMEWINDOW_LEFT)*1000) / (fs/(TIMEWINDOW_BIN*1000));

%% 
OUTPUT = zeros(numel(Neurons), numTrial, numWindow);

for n = 1 : numel(Neurons)
    for t = 1 : numTrial
        tempdata = zeros(1000*(TIMEWINDOW_RIGHT - TIMEWINDOW_LEFT),1);
        % firing 시간에 맞춰서 가장 가까운 timepoint에 1을 배당
        tempdata(round((Neurons{n}.raw_IROF{t}) * 1000)) = 1;
        % 가우시안 커널과 convolution
        kernel = gausswin(kernel_size,kernel_size/(2*stdev));
        tempdata = conv(tempdata,kernel);
        tempdata = tempdata(kernel_size/2+1:end-kernel_size/2+1);
        % bin으로 나눠서 해당 빈 안에 들어가는 데이터는 전부 합치고 OUTPUT에 대입
        OUTPUT(n,t,:) = sum(reshape(tempdata,fs/(TIMEWINDOW_BIN*1000),[]),1).^0.5;
    end
end

%% Trial 정보를 없애기 위해서 전부 붙여줌
FinalOutput = zeros(numNeuron,numWindow*numTrial);
for t = 1 : numTrial
    FinalOutput(:,numWindow*(t-1) + 1 : numWindow*t) = OUTPUT(:,t,:);
end

%% 각 뉴런 별로 ZScore 처리
for n = 1 : numNeuron
    FinalOutput(n,:) = zscore(FinalOutput(n,:));
end





% 
% 
% numTrial = 85;
% 
% window = TIMEWINDOW_LEFT : TIMEWINDOW_BIN : TIMEWINDOW_RIGHT;
% 
% OUTPUT = zeros(numel(Neurons), numel(window)-1,numTrial);
% 
% for n = 1 : numel(Neurons)
%     for t = 1 : numel(Neurons{n}.raw_IROF)
%         Spikes = Neurons{n}.raw_IROF{t} - 4;
%         for s = 1 : numel(Spikes)
%             gm = gmdistribution(Spikes(s),sigma);
%             for w = 1 : numel(window)-1
%                 OUTPUT(n,w,t) = OUTPUT(n,w,t) + cdf(gm,window(w+1)) - cdf(gm,window(w));
%             end
%         end
%     end
% end
