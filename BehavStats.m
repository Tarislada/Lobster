%% Plot Behav Stats
% BehavDataParser�� ���� �Ŀ� �ش� �����͸� ���, �׷��� ���� ������ִ� ��ũ��Ʈ

[ParsedData, Trials, IRs, Licks, Attacks ] = BehavDataParser();
AnalyticValueExtractor;

%% Data Array Format
% +-----+-----+-------+-------+--------+----------------+
% |  1  |  2  |   3   |   4   |   5    |       6        |
% +-----+-----+-------+-------+--------+----------------+
% | fIR | lIR | fLick | lLick | Attack | BehaviorResult |
% +-----+-----+-------+-------+--------+----------------+
% BehaviorResult : A : 0 | E : 1 | G : 2 | M : 3
numTrial = size(ParsedData,1);
InputArray = zeros(numTrial, 6);

for t = 1 : numTrial
    switch(behaviorResult(t))
        case 'A'
            InputArray(t,6) = 0;
        case 'E'
            InputArray(t,6) = 1;
        case 'G'
            InputArray(t,6) = 2;
        case 'M'
            InputArray(t,6) = 3;
    end        
    if or(InputArray(t,6) == 0, InputArray(t,6) == 1) % Avoid�� Escape �� ��쿡��.
        InputArray(t,1) = ParsedData{t,2}(1); % first IR
        InputArray(t,2) = ParsedData{t,2}(end); % last IR
        InputArray(t,3) = ParsedData{t,3}(1); % first Lick
        InputArray(t,4) = ParsedData{t,3}(end); % last Lick
        InputArray(t,5) = ParsedData{t,4}(1); % fAttack
    end
end
clear t;

%% Data for Stats
% +-----+-----------+-------+-------------+-------------+--------------+------------+---------------+-----------------+----------------+
% |  1  |     2     |   3   |      4      |      5      |      6       |     7      |       8       |        9        |       10       |
% +-----+-----------+-------+-------------+-------------+--------------+------------+---------------+-----------------+----------------+
% | fIR | length IR | fLick | length Lick | fLick - fIR | Attk - lLick | Attk - lIR | numIRClusters | numLickClusters | BehaviorResult |
% +-----+-----------+-------+-------------+-------------+--------------+------------+---------------+-----------------+----------------+

StatArray = zeros(numTrial,10);
StatArray(:,1) = InputArray(:,1);
StatArray(:,2) = InputArray(:,2) - InputArray(:,1);
StatArray(:,3) = InputArray(:,3);
StatArray(:,4) = InputArray(:,4) - InputArray(:,3);
StatArray(:,5) = InputArray(:,3) - InputArray(:,1);
StatArray(:,6) = InputArray(:,5) - InputArray(:,4);
StatArray(:,7) = InputArray(:,5) - InputArray(:,2);
StatArray(:,8) = numIRClusters;
StatArray(:,9) = numLickClusters;
StatArray(:,10) = InputArray(:,6);

%% Draw Figures
Monitors = get(groot, 'MonitorPositions');

%% First IR
fig1 = figure('Name','First IR');
set(fig1,'Position',[1,1,Monitors(1,3),Monitors(1,4)]);
draw6graph(1, [0,20,-inf,inf], numTrial, StatArray);

%% Length IR
fig2 = figure('Name','Length between the first and the last IR');
set(fig2,'Position',[1,1,Monitors(1,3),Monitors(1,4)]);
draw6graph(2, [0,20,-inf,inf], numTrial, StatArray);

%% First Lick
fig3 = figure('Name','First Lick');
set(fig3,'Position',[1,1,Monitors(1,3),Monitors(1,4)]);
draw6graph(3, [0,20,-inf,inf], numTrial, StatArray);

%% Length Lick
fig4 = figure('Name','Length between the first and the last Lick');
set(fig4,'Position',[1,1,Monitors(1,3),Monitors(1,4)]);
draw6graph(4, [0,10,-inf,inf], numTrial, StatArray);

%% fLick - fIR
fig5 = figure('Name','Length between the first Lick and the first IR');
set(fig5,'Position',[1,1,Monitors(1,3),Monitors(1,4)]);
draw6graph(5, [0,10,-inf,inf], numTrial, StatArray);

%% Attack - lLick
fig6 = figure('Name','Length between the Attack and the last Lick');
set(fig6,'Position',[1,1,Monitors(1,3),Monitors(1,4)]);
draw6graph(6, [-1,6,-inf,inf], numTrial, StatArray);

%% Attack - lIR
fig7 = figure('Name','Length between the Attack and the last IR');
set(fig7,'Position',[1,1,Monitors(1,3),Monitors(1,4)]);
draw6graph(7, [-1,6,-inf,inf], numTrial, StatArray);

%% IR Cluster
fig8 = figure('Name','IR clusters');
set(fig8,'Position',[1,1,Monitors(1,3),Monitors(1,4)]);
draw6graph(8, [0,5,-inf,inf], numTrial, StatArray);

%% Lick Cluster
fig9 = figure('Name','Lick clusters');
set(fig9,'Position',[1,1,Monitors(1,3),Monitors(1,4)]);
draw6graph(9, [0,5,-inf,inf], numTrial, StatArray);

%% Draw Composition Data
fig_C = figure('Name','Trial Composition');
set(fig_C,'Position',[1,1,1100,300]);
movegui(fig_C,'center');

% sequential behav pattern
for i = 1 : numTrial
    switch(StatArray(i,10))
        case 0
            barh(2,numTrial-i+1,'b');
            hold on;
        case 1
            barh(2,numTrial-i+1,'r');
            hold on;
        case 2
            barh(2,numTrial-i+1,'FaceColor',[0.8,0.8,0.8]);
            hold on;
        case 3
            barh(2,numTrial-i+1,'k');
            hold on;
    end
end

% behav pattern composition
tempdat = [...
    sum(StatArray(:,10) == 0),... % Avoid
    sum(StatArray(:,10) == 1),... % Escape
    sum(StatArray(:,10) == 2),... % Give Up
    sum(StatArray(:,10) == 3),... % 1Min Out
    ];
compdat = cumsum(tempdat);

barh(1,compdat(4),'k');
barh(1,compdat(3),'FaceColor',[0.8,0.8,0.8])
barh(1,compdat(2),'r');
barh(1,compdat(1),'b');

text(tempdat(1)/2, 1,'A','FontSize',12,'FontWeight','bold','Color','w');
text(tempdat(2)/2 + compdat(1), 1,'E','FontSize',12,'FontWeight','bold','Color','w');
text(tempdat(3)/2 + compdat(2), 1,'G','FontSize',12,'FontWeight','bold','Color','k');
text(tempdat(4)/2 + compdat(3), 1,'M','FontSize',12,'FontWeight','bold','Color','k');

yticks([1,2]);
yticklabels({'Composition','Behavior Type'});

title('Trial Composition');
xlabel('trial');

% ����� ���Ǹ� ���ؼ� ��ư �����
figs = {fig1, fig2, fig3, fig4, fig5, fig6, fig7, fig8, fig9};

for i = 1 : 9
    figs{i}.Visible = 'off';
end


pushbutton_1 = uicontrol('Style','pushbutton','String','First IR',...
    'Position',[160,60,80,30],...
    'Callback',@figvis,...
    'UserData',{1,figs} ...
    );
pushbutton_2 = uicontrol('Style','pushbutton','String','IR Length',...
    'Position',[160+90*1,60,80,30],...
    'Callback',@figvis,...
    'UserData',{2,figs} ...
    );
pushbutton_3 = uicontrol('Style','pushbutton','String','First Lick',...
    'Position',[160+90*2,60,80,30],...
    'Callback',@figvis,...
    'UserData',{3,figs} ...
    );
pushbutton_4 = uicontrol('Style','pushbutton','String','Lick Length',...
    'Position',[160+90*3,60,80,30],...
    'Callback',@figvis,...
    'UserData',{4,figs} ...
    );
pushbutton_5 = uicontrol('Style','pushbutton','String','IR to Lick',...
    'Position',[160+90*4,60,80,30],...
    'Callback',@figvis,...
    'UserData',{5,figs} ...
    );
pushbutton_6 = uicontrol('Style','pushbutton','String','lLick to Attk',...
    'Position',[160+90*5,60,80,30],...
    'Callback',@figvis,...
    'UserData',{6,figs} ...
    );
pushbutton_7 = uicontrol('Style','pushbutton','String','lIR to Attk',...
    'Position',[160+90*6,60,80,30],...
    'Callback',@figvis,...
    'UserData',{7,figs} ...
    );
pushbutton_8 = uicontrol('Style','pushbutton','String','IR Cluster',...
    'Position',[160+90*7,60,80,30],...
    'Callback',@figvis,...
    'UserData',{8,figs} ...
    );
pushbutton_9 = uicontrol('Style','pushbutton','String','Lick Cluster',...
    'Position',[160+90*8,60,80,30],...
    'Callback',@figvis,...
    'UserData',{9,figs} ...
    );

%% Define Repetitive Function
function draw6graph(type, axis_, numTrial, StatArray)
    subplot(2,3,1);
    xbar = 1:numTrial;
    barh(flipud(xbar(StatArray(:,10) == 0)),flipud(StatArray(StatArray(:,10) == 0,type)),'b');
    hold on;
    barh(flipud(xbar(StatArray(:,10) == 1)),flipud(StatArray(StatArray(:,10) == 1,type)),'r');
    hold off;
    axis(axis_);
    title('All Trials');
    xlabel('sec');
    ylabel('trials');
    tick = 0:10:(ceil(numTrial/10))*10;
    yticks(tick);
    yticklabels(fliplr(tick)+1);
    legend({'avoid','escape'});

    subplot(2,3,4);
    histogram(StatArray(:,type));
    xlabel('sec');
    
    % Avoid trial graph
    subplot(2,3,2);
    barh(flipud(StatArray(StatArray(:,10) == 0,type)),'b');
    title('Avoid');
    xlabel('sec');
    ylabel('trials');
    yticks([]);

    % Escape trial graph
    subplot(2,3,3);
    barh(flipud(StatArray(StatArray(:,10) == 1,type)),'r');
    title('Escape');
    xlabel('sec');
    ylabel('trials');
    yticks([]);

    % Avoid Histo
    subplot(2,3,5);
    histogram(StatArray(StatArray(:,10) == 0,type));
    xlabel('sec');

    % Escape Histo
    subplot(2,3,6);
    histogram(StatArray(StatArray(:,10) == 1,type));
    xlabel('sec');          
end
function figvis(hObject, eventdata, handles)
figs = hObject.UserData{2};
for i = 1 : 9
    figs{i}.Visible = 'off';
end
    figs{hObject.UserData{1}}.Visible = 'on';
end
