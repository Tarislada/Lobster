function [Neurons, Neuron_names] = loadAlignedData()
%% loadAlignedData
% Align�� ���� �����͸� ��� ��Ƽ� �ϳ��� matrix�� ����.

%% �м��� .mat ���� ����
[filename, pathname] = uigetfile('.mat', 'select unit.mat file', 'MultiSelect', 'on');
if isequal(filename,0)
    return;
end
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

numNeuron = numel(Paths); % ������ ������ ��.


%% ������ .mat ������ ���� ������ cell�� ����� �ϳ��� �ε��Ͽ� ����.
Neurons = cell(numNeuron,1); % �ε��� �����͸� ��Ƶδ� ����.
Neuron_names = cell(numNeuron,1); % �ε��� ������ �̸��� ��Ƶδ� ����.
for f = 1 : numNeuron
    load(Paths{f});
    Neurons{f} = Z;
    clearvars Z
    
    t1 = find(filename{f}=='_');
    t2 = filename{f}(1:t1(end)-1);
    Neuron_names{f} = t2;
end
end