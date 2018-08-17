%% A1_GR_UNITS_read
% .txt �������� �Ǿ� �ִ� firing data ������ �����ͼ� neuron���� .mat ������ �����Ѵ�.

%% Initialize
clear;

%% open units exported in 'txt' file
[FileName,PathName] = uigetfile('.txt');

% reset variables
F = strcat(PathName, FileName);
delimiter = ',';
startRow = 2;

% format of each text line : %   ��1~�� 91 : double (%f)
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

% open txt file
fileID = fopen(F,'r');

% read file
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

% close txt file
fclose(fileID);
 
%% make output variables
UNITS = table(dataArray{1:end-1}, 'VariableNames', {'Timestamp','Channel','Unit','VarName4','VarName5','VarName6','VarName7','VarName8','VarName9','VarName10','VarName11','VarName12','VarName13','VarName14','VarName15','VarName16','VarName17','VarName18','VarName19','VarName20','VarName21','VarName22','VarName23','VarName24','VarName25','VarName26','VarName27','VarName28','VarName29','VarName30','VarName31','VarName32','VarName33','VarName34','VarName35','VarName36','VarName37','VarName38','VarName39','VarName40','VarName41','VarName42','VarName43','VarName44','VarName45','VarName46','VarName47','VarName48','VarName49','VarName50','VarName51','VarName52','VarName53','VarName54','VarName55','VarName56','VarName57','VarName58','VarName59','VarName60','VarName61','VarName62','VarName63','VarName64','VarName65','VarName66','VarName67','VarName68','VarName69','VarName70','VarName71','VarName72','VarName73','VarName74','VarName75','VarName76','VarName77','VarName78','VarName79','VarName80','VarName81','VarName82','VarName83','VarName84','VarName85','VarName86','VarName87','VarName88','VarName89','VarName90','VarName91'});

%% delete temp variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;




%% Segregate by Units

Chan = UNITS(:,2); % Chan here refers to a single tetrode (data from 4 closely positioned channels)
Chan = table2array(Chan);
Chan_num = max(Chan);

for i = 1:Chan_num
    
T = find(Chan == i);  % find the data row for each chan

TT = UNITS(T,:); % timestamp, chan, unit, waveform data for each chan


U = TT(:,3); %  % unit index per chan
U = table2array(U); % change unit index to array data
U_num = max(U); % how many units are in the channel?


    for j = 1:U_num
        TU = find(U == j); % row for each unit
        MU{j,i} = TT(TU,:); % extract single unit data from single channel data, put them into multi unit data in order
    end
end

Filename = strsplit(FileName,'.');
Filename = strcat(Filename(1),'_UNITS');
save([PathName,Filename{1}],'MU')

%% Look into each unit
Unitname = strsplit(FileName,'.');
Unitname = Unitname(1);
d = 0;


% isolate and extract single unit data!
numunit = 0; % ����� ���� �� üũ��
for k=1:size(MU,1)*size(MU,2)

if isempty(MU{k}) == 1
    
    d = d+1;
end
    
    
if isempty(MU{k}) == 0
    
    SU = MU{k};
    
    Unit = strcat(Unitname,'_',num2str(k-d));
    save([PathName,Unit{1}],'SU')
    numunit = numunit + 1 ; % ���� fprintf ������ ������ � ����������� ����ϱ� ����.
    
end

end

fprintf('----------A1_GR_UNITS_read----------\n');
fprintf('%s ��ġ�� \n�� %d ���� ������ �����Ǿ����ϴ�.\n',PathName,numunit);

    


