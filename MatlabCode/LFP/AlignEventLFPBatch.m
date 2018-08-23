%% deprecated
% AlignEventLFPBatch
% Event Data Loc
loc0 = 'C:\VCF\Lobster\data\rawdata\';
loc1 = dir(loc0);
loc2 = {loc1.name};
loc2 = loc2(3:end);

matloc0 = 'C:\VCF\Lobster\data\processedData\lfp\';

outputdata = cell(1,8148);
outputdata{1,1} = 'Session';
outputdata{1,2} = 'Channel';
outputdata{1,3} = 'Trial';
outputdata{1,4} = 'Event';
for i = 5 : 8148
    outputdata{1,i} = strcat('datapoint_',num2str(i-4));
end

tagdata = cell(32000,4);
ltpdata = zeros(32000,8144);
ccounter = 1;
for fol = 1 : numel(loc2) % 모든 폴더에 대해서
    if contains(loc2{fol}, 'suc') % suc 데이터 라면
        continue; % 스킵
    else % suc 데이터가 아닌 경우에만
        targetdir = strcat(loc0,loc2{fol},'\EVENTS');
        LFPmatPath = strcat(matloc0,loc2{fol},'.mat');
        AlignEventLFP;
        AnalyticValueExtractor;
        for ch = 1 : 16
            for tr = 1 : size(ltp_IROF,2)
                tagdata(ccounter,:) = {loc2{fol},ch,tr,strcat('IROF','_',behaviorResult(tr))};
                ltpdata(ccounter,:) = ltp_IROF(:,tr,ch)';
                ccounter = ccounter + 1;
            end
        end
        fprintf('%5.2f%%\n',fol/numel(loc2)*100);
    clearvars behaviorResult ParsedData
    end
end

clearvars fol loc* matloc0
        
