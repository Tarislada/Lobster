%% Experiemtn Param
numNeuron = 100;
numTrial = 50;
numTimepoints = 4000;

%% Neuron Param
meanFR = 0.2;
minFR = 0.1;
stdFR = 0.1;

%% Kernel Param
stdev = 150; % std of Gausswin (in ms)
kernel_size = 1500;
bin_size = 20;
kernel = gausswin(kernel_size,kernel_size/(2*stdev));

%% Make Fake Experiment Data
Neuron = struct();
for n = 1 : numNeuron
    Neuron(n).fr = max(minFR, stdFR * (randn(1) + meanFR));
    Neuron(n).data1 = zeros(numTrial, numTimepoints);
    Neuron(n).data1(rand(numTrial, numTimepoints) < Neuron(n).fr/1000) = 1;
    Neuron(n).data2 = zeros(numTrial, numTimepoints);
    Neuron(n).data2(rand(numTrial, numTimepoints) < Neuron(n).fr/1000) = 1;
    Neuron(n).hist1 = sum(reshape(sum(Neuron(n).data1,1),bin_size,[]),1);
    Neuron(n).hist2 = sum(reshape(sum(Neuron(n).data2,1),bin_size,[]),1);
    Neuron(n).kerneled_data1 = zeros(numTrial, numTimepoints/bin_size);
    Neuron(n).kerneled_data2 = zeros(numTrial, numTimepoints/bin_size);
    for t = 1 : numTrial
        tempdata = Neuron(n).data1(t,:);
        % Convolve gaussian kernel
        tempdata = conv(tempdata,kernel);
        % Trim start/end point of the data to match the size
        tempdata = tempdata(kernel_size/2+1:end-kernel_size/2+1);
        % binning
        Neuron(n).kerneled_data1(t,:) = sum(reshape(tempdata(1 : numTimepoints),bin_size,[]),1).^0.5;
        
        tempdata = Neuron(n).data2(t,:);
        % Convolve gaussian kernel
        tempdata = conv(tempdata,kernel);
        % Trim start/end point of the data to match the size
        tempdata = tempdata(kernel_size/2+1:end-kernel_size/2+1);
        % binning
        Neuron(n).kerneled_data2(t,:) = sum(reshape(tempdata(1 : numTimepoints),bin_size,[]),1).^0.5;
    end
    % Z score
    m = mean(reshape([Neuron(n).kerneled_data1, Neuron(n).kerneled_data2],1,[]));
    s = std(reshape([Neuron(n).kerneled_data1, Neuron(n).kerneled_data2],1,[]));
    Neuron(n).kerneled_data1 = (Neuron(n).kerneled_data1 - m) ./ s;
    Neuron(n).kerneled_data2 = (Neuron(n).kerneled_data2 - m) ./ s;
end

%% Matrix for Visual Selection
Hist1 = zeros(numNeuron, numTimepoints/bin_size);
Hist2 = zeros(numNeuron, numTimepoints/bin_size);
Hist_kernel1 = zeros(numNeuron, numTimepoints/bin_size);
Hist_kernel2 = zeros(numNeuron, numTimepoints/bin_size);
diff = zeros(numNeuron,1);
for n = 1 : numNeuron
    Hist1(n,:) = Neuron(n).hist1;
    Hist2(n,:) = Neuron(n).hist2;
    Hist_kernel1(n,:) = sum(Neuron(n).kerneled_data1,1);
    Hist_kernel2(n,:) = sum(Neuron(n).kerneled_data2,1);
    %diff(n) = sum(conv(Hist_kernel2(n,:), fliplr(Hist_kernel1(n,:))));
    diff(n) = sum(conv(Hist_kernel2(n,:), Hist_kernel1(n,:)));
end

%% Select Most Different Neurons
num2Sel = 5;
[~, ind] = sort(diff);
%SelectedFakeNeuron = Neuron(find(ind>numNeuron - num2Sel));
SelectedFakeNeuron = Neuron(find(ind<=num2Sel));

figure(1);
clf;
plot(Hist_kernel1(find(ind == 1),:));
hold on;
plot(Hist_kernel2(find(ind == 1),:));

%% Hist_kernel for selected Neurons
Hist_kernel_sel1 = zeros(num2Sel, numTimepoints/bin_size);
Hist_kernel_sel2 = zeros(num2Sel, numTimepoints/bin_size);
for n = 1 : num2Sel
    Hist_kernel_sel1(n,:) = sum(Neuron(n).kerneled_data1,1);
    Hist_kernel_sel2(n,:) = sum(Neuron(n).kerneled_data2,1);
end

%% Generate csv file for ML
X1 = zeros(numTrial,numTimepoints/bin_size*num2Sel);
X2 = zeros(numTrial,numTimepoints/bin_size*num2Sel);
for n = 1 : num2Sel
    X1(:, (n-1) * numTimepoints/bin_size + 1 : n * numTimepoints/bin_size) = ...
        SelectedFakeNeuron(n).kerneled_data1;
    X2(:, (n-1) * numTimepoints/bin_size + 1 : n * numTimepoints/bin_size) = ...
        SelectedFakeNeuron(n).kerneled_data2; 
end

X = [X1; X2];
y = ones(numTrial*2,1);
y(1:numTrial) = 0;

data2Export = [X,y];

plot_scroll(Hist_kernel_sel1');
plot_scroll(Hist_kernel_sel2');