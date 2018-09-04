%% AlignEventLFPBatch
% Event Data Loc
loc0 = 'C:\VCF\Lobster\data\rawdata\';
loc1 = dir(loc0);
loc2 = {loc1.name};
loc2 = loc2(3:end);

matloc0 = 'C:\VCF\Lobster\data\processedData\lfp\';

%% suc 골라내기
loc2_new = {}; % suc이 아닌 trial
loc2_suc = {}; % suc인 trial
for fol = 1 : numel(loc2) % 모든 폴더에 대해서
    if contains(loc2{fol}, 'suc') % suc 데이터 라면
        loc2_suc = [loc2_suc,{loc2{fol}}];
    else
        loc2_new = [loc2_new,{loc2{fol}}];
    end
end

loc2_new(2) = [];

LFP_ALL = cell(1,numel(loc2_new));
AE = cell(1,numel(loc2_new)); % behaviorResult 를 담는 변수
%% Non-Suc LFP data (run with AnalyticValueExtractor )
for fol = 1 : numel(loc2_new) % 모든 폴더에 대해서
    targetdir = strcat(loc0,loc2_new{fol},'\EVENTS');
    LFPmatPath = strcat(matloc0,loc2_new{fol},'.mat');
    AlignEventLFP;
    AnalyticValueExtractor;
    LFP_ALL{1,fol} = lfp_IROF;
    AE{1,fol} = behaviorResult;
    fprintf('%5.2f%%\n',fol/numel(loc2_new)*100);
    clearvars behaviorResult ParsedData
end

%% Suc LFP data
LFP_SUC_ALL = cell(1,numel(loc2_suc));
for fol = 1 : numel(loc2_suc)
    targetdir = strcat(loc0, loc2_suc{fol},'\EVENTS');
    LFPmatPath = strcat(matloc0, loc2_suc{fol}(1:end-4),'.mat');
    AlignEventLFP;
    LFP_SUC_ALL{1,fol} = lfp_IROF;
    fprintf('%5.2f%%\n',fol/numel(loc2_suc)*100);
    clearvars behaviorResult ParsedData
end

clearvars fol loc* matloc0 lfp_* num*
        
