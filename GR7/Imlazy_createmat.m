% A2�� A3_v3_JH�� ���ÿ� �����µ�, ���� PCA �м��� ���ؼ� figure�� �׸��� �ʰ� mat ���ϸ� �����ϴ�
% ���α׷��Դϴ�.

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
    donotdrawA2 = true;
    A2_GR_singleUnit_anlyzer_JH;
    A3_GR_PSTH_v3_JH;
    clearvars -except filename pathname Paths targetdir f Z
    save([filename{f}(1:end-4),'___aligned.mat'],'Z');
    clearvars Z
end