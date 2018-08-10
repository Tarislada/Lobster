%% Neuron�� �ι� �ҷ��ͼ� Avoid�� Escape�� ���̸� ��.

%% aligned mat ���� �������� �Ѳ����� �о PCA�� ������ ��ũ��Ʈ - Avoid - Escape
% Imlazy_createmat.m �̳� Imlazy_trial_by_trial.m ���� �����ϴ� *aligned.mat �����Ͱ�
% �ʿ�.
% ������ aligned.mat �� �ϳ��� neuron�� �����ϴ� ��������.
% �� �ڵ带 �����ϸ� ���� aligned.mat ������ �����ϵ��� �ϰ�, �� �����ͷ� PCA �м��� ������.


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
% TRON_mat1 = zeros(numNeuron,numel(Neurons{1}.TRON));
% IRON_mat1 = zeros(numNeuron,numel(Neurons{1}.IRON));
% LICK_mat1 = zeros(numNeuron,numel(Neurons{1}.LICK));
LOFF_mat1 = zeros(numNeuron,numel(Neurons{1}.LOFF));
IROF_mat1 = zeros(numNeuron,numel(Neurons{1}.IROF));
ATTK_mat1 = zeros(numNeuron,numel(Neurons{1}.ATTK));
% TROF_mat1 = zeros(numNeuron,numel(Neurons{1}.TROF));

for n = 1 : numNeuron
%     TRON_mat1(n,:) = Neurons{n}.TRON;
%     IRON_mat1(n,:) = Neurons{n}.IRON;
%     LICK_mat1(n,:) = Neurons{n}.LICK;
    LOFF_mat1(n,:) = Neurons{n}.LOFF;
    IROF_mat1(n,:) = Neurons{n}.IROF;
    ATTK_mat1(n,:) = Neurons{n}.ATTK;
%     TROF_mat1(n,:) = Neurons{n}.TROF;
end

clearvars Neurons n

IROF_mat1_new = [];
for i = 1 : size(IROF_mat1,1)
    if or(sum(IROF_mat1(i,:)>3) >= 1,sum(IROF_mat1(i,:)<-3) >= 1)
        IROF_mat1_new = [IROF_mat1_new;IROF_mat1(i,:)];
    end
end

%% Escape
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
% TRON_mat2 = zeros(numNeuron,numel(Neurons{1}.TRON));
% IRON_mat2 = zeros(numNeuron,numel(Neurons{1}.IRON));
% LICK_mat2 = zeros(numNeuron,numel(Neurons{1}.LICK));
LOFF_mat2 = zeros(numNeuron,numel(Neurons{1}.LOFF));
IROF_mat2 = zeros(numNeuron,numel(Neurons{1}.IROF));
ATTK_mat2 = zeros(numNeuron,numel(Neurons{1}.ATTK));
% TROF_mat2 = zeros(numNeuron,numel(Neurons{1}.TROF));

for n = 1 : numNeuron
%     TRON_mat2(n,:) = Neurons{n}.TRON;
%     IRON_mat2(n,:) = Neurons{n}.IRON;
%     LICK_mat2(n,:) = Neurons{n}.LICK;
    LOFF_mat2(n,:) = Neurons{n}.LOFF;
    IROF_mat2(n,:) = Neurons{n}.IROF;
    ATTK_mat2(n,:) = Neurons{n}.ATTK;
%     TROF_mat2(n,:) = Neurons{n}.TROF;
end

clearvars Neurons n

IROF_mat2_new = [];
for i = 1 : size(IROF_mat2,1)
    if or(sum(IROF_mat2(i,:)>3) >= 1,sum(IROF_mat2(i,:)<-3) >= 1)
        IROF_mat2_new = [IROF_mat2_new;IROF_mat2(i,:)];
    end
end




IROF_mat = IROF_mat1 -IROF_mat2;
LOFF_mat = LOFF_mat1 -LOFF_mat2;
ATTK_mat = ATTK_mat1 -ATTK_mat2;



%% Constants
%varnames = {'TRON_mat','IRON_mat','LICK_mat','LOFF_mat','IROF_mat','ATTK_mat','TROF_mat'};
varnames = {'LOFF_mat','IROF_mat','ATTK_mat'};
zeroline = 40; % A3���� edges�� �������� 0�� ������ index ��. A3 �ڵ尡 �ٲ�� �ٲ���� ��!!!
xedges = -4:0.1:4; 

N = 4; % ����ϴ� Component�� ��
KernelSize = 10; % moving average�� ũ��

%% PCA ������ �� �����(loading)�� ���� ������)
Screensize = get(groot, 'Screensize'); % �¿� ���ĵ� �׷���, �쿡 eigenvector�� ǥ���ϱ� ���� �κ�.

for events = 1 : numel(varnames)
    % PCA ������. �� �κ��� ���� �ڵ�� ��Ȯ�� ��ġ��.
    X = eval(varnames{events}); % �� ���Ǻ� ������ �ҷ�����
    X = movmean(X,KernelSize,2); % X������ �̵��ϸ�(���� �̵��ϸ�) moving average)
    [u, s, v] = svd(X',0);
    U = u(:,1:N); % eigenvenctors
    l = diag(s).^2/(numNeuron-1); % eigenvalues
    Z = X*U; % scores = loading
    clearvars u s v
    
    % Component figure �׸���.
    gui2 = figure('name',[varnames{events}, ' : Components']);
    set(gui2, 'Position', [1,1,Screensize(3)/2,Screensize(4)]);
    movegui(gui2,'east');
    for comp = 1 : N
        subplot(N,1,comp);
        plot(U(:,comp));
    end
    subplot(N,1,1);
    title([varnames{events}, ' : Components']);
    
    % loading ���� ���� ������ Neuron ������ �׸���.
    gui1 = figure('name',varnames{events});
    set(gui1, 'Position', [1,1,Screensize(3)/2,Screensize(4)]);
    movegui(gui1,'west');
    % �� N���� component�� ���. �� component�� loading ���� �������� ������.
    % �����Ϳ��� ���� ���� �ȴ�� �����ϴ� ��ĸ� �ٲ� ��.
    title(varnames{events});
    for comp = 1 : N
        subplot(1,N,comp);
        [~,sortindex] = sort(Z(:,comp));
        imagesc(X(sortindex,:));
        colormap jet;
        hold on;
        line([zeroline, zeroline],[0, numNeuron],'Color','r');
    end
    subplot(1,N,1);
    title(varnames{events});
end
        

