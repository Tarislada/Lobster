%% A2, A3 를 돌린 후 align된 firing 데이터를 저장하는 스크립트.
% uigetfile 함수를 통해서 여러개의 뉴런 데이터(.mat)형식을 선택.
% 행동 데이터가 들어있는 EVENT 폴더를 선택.
% (뉴런 데이터와 같은 위치에 EVENT 폴더가 있으면 묻지 않고 해당 폴더를 사용)
% align된 firing data를 선택한 뉴런 파일 끝에 ___aligned 를 붙여서 저장.
% 향후 PCA 분석을 위함.

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
    donotdrawA2 = true; % A2에서 이 파트가 있으면 뒤에서 그래프를 그리지 않음.
    A2_GR_singleUnit_anlyzer;
    A3_GR_PSTH_noplot;
    clearvars -except filename pathname Paths targetdir f Z
    if exist(strcat(pathname,'aligned'),'dir') == 0 % aligned 폴더가 존재하지 않으면
        mkdir(strcat(pathname,'aligned')); % 만들어줌
    end
    save([pathname,'\aligned\',filename{f}(1:end-4),'___aligned.mat'],'Z');
    clearvars Z
end

fprintf('====================================================\n');
fprintf('%d 개의 파일이 %s에 생성되었습니다.\n',f,strcat(pathname,'aligned'));