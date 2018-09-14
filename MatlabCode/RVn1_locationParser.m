%% RVn1.csv ���� location �̾Ƴ���
% Bridge���� ������ RVn1.csv ������ Parsing �ؼ� Location data�� ����

%% Load Data
[filename, pathname] = uigetfile('.csv','��ġ���� "*RVn1.csv ������ ������ �ּ���.');
fileID = fopen([pathname,filename],'r');

formatSpec = '%*s%s%f%d%*d%*d%d';
dataArray = textscan(fileID,formatSpec, 'Delimiter', ',', 'ReturnOnError',false, 'HeaderLines',1);

fclose(fileID);

% EVENT �̸��� RVn1 �� �´��� Ȯ��.
if (dataArray{1}{1} ~= 'RVn1')
    error('RVn1 �����Ͱ� �³���? �̺�Ʈ �̸��� �ٸ��� �����ϴ�.');
end

% ������ �Űܴ��
TIME = dataArray{2};
CHAN = dataArray{3};
D0 = dataArray{4};

if rem(numel(dataArray{2}),8) ~= 0 
    % ���� �ð��� �����Ͱ� 8�� �ִٴ� ���� �Ͽ� �Ʒ� �ڵ带 �����ϱ⿡ ���� üũ�� ���ݴϴ�.
    error('�����Ͱ� 8ä���� �ƴմϴ�.')
end

clearvars pathname fileID formatSpec dataArray

%% Parse Data

num_datapoint = numel(TIME) / 8;

% 8���� ������ �����͸� �����մϴ�.
TIME_reshaped = reshape(TIME,8,num_datapoint);
CHAN_reshaped = reshape(CHAN,8,num_datapoint);
D0_reshaped = reshape(D0,8,num_datapoint);

if sum(sum(CHAN_reshaped) ~= 36) ~= 0 
    % ���� ������ ������� 8���� �ڸ��� �� �ڸ� �������� channel 1,2,3,4,5,6,7,8�� �ϳ��� �־�� �մϴ�.
    % �׻� 87654321 ������ ������ ���� �����ٵ� �� �׷��� �ƴѰ� ���ϴ�.
    % �׷��� ä�� ������ �� ���ϸ� (1+2+3+4+5+6+7+8 = )36�̰� �̰� �ƴ� ����� �࿩�� �ִ��� Ȯ���մϴ�.
    error('ä���� �з��� �� �ֽ��ϴ�.')
end


% Time extraction
TIME = TIME_reshaped(1,:)';

% �� ������ ����Ʈ�� ¤��� ä�ο� �´� �����͸� ã�ư��ϴ�.
arranged_D0 = zeros(num_datapoint,8);

for i = 1 : num_datapoint
    channelarray = CHAN_reshaped(:,i)';
    for chn = 1 : 8
        arranged_D0(i,channelarray == chn) = D0_reshaped(chn,i);
    end
end

D0 = arranged_D0;
        
clearvars i channelarray *_reshaped chn arranged_D0 filename num_datapoint

Location = {D0(:,3),D0(:,4),D0(:,7),D0(:,8)};

clearvars D0
