function [firedIndices] = firedLocationParser(result)
%% spike time �����Ͱ� �ִ� txt ������ �о ��ġ�� �������ش�.
%   @param result : locationParser�� ���� result ����.
%       �� ������ ù��° �� �����͸� ���� index���� ����.

%% Load Data
[filename, pathname] = uigetfile('.txt');
fileID = fopen([pathname,filename],'r');

formatSpec = '%f%[^\n]';
spikes = textscan(fileID,formatSpec, 'Delimiter', ',', 'ReturnOnError',false);
spikes = spikes{1};

fclose(fileID);

clear filename pathname fileID formatSpec

%% Find Indexes
numSpike = size(spikes,1);
spikeIndex = zeros(numSpike,1);

% spike �����ʹ� spike�� ��Ÿ���� �ð� ������ �ۿ� �������� ����.
% �׷��Ƿ�, �ش� timestamp �� ���� ����� location �����͸� ��������
for i = 1 : numSpike
    difference = abs(result(:,1) - spikes(i));
    [~,spikeIndex(i)] = min(difference);
end

firedIndices = spikeIndex;

end
    
