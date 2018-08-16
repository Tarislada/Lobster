
%% load LFP data

[FileName,PathName] = uigetfile('.csv');

% reset variables
F = strcat(PathName, FileName);
delimiter = ',';
startRow = 2;

% format of each text line : %   열1~열 91 : double (%f)
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
    % 같은 시간에 데이터가 NUM_CHAN개 있다는 가정 하에 아래 코드를 진행하기에 에러 체크를 해줍니다.
    error('데이터의 채널 갯수가 이상합니다.');
end

num_datapoint = numel(time) / num_chan;

% NUM_CHAN개씩 나눠서 데이터를 정렬합니다.
time_reshaped = reshape(time,num_chan,num_datapoint);
chan_reshaped = reshape(chan,num_chan,num_datapoint);
data_reshaped = reshape(data',128,num_chan,num_datapoint);

if sum(sum(chan_reshaped) ~= num_chan*(num_chan+1)/2) ~= 0 
    % 위의 가정을 기반으로 NUM_CHAN개씩 자르면 각 자른 조각마다 channel 1,2,3, ... , NUM_CHAN이 하나씩 있어야 합니다.
    % 일단 채널 값들을 다 합하면 (1+2+3+...+NUM_CHAN = NUM_CHAN*(NUM_CHAN+1)/2 이고 이게 아닌 놈들이 행여나 있는지 확인합니다.
    error('채널이 밀렸을 수 있습니다.');
end

clearvars time chan data

%% Parse Date 3
% 시간 추출
TIME = zeros(128*num_datapoint,1);
for i = 1 : num_datapoint-1
    temp = linspace(time_reshaped(1,i),time_reshaped(1,i+1),128+1);
    TIME( 128*(i-1)+1 : 128*i, 1 ) = temp(1:end-1)';
end
clearvars i temp time_reshaped

% LFP 추출
LFP = zeros(128*num_datapoint,16);
for i = 1 : num_datapoint
    for chn = 1 : num_chan
        LFP( 128*(i-1)+1 : 128*i, chan_reshaped(chn,i) ) = data_reshaped(:,chn,i);
    end
end

clearvars chan_reshaped data_reshaped num_chan num_datapoint i chn


