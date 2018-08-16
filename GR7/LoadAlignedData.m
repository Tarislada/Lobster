%% LoadAlignedData
% Align된 뉴런 데이터를 모두 모아서 하나의 matrix로 만듦.

%% 분석할 .mat 파일 선택
[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
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
for f = 1 : numNeuron
    load(Paths{f});
    Neurons{f} = Z;
    clearvars Z
end
clearvars f;

%% 각 이벤트에 align된 데이터를 가지고 matrix 만들기
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