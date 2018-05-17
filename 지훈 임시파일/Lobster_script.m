%% Lobster Script
% ui를 사용해서 tracking data와 recording data를 엮어주는 script
% @knowblesse 2018

% 분석 결과를 담는 matrix
ouputdata = [];
% +-----------+-----------+-----------+-------------+-------------+----------------------+
% |   Col 1   |   Col 2   |   Col 3   |    Col 4    |    Col 5    |        Col 6         |
% +-----------+-----------+-----------+-------------+-------------+----------------------+
% | Timestamp | Red LED X | Red LED Y | Green LED X | Green LED Y | Head Degree(East=0º) |
% +-----------+-----------+-----------+-------------+-------------+----------------------+


%% Location Parsing
% XYXY.csv 데이터 파일에서 쥐 위치정보를 불러오기
%   tracking 끊긴 부분까지 자동 수정.
outputdata= locationParser(true);

%% Location Map Building
map_loc = createGaussianHitmap(outputdata(:,2:3),  10, 10, [], false);

%% Draw Location Heat Map
drawmap(map_loc, [], [0, 1.0E-4]);

%% Spike Data Parsing
% spike time을 담은 .txt 파일을 불러와 그래프를 plot
firedIndicies = firedLocationParser(outputdata);

%% Draw Spike Scatter Map
figure;
% Red LED와 Green LED의 X좌표, Y좌표의 평균을 내어서 중앙점으로 잡음
X_loc_array = (outputdata(firedIndicies,2) + outputdata(firedIndicies,4))./2;
Y_loc_array = (outputdata(firedIndicies,3) + outputdata(firedIndicies,5))./2;
scatter(X_loc_array,Y_loc_array, '*', 'r'); 

%% Spike Heat Map Building
map_spk = createGaussianHitmap(outputdata(firedIndicies,2:3), 10, 10, [], false);

%% Draw Spike Heat Map
drawmap(map_spk, [], [0, 1.0E-4]);

%% 머문 시간을 보정한 Spike Heat Map 그리기
drawmap(map_spk./map_loc, [], [0,1.0E-4]);
caxis('auto');