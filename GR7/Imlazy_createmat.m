%% A2 스크립트와 A3 스크립트를 돌린 후 뉴런 firing 데이터만 저장하는 script
% 먼저 uigetfile 함수를 통해서 여러개의 뉴런 데이터(.mat)형식을 선택.
% 다음으로 GambleRatsBehavParser를 돌리기 위해서 EVENT 폴더를 선택해 주는 uiget dir을 실행.
% 처음에 선택한 뉴런 데이터의 파일명을 기준으로 A3를 돌린뒤 해당 결과물을 .png 형식으로 저장.
% 향후 PCA 분석을 위함.

[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

if exist(strcat(pathname,'EVENTS'),'dir') == 7 % 같은 위치에 EVENTS 폴더가 있음
    targetdir = strcat(pathname,'EVENTS');
else
    targetdir = uigetdir(); % 같은 위치에 EVENT 폴더가 없으면 사용자에게 물어봄.
end

for f = 1 : numel(Paths)
    load(Paths{f});
    neuronname = filename{f};
    donotdrawA2 = true; % A2에서 이 파트가 있으면 뒤에서 그래프를 그리지 않음.
    A2_GR_singleUnit_anlyzer_JH;
    A3_GR_PSTH_v3_JH;
    clearvars -except filename pathname Paths targetdir f Z
    if exist(strcat(pathname,'aligned'),'dir') == 0 % aligned 폴더가 존재하지 않으면
        mkdir(strcat(pathname,'aligned')); % 만들어줌
    end
    save([pathname,'\aligned\',filename{f}(1:end-4),'___aligned.mat'],'Z');
    clearvars Z
end

fprintf('====================================================\n');
fprintf('%d 개의 파일이 %s에 생성되었습니다.\n',f,strcat(pathname,'aligned'));