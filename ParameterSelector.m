%% ParameterSelector
% IRs, Licks, Inter Licks Interval, Inter IRs Interval 등 길이를 trial/subject/experiment 상관 없이 
% 전부 모아서 baseline physical pattern을 찾아내기 위한 스크립트.

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
        
       %% IR 간격 분석
        IIRI = [];
        for trial = 1 : size(Trials,1)
            IRInInTrial = ParsedData{trial,2};
            IIRI = [IIRI;IRInInTrial(2:end,1) - IRInInTrial(1:end-1,2)];
        end 
        cumIIRI = [cumIIRI;IIRI];
        
       %% Lick 간격 분석
        ILickI = [];
        for trial = 1 : size(Trials,1)
            LicksInTrial = ParsedData{trial,3};
            ILickI = [ILickI;LicksInTrial(2:end,1) - LicksInTrial(1:end-1,2)];
        end 
        cumILickI = [cumILickI;ILickI];

    end
end