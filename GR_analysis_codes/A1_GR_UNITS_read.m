%% 텍스트 파일에서 데이터를 가져옵니다.
% open units exported in 'txt' file

clc
clear


[FileName,PathName] = uigetfile;


%% 변수를 초기화합니다.
F = strcat(PathName, FileName);
delimiter = ',';
startRow = 2;

%% 각 텍스트 라인의 형식:
%   열1: double (%f)
%	열2: double (%f)
%   열3: double (%f)
%	열4: double (%f)
%   열5: double (%f)
%	열6: double (%f)
%   열7: double (%f)
%	열8: double (%f)
%   열9: double (%f)
%	열10: double (%f)
%   열11: double (%f)
%	열12: double (%f)
%   열13: double (%f)
%	열14: double (%f)
%   열15: double (%f)
%	열16: double (%f)
%   열17: double (%f)
%	열18: double (%f)
%   열19: double (%f)
%	열20: double (%f)
%   열21: double (%f)
%	열22: double (%f)
%   열23: double (%f)
%	열24: double (%f)
%   열25: double (%f)
%	열26: double (%f)
%   열27: double (%f)
%	열28: double (%f)
%   열29: double (%f)
%	열30: double (%f)
%   열31: double (%f)
%	열32: double (%f)
%   열33: double (%f)
%	열34: double (%f)
%   열35: double (%f)
%	열36: double (%f)
%   열37: double (%f)
%	열38: double (%f)
%   열39: double (%f)
%	열40: double (%f)
%   열41: double (%f)
%	열42: double (%f)
%   열43: double (%f)
%	열44: double (%f)
%   열45: double (%f)
%	열46: double (%f)
%   열47: double (%f)
%	열48: double (%f)
%   열49: double (%f)
%	열50: double (%f)
%   열51: double (%f)
%	열52: double (%f)
%   열53: double (%f)
%	열54: double (%f)
%   열55: double (%f)
%	열56: double (%f)
%   열57: double (%f)
%	열58: double (%f)
%   열59: double (%f)
%	열60: double (%f)
%   열61: double (%f)
%	열62: double (%f)
%   열63: double (%f)
%	열64: double (%f)
%   열65: double (%f)
%	열66: double (%f)
%   열67: double (%f)
%	열68: double (%f)
%   열69: double (%f)
%	열70: double (%f)
%   열71: double (%f)
%	열72: double (%f)
%   열73: double (%f)
%	열74: double (%f)
%   열75: double (%f)
%	열76: double (%f)
%   열77: double (%f)
%	열78: double (%f)
%   열79: double (%f)
%	열80: double (%f)
%   열81: double (%f)
%	열82: double (%f)
%   열83: double (%f)
%	열84: double (%f)
%   열85: double (%f)
%	열86: double (%f)
%   열87: double (%f)
%	열88: double (%f)
%   열89: double (%f)
%	열90: double (%f)
%   열91: double (%f)
% 자세한 내용은 도움말 문서에서 TEXTSCAN을 참조하십시오.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% 텍스트 파일을 엽니다.
fileID = fopen(F,'r');

%% 형식에 따라 데이터 열을 읽습니다.
% 이 호출은 이 코드를 생성하는 데 사용되는 파일의 구조체를 기반으로 합니다. 다른 파일에 대한 오류가 발생하는 경우 가져오기 툴에서
% 코드를 다시 생성하십시오.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% 텍스트 파일을 닫습니다.
fclose(fileID);

%% 가져올 수 없는 데이터에 대한 사후 처리 중입니다.
% 가져오기 과정에서 가져올 수 없는 데이터에 규칙이 적용되지 않았으므로 사후 처리 코드가 포함되지 않았습니다. 가져올 수 없는
% 데이터에 사용할 코드를 생성하려면 파일에서 가져올 수 없는 셀을 선택하고 스크립트를 다시 생성하십시오.

%% 출력 변수 만들기
UNITS = table(dataArray{1:end-1}, 'VariableNames', {'Timestamp','Channel','Unit','VarName4','VarName5','VarName6','VarName7','VarName8','VarName9','VarName10','VarName11','VarName12','VarName13','VarName14','VarName15','VarName16','VarName17','VarName18','VarName19','VarName20','VarName21','VarName22','VarName23','VarName24','VarName25','VarName26','VarName27','VarName28','VarName29','VarName30','VarName31','VarName32','VarName33','VarName34','VarName35','VarName36','VarName37','VarName38','VarName39','VarName40','VarName41','VarName42','VarName43','VarName44','VarName45','VarName46','VarName47','VarName48','VarName49','VarName50','VarName51','VarName52','VarName53','VarName54','VarName55','VarName56','VarName57','VarName58','VarName59','VarName60','VarName61','VarName62','VarName63','VarName64','VarName65','VarName66','VarName67','VarName68','VarName69','VarName70','VarName71','VarName72','VarName73','VarName74','VarName75','VarName76','VarName77','VarName78','VarName79','VarName80','VarName81','VarName82','VarName83','VarName84','VarName85','VarName86','VarName87','VarName88','VarName89','VarName90','VarName91'});

%% 임시 변수 지우기
clearvars filename delimiter startRow formatSpec fileID dataArray ans;




%% Segregate by Units


Chan = UNITS(:,2);
Chan = table2array(Chan);
Chan_num = max(Chan);



for i = 1:Chan_num
    
T = find(Chan == i);

TT = UNITS(T,:);


U = TT(:,3);
U = table2array(U);
U_num = max(U);


for j = 1:U_num

    TU = find(U == j);
    
    MU{j,i} = TT(TU,:);
    
     
end

end

Filename = strsplit(FileName,'.');
Filename = strcat(Filename(1),'_UNITS');
save(Filename{1},'MU')
%% Look into each unit

Unitname = strsplit(FileName,'.');
Unitname = Unitname(1);
d = 0;


for k=1:i*j

if isempty(MU{k}) == 1
    
    d = d+1;
end
    
    
if isempty(MU{k}) == 0
    
    SU = MU{k};
    
    Unit = strcat(Unitname,'_',num2str(k-d));
    save(Unit{1},'SU')
    
end

end

    


