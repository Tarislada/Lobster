%% A2 ��ũ��Ʈ�� A3 ��ũ��Ʈ�� ���� �� �׷��� �����͸� �ѹ��� �����ϱ� ���� script
% ���� uigetfile �Լ��� ���ؼ� �������� ���� ������(.mat)������ ����.
% �������� GambleRatsBehavParser�� ������ ���ؼ� EVENT ������ ������ �ִ� uiget dir�� ����.
% ó���� ������ ���� �������� ���ϸ��� �������� A3�� ������ �ش� ������� .png �������� ����.

[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

if exist(strcat(pathname,'EVENTS'),'dir') == 7 % ���� ��ġ�� EVENTS ������ ����
    targetdir = strcat(pathname,'EVENTS');
else
    targetdir = uigetdir(); % ���� ��ġ�� EVENT ������ ������ ����ڿ��� ���.
end

for f = 1 : numel(Paths)
    load(Paths{f});
    neuronname = filename{f};
    A2_GR_singleUnit_anlyzer_JH;
    A3_GR_PSTH_v2_JH;
end