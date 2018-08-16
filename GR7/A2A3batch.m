%% A2, A3 자동화 스크립트.
% uigetfile 함수를 통해서 여러개의 뉴런 데이터(.mat)형식을 선택.
% 행동 데이터가 들어있는 EVENT 폴더를 선택.
% (뉴런 데이터와 같은 위치에 EVENT 폴더가 있으면 묻지 않고 해당 폴더를 사용)
% 처음에 선택한 뉴런 데이터의 파일명을 기준으로 A3를 돌린뒤 해당 결과물을 .png 형식으로 저장.

[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
if isequal(filename,0)
    return;
end
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

if exist(strcat(pathname,'EVENTS'),'dir') == 7 % 같은 위치에 EVENTS 폴더가 있음
    targetdir = strcat(pathname,'EVENTS');
else
    targetdir = uigetdir(); % 같은 위치에 EVENT 폴더가 없으면 사용자에게 물어봄.
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