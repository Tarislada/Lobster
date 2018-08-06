%% A2 스크립트와 A3 스크립트를 돌린 후 그려진 데이터를 한번에 저장하기 위한 script
% 먼저 uigetfile 함수를 통해서 여러개의 뉴런 데이터(.mat)형식을 선택.
% 다음으로 GambleRatsBehavParser를 돌리기 위해서 EVENT 폴더를 선택해 주는 uiget dir을 실행.
% 처음에 선택한 뉴런 데이터의 파일명을 기준으로 A3를 돌린뒤 해당 결과물을 .png 형식으로 저장.

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
    A2_GR_singleUnit_anlyzer_JH;
    A3_GR_PSTH_v2_JH;
end