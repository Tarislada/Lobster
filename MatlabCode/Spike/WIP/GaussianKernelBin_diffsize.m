%% GaussainKernelBin
% Using "Neurons" variable from <LoadAlginedData.m>, generate matrix with 
%% PARAMETERS
TIMEWINDOW_BIN = 0.05; % TIMEWINDOW�� ������ bin ũ��� �󸶷� ������.
stdev = 150; % ms
kernel_size = 1500;
bin_size = 20;

%% LoadAlignedData
% Align�� ���� �����͸� ��� ��Ƽ� �ϳ��� matrix�� ����.

%% �м��� .mat ���� ����
[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
if isequal(filename,0)
    return;
end
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

numNeuron = numel(Paths); % ������ ������ ��.

%% ������ .mat ������ ���� ������ cell�� ����� �ϳ��� �ε��Ͽ� ����.
Neurons = cell(numNeuron,1); % �ε��� �����͸� ��Ƶδ� ����.
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
        % ��ü Trial �� �ð��� ���ϰ� �̸� ������� array�� ����.
        tempdata = zeros(round(window(t,2)*1000) - round(window(t,1)*1000),1);
        % firing �ð��� ���缭 ���� ����� timepoint�� 1�� ���
        tempdata(round(Neurons{n}{t} * 1000) - round(window(t,1)*1000)+1) = 1;
        % ����þ� Ŀ�ΰ� convolution
        kernel = gausswin(kernel_size,kernel_size/(2*stdev));
        tempdata = conv(tempdata,kernel);
        tempdata = tempdata(kernel_size/2+1:end-kernel_size/2+1);
        % bin���� ������ �ش� �� �ȿ� ���� �����ʹ� ���� ��ġ�� OUTPUT�� ����
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