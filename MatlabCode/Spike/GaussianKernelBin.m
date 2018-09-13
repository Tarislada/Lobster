%% GaussainKernelBin
% Using "Neurons" variable from <LoadAlginedData.m>, generate matrix with 
%% PARAMETERS
TIMEWINDOW_LEFT = -4; % �̺�Ʈ�� �������� ���� �� �����ͱ��� �������.
TIMEWINDOW_RIGHT = 4; % �̺�Ʈ�� �������� ���� �� �����͸� �������.
TIMEWINDOW_BIN = 0.05; % TIMEWINDOW�� ������ bin ũ��� �󸶷� ������.
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
        % firing �ð��� ���缭 ���� ����� timepoint�� 1�� ���
        tempdata(round((Neurons{n}.raw_IROF{t}) * 1000)) = 1;
        % ����þ� Ŀ�ΰ� convolution
        kernel = gausswin(kernel_size,kernel_size/(2*stdev));
        tempdata = conv(tempdata,kernel);
        tempdata = tempdata(kernel_size/2+1:end-kernel_size/2+1);
        % bin���� ������ �ش� �� �ȿ� ���� �����ʹ� ���� ��ġ�� OUTPUT�� ����
        OUTPUT(n,t,:) = sum(reshape(tempdata,fs/(TIMEWINDOW_BIN*1000),[]),1).^0.5;
    end
end

%% Trial ������ ���ֱ� ���ؼ� ���� �ٿ���
FinalOutput = zeros(numNeuron,numWindow*numTrial);
for t = 1 : numTrial
    FinalOutput(:,numWindow*(t-1) + 1 : numWindow*t) = OUTPUT(:,t,:);
end

%% �� ���� ���� ZScore ó��
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
