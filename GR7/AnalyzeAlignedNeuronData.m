%% aligned mat 파일 여러개를 한꺼번에 읽어서 PCA를 돌리는 스크립트
% Imlazy_createmat.m 이나 Imlazy_trial_by_trial.m 에서 생성하는 *aligned.mat 데이터가
% 필요.
% 각각의 aligned.mat 은 하나의 neuron에 대응하는 데이터임.
% 이 코드를 실행하면 여러 aligned.mat 파일을 선택하도록 하고, 이 데이터로 PCA 분석을 진행함.


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
TRON_mat = zeros(numNeuron,numel(Neurons{1}.TRON));
IRON_mat = zeros(numNeuron,numel(Neurons{1}.IRON));
LICK_mat = zeros(numNeuron,numel(Neurons{1}.LICK));
LOFF_mat = zeros(numNeuron,numel(Neurons{1}.LOFF));
IROF_mat = zeros(numNeuron,numel(Neurons{1}.IROF));
ATTK_mat = zeros(numNeuron,numel(Neurons{1}.ATTK));
TROF_mat = zeros(numNeuron,numel(Neurons{1}.TROF));

for n = 1 : numNeuron
    TRON_mat(n,:) = Neurons{n}.TRON;
    IRON_mat(n,:) = Neurons{n}.IRON;
    LICK_mat(n,:) = Neurons{n}.LICK;
    LOFF_mat(n,:) = Neurons{n}.LOFF;
    IROF_mat(n,:) = Neurons{n}.IROF;
    ATTK_mat(n,:) = Neurons{n}.ATTK;
    TROF_mat(n,:) = Neurons{n}.TROF;
end

clearvars Neurons n

%% figure 그리기 (sorting 안하고 선택한 neuron___aligned.mat 파일 순서로 plot
% figure('name','TRON');
% imagesc(TRON_mat);
% figure('name','IRON');
% imagesc(IRON_mat);
% figure('name','LICK');
% imagesc(LICK_mat);
% figure('name','LOFF');
% imagesc(LOFF_mat);
% figure('name','IROF');
% imagesc(IROF_mat);
% figure('name','ATTK');
% imagesc(ATTK_mat);
% figure('name','TROF');
% imagesc(TROF_mat);

%% Constants
%varnames = {'TRON_mat','IRON_mat','LICK_mat','LOFF_mat','IROF_mat','ATTK_mat','TROF_mat'};
varnames = {'LOFF_mat','IROF_mat','ATTK_mat'};
zeroline = 40; % A3에서 edges를 기준으로 0인 지점의 index 값. A3 코드가 바뀌면 바꿔줘야 함!!!
xedges = -4:0.1:4; 

N = 4; % 사용하는 Component의 수
KernelSize = 10; % moving average의 크기

%% PCA 돌리고 그 결과값(loading)에 따라서 재정렬)
Screensize = get(groot, 'Screensize'); % 좌에 정렬된 그래프, 우에 eigenvector를 표시하기 위한 부분.

for events = 1 : numel(varnames)
    % PCA 돌리기. 이 부분은 논문의 코드와 정확히 일치함.
    X = eval(varnames{events}); % 각 조건별 데이터 불러오기
    X = movmean(X,KernelSize,2); % X축으로 이동하며(열로 이동하며) moving average)
    [u, s, v] = svd(X',0);
    U = u(:,1:N); % eigenvenctors
    l = diag(s).^2/(numNeuron-1); % eigenvalues
    Z = X*U; % scores = loading
    clearvars u s v
    
    % Component figure 그리기.
    gui2 = figure('name',[varnames{events}, ' : Components']);
    set(gui2, 'Position', [1,1,Screensize(3)/2,Screensize(4)]);
    movegui(gui2,'east');
    for comp = 1 : N
        subplot(N,1,comp);
        plot(U(:,comp));
    end
    subplot(N,1,1);
    title([varnames{events}, ' : Components']);
    
    % loading 값에 따라서 정렬한 Neuron 데이터 그리기.
    gui1 = figure('name',varnames{events});
    set(gui1, 'Position', [1,1,Screensize(3)/2,Screensize(4)]);
    movegui(gui1,'west');
    % 총 N개의 component를 사용. 각 component의 loading 값을 기준으로 정렬함.
    % 데이터에는 따로 손을 안대고 정렬하는 방식만 바꾼 것.
    title(varnames{events});
    for comp = 1 : N
        subplot(N,1,comp);
        [~,sortindex] = sort(Z(:,comp));
        imagesc(X(sortindex,:));
        colormap jet;
        hold on;
        line([zeroline, zeroline],[0, numNeuron],'Color','r');
    end
    subplot(N,1,1);
    title(varnames{events});
end
        

