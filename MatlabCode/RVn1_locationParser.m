%% RVn1.csv ���� location �̾Ƴ���


%% Load Data
[filename, pathname] = uigetfile('.csv','��ġ���� "*RVn1.csv ������ ������ �ּ���.');
fileID = fopen([pathname,filename],'r');

formatSpec = '%*s%s%f%d%*d%*d%d';
dataArray = textscan(fileID,formatSpec, 'Delimiter', ',', 'ReturnOnError',false, 'HeaderLines',1);

% EVENT �̸��� RVn1 �� �´��� Ȯ��.
if (dataArray{1}(1) ~= 'RVn1')
    error('RVn1 �����Ͱ� �³���? �̺�Ʈ �̸��� �ٸ��� �����ϴ�.');
end

% ������ �Űܴ��
Time = dataArray{2};
Channel = dataArray{3};
D0 = dataArray{4};

clearvars pathname fileID formatSpec dataArray

%% Parse Data

% ���� �ϳ��� timepoint�� ���ؼ� ä���� �� 8���� �ִ°��� �´°� Ȯ��.





