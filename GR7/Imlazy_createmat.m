% A2와 A3_v3_JH를 동시에 돌리는데, 향후 PCA 분석을 위해서 figure는 그리지 않고 mat 파일만 저장하는
% 프로그램입니다.

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