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

%% FR 1 ���ϴ� ����
newNeurons = {};
for f = 1 : numel(Neurons)
    if and(Neurons{f}.FR >= 0.5, Neurons{f}.FR < 10)
        newNeurons = [newNeurons;Neurons{f}];
    end
end
% 
% Neurons = newNeurons;
% numNeuron = size(newNeurons,1);
% 
% clearvars newNeurons;

% %% �̺�Ʈ�� align�� �����͸� ������ matrix �����
% IROF_mat = zeros(numNeuron,numel(Neurons{1}.IROF));
% 
% for n = 1 : numNeuron
%     IROF_mat(n,:) = Neurons{n}.IROF;
% end
% 
% clearvars n