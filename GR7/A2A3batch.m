%% A2, A3 �ڵ�ȭ ��ũ��Ʈ.
% uigetfile �Լ��� ���ؼ� �������� ���� ������(.mat)������ ����.
% �ൿ �����Ͱ� ����ִ� EVENT ������ ����.
% (���� �����Ϳ� ���� ��ġ�� EVENT ������ ������ ���� �ʰ� �ش� ������ ���)
% ó���� ������ ���� �������� ���ϸ��� �������� A3�� ������ �ش� ������� .png �������� ����.

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
    A2_GR_singleUnit_anlyzer_JH;
    A3_GR_PSTH_v2_JH;
end