%% CombineLFPData
% merge LFP data in to one single Matrix
% 2018 Knowblesse

%% Create data matrix
% LFP_ALL, LFP_SUC_ALL AE  ------> lfp, lfp_suc, ae

numSession = numel(LFP_ALL);
lfp = [];
ae = [];
for s = 1 : numSession
    lfp = cat(2,lfp,LFP_ALL{s});
    ae = [ae;AE{s}];
end

numSession_suc = numel(LFP_SUC_ALL);
lfp_suc = [];
for s = 1 : numSession_suc
    lfp_suc = cat(2,lfp_suc,LFP_SUC_ALL{s});
end

%clearvars AE LFP_ALL LFP_SUC_ALL
%% Set threshold for artifact detection
thr = std(abs(lfp(:))) * 2; % std * 2 

%% Separate Trials by behavior Label(A,C,D,E)
numTrial = numel(ae);
A = [];
C = [];
D = [];
E = [];

for i = 1 : numTrial
    if std(abs(lfp(:,i,1))) < thr % only if std is lower than the thr
        if ae(i) == 'A'
            A = [A;lfp(:,i,1)'];
        elseif ae(i) == 'C'
            C = [C;lfp(:,i,1)'];
        elseif ae(i) == 'D'
            D = [D;lfp(:,i,1)'];
        elseif ae(i) == 'E'
            E = [E;lfp(:,i,1)'];
        else
            error('Unknown behavior type');
        end
    end
    fprintf('%4.2f%%\n',i/numTrial*100);
end 

%% Data
A = A(:,1:4072);
C = C(:,1:4072);
D = D(:,1:4072);


close all;
[ERSP, ITC, ~, times, freqs] = newtimef({A',D'},1000,[-4000,4000],1018,[1,4],...
    'freqs',[1,50],...
    'nfreqs',50,...
    'baseline',NaN,...
    'plotphasesign','off');

