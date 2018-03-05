%% ParameterSelector
% IRs, Licks, Inter Licks Interval, Inter IRs Interval �� ���̸� trial/subject/experiment ��� ���� 
% ���� ��Ƽ� baseline physical pattern�� ã�Ƴ��� ���� ��ũ��Ʈ.

cumTrials = [];
cumIRs = [];
cumLicks = [];
cumAttacks = [];
cumILickI= [];
cumIIRI= [];
cumIAttackIROFI = [];

for i = {'lob1','lob2','lob3','lob4'} % �� �����Y���� ���ؼ�
    datasetdir = dir(strcat(cd,'\data\',cell2mat(i)));
    datasetdir = datasetdir(3:end);
    datasetnames = struct2cell(datasetdir);
        
    for j = 1 : size(datasetdir,1) % ��� subject �����Ϳ� ����
        location = strcat(cd,'\data\',i,'\',datasetnames{1,j});
        [ParsedData, Trials, IRs, Licks,Attacks ] = BehavDataParser(cell2mat(location));
        % ���� cum IR, Licks, Attack �����ʹ� trial ���� �� �������� ������ �ȵǾ� ����.
        cumTrials = [cumTrials;Trials];
        cumIRs = [cumIRs; IRs];
        cumLicks = [cumLicks; Licks];
        cumAttacks = [cumAttacks; Attacks];
        
       
        IIRI = [];
        ILickI = [];
        IAttackIROFI = [];
        
        for trial = 1 : size(Trials,1)
            %% IR ���� �м�
            IRInTrial = ParsedData{trial,2};
            IIRI = [IIRI;IRInTrial(2:end,1) - IRInTrial(1:end-1,2)];
            %% Lick ���� �м�
            LicksInTrial = ParsedData{trial,3};
            ILickI = [ILickI;LicksInTrial(2:end,1) - LicksInTrial(1:end-1,2)];
            %% Inter Attack-IROFF Interval
            if isempty(IRInTrial)
                continue;
            elseif isempty(ParsedData{trial,4})
                continue;
            else
                % �ش� trial ���� Attack �ð����� IR ���� ������ ��
                % (=������ IR�� On/Off �� ��Off ��)�� �� ũ�ٸ�,
                % �����鼭(Attack ����) ����(IR Off) ���̽�.
                % �׷��� ��Ȥ Attack �� �� ������ Trial�� ����������
                % ���� ���̹о� IR�� ����� ��찡 �ִ�.
                % �̷� ���� �� ������ IR�� �ƴ϶� �� �� IR Off�� 
                % Inter-Attack-IROF-Interval�� ����ؾ��Ѵ�.
                %if IRInTrial(end) - ParsedData{trial,4} > 1
                IAttackIROFI = [IAttackIROFI;IRInTrial(end) - ParsedData{trial,4}(1)];
            end 
        end 
        cumIIRI = [cumIIRI;IIRI];
        cumILickI = [cumILickI;ILickI];
        cumIAttackIROFI = [cumIAttackIROFI; IAttackIROFI];
    end
end