%% ParameterSelector
% IRs, Licks, Inter Licks Interval, Inter IRs Interval 등 길이를 trial/subject/experiment 상관 없이 
% 전부 모아서 baseline physical pattern을 찾아내기 위한 스크립트.

cumTrials = [];
cumIRs = [];
cumLicks = [];
cumAttacks = [];
cumILickI= [];
cumIIRI= [];
cumIAttackIROFI = [];

for i = {'lob1','lob2','lob3','lob4'} % 이 폴더륻ㄹ에 대해서
    datasetdir = dir(strcat(cd,'\data\',cell2mat(i)));
    datasetdir = datasetdir(3:end);
    datasetnames = struct2cell(datasetdir);
        
    for j = 1 : size(datasetdir,1) % 모든 subject 데이터에 대해
        location = strcat(cd,'\data\',i,'\',datasetnames{1,j});
        [ParsedData, Trials, IRs, Licks,Attacks ] = BehavDataParser(cell2mat(location));
        % 주의 cum IR, Licks, Attack 데이터는 trial 시작 값 기준으로 정렬이 안되어 있음.
        cumTrials = [cumTrials;Trials];
        cumIRs = [cumIRs; IRs];
        cumLicks = [cumLicks; Licks];
        cumAttacks = [cumAttacks; Attacks];
        
       
        IIRI = [];
        ILickI = [];
        IAttackIROFI = [];
        
        for trial = 1 : size(Trials,1)
            %% IR 간격 분석
            IRInTrial = ParsedData{trial,2};
            IIRI = [IIRI;IRInTrial(2:end,1) - IRInTrial(1:end-1,2)];
            %% Lick 간격 분석
            LicksInTrial = ParsedData{trial,3};
            ILickI = [ILickI;LicksInTrial(2:end,1) - LicksInTrial(1:end-1,2)];
            %% Inter Attack-IROFF Interval
            if isempty(IRInTrial)
                continue;
            elseif isempty(ParsedData{trial,4})
                continue;
            else
                % 해당 trial 에서 Attack 시간보다 IR 값의 마지막 값
                % (=마지막 IR의 On/Off 값 중Off 값)이 더 크다면,
                % 맞으면서(Attack 먼저) 빼는(IR Off) 케이스.
                % 그러나 간혹 Attack 이 다 끝나고 Trial을 끝내기전에
                % 얼굴을 들이밀어 IR이 끊기는 경우가 있다.
                % 이런 경우는 맨 마지막 IR이 아니라 그 전 IR Off와 
                % Inter-Attack-IROF-Interval을 계산해야한다.
                %if IRInTrial(end) - ParsedData{trial,4} > 1
                IAttackIROFI = [IAttackIROFI;IRInTrial(end) - ParsedData{trial,4}(1)];
            end 
        end 
        cumIIRI = [cumIIRI;IIRI];
        cumILickI = [cumILickI;ILickI];
        cumIAttackIROFI = [cumIAttackIROFI; IAttackIROFI];
    end
end