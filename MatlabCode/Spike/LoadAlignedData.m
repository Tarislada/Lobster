%% LoadAlignedData
% Align�� ���� �����͸� ��� ��Ƽ� �ϳ��� matrix�� ����.

%% �м��� .mat ���� ����
[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
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
for f = 1 : numNeuron
    load(Paths{f});
    Neurons{f} = Z;
    clearvars Z
end
clearvars f;

%% �� �̺�Ʈ�� align�� �����͸� ������ matrix �����
%TRON_mat = zeros(numNeuron,numel(Neurons{1}.TRON));
%IRON_mat = zeros(numNeuron,numel(Neurons{1}.IRON));
LICK_mat = zeros(numNeuron,numel(Neurons{1}.LICK));
LOFF_mat = zeros(numNeuron,numel(Neurons{1}.LOFF));
IROF_mat = zeros(numNeuron,numel(Neurons{1}.IROF));
ATTK_mat = zeros(numNeuron,numel(Neurons{1}.ATTK));
%TROF_mat = zeros(numNeuron,numel(Neurons{1}.TROF));

for n = 1 : numNeuron
    %TRON_mat(n,:) = Neurons{n}.TRON;
    %IRON_mat(n,:) = Neurons{n}.IRON;
    LICK_mat(n,:) = Neurons{n}.LICK;
    LOFF_mat(n,:) = Neurons{n}.LOFF;
    IROF_mat(n,:) = Neurons{n}.IROF;
    ATTK_mat(n,:) = Neurons{n}.ATTK;
    %TROF_mat(n,:) = Neurons{n}.TROF;
end

clearvars Neurons n