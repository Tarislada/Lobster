%% ParameterSelector
% IRs, Licks, Inter Licks Interval, Inter IRs Interval �� ���̸� trial/subject/experiment ��� ���� 
% ���� ��Ƽ� baseline physical pattern�� ã�Ƴ��� ���� ��ũ��Ʈ.

cumTrials = [];
cumIRs = [];
cumLicks = [];
cumAttacks = [];
cumILickI= [];
cumIIRI= [];

for i = {'lob1','lob2','lob3','lob4'}
    datasetdir = dir(strcat(cd,'\data\',cell2mat(i)));
    datasetdir = datasetdir(3:end);
    datasetnames = struct2cell(datasetdir);
        
    for j = 1 : size(datasetdir,1)
        location = strcat(cd,'\data\',i,'\',datasetnames{1,j});
        [ParsedData, Trials, IRs, Licks,Attacks ] = BehavDataParser(cell2mat(location));
        cumTrials = [cumTrials;Trials];
        cumIRs = [cumIRs; IRs];
        cumLicks = [cumLicks; Licks];
        cumAttacks = [cumAttacks; Attacks];
        
       %% IR ���� �м�
        IIRI = [];
        for trial = 1 : size(Trials,1)
            IRInInTrial = ParsedData{trial,2};
            IIRI = [IIRI;IRInInTrial(2:end,1) - IRInInTrial(1:end-1,2)];
        end 
        cumIIRI = [cumIIRI;IIRI];
        
       %% Lick ���� �м�
        ILickI = [];
        for trial = 1 : size(Trials,1)
            LicksInTrial = ParsedData{trial,3};
            ILickI = [ILickI;LicksInTrial(2:end,1) - LicksInTrial(1:end-1,2)];
        end 
        cumILickI = [cumILickI;ILickI];

    end
end