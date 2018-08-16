
%% load LFP data

[FileName,PathName] = uigetfile('.csv');

% reset variables
F = strcat(PathName, FileName);
delimiter = ',';
startRow = 2;

% format of each text line : %   ��1~�� 91 : double (%f)
formatSpec = strcat('%*s %*s %f %f %f %*f ', repmat('%f ',1,128));

% open csv file
fileID = fopen(F,'r');

% read file
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

% close txt file
fclose(fileID);

clearvars FileName PathName F delimiter startRow formatSpec fileID
 
%% Parse Data 1
time = cell2mat(dataArray(1));
chan = cell2mat(dataArray(2));
FS = dataArray{3}(1);
data = cell2mat(dataArray(4:end));

clearvars dataArray

%% Parse Data 2
num_chan = numel(unique(chan));

if rem(numel(time),num_chan) ~= 0 
    % ���� �ð��� �����Ͱ� NUM_CHAN�� �ִٴ� ���� �Ͽ� �Ʒ� �ڵ带 �����ϱ⿡ ���� üũ�� ���ݴϴ�.
    error('�������� ä�� ������ �̻��մϴ�.');
end

num_datapoint = numel(time) / num_chan;

% NUM_CHAN���� ������ �����͸� �����մϴ�.
time_reshaped = reshape(time,num_chan,num_datapoint);
chan_reshaped = reshape(chan,num_chan,num_datapoint);
data_reshaped = reshape(data',128,num_chan,num_datapoint);

if sum(sum(chan_reshaped) ~= num_chan*(num_chan+1)/2) ~= 0 
    % ���� ������ ������� NUM_CHAN���� �ڸ��� �� �ڸ� �������� channel 1,2,3, ... , NUM_CHAN�� �ϳ��� �־�� �մϴ�.
    % �ϴ� ä�� ������ �� ���ϸ� (1+2+3+...+NUM_CHAN = NUM_CHAN*(NUM_CHAN+1)/2 �̰� �̰� �ƴ� ����� �࿩�� �ִ��� Ȯ���մϴ�.
    error('ä���� �з��� �� �ֽ��ϴ�.');
end

clearvars time chan data

%% Parse Date 3
% �ð� ����
TIME = zeros(128*num_datapoint,1);
for i = 1 : num_datapoint-1
    temp = linspace(time_reshaped(1,i),time_reshaped(1,i+1),128+1);
    TIME( 128*(i-1)+1 : 128*i, 1 ) = temp(1:end-1)';
end
clearvars i temp time_reshaped

% LFP ����
LFP = zeros(128*num_datapoint,16);
for i = 1 : num_datapoint
    for chn = 1 : num_chan
        LFP( 128*(i-1)+1 : 128*i, chan_reshaped(chn,i) ) = data_reshaped(:,chn,i);
    end
end

clearvars chan_reshaped data_reshaped num_chan num_datapoint i chn


