%% A2, A3 �� ���� �� align�� firing �����͸� �����ϴ� ��ũ��Ʈ.
% uigetfile �Լ��� ���ؼ� �������� ���� ������(.mat)������ ����.
% �ൿ �����Ͱ� ����ִ� EVENT ������ ����.
% (���� �����Ϳ� ���� ��ġ�� EVENT ������ ������ ���� �ʰ� �ش� ������ ���)
% align�� firing data�� ������ ���� ���� ���� ___aligned �� �ٿ��� ����.
% ���� PCA �м��� ����.

[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
if isequal(filename,0)
    return;
end
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

if exist(strcat(pathname,'EVENTS'),'dir') == 7 % ���� ��ġ�� EVENTS ������ ����
    targetdir = strcat(pathname,'EVENTS');
else
    targetdir = uigetdir(); % ���� ��ġ�� EVENT ������ ������ ����ڿ��� ���.
    if isequal(targetdir,0)
        return;
    end
end

for f = 1 : numel(Paths)
    load(Paths{f});
    neuronname = filename{f};
    donotdrawA2 = true; % A2���� �� ��Ʈ�� ������ �ڿ��� �׷����� �׸��� ����.
    A2_GR_singleUnit_anlyzer;
    A3_GR_PSTH_noplot;
    clearvars -except filename pathname Paths targetdir f Z
    if exist(strcat(pathname,'aligned'),'dir') == 0 % aligned ������ �������� ������
        mkdir(strcat(pathname,'aligned')); % �������
    end
    save([pathname,'\aligned\',filename{f}(1:end-4),'___aligned.mat'],'Z');
    clearvars Z
end

fprintf('====================================================\n');
fprintf('%d ���� ������ %s�� �����Ǿ����ϴ�.\n',f,strcat(pathname,'aligned'));