%% �ؽ�Ʈ ���Ͽ��� �����͸� �����ɴϴ�.

clc
clear

[FileName,PathName] = uigetfile;

filepath = strcat(PathName,FileName);

%% ������ �ʱ�ȭ�մϴ�.
filename = filepath;
delimiter = ',';
startRow = 2;

%% ������ ���� �ؽ�Ʈ�� ����:
% �ڼ��� ������ ���� �������� TEXTSCAN�� �����Ͻʽÿ�.
formatSpec = '%*s%*s%f%f%*s%*s%f%*[^\n\r]';

%% �ؽ�Ʈ ������ ���ϴ�.
fileID = fopen(filename,'r');

%% ���Ŀ� ���� ������ ���� �н��ϴ�.
% �� ȣ���� �� �ڵ带 �����ϴ� �� ���Ǵ� ������ ����ü�� ������� �մϴ�. �ٸ� ���Ͽ� ���� ������ �߻��ϴ� ��� �������� ������
% �ڵ带 �ٽ� �����Ͻʽÿ�.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% �ؽ�Ʈ ������ �ݽ��ϴ�.
fclose(fileID);


%%%%%%%%%%%%%%%% ������� ��� �����͸� ���� dataArray ��� �̸��� cell �ȿ� �ֽ��ϴ�.

% �������� ���¸� ���� �� timepoint�� 8ä���� �����͸� �޽��ϴ�.
% �ϴ� 8ä�� �����͸� �޴� ���̸� ��ü ����� 8�� �������߰�����.
TIME = dataArray{1};
CHAN = dataArray{2};
D0 = dataArray{3};

if rem(numel(dataArray{1}),8) ~= 0 
    % ���� �ð��� �����Ͱ� 8�� �ִٴ� ���� �Ͽ� �Ʒ� �ڵ带 �����ϱ⿡ ���� üũ�� ���ݴϴ�.
    error('�����Ͱ� 8ä���� �ƴմϴ�.')
end

num_datapoint = numel(dataArray{1}) / 8;

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

%%%%%%%%%%%%%%%%%
% ���� ���� �ð��� ���� �̽��ϴ�.
TIME = TIME_reshaped(1,:)';

% �� ������ ����Ʈ�� ¤��� ä�ο� �´� �����͸� ã�ư��ϴ�.
arranged_D0 = zeros(num_datapoint,8);

for i = 1 : num_datapoint
    channelarray = CHAN_reshaped(:,i)';
    for chn = 1 : 8
        arranged_D0(i,channelarray == chn) = D0_reshaped(chn,i);
    end
end
        
% arranged_D0�� ä�� ������ ������ �����Ͱ� �˸°� �����ϴ�.

POS1x = arranged_D0(:,8);
POS1y = arranged_D0(:,7);
POS1A = arranged_D0(:,5);

POS2x = arranged_D0(:,4);
POS2y = arranged_D0(:,3);
POS2A = arranged_D0(:,1);

LOC{1,1} = POS1x;
LOC{2,1} = POS1y;
LOC{1,2} = POS2x;
LOC{2,2} = POS2y;


clearvars CHAN CHAN_reshaped channelarray chn D0 dataArray delimiter fileID filename formatSpec i num_datapoint startRow TIME_reshaped


%%


RELOC = recoverLocData(LOC);

figure

plot(RELOC{1,1},RELOC{2,1},'g')
hold on
plot(RELOC{1,2},RELOC{2,2},'r')



XY1 = [RELOC{1,1},RELOC{2,1}];
XY2 = [RELOC{1,2},RELOC{2,2}];








