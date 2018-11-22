function [Neurons, Neuron_names] = loadAlignedData()
%% loadAlignedData
% Align된 뉴런 데이터를 모두 모아서 하나의 matrix로 만듦.

%% 분석할 .mat 파일 선택
[filename, pathname] = uigetfile('.mat', 'select unit.mat file', 'MultiSelect', 'on');
if isequal(filename,0)
    return;
end
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

numNeuron = numel(Paths); % 선택한 뉴런의 수.


%% 선택한 .mat 파일의 수를 가지고 cell을 만든뒤 하나씩 로드하여 저장.
Neurons = cell(numNeuron,1); % 로드한 데이터를 담아두는 변수.
Neuron_names = cell(numNeuron,1); % 로드한 뉴런의 이름을 담아두는 변수.
for f = 1 : numNeuron
    load(Paths{f});
    Neurons{f} = Z;
    clearvars Z
    
    t1 = find(filename{f}=='_');
    t2 = filename{f}(1:t1(end)-1);
    Neuron_names{f} = t2;
end
end