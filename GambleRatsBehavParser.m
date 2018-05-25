function [TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF, BLON, BLOF]=GambleRatsBehavParser(targetdir)
%% BehavDataParser
% TDT OpenBridge ���� ������ ������ �̿��� �ൿ �����͸� �м��Ѵ�.
% 2018 Knowblesse
%% Constants
DATALIST = {'ATTK', 'ATOF', 'BLON', 'BLOF', 'IROF', 'IRON', 'LICK', 'LOFF', 'TROF', 'TRON' }; % parsing�� �ʿ��� �������� ���
DATAPAIR = [0,         0,      1,      1,      2,      2,      3,      3,      4,      4      ]; % ���� Ȯ�ο� ����. ���� pair ��ȣ�� ������ ������ ������ ũ�Ⱑ ���ƾ� ��.��, 0�ΰ�� �Ű� �Ⱦ�.

%% ���� ����
if ~exist('targetdir','var')
    currfolder = uigetdir();
    if currfolder == 0
        error('Error.\n������ ���� ������ �������� �����̽��ϴ�.','');
    end
    targetdir = currfolder;
else
    currfolder = targetdir;
end

location = strcat(currfolder, '\*.csv');
filelist = ls(location);

%% �м��� �ʿ��� ���  ������ csv ������ �ִ��� Ȯ��
datafound = zeros(1,numel(DATALIST)); 
filename = cell(numel(DATALIST),1);
for i = 1 : numel(DATALIST) % �� ���ٷε� ���ϸ� DATALIST�� �ش��ϴ� ���ڰ� ���� �ִ��� Ȯ�� 
    for j = 1 : numel(filelist)
        if contains(filelist(j,:),DATALIST{i})
            datafound(i) = 1;
            filename{i} = filelist(j,:);
            break;
        end
    end
end

if sum(datafound) ~= numel(DATALIST) % ������ �ϳ��� ���� ���
    temp = 1:numel(DATALIST);
    nodataindex = temp(not(datafound));
    nodatalist = [];
    for i = nodataindex % ���� ���� ã�Ƽ� error �޽��� ����
        nodatalist = [nodatalist,DATALIST{i},'\n'];
    end
    error(strcat('Error.\n%s\n�� ��ο� �Ʒ��� csv ������ ���� �ʽ��ϴ�.\n',location,nodatalist),'');
end
fprintf('�ൿ ������ Ȯ�� �Ϸ�\n');
clearvars i j datafound squeezedFilelist temp nodataindex nodatalist location

%% �ൿ ������ ���� �ε�
RAWDATA = cell(1,numel(DATALIST));
for i = 1 : numel(DATALIST)
    % �Ķ���� ����
    startRow = 2;
    formatSpec = '%*s%s%f%*s%*s%*s%*s%*[^\n\r]';
    % ���� ����
    fileID = fopen(strcat(currfolder,'\',filename{i}),'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', ',', 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    % ����� �ҷ��Դ��� Ȯ��
    if ~strcmp(dataArray{1},DATALIST{i})
        error('Error.\n%s ������ ������ ������ �̻��մϴ�.\n���� �̸��� �����͸� Ȯ���ϰ� �����Ͱ� �� ��° ���� �ִ��� Ȯ���ϼ���.',DATALIST{i});
    end
    RAWDATA{i} = dataArray{:,2};
end
fprintf('�ൿ ������ �ε� �Ϸ�\n');

clearvars startRow formatSpec fileID dataArray filelist filename currfolder ans

%% �̻��Ѱ� Ȯ��
% ���� ¦�� �Ǵ� ������, ���� ��� TRON�� TROF�� ���� ������ �ٸ� �̻��� �����͸� ã�Ƴ��� ����.
% �ѵ� ¦�� �Ǵ� ���� �������� �ۼ�. �� ���� ������ ũ�Ⱑ ���� ��� �ڵ� ���� �ʿ�.
PAIR = unique(DATAPAIR);
for i = numel(PAIR)
    if PAIR(i) == 0
        continue;
    end
    j = find(DATAPAIR == PAIR(i));
    if size(RAWDATA{j(1)}) ~= size(RAWDATA{j(2)})
        error('Error.\n %s�� %s�� ũ�Ⱑ �ٸ��ϴ�.\n������ ������ ���ɼ��� �ֽ��ϴ�.',DATALIST{j(1)}, DATALIST{j(2)});
    end
end
        
fprintf('������ ũ�� �˻� ���.\n');

clearvars i j PAIR

%% ������ ��ȯ
% �ε��� Ȯ��
TRON_index = find(strcmp(DATALIST,'TRON'));
TROF_index = find(strcmp(DATALIST,'TROF'));
IRON_index = find(strcmp(DATALIST,'IRON'));
IROF_index = find(strcmp(DATALIST,'IROF'));
LICK_index = find(strcmp(DATALIST,'LICK'));
LOFF_index = find(strcmp(DATALIST,'LOFF'));
ATTK_index = find(strcmp(DATALIST,'ATTK'));
ATOF_index = find(strcmp(DATALIST,'ATOF'));
BLON_index = find(strcmp(DATALIST, 'BLON'));
BLOF_index = find(strcmp(DATALIST, 'BLOF'));
% ������ ������

TRON = RAWDATA{TRON_index};
TROF = RAWDATA{TROF_index};
IRON = RAWDATA{IRON_index};
IROF = RAWDATA{IROF_index};
LICK = RAWDATA{LICK_index};
LOFF = RAWDATA{LOFF_index};
ATTK = RAWDATA{ATTK_index};
ATOF = RAWDATA{ATOF_index};
BLON = RAWDATA{BLON_index};
BLOF = RAWDATA{BLOF_index};

clearvars TRON_index TROF_index IRON_index IROF_index LICK_index LOFF_index ATTK_index ATOF_index BLON_index BLOF_index
clearvars RAWDATA


clearvars DATALIST DATAPAIR i 

%clearvars Attacks IRs Licks numTrial Trials

fprintf('%s ���� �м� �Ϸ�\n',targetdir);
end
    
    
