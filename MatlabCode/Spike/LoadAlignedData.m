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

%% FR 1 이하는 제거
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

% %% 이벤트에 align된 데이터를 가지고 matrix 만들기
% IROF_mat = zeros(numNeuron,numel(Neurons{1}.IROF));
% 
% for n = 1 : numNeuron
%     IROF_mat(n,:) = Neurons{n}.IROF;
% end
% 
% clearvars n