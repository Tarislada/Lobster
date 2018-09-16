%% GaussainKernelBin
% Using "Neurons" variable from <LoadAlginedData.m>, generate matrix with 
%% PARAMETERS
TIMEWINDOW_BIN = 0.05; % TIMEWINDOW의 각각의 bin 크기는 얼마로 잡을지.
fs = 1000; % spike를 담을 timeseries의 Fs
stdev = 150; % std of Gausswin (in ms)
kernel_size = 1500;
bin_size = 20;

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

%% Load Unit.mat file and load into <Neurons>
Neurons = cell(numNeuron,1); % 로드한 데이터를 담아두는 변수.
for f = 1 : numNeuron
    load(Paths{f});
    Neurons{f} = raw_LOFF;
end
clearvars f;

%% Find Data Parameters
numTrial = numel(Neurons{1});
OUTPUT = cell(numNeuron,numTrial);
bdl = zeros(numTrial,1); % binned data length

%% Convolve Kernel
for n = 1 : numel(Neurons)
    for t = 1 : numTrial
        % Generate psudo-timeseries data 
        % with length of window(t,1) ~ window(t,2)
        % fs : 1000
        tempdata = zeros(round(window(t,2)*1000) - round(window(t,1)*1000),1);
        % assign "1" to spike point 
        tempdata(round(Neurons{n}{t} * 1000) - round(window(t,1)*1000)+1) = 1;
        % Generate gaussian kernel
        kernel = gausswin(kernel_size,kernel_size/(2*stdev));
        % Convolve gaussian kernel
        tempdata = conv(tempdata,kernel);
        % Trim start/end point of the data to match the size
        tempdata = tempdata(kernel_size/2+1:end-kernel_size/2+1);
        % binning
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