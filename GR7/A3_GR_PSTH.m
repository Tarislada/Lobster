%% Gamble Rats LOB sessions event reader

% 단독으로 돌릴시에 GambleRatBehavParser에서 .csv event 파일이 들어있는 경로를 물어봄.
% Imlazy 스크립트 내에서 돌릴 시에는 targetdir에 자동으로 pathname 이 들어가므로, 
% 해당 정보를 사용해서 돌림.

% 선휘선배 코드 A3_GR_PSTH_v2 에서 변경사항
% whitespace(엔터 등등) 제거 및 indent 맞춤
% 반복적으로 사용되는 코드 제거 및 속도 최적화
% Imlazy script를 위해서 GambleRatBehavParser를 단독으로도, script 내에서도 돌릴 수 있도록 변경.
% 이미지 자동저장.
% 첫 trial에서 IRON, IROF, Attack 데이터가 없는 경우 해당 분석은 하지 않음.
if ~exist('noBehavParser','var')
    if exist('targetdir','var')
        [TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF, BLON, BLOF]=GambleRatsBehavParser(targetdir);
    else
        [TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF, BLON, BLOF]=GambleRatsBehavParser();
        neuronname = 'Neuron.mat';
    end
end
%% Overall firing rate change analysis

figure(9);
clf;
subplot(2,1,1)
kkk =  histogram(ts, 'BinWidth',1);
ylabel('Firing Rate /Second')
xlim(kkk.BinLimits)
xlabel('Second')

subplot(2,1,2)
trial_accum = ones(length(TRON),1);
trial_accum = cumsum(trial_accum);

plot(TRON,trial_accum)
xlim(kkk.BinLimits)
ylabel('Trial')
xlabel('Second')

saveas(9,[neuronname(1:end-4), '_NEUR.png'],'png');

%% exp conditions

%  attack at 6s : 80% 
%  attack at 3s : 20%
% 1 block of trials

%% BLock_trial_lize  % cut data by trials

TR = struct;

for j = 1: length(TRON)
    
    TR(j).TRON = TRON(j);
    TR(j).TROF = TROF(j);
                
    k = IRON(TRON(j)<IRON);
    k = k(k<TROF(j));
    TR(j).IRON = k;
    
    k = IROF(TRON(j)<IROF);
    k = k(k<TROF(j));
    TR(j).IROF = k;
   
    k = LICK(TRON(j)<LICK);
    k = k(k<TROF(j));
    TR(j).LICK = k;
     
    k = LOFF(TRON(j)<LOFF);
    k = k(k<TROF(j));
    TR(j).LOFF = k;
    
    k = ATTK(TRON(j)<ATTK);
    k = k(k<TROF(j));
    TR(j).ATTK = k;
    
    k = ATOF(TRON(j)<ATOF);
    k = k(k<TROF(j));
    TR(j).ATOF = k;
    
    k = ts(TRON(j)-10<ts);  % trial+10s before after, get spikes
    k = k(k<TROF(j)+10);
    TR(j).ts = k;
    
end
    

%% Analyze Only Lick trials PRTH (peri response t histogram)% 

% exclude the trials in which rat showed no attempt to lick


%% 반복되는 코드 하나로 통일

IRon = cell(1,length(TRON));
IRoff = cell(1,length(TRON));
Lon= cell(1,length(TRON));
Loff = cell(1,length(TRON));
Attk = cell(1,length(TRON));
Atof = cell(1,length(TRON));
stmp = cell(1,length(TRON));
trof = cell(1,length(TRON));

for j = 1 : length(TRON)
    IRon{j} = TR(j).IRON-TRON(j);
    IRoff{j} = TR(j).IROF-TRON(j);
    Lon{j} = TR(j).LICK-TRON(j);
    Loff{j} = TR(j).LOFF-TRON(j);
    Attk{j} = TR(j).ATTK-TRON(j);
    Atof{j} = TR(j).ATOF-TRON(j);
    stmp{j} = TR(j).ts-TRON(j);
    trof{j} = TROF(j)-TRON(j);
end


%% align by Trial ON
nodataflag = false; % 데이터에 문제가 있는 경우 true
figure(1);
clf;

subplot(4,1,1);
hold on;
subplot(4,1,3);
hold on;
subplot(4,1,4);
hold on;

ltr = 0;
s_tmp_stack = [];
for j = 1:length(TRON)
   
    if (~isempty(Lon{j}))
        
        ltr = ltr+1;
        
        % Align
        L_ON = Lon{j};
        L_OFF = Loff{j};
        IR_ON = IRon{j};
        IR_OFF = IRoff{j};
        A_ttk = Attk{j};
        A_tof = Atof{j};
        s_tmp = stmp{j};
        s_tmp_stack = [s_tmp_stack; s_tmp];

        subplot(4,1,1);    
        if ~isempty(s_tmp)
            for h = 1:length(s_tmp)
                line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
            end
        end

        subplot(4,1,3)
        for h = 1:length(IR_ON)
            line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        end

        subplot(4,1,4)
        for h = 1:length(L_ON)
            line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        end

    end
end

% Label 그리기
subplot(4,1,1);
xlabel('seconds');
xlim([-6 12]);
subplot(4,1,3);
xlabel('seconds');
xlim([-6 12]);
ylabel('trials');
subplot(4,1,4);
xlabel('seconds');
xlim([-6 12]);
ylabel('trials');


if ltr ~= 0
    
    subplot(4,1,1)

    line([0 0],[0 ltr],'Color','y','LineWidth',3)
    hold on

    ylim([0 ltr])

    tt = strcat('all blocks aligned by trial on');
    title(tt)

    subplot(4,1,2)

    edges = -6:0.1:12; %from -6 befor first lick to 12 after trial on
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;

    bar(Nt)
    set(gca, 'XTick', 0.5:10:length(edges)+0.5)
    set(gca, 'XTickLabel', edges(1:10:end))
    xlim([0.5 length(edges)-.5])

    ylabel('Firing Rate')

end

saveas(1,[neuronname(1:end-4), '_TRON.png'],'png');


%% Only Lick trials PRTH (peri response t histogram)
%align by first IR
nodataflag = false; % 데이터에 문제가 있는 경우 true    
figure(2);
clf;

subplot(4,1,1);
hold on;
subplot(4,1,3);
hold on;
subplot(4,1,4);
hold on;
    
ltr = 0;
s_tmp_stack = [];
for j = 1:length(TRON)
    
    if (~isempty(Lon{j}))
        
        if numel(IRon{j}) == 0 % 만약 IROn 요소가 하나도 없으면, 
            warning([num2str(j),' 번째 trial 에 IR이 하나도 없음']);
            nodataflag = true;
            clf;
            break;
        end
        IR = IRon{j}(1);
        
        % Align
        L_ON = Lon{j}-IR;
        L_OFF = Loff{j}-IR;
        IR_ON = IRon{j}-IR;
        IR_OFF = IRoff{j}-IR;
        A_ttk = Attk{j}-IR;
        A_tof = Atof{j}-IR;
        s_tmp = stmp{j} - IR;
        s_tmp_stack = [s_tmp_stack; s_tmp];

        ltr = ltr+1;

        subplot(4,1,1)
        if ~isempty(s_tmp)
            for h = 1:length(s_tmp)
                line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
            end
        end

        subplot(4,1,3)
        for h = 1:length(IR_ON)
            line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        end

        subplot(4,1,4)
        for h = 1:length(L_ON)
            line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        end
    end
end

% Label 그리기
subplot(4,1,1);
xlabel('seconds');
xlim([-3 10]);
ylabel('trials');

subplot(4,1,3);
xlabel('seconds');
xlim([-3 10]);
ylabel('trials');

subplot(4,1,4);
xlabel('seconds');
xlim([-3 10]);
ylabel('trials');

if ltr ~=0

    subplot(4,1,1)
    line([0 0],[0 ltr],'Color','g','LineWidth',3)
    hold on

    ylim([0 ltr])

    tt = strcat('all blocks  aligned by first IR');
    title(tt)

    subplot(4,1,2)

    edges = -3:.1:10; %from -6 befor last lick to 6 after last lick
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;

    bar(Nt)
    set(gca, 'XTick', 0.5:10:length(edges)+0.5)
    set(gca, 'XTickLabel', edges(1:10:end))
    xlim([0.5 length(edges)-.5])

    ylabel('Firing Rate')

end
if nodataflag
    figure(2);
    clf;
    text(0.5,0.5,'IROn 데이터 오류','FontSize',20,'HorizontalAlignment','center')
end
saveas(2,[neuronname(1:end-4), '_IRON.png'],'png');

%% Only Lick trials PRTH (peri response t histogram)% when attack fixedd
%align by first lick
nodataflag = false; % 데이터에 문제가 있는 경우 true
figure(3);
clf;

subplot(4,1,1);
hold on;
subplot(4,1,3);
hold on;
subplot(4,1,4);
hold on;
       
ltr = 0;
s_tmp_stack = [];
for j = 1:length(TRON)
    
    if (~isempty(Lon{j}))
        
        FL = Lon{j}(1);
        
        % align
        L_ON = Lon{j}-FL;
        L_OFF = Loff{j}-FL;
        IR_ON = IRon{j}-FL;
        IR_OFF = IRoff{j}-FL;
        A_ttk = Attk{j}-FL;
        A_tof = Atof{j}-FL;
        s_tmp = stmp{j}-FL;
        s_tmp_stack = [s_tmp_stack; s_tmp];
        
        ltr = ltr+1;
        
        subplot(4,1,1)
        if ~isempty(s_tmp)
            for h = 1:length(s_tmp)
                line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
            end
        end

        subplot(4,1,3)
        for h = 1:length(IR_ON)
            line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        end

        subplot(4,1,4)
        for h = 1:length(L_ON)
            line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        end
    end
end

% Label 그리기
subplot(4,1,1);
xlabel('seconds');
xlim([-6 12]);
ylabel('trials');

subplot(4,1,3);
xlabel('seconds');
xlim([-6 12]);
ylabel('trials');

subplot(4,1,4);
xlabel('seconds');
xlim([-6 12]);
ylabel('trials');

if ltr ~= 0
    
    subplot(4,1,1)
    line([0 0],[0 ltr],'Color','b','LineWidth',3)
    hold on
    line([6 6],[0 ltr],'Color','r','LineWidth',3)
    line([3 3],[0 ltr],'Color','r','LineWidth',3)
    ylim([0 ltr])

    tt = strcat('block  ', num2str(i), '  aligned by first lick');
    title(tt)

    ylim([0 ltr])

    subplot(4,1,2)

    edges = -6:.1:12; %from -6 befor first lick to 12 after first lick
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;

    bar(Nt)
    set(gca, 'XTick', 0.5:10:length(edges)+0.5)
    set(gca, 'XTickLabel', edges(1:10:end))
    xlim([0.5 length(edges)-.5])

    ylabel('Firing Rate')

end
saveas(3,[neuronname(1:end-4), '_LICK.png'],'png');



%% Only Lick trials PRTH (peri response t histogram)
%align by last lick
nodataflag = false; % 데이터에 문제가 있는 경우 true
figure(4);
clf;

subplot(4,1,1);
hold on;
subplot(4,1,3);
hold on;
subplot(4,1,4);
hold on;
    
ltr = 0;
s_tmp_stack = [];

for j = 1:length(TRON)

    if (~isempty(Lon{j}))
        
        LL = Loff{j}(end); %Lon->Loff
        
        %align
        L_ON = Lon{j}-LL;
        L_OFF = Loff{j}-LL;
        IR_ON = IRon{j}-LL;
        IR_OFF = IRoff{j}-LL;
        A_ttk = Attk{j}-LL;
        A_tof = Atof{j}-LL;
        s_tmp = stmp{j}-LL;
        s_tmp_stack = [s_tmp_stack; s_tmp];
    
        ltr = ltr+1;

        subplot(4,1,1)
        if ~isempty(s_tmp)
            for h = 1:length(s_tmp)
            line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
            end
        end

        subplot(4,1,3)
        for h = 1:length(IR_ON)
            line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        end

        subplot(4,1,4)
        for h = 1:length(L_ON)
            line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        end
   end    
end

% Label 그리기
subplot(4,1,1);
xlabel('seconds');
xlim([-6 6]);
ylabel('trials');

subplot(4,1,3);
xlabel('seconds');
xlim([-6 6]);
ylabel('trials');

subplot(4,1,4);
xlabel('seconds');
xlim([-6 6]);
ylabel('trials');

if ltr ~= 0
    subplot(4,1,1)
    line([0 0],[0 ltr],'Color','b','LineWidth',3)
    hold on

    ylim([0 ltr])

    tt = strcat('all blocks aligned by last lick');
    title(tt)

    subplot(4,1,2)

    edges = -6:.1:6; %from -6 befor last lick to 6 after last lick
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;

    bar(Nt)
    set(gca, 'XTick', 0.5:10:length(edges)+0.5)
    set(gca, 'XTickLabel', edges(1:10:end))
    xlim([0.5 length(edges)-.5])

    ylabel('Firing Rate')
end
saveas(4,[neuronname(1:end-4), '_LOFF.png'],'png');


%% Only Lick trials PRTH (peri response t histogram)
%align by last IR
nodataflag = false; % 데이터에 문제가 있는 경우 true
figure(5);
clf;
    
ltr = 0;

for j = 1:length(TRON)
    
    if (~isempty(Lon{j}))
        if numel(IRon{j}) == 0 % 만약 IROn 요소가 하나도 없으면, 
            warning([num2str(j),' 번째 trial 에 IR이 하나도 없음']);
            nodataflag = true;
            clf;
            break;
        end
        
        IR = IRoff{j}(end);
        
        % align
        L_ON = Lon{j}-IR;
        L_OFF = Loff{j}-IR;
        IR_ON = IRon{j}-IR;
        IR_OFF = IRoff{j}-IR;
        A_ttk = Attk{j}-IR;
        A_tof = Atof{j}-IR;
        s_tmp = stmp{j}-IR;
        s_tmp_stack = [s_tmp_stack; s_tmp];
        
        ltr = ltr+1;

        subplot(4,1,1)
        if ~isempty(s_tmp)
            for h = 1:length(s_tmp)
                line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
            end        
        end

        subplot(4,1,3)
        for h = 1:length(IR_ON)
            line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        end

        subplot(4,1,4)
        for h = 1:length(L_ON)
            line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        end
    end  
end

% Label 그리기
subplot(4,1,1);
xlabel('seconds');
xlim([-10 5]);
ylabel('trials');

subplot(4,1,3);
xlabel('seconds');
xlim([-10 5]);
ylabel('trials');

subplot(4,1,4);
xlabel('seconds');
xlim([-10 5]);
ylabel('trials');

if ltr ~=0

    subplot(4,1,1)
    line([0 0],[0 ltr],'Color','g','LineWidth',3)
    hold on

    ylim([0 ltr])

    tt = strcat('all trials aligned by last IR');
    title(tt)

    subplot(4,1,2)

    edges = -10:.1:5; %from -10 befor last lick to 5 after last
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;

    bar(Nt)
    set(gca, 'XTick', 0.5:10:length(edges)+0.5)
    set(gca, 'XTickLabel', edges(1:10:end))
    xlim([0.5 length(edges)-.5])

    ylabel('Firing Rate')

end
if nodataflag
    figure(5);
    clf;
    text(0.5,0.5,'IROff 데이터 오류','FontSize',20,'HorizontalAlignment','center')
end
saveas(5,[neuronname(1:end-4), '_IROF.png'],'png');



%% Only Lick trials PRTH (peri response t histogram)
%align by Attack
nodataflag = false; % 데이터에 문제가 있는 경우 true
figure(6);
clf;

subplot(4,1,1);
hold on;
subplot(4,1,3);
hold on;
subplot(4,1,4);
hold on;
   
ltr = 0;
s_tmp_stack = [];

for j = 1:length(TRON)
    
    if (~isempty(Lon{j}))
        if numel(Attk{j}) == 0 % 만약 IROn 요소가 하나도 없으면, 
            warning([num2str(j),' 번째 trial 에 Attk가 하나도 없음']);
            nodataflag = true;
            clf;
            break;
        end
        AT = Attk{j}(1);

        ltr = ltr+1;
        
        % align
        L_ON = Lon{j}-AT;
        L_OFF = Loff{j}-AT;
        IR_ON = IRon{j}-AT;
        IR_OFF = IRoff{j}-AT;
        A_ttk = Attk{j}-AT;
        A_tof = Atof{j}-AT;
        s_tmp = stmp{j}-AT;
        s_tmp_stack = [s_tmp_stack; s_tmp];
        
        subplot(4,1,1)
        if ~isempty(s_tmp)
            for h = 1:length(s_tmp)
                line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
            end
        end

        subplot(4,1,3)
        for h = 1:length(IR_ON)
            line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        end

        subplot(4,1,4)
        for h = 1:length(L_ON)
            line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        end
    end
end

% Label 그리기
subplot(4,1,1);
xlabel('seconds');
xlim([-10 5]);
ylabel('trials');

subplot(4,1,3);
xlabel('seconds');
xlim([-10 5]);
ylabel('trials');

subplot(4,1,4);
xlabel('seconds');
xlim([-10 5]);
ylabel('trials');

if ltr ~=0

    subplot(4,1,1)
    line([0 0],[0 ltr],'Color','r','LineWidth',3)
    hold on

    ylim([0 ltr])

    tt = strcat('all trials aligned by attack');
    title(tt)

    subplot(4,1,2)

    edges = -10:.1:5; %from -10 befor last lick to 5 after last
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;

    bar(Nt)
    set(gca, 'XTick', 0.5:10:length(edges)+0.5)
    set(gca, 'XTickLabel', edges(1:10:end))
    xlim([0.5 length(edges)-.5])

    ylabel('Firing Rate')
end
if nodataflag
    figure(6);
    clf;
    text(0.5,0.5,'Attk 데이터 오류','FontSize',20,'HorizontalAlignment','center')
end
saveas(6,[neuronname(1:end-4), '_ATTK.png'],'png');


%% Only Lick trials PRTH (peri response t histogram)
%all block align by trial off
nodataflag = false; % 데이터에 문제가 있는 경우 true
figure(7);
clf;

subplot(4,1,1);
hold on;
subplot(4,1,3);
hold on;
subplot(4,1,4);
hold on;
    
ltr = 0;
s_tmp_stack = [];
for j = 1:length(TRON)
    
    
    if (~isempty(Lon{j}))
        
        TF = trof{j};
        
        % align
        L_ON = Lon{j}-TF;
        L_OFF = Loff{j}-TF;
        IR_ON = IRon{j}-TF;
        IR_OFF = IRoff{j}-TF;
        A_ttk = Attk{j}-TF;
        A_tof = Atof{j}-TF;
        s_tmp = stmp{j}-TF;
        s_tmp_stack = [s_tmp_stack; s_tmp];
        

        ltr = ltr+1;

        subplot(4,1,1)
        if ~isempty(s_tmp)
            for h = 1:length(s_tmp)
                line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
            end    
        end

        subplot(4,1,3)
        for h = 1:length(IR_ON)
            line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        end

        subplot(4,1,4)
        for h = 1:length(L_ON)
            line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        end
    end
end

% Label 그리기
subplot(4,1,1);
xlabel('seconds');
xlim([-10 5]);
ylabel('trials');

subplot(4,1,3);
xlabel('seconds');
xlim([-10 5]);
ylabel('trials');

subplot(4,1,4);
xlabel('seconds');
xlim([-10 5]);
ylabel('trials');

if ltr ~=0
    subplot(4,1,1)
    line([0 0],[0 ltr],'Color','y','LineWidth',3)
    hold on

    ylim([0 ltr])

    tt = strcat('all blocks aligned by trial off');
    title(tt)

    subplot(4,1,2)

    edges = -10:.1:5; %from -10 befor last lick to 5 after attack
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;

    bar(Nt)
    set(gca, 'XTick', 0.5:10:length(edges)+0.5)
    set(gca, 'XTickLabel', edges(1:10:end))
    xlim([0.5 length(edges)-.5])

    ylabel('Firing Rate')
end
saveas(7,[neuronname(1:end-4), '_TROF.png'],'png');



