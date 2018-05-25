%% A5_UNIT~MAP (A4 먼저 돌릴것)
% using TIME from A4
       % XY1
       % XY2
% match the session of tracking and Unit
%% spike time


[FileName,PathName] = uigetfile;

filepath = strcat(PathName,FileName);

load(filepath);

su = table2array(SU);

 ts = su(:,1);
 
 spikes = ts;



%% Find Indexes
numSpike = size(spikes,1);
spikeIndex = zeros(numSpike,1);

% spike 데이터는 spike가 나타났던 시간 데이터 밖에 존재하지 않음.
% 그러므로, 해당 timestamp 와 가장 가까운 location 데이터를 연결해줌
for i = 1 : numSpike
    difference = abs(TIME - spikes(i));
    [~,spikeIndex(i)] = min(difference);
end

firedIndices = spikeIndex;


fXY1 = XY1(firedIndices,:);
fXY2 = XY2(firedIndices,:);

figure
scatter(fXY1(:,1), fXY1(:,2),'go')
hold on
scatter(fXY2(:,1), fXY2(:,2),'ro')

subtitle = title('Spike Locations');


%% FR heat map_using fXY1


x=100:2:380;  % x axis of the apparatus,from border to border, 4 pixels per step 
y=160:2:580;   % y axis of the apparatus, 4 pixels per step
ctrs = {x y}; % borders of apparatus




Fc1h = hist3(fXY1,ctrs); %hist3 raw fired positions
Pos1h = hist3(XY1,ctrs); %hist3 tracked positons

clims = [0 20];



figure


subplot(3,1,1)

GaussFc1h = imgaussfilt(Fc1h,2);
imagesc(GaussFc1h,clims)

colormap(jet)
colorbar

subtitle = title('Raw Spike Heat Map');


subplot(3,1,2)
GaussPos1h = imgaussfilt(Pos1h,2);
imagesc(GaussPos1h,clims)
colormap(jet)
colorbar

subtitle = title('Occupation Heat Map');



subplot(3,1,3)
FRmap = GaussFc1h./(GaussPos1h/30);  % FR for each pixel block divided by how many seconds stayed (frame rate 30 fps)
FRmap(isnan(FRmap))=0;

v =  max(max(FRmap))/3;
climsf = [0 v];

GaussFRmap = imgaussfilt(FRmap,2);
imagesc(GaussFRmap,climsf)
colormap(jet)

colorbar
subtitle = title('FR(Hz)');


%% 1 dimension FR map (Y in XY)


% 
% 
% y=160:4:580;   % y axis of the apparatus, 4 pixels per step
% ctrs = y; % borders of apparatus
% 
% 
% 
% 
% Fy = histogram(fXY1(:,2),ctrs); %hist3 raw fired positions
% Fy = Fy.Values;
% 
% Py = histogram(XY1(:,2),ctrs); %hist3 tracked positons
% Py = Py.Values;
% 
% FRy = Fy./(Py/30);



%% BLock divide


[TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF, BLON, BLOF]=GambleRatsBehavParser;


BON_index = zeros(length(BLON),1);
BOF_index = zeros(length(BLOF),1);

for i = 1 : length(BLON)
    difference = abs(BLON(i) - TIME);
    [~,BON_index(i)] = min(difference);
    
    difference = abs(BLOF(i) - TIME);
    [~,BOF_index(i)] = min(difference);
end



BL = struct;
NBL = struct;

track_indices = 1:1:length(TIME);

    k = firedIndices(BON_index(1) > firedIndices); 
    NBL(1).s_index = k;
        
    k = track_indices(BON_index(1) > track_indices); 
    NBL(1).t_index = k;
    
    

for j = 1: length(BLON)
    
      
     
    
    k = firedIndices(BON_index(j) <firedIndices); 
    k = k(k<BOF_index(j));
    BL(j).s_index = k;
    
    k = track_indices(BON_index(j) < track_indices); % coord time
    k = k(k<BOF_index(j));
    BL(j).t_index = k;
    
    if j < length(BLON)
    
        
    k = firedIndices(BOF_index(j) <firedIndices); 
    k = k(k<BON_index(j+1));
    NBL(j+1).s_index = k;
    
    k = track_indices(BOF_index(j) < track_indices); % coord time
    k = k(k<BON_index(j+1));
    NBL(j+1).t_index = k;    
    
    
    end
    
    
  
    
end
    



%% 

figure

for i = 1:length(NBL)
    
fXY1 = XY1(NBL(i).s_index,:);
fXY2 = XY2(NBL(i).s_index,:);

xy1 = XY1(NBL(i).t_index,:);


Fc1h = hist3(fXY1,ctrs); %hist3 raw fired positions
Pos1h = hist3(xy1,ctrs); %hist3 tracked positons

clims = [0 20];



subplot(length(NBL),3,3*i-2)

GaussFc1h = imgaussfilt(Fc1h,2);
imagesc(GaussFc1h,clims)

colormap(jet)
colorbar

subtitle = title('Raw Spike Heat Map');


subplot(length(NBL),3,3*i-1)
GaussPos1h = imgaussfilt(Pos1h,2);
imagesc(GaussPos1h,clims)
colormap(jet)
colorbar

subtitle = title('Occupation Heat Map');




subplot(length(NBL),3,3*i)
FRmap = GaussFc1h./(GaussPos1h/30);  % FR for each pixel block divided by how many seconds stayed (frame rate 30 fps)
FRmap(isnan(FRmap))=0;

v =  max(max(FRmap))/3;
climsf = [0 v];

GaussFRmap = imgaussfilt(FRmap,2);
imagesc(GaussFRmap,climsf)
colormap(jet)

colorbar
subtitle = title('FR(Hz)');

end



%%
% block

figure

for i = 1:length(BL)
    
fXY1 = XY1(BL(i).s_index,:);
fXY2 = XY2(BL(i).s_index,:);

xy1 = XY1(BL(i).t_index,:);


Fc1h = hist3(fXY1,ctrs); %hist3 raw fired positions
Pos1h = hist3(xy1,ctrs); %hist3 tracked positons

clims = [0 20];



subplot(length(BL),3,3*i-2)

GaussFc1h = imgaussfilt(Fc1h,2);
imagesc(GaussFc1h,clims)

colormap(jet)
colorbar

subtitle = title('Raw Spike Heat Map');


subplot(length(BL),3,3*i-1)
GaussPos1h = imgaussfilt(Pos1h,2);
imagesc(GaussPos1h,clims)
colormap(jet)
colorbar

subtitle = title('Occupation Heat Map');




subplot(length(BL),3,3*i)
FRmap = GaussFc1h./(GaussPos1h/30);  % FR for each pixel block divided by how many seconds stayed (frame rate 30 fps)
FRmap(isnan(FRmap))=0;

v =  max(max(FRmap))/3;
climsf = [0 v];

GaussFRmap = imgaussfilt(FRmap,2);
imagesc(GaussFRmap,climsf)
colormap(jet)

colorbar
subtitle = title('FR(Hz)');

end

