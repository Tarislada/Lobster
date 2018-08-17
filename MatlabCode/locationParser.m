function result = locationParser(dodraw)
%% XYXY csv ������ �о ��ġ ������ �̾� ����Ѵ�.
%   �� �Լ��� �߰��� tracking�� ���� ��츦 �������ִ� �Լ� recoverLocData �Լ��� �����Ѵ�.
%   ui�� xyxy ������ �������ָ� �ڵ����� Red LED, Green LED �� �ش��ϴ� ��ġ ��ǥ���� Ȯ���ϰ� 
%   tracking�� ���� ���� �ڵ����� �������ش�. 
%   �� �۾����� recoverLocData ������ �������� X ��ǥ�� ������ ��Ÿ���� X_RANGE ���� ������ ������ Ȯ����
%   �ʿ��ϴ�. @Knowblesse 2018
%   result ���� �� 6���� ������ �����Ǹ�, ������ �Ʒ��� ����.
%   [ �ð�, Red X, Red Y, Green X, Green Y, Head Direction Degree ]


%% Load Data
[filename, pathname] = uigetfile('.csv','��ġ���� "*XYXY.csv ������ ������ �ּ���.');
fileID = fopen([pathname,filename],'r');

formatSpec = '%*s%*s%f%d%*s%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d';
dataArray = textscan(fileID,formatSpec, 'Delimiter', ',', 'ReturnOnError',false, 'HeaderLines',1);

% Check Data Load by checking NumOfPoints Value = 32
if (dataArray{3}(1) ~= 32)
    error('Something is wrong with the data import');
end

% Timestamps
Time = dataArray{1};

% Convert into Matrix
channel = dataArray{2};
length = size(channel,1) / 4; % Length of the acquired data

data = zeros(length*4, 32);
for i = 4:numel(dataArray)
    data(:,i-3) = dataArray{i}(:);
end

clear fileID formatSpec dataArray filename pathname i

%% Data Cell for Locations
%{
    structures : 
    {1:X1}{3:X2}
    {2:Y1}{4:Y2}
%}
Loc = cell(2,2);
for i = 1 : 4
    Loc{i} = zeros(length,32);
end
clear i 

%% Parse Data
f = [1,1,1,1]; % flag for data input
for i = 1 : length*4
    Loc{channel(i,1)}(f(channel(i,1)),:) = data(i,:);
    f(channel(i,1)) = f(channel(i,1)) + 1;
end

for i = 1 : 4
    Loc{i} = reshape(Loc{i}',numel(Loc{i}),1);
end

Loc_rec = recoverLocData(Loc);
%% Delete Zeros
i = 1;
while Loc_rec{1}(i) == 0
    i = i +1;
end

for j = 1 : 4
    Loc_rec{j}(1:i-1) = Loc_rec{j}(i);
end


%% Draw
if dodraw == true
    fig1 = figure('name', 'Original Location');
    plot(Loc{1},Loc{2},'r');
    hold on;
    plot(Loc{3},Loc{4},'g');

    fig2 = figure('name', 'Recovered Location');
    plot(Loc_rec{1}, Loc_rec{2}, 'r');
    hold on;
    plot(Loc_rec{3}, Loc_rec{4},'g');
end

%% Get TimeStamp
time = [];
for i = 1 : 4 : size(Time,1)
    time = [time;Time(i)];
end
timestamp = zeros((size(time,1)-1)*32,1);
for i = 1 : size(time,1)-1
    interval = time(i+1) - time(i);
    for j = 1 : 32
        timestamp((i-1)*32 + j) = time(i) + (interval/32) * j;
    end
end

%% Calculate Degree
headDegree = zeros(size(Loc_rec{1},1),1);
for i = 1 : size(Loc_rec{1},1)
    headDegree(i) = getHeadDegree(Loc_rec{1}(i),Loc_rec{2}(i),Loc_rec{3}(i),Loc_rec{4}(i));
end 

%% Return Result
result = [timestamp,Loc_rec{1}(1:end-32),Loc_rec{2}(1:end-32),Loc_rec{3}(1:end-32),Loc_rec{4}(1:end-32),headDegree(1:end-32)];

clear channel data f i interval j length time Time Loc Loc_rec i ans timestamp


end