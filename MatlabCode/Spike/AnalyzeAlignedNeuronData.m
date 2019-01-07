%% depricated


%% aligned mat ���� �������� �Ѳ����� �о PCA�� ������ ��ũ��Ʈ
% Imlazy_createmat.m �̳� Imlazy_trial_by_trial.m ���� �����ϴ� *aligned.mat �����Ͱ�
% �ʿ�.
% ������ aligned.mat �� �ϳ��� neuron�� �����ϴ� ��������.
% �� �ڵ带 �����ϸ� ���� aligned.mat ������ �����ϵ��� �ϰ�, �� �����ͷ� PCA �м��� ������.

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
        

