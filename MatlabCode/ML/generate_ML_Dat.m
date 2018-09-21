%% Generate_ML_Dat
% Generate data.mat for LocNet_PT_Conv.py

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Spike
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cut Spike data using EVENT data
Cut_Spikes_by_EVENT

%% Load Spike data and make it into a big array
GaussianKernelBin_diffsize

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Location
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load and Parse Location Data
RVn1_locationParser;

%% Recover Location Data
XRange = [100,600];
YRange = [150,300];
Location = recoverLocData(Location, XRange, YRange);
Location = [ TIME, mean([Location{1},Location{3}],2), mean([Location{2},Location{4}],2) ];

%% Cut Only Valid Location Data and make it into a big array
FinalLocOutput = [];
for w = 1 : size(window,1)
    locindex_start = find(Location(:,1)>window(w,1));
    locindex_end = find(Location(:,1)>window(w,2));
    shrinkedData = interp1(1:(locindex_end(1) - locindex_start(1)),...
        Location(locindex_start(1):locindex_end(1)-1, 2:3),...
        linspace(1,(locindex_end(1) - locindex_start(1)),bdl(w)));
        
    FinalLocOutput = [FinalLocOutput;shrinkedData];
end

clearvars -except Final*

train = FinalOutput;
train_loc = FinalLocOutput';

clearvars Final*
    
    