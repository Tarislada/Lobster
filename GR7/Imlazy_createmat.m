%% A2 ��ũ��Ʈ�� A3 ��ũ��Ʈ�� ���� �� ���� firing �����͸� �����ϴ� script
% ���� uigetfile �Լ��� ���ؼ� �������� ���� ������(.mat)������ ����.
% �������� GambleRatsBehavParser�� ������ ���ؼ� EVENT ������ ������ �ִ� uiget dir�� ����.
% ó���� ������ ���� �������� ���ϸ��� �������� A3�� ������ �ش� ������� .png �������� ����.
% ���� PCA �м��� ����.

[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

targetdir = uigetdir();

for f = 1 : numel(Paths)
    load(Paths{f});
    neuronname = filename{f};
    donotdrawA2 = true; % A2���� �� ��Ʈ�� ������ �ڿ��� �׷����� �׸��� ����.
    A2_GR_singleUnit_anlyzer_JH;
    A3_GR_PSTH_v3_JH;
    clearvars -except filename pathname Paths targetdir f Z
    save([filename{f}(1:end-4),'___aligned.mat'],'Z');
    clearvars Z
end