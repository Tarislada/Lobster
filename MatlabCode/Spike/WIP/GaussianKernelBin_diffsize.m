%% GaussainKernelBin
% Using "Neurons" variable from <LoadAlginedData.m>, generate matrix with 
%% PARAMETERS
TIMEWINDOW_BIN = 0.05; % TIMEWINDOW의 각각의 bin 크기는 얼마로 잡을지.
stdev = 150; % ms
kernel_size = 1500;
bin_size = 20;

%% LoadAlignedData
% Align된 뉴런 데이터를 모두 모아서 하나의 matrix로 만듦.

%% 분석할 .mat 파일 선택
[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
if isequal(filename,0)
    return;
end
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

numNeuron = numel(Paths); % 선택한 뉴런의 수.

%% 선택한 .mat 파일의 수를 가지고 cell을 만든뒤 하나씩 로드하여 저장.
Neurons = cell(numNeuron,1); % 로드한 데이터를 담아두는 변수.
for f = 1 : numNeuron
    load(Paths{f});
    Neurons{f} = raw_LOFF;
end
clearvars f;

%% Find data parameters
numTrial = numel(Neurons{1});

OUTPUT = cell(numNeuron,numTrial);
bdl = zeros(numTrial,1);
for n = 1 : numel(Neurons)
    for t = 1 : numTrial
        % 전체 Trial 의 시간을 구하고 이를 기반으로 array를 만듦.
        tempdata = zeros(round(window(t,2)*1000) - round(window(t,1)*1000),1);
        % firing 시간에 맞춰서 가장 가까운 timepoint에 1을 배당
        tempdata(round(Neurons{n}{t} * 1000) - round(window(t,1)*1000)+1) = 1;
        % 가우시안 커널과 convolution
        kernel = gausswin(kernel_size,kernel_size/(2*stdev));
        tempdata = conv(tempdata,kernel);
        tempdata = tempdata(kernel_size/2+1:end-kernel_size/2+1);
        % bin으로 나눠서 해당 빈 안에 들어가는 데이터는 전부 합치고 OUTPUT에 대입
        binned_data_length = floor(numel(tempdata) / bin_size);
        bdl(t) = binned_data_length;
        OUTPUT{n,t} = sum(reshape(tempdata(1 : bin_size * binned_data_length),bin_size,binned_data_length),1).^0.5;
    end
end

%% Concentrate data into Trial by Trial manner ( removing trial dimension )
FinalOutput = [];
for t = 1 : numTrial
    FinalOutput = [FinalOutput, cell2mat(OUTPUT(:,t))];
end

%% Apply ZScore
for n = 1 : numNeuron
    FinalOutput(n,:) = zscore(FinalOutput(n,:));
end