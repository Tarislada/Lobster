%% RVn1.csv 에서 location 뽑아내기


%% Load Data
[filename, pathname] = uigetfile('.csv','위치파일 "*RVn1.csv 파일을 선택해 주세요.');
fileID = fopen([pathname,filename],'r');

formatSpec = '%*s%s%f%d%*d%*d%d';
dataArray = textscan(fileID,formatSpec, 'Delimiter', ',', 'ReturnOnError',false, 'HeaderLines',1);

% EVENT 이름이 RVn1 이 맞는지 확인.
if (dataArray{1}(1) ~= 'RVn1')
    error('RVn1 데이터가 맞나요? 이벤트 이름이 다른것 같습니다.');
end

% 데이터 옮겨담기
Time = dataArray{2};
Channel = dataArray{3};
D0 = dataArray{4};

clearvars pathname fileID formatSpec dataArray

%% Parse Data

% 먼저 하나의 timepoint에 대해서 채널이 총 8개가 있는것이 맞는가 확인.





