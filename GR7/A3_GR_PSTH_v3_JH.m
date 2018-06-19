%% Gamble Rats LOB sessions event reader

% 모든 trial을 TRON, First IR 등으로 align.
% align된 데이터를 모든 trial에 대해서 합친 변수 => Nt
% Nt 를 정규화 시킨 데이터를 각 정렬한 event의 이름을 따서 Z struct 내에 저장.
% 예 : IROF를 기준으로 정렬한 데이터의 Nt의 Z 값 은 Z.IROF 에 저장됨.
% 이 Z 값을 .mat 파일로 저장.
% Plot 그리는 기능은 지움.

if exist('targetdir','var')
    [TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF, BLON, BLOF]=GambleRatsBehavParser(targetdir);
else
    [TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF, BLON, BLOF]=GambleRatsBehavParser();
end

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
    end
end

if ltr ~= 0
    edges = -6:0.1:12; %from -6 befor first lick to 12 after trial on
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;
end

Z.TRON = zscore(Nt);


%% Only Lick trials PRTH (peri response t histogram)
%align by first IR    
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
    end
end

if ltr ~=0

    edges = -3:.1:10; %from -6 befor last lick to 6 after last lick
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;
end

Z.IRON = zscore(Nt);

%% Only Lick trials PRTH (peri response t histogram)% when attack fixedd
%align by first lick      
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
    end
end

if ltr ~= 0
    edges = -6:.1:12; %from -6 befor first lick to 12 after first lick
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;

end

Z.LICK = zscore(Nt);

%% Only Lick trials PRTH (peri response t histogram)
%align by last lick  
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

   end    
end

if ltr ~= 0
    
    edges = -6:.1:6; %from -6 befor last lick to 6 after last lick
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;
end

Z.LOFF = zscore(Nt);

%% Only Lick trials PRTH (peri response t histogram)
%align by last IR
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

    end  
end

if ltr ~=0

    edges = -10:.1:5; %from -10 befor last lick to 5 after last
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;
end

Z.IROF = zscore(Nt);

%% Only Lick trials PRTH (peri response t histogram)
%align by Attack
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
        
    end
end

if ltr ~=0

    edges = -10:.1:5; %from -10 befor last lick to 5 after last
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;
end

Z.ATTK = zscore(Nt);

%% Only Lick trials PRTH (peri response t histogram)
%all block align by trial off
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

    end
end

if ltr ~=0
    
    edges = -10:.1:5; %from -10 befor last lick to 5 after attack
    [N, edges] = histcounts(s_tmp_stack, edges);
    Nt = N/ltr;

end

Z.TROF = zscore(Nt);