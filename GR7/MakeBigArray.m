%% ����� aligned �� mat ������ �о �ϳ��� ū ���Ϸ� �����.


%% �м��� .mat ���� ����
[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
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


%% figure �׸���
figure('name','TRON');
imagesc(TRON_mat);
figure('name','IRON');
imagesc(IRON_mat);
figure('name','LICK');
imagesc(LICK_mat);
figure('name','LOFF');
imagesc(LOFF_mat);
figure('name','IROF');
imagesc(IROF_mat);
figure('name','ATTK');
imagesc(ATTK_mat);
figure('name','TROF');
imagesc(TROF_mat);

%% Ư�� timepoint(0�� ����)�� �������� ����
zeroline = [61,31,61,61,101,101,101]; % A3���� edges�� �������� 0�� ������ index ��.

% �� ���� ���ķ� 9point, 10����Ʈ�� �ؼ� ����� ����
TRON_sort_val = mean(TRON_mat(:,zeroline(1):zeroline(1)+20),2);
IRON_sort_val = mean(IRON_mat(:,zeroline(2):zeroline(2)+20),2);
LICK_sort_val = mean(LICK_mat(:,zeroline(3):zeroline(3)+20),2);
LOFF_sort_val = mean(LOFF_mat(:,zeroline(4):zeroline(4)+20),2);
IROF_sort_val = mean(IROF_mat(:,zeroline(5):zeroline(5)+20),2);
ATTK_sort_val = mean(ATTK_mat(:,zeroline(6):zeroline(6)+20),2);
TROF_sort_val = mean(TROF_mat(:,zeroline(7):zeroline(7)+20),2);

% �� ��հ��� �������� ���� ����� neuron�� ����
[~, TRON_sort_i] = sort(TRON_sort_val);
[~, IRON_sort_i] = sort(IRON_sort_val);
[~, LICK_sort_i] = sort(LICK_sort_val);
[~, LOFF_sort_i] = sort(LOFF_sort_val);
[~, IROF_sort_i] = sort(IROF_sort_val);
[~, ATTK_sort_i] = sort(ATTK_sort_val);
[~, TROF_sort_i] = sort(TROF_sort_val);

%% ���ĵȰ� plot
f1 = figure('name','TRON');
imagesc(TRON_mat(TRON_sort_i,:));
hold on;
line([zeroline(1), zeroline(1)],[0, numNeuron],'Color','r');

f2 = figure('name','IRON');
imagesc(IRON_mat(IRON_sort_i,:));
hold on;
line([zeroline(2), zeroline(2)],[0, numNeuron],'Color','r');

f3 = figure('name','LICK');
imagesc(LICK_mat(LICK_sort_i,:));
hold on;
line([zeroline(3), zeroline(3)],[0, numNeuron],'Color','r');

f4 = figure('name','LOFF');
imagesc(LOFF_mat(LOFF_sort_i,:));
hold on;
line([zeroline(4), zeroline(4)],[0, numNeuron],'Color','r');

f5 = figure('name','IROF');
imagesc(IROF_mat(IROF_sort_i,:));
hold on;
line([zeroline(5), zeroline(5)],[0, numNeuron],'Color','r');

f6 = figure('name','ATTK');
imagesc(ATTK_mat(ATTK_sort_i,:));
hold on;
line([zeroline(6), zeroline(6)],[0, numNeuron],'Color','r');

f7 = figure('name','TROF');
imagesc(TROF_mat(TROF_sort_i,:));
hold on;
line([zeroline(7), zeroline(7)],[0, numNeuron],'Color','r');
