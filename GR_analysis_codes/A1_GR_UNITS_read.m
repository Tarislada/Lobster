%% �ؽ�Ʈ ���Ͽ��� �����͸� �����ɴϴ�.
% open units exported in 'txt' file

clc
clear


[FileName,PathName] = uigetfile;


%% ������ �ʱ�ȭ�մϴ�.
F = strcat(PathName, FileName);
delimiter = ',';
startRow = 2;

%% �� �ؽ�Ʈ ������ ����:
%   ��1: double (%f)
%	��2: double (%f)
%   ��3: double (%f)
%	��4: double (%f)
%   ��5: double (%f)
%	��6: double (%f)
%   ��7: double (%f)
%	��8: double (%f)
%   ��9: double (%f)
%	��10: double (%f)
%   ��11: double (%f)
%	��12: double (%f)
%   ��13: double (%f)
%	��14: double (%f)
%   ��15: double (%f)
%	��16: double (%f)
%   ��17: double (%f)
%	��18: double (%f)
%   ��19: double (%f)
%	��20: double (%f)
%   ��21: double (%f)
%	��22: double (%f)
%   ��23: double (%f)
%	��24: double (%f)
%   ��25: double (%f)
%	��26: double (%f)
%   ��27: double (%f)
%	��28: double (%f)
%   ��29: double (%f)
%	��30: double (%f)
%   ��31: double (%f)
%	��32: double (%f)
%   ��33: double (%f)
%	��34: double (%f)
%   ��35: double (%f)
%	��36: double (%f)
%   ��37: double (%f)
%	��38: double (%f)
%   ��39: double (%f)
%	��40: double (%f)
%   ��41: double (%f)
%	��42: double (%f)
%   ��43: double (%f)
%	��44: double (%f)
%   ��45: double (%f)
%	��46: double (%f)
%   ��47: double (%f)
%	��48: double (%f)
%   ��49: double (%f)
%	��50: double (%f)
%   ��51: double (%f)
%	��52: double (%f)
%   ��53: double (%f)
%	��54: double (%f)
%   ��55: double (%f)
%	��56: double (%f)
%   ��57: double (%f)
%	��58: double (%f)
%   ��59: double (%f)
%	��60: double (%f)
%   ��61: double (%f)
%	��62: double (%f)
%   ��63: double (%f)
%	��64: double (%f)
%   ��65: double (%f)
%	��66: double (%f)
%   ��67: double (%f)
%	��68: double (%f)
%   ��69: double (%f)
%	��70: double (%f)
%   ��71: double (%f)
%	��72: double (%f)
%   ��73: double (%f)
%	��74: double (%f)
%   ��75: double (%f)
%	��76: double (%f)
%   ��77: double (%f)
%	��78: double (%f)
%   ��79: double (%f)
%	��80: double (%f)
%   ��81: double (%f)
%	��82: double (%f)
%   ��83: double (%f)
%	��84: double (%f)
%   ��85: double (%f)
%	��86: double (%f)
%   ��87: double (%f)
%	��88: double (%f)
%   ��89: double (%f)
%	��90: double (%f)
%   ��91: double (%f)
% �ڼ��� ������ ���� �������� TEXTSCAN�� �����Ͻʽÿ�.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% �ؽ�Ʈ ������ ���ϴ�.
fileID = fopen(F,'r');

%% ���Ŀ� ���� ������ ���� �н��ϴ�.
% �� ȣ���� �� �ڵ带 �����ϴ� �� ���Ǵ� ������ ����ü�� ������� �մϴ�. �ٸ� ���Ͽ� ���� ������ �߻��ϴ� ��� �������� ������
% �ڵ带 �ٽ� �����Ͻʽÿ�.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% �ؽ�Ʈ ������ �ݽ��ϴ�.
fclose(fileID);

%% ������ �� ���� �����Ϳ� ���� ���� ó�� ���Դϴ�.
% �������� �������� ������ �� ���� �����Ϳ� ��Ģ�� ������� �ʾ����Ƿ� ���� ó�� �ڵ尡 ���Ե��� �ʾҽ��ϴ�. ������ �� ����
% �����Ϳ� ����� �ڵ带 �����Ϸ��� ���Ͽ��� ������ �� ���� ���� �����ϰ� ��ũ��Ʈ�� �ٽ� �����Ͻʽÿ�.

%% ��� ���� �����
UNITS = table(dataArray{1:end-1}, 'VariableNames', {'Timestamp','Channel','Unit','VarName4','VarName5','VarName6','VarName7','VarName8','VarName9','VarName10','VarName11','VarName12','VarName13','VarName14','VarName15','VarName16','VarName17','VarName18','VarName19','VarName20','VarName21','VarName22','VarName23','VarName24','VarName25','VarName26','VarName27','VarName28','VarName29','VarName30','VarName31','VarName32','VarName33','VarName34','VarName35','VarName36','VarName37','VarName38','VarName39','VarName40','VarName41','VarName42','VarName43','VarName44','VarName45','VarName46','VarName47','VarName48','VarName49','VarName50','VarName51','VarName52','VarName53','VarName54','VarName55','VarName56','VarName57','VarName58','VarName59','VarName60','VarName61','VarName62','VarName63','VarName64','VarName65','VarName66','VarName67','VarName68','VarName69','VarName70','VarName71','VarName72','VarName73','VarName74','VarName75','VarName76','VarName77','VarName78','VarName79','VarName80','VarName81','VarName82','VarName83','VarName84','VarName85','VarName86','VarName87','VarName88','VarName89','VarName90','VarName91'});

%% �ӽ� ���� �����
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

    


