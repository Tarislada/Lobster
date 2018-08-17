%% Lobster Script
% ui�� ����ؼ� tracking data�� recording data�� �����ִ� script
% @knowblesse 2018

% �м� ����� ��� matrix
ouputdata = [];
% +-----------+-----------+-----------+-------------+-------------+----------------------+
% |   Col 1   |   Col 2   |   Col 3   |    Col 4    |    Col 5    |        Col 6         |
% +-----------+-----------+-----------+-------------+-------------+----------------------+
% | Timestamp | Red LED X | Red LED Y | Green LED X | Green LED Y | Head Degree(East=0��) |
% +-----------+-----------+-----------+-------------+-------------+----------------------+


%% Location Parsing
% XYXY.csv ������ ���Ͽ��� �� ��ġ������ �ҷ�����
%   tracking ���� �κб��� �ڵ� ����.
outputdata= locationParser(true);

%% Location Map Building
map_loc = createGaussianHitmap(outputdata(:,2:3),  10, 10, [], false);

%% Draw Location Heat Map
drawmap(map_loc, [], [0, 1.0E-4]);

%% Spike Data Parsing
% spike time�� ���� .txt ������ �ҷ��� �׷����� plot
firedIndicies = firedLocationParser(outputdata);

%% Draw Spike Scatter Map
figure;
% Red LED�� Green LED�� X��ǥ, Y��ǥ�� ����� ��� �߾������� ����
X_loc_array = (outputdata(firedIndicies,2) + outputdata(firedIndicies,4))./2;
Y_loc_array = (outputdata(firedIndicies,3) + outputdata(firedIndicies,5))./2;
scatter(X_loc_array,Y_loc_array, '*', 'r'); 

%% Spike Heat Map Building
map_spk = createGaussianHitmap(outputdata(firedIndicies,2:3), 10, 10, [], false);

%% Draw Spike Heat Map
drawmap(map_spk, [], [0, 1.0E-4]);

%% �ӹ� �ð��� ������ Spike Heat Map �׸���
drawmap(map_spk./map_loc, [], [0,1.0E-4]);
caxis('auto');