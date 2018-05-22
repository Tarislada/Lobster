%% 텍스트 파일에서 데이터를 가져옵니다.

clc
clear

[FileName,PathName] = uigetfile;

filepath = strcat(PathName,FileName);

%% 변수를 초기화합니다.
filename = filepath;
delimiter = ',';
startRow = 2;

%% 데이터 열을 텍스트로 읽음:
% 자세한 내용은 도움말 문서에서 TEXTSCAN을 참조하십시오.
formatSpec = '%*s%*s%f%f%*s%*s%f%*[^\n\r]';

%% 텍스트 파일을 엽니다.
fileID = fopen(filename,'r');

%% 형식에 따라 데이터 열을 읽습니다.
% 이 호출은 이 코드를 생성하는 데 사용되는 파일의 구조체를 기반으로 합니다. 다른 파일에 대한 오류가 발생하는 경우 가져오기 툴에서
% 코드를 다시 생성하십시오.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% 텍스트 파일을 닫습니다.
fclose(fileID);


%%%%%%%%%%%%%%%% 여기까지 모든 데이터를 전부 dataArray 라는 이름의 cell 안에 넣습니다.

% 데이터의 형태를 보니 한 timepoint에 8채널의 데이터를 받습니다.
% 일단 8채널 데이터를 받는 것이면 전체 사이즈가 8로 나눠져야겠지요.
TIME = dataArray{1};
CHAN = dataArray{2};
D0 = dataArray{3};

if rem(numel(dataArray{1}),8) ~= 0 
    % 같은 시간에 데이터가 8개 있다는 가정 하에 아래 코드를 진행하기에 에러 체크를 해줍니다.
    error('데이터가 8채널이 아닙니다.')
end

num_datapoint = numel(dataArray{1}) / 8;

% 8개씩 나눠서 데이터를 정렬합니다.
TIME_reshaped = reshape(TIME,8,num_datapoint);
CHAN_reshaped = reshape(CHAN,8,num_datapoint);
D0_reshaped = reshape(D0,8,num_datapoint);

if sum(sum(CHAN_reshaped) ~= 36) ~= 0 
    % 위의 가정을 기반으로 8개씩 자르면 각 자른 조각마다 channel 1,2,3,4,5,6,7,8이 하나씩 있어야 합니다.
    % 항상 87654321 순으로 받으면 정말 좋을텐데 꼭 그런건 아닌가 봅니다.
    % 그래서 채널 값들을 다 합하면 (1+2+3+4+5+6+7+8 = )36이고 이게 아닌 놈들이 행여나 있는지 확인합니다.
    error('채널이 밀렸을 수 있습니다.')
end

%%%%%%%%%%%%%%%%%
% 가장 쉬운 시간을 먼저 뽑습니다.
TIME = TIME_reshaped(1,:)';

% 각 데이터 포인트를 짚어가며 채널에 맞는 데이터를 찾아갑니다.
arranged_D0 = zeros(num_datapoint,8);

for i = 1 : num_datapoint
    channelarray = CHAN_reshaped(:,i)';
    for chn = 1 : 8
        arranged_D0(i,channelarray == chn) = D0_reshaped(chn,i);
    end
end
        
% arranged_D0에 채널 순으로 설정한 데이터가 알맞게 들어갔습니다.

POS1x = arranged_D0(:,8);
POS1y = arranged_D0(:,7);
POS1A = arranged_D0(:,5);

POS2x = arranged_D0(:,4);
POS2y = arranged_D0(:,3);
POS2A = arranged_D0(:,1);

LOC{1,1} = POS1x;
LOC{2,1} = POS1y;
LOC{1,2} = POS2x;
LOC{2,2} = POS2y;


clearvars CHAN CHAN_reshaped channelarray chn D0 dataArray delimiter fileID filename formatSpec i num_datapoint startRow TIME_reshaped


%%


RELOC = recoverLocData(LOC);

figure

plot(RELOC{1,1},RELOC{2,1},'g')
hold on
plot(RELOC{1,2},RELOC{2,2},'r')



XY1 = [RELOC{1,1},RELOC{2,1}];
XY2 = [RELOC{1,2},RELOC{2,2}];








