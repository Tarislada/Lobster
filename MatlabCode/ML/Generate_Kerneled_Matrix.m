%% Generate Kerneled Matrix
% ���� ���� ������ ������ �������� aligned ������ ����ؼ� kenel�� ������ Azure �� ������ ������ ����
warndlg('���� ���ǿ� �ش��ϴ� �������� aligned.mat ���ϸ� �������ּ���. ���� All �����Դϴ�.');
[tempNeurons, Neuron_names] = loadAlignedData();

numNeuron = numel(tempNeurons);
Neuron = cell(numNeuron,1);

for n = 1 : numNeuron
    Neuron{n}.raw_IRON = tempNeurons{n}.raw_IRON;
end

warndlg('���� ���ǿ� �ش��ϴ� �������� aligned.mat ���ϸ� �������ּ���. �������� Avoid �����Դϴ�.');
[tempNeurons, Neuron_names] = loadAlignedData();

for n = 1 : numNeuron
    Neuron{n}.raw_IROF_A = tempNeurons{n}.raw_IROF;
end

warndlg('���� ���ǿ� �ش��ϴ� �������� aligned.mat ���ϸ� �������ּ���. ���������� Escape �����Դϴ�.');
[tempNeurons, Neuron_names] = loadAlignedData();

for n = 1 : numNeuron
    Neuron{n}.raw_IROF_E = tempNeurons{n}.raw_IROF;
end

%% Parameters
stdev = 150; % std of Gausswin (in ms)
kernel_size = 1500;
windowlength = 4000;
binnedDataSize = windowlength/100; % divied by 100ms

X = zeros([],binnedDataSize*numNeuron);

dataType = {'raw_IRON','raw_IROF_A', 'raw_IROF_E'};
for dt = dataType
    numTrial = eval(cell2mat(strcat('numel(Neuron{1}.',dt,')')));
    OUTPUT = cell(numNeuron,numTrial);
    %% Convolve Kernel
    for n = 1 : numNeuron
        for t = 1 : numTrial
            eval(cell2mat(strcat('data = Neuron{n}.', dt, '{t};')));
            % Generate psudo-timeseries data 
            % with length of windowlength ms
            % fs : 1000
            tempdata = zeros(windowlength,1);
            % assign "1" to spike point 
            tempdata(round(data * 1000)+1) = 1;
            % Generate gaussian kernel
            kernel = gausswin(kernel_size,kernel_size/(2*stdev));
            % Convolve gaussian kernel
            tempdata = conv(tempdata,kernel);
            % Trim start/end point of the data to match the size
            tempdata = tempdata(kernel_size/2+1:end-kernel_size/2+1);
            % binning
            OUTPUT{n,t} = sum(...
                reshape(tempdata(1:windowlength),100,binnedDataSize)... 
                ,1).^0.5;
        end
    end
    
    %% ZScore
    for n = 1 : numNeuron
        m = mean(cell2mat(OUTPUT(n,:)));
        s = std(cell2mat(OUTPUT(n,:)));
        for t = 1 : numTrial
            OUTPUT{n,t} = (OUTPUT{n,t} - m) ./ s;
        end
    end
    
    for t = 1 : numTrial
        X = [X; reshape(cell2mat(OUTPUT(:,t))',binnedDataSize*numNeuron,[])'];
    end
end

clearvars -except Neuron X

%% Generate y data
y = [ones(numel(Neuron{1}.raw_IRON),1);...
    2*ones(numel(Neuron{1}.raw_IROF_A),1);...
    3*ones(numel(Neuron{1}.raw_IROF_E),1)];