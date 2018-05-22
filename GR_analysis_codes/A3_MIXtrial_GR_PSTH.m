%% Gamble Rats LOB sessions event reader V2_ 6s 3s mix version





[TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF, BLON, BLOF]=GambleRatsBehavParser;






%% FR

figure
subplot(2,1,1)
kkk =  histogram(ts, 'BinWidth',60);
ylabel('Firing Rate /Min')
xlim(kkk.BinLimits)

subplot(2,1,2)
Bf = [];
Bfid = {};


    
k = ts(BLON(1)>ts);  
NBf = length(k)/BLON(1); %before block 1 firing rate
 NBfid{1}  = 'Pre Block 1';




for i = 1:length(BLON)
    
line([BLON(i) BLOF(i)],[0 0],'Color','b','LineWidth',10) 
hold on

    k = ts(BLON(i)<ts);  
    k = k(k<BLOF(i));
    
    Bf = [Bf length(k)/(BLOF(i)-BLON(i))];
    temps = strcat('Block', num2str(i));
    Bfid{i} = temps;
    
   
    if length(BLON) ~= i
    k = ts(BLOF(i)<ts);  
    k = k(k<BLON(i+1));
    NBf = [NBf length(k)/(BLON(i+1)-BLOF(i))];
    temps = strcat('Post Block', num2str(i));
    NBfid{i+1} =temps;
    end
    
   
end

xlabel('Block')
xlim(kkk.BinLimits)


figure

maxf = max(Bf, NBf);
maxf = max(maxf);


subplot(1,2,1)

bar(Bf)
xticklabels(Bfid)
ylabel('FR(Hz)')
ylim([0 maxf])

subplot(1,2,2)

bar(NBf)
xticklabels(NBfid)
ylabel('FR(Hz)')
ylim([0 maxf])




%% BLock_trial_lize

bl = struct;
m = 1;
n = 1;

for i = 1: length(BLON)
    
    
    k = TRON(BLON(i)<TRON);
    k = k(k<BLOF(i));
    tTRON = k;
    
    k = TROF(BLON(i)<TROF);
    k = k(k<BLOF(i));
    tTROF = k;
    
    
    for j = 1: length(tTRON)
    
   
    bl(i).tr(j).TRON = tTRON(j);
    bl(i).tr(j).TROF = tTROF(j);
        
        
    k = IRON(tTRON(j)<IRON);
    k = k(k<tTROF(j));
    bl(i).tr(j).IRON = k;
    
    
    k = IROF(tTRON(j)<IROF);
    k = k(k<tTROF(j));
    bl(i).tr(j).IROF = k;
   
    
    k = LICK(tTRON(j)<LICK);
    k = k(k<tTROF(j));
    bl(i).tr(j).LICK = k;
    
    
    k = LOFF(tTRON(j)<LOFF);
    k = k(k<tTROF(j));
    bl(i).tr(j).LOFF = k;
    

    k = ATTK(tTRON(j)<ATTK);
    k = k(k<tTROF(j));
    bl(i).tr(j).ATTK = k;
    
    
    
    k = ATOF(tTRON(j)<ATOF);
    k = k(k<tTROF(j));
    bl(i).tr(j).ATOF = k;
    
    
     
    
    k = ts(tTRON(j)-10<ts);  % trial+10s before after, get spikes
    k = k(k<tTROF(j)+10);
    bl(i).tr(j).ts = k;
    
    
    
    
    
    
    if (~isempty(bl(i).tr(j).LICK) && ~isempty(bl(i).tr(j).ATTK))
    
    
    if (bl(i).tr(j).ATTK(1) - bl(i).tr(j).LICK(1)) > 5   % if attack accours at 6s after first lick
        
        bl(i).Longtr(m) = bl(i).tr(j);
        m = m+1;
        
    end
    
    
    if (bl(i).tr(j).ATTK(1) - bl(i).tr(j).LICK(1)) < 4  % if attack accours at 3s after first lick
        
        bl(i).Shorttr(n) = bl(i).tr(j);
        n = n+1;
        
    end
    
    end 
    
  
    
     end
    
    
    


end



%% 1 block analysis : mix trials, 6s or 3s attack



%% Only Lick trials PRTH (peri response t histogram)% 
%align by Trial ON




for i = 1:length(BLON)
    
    k = TRON(BLON(i)<TRON);
    k = k(k<BLOF(i));
    tTRON = k;
    
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(tTRON)
    
    IRon = bl(i).tr(j).IRON-tTRON(j);
    IRoff = bl(i).tr(j).IROF-tTRON(j);
    Lon = bl(i).tr(j).LICK-tTRON(j);
    Loff = bl(i).tr(j).LOFF-tTRON(j);
    Attk = bl(i).tr(j).ATTK-tTRON(j);
    Atof = bl(i).tr(j).ATOF-tTRON(j);
    stmp = bl(i).tr(j).ts-tTRON(j);
    
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
        
  
 
    ltr = ltr+1;
   
    L_ON = Lon;
    L_OFF = Loff;
    IR_ON = IRon;
    IR_OFF = IRoff;
    A_ttk = Attk;
    A_tof = Atof;
    s_tmp = stmp;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
    bl(i).Ltr = ltr;
 
   
    
    subplot(4,1,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    


    xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

    

    subplot(4,1,3)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')
        
        
        
         subplot(4,1,4)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,1,1)


    
 line([0 0],[0 ltr],'Color','y','LineWidth',3)
 hold on

 ylim([0 ltr])

tt = strcat('block  ', num2str(i), '  aligned by trial on');
    title(tt)



subplot(4,1,2)
k = 5;
edges = -6:1/k:12; %from -6 befor first lick to 12 after trial on
[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])



ylabel('Firing Rate')



end




end







%% Trial on Mix divide





for i = 1:length(BLON)
    
 
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
     
     
     % long trials
    
for j = 1:length(bl(i).Longtr)
    
   
    
    IRon = bl(i).Longtr(j).IRON-bl(i).Longtr(j).TRON;
    IRoff = bl(i).Longtr(j).IROF-bl(i).Longtr(j).TRON;
    Lon = bl(i).Longtr(j).LICK-bl(i).Longtr(j).TRON;
    Loff = bl(i).Longtr(j).LOFF-bl(i).Longtr(j).TRON;
    Attk = bl(i).Longtr(j).ATTK-bl(i).Longtr(j).TRON;
    Atof = bl(i).Longtr(j).ATOF-bl(i).Longtr(j).TRON;
    stmp = bl(i).Longtr(j).ts-bl(i).Longtr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))  %% only lick & attack trials
        
  
 
    ltr = ltr+1;
   
    L_ON = Lon;
    L_OFF = Loff;
    IR_ON = IRon;
    IR_OFF = IRoff;
    A_ttk = Attk;
    A_tof = Atof;
    s_tmp = stmp;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
    bl(i).Ltr = ltr;
 

    
    subplot(4,2,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

    
    

    subplot(4,2,5)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')
        
        
        
         subplot(4,2,7)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,1)


    
 line([0 0],[0 ltr],'Color','y','LineWidth',3)
 hold on

 ylim([0 ltr])

tt = strcat('Long block  ', num2str(i), '  aligned by trial on');
    title(tt)



subplot(4,2,3)


k = 5;
edges = -6:1/k:12; %from -6 befor first lick to 12 after trial on
[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
  Lymax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])




ylabel('Firing Rate')



end



% short trials


    ltr = 0;
     s_tmp_stack = [];

for j = 1:length(bl(i).Shorttr)
    
   
    
    IRon = bl(i).Shorttr(j).IRON-bl(i).Shorttr(j).TRON;
    IRoff = bl(i).Shorttr(j).IROF-bl(i).Shorttr(j).TRON;
    Lon = bl(i).Shorttr(j).LICK-bl(i).Shorttr(j).TRON;
    Loff = bl(i).Shorttr(j).LOFF-bl(i).Shorttr(j).TRON;
    Attk = bl(i).Shorttr(j).ATTK-bl(i).Shorttr(j).TRON;
    Atof = bl(i).Shorttr(j).ATOF-bl(i).Shorttr(j).TRON;
    stmp = bl(i).Shorttr(j).ts-bl(i).Shorttr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
        
  
 
    ltr = ltr+1;
   
    L_ON = Lon;
    L_OFF = Loff;
    IR_ON = IRon;
    IR_OFF = IRoff;
    A_ttk = Attk;
    A_tof = Atof;
    s_tmp = stmp;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
    bl(i).Ltr = ltr;
 
    

    
    subplot(4,2,2)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

    
    

    subplot(4,2,6)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')
        
        
        
         subplot(4,2,8)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,2)


    
 line([0 0],[0 ltr],'Color','y','LineWidth',3)
 hold on

 ylim([0 ltr])

tt = strcat('Short block  ', num2str(i), '  aligned by trial on');
    title(tt)



subplot(4,2,4)

k = 5;
edges = -6:1/k:12; %from -6 befor first lick to 12 after trial on
[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
 Symax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])
ylabel('Firing Rate')


subplot(4,2,3)


ylim([0 max(Lymax, Symax)*1.5])


subplot(4,2,4)


ylim([0 max(Lymax, Symax)*1.5])




end






end


%% IR on all type




for i = 1:length(BLON)
    
    k = TRON(BLON(i)<TRON);
    k = k(k<BLOF(i));
    tTRON = k;
    
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(tTRON)
    
    IRon = bl(i).tr(j).IRON-tTRON(j);
    IRoff = bl(i).tr(j).IROF-tTRON(j);
    Lon = bl(i).tr(j).LICK-tTRON(j);
    Loff = bl(i).tr(j).LOFF-tTRON(j);
    Attk = bl(i).tr(j).ATTK-tTRON(j);
    Atof = bl(i).tr(j).ATOF-tTRON(j);
    stmp = bl(i).tr(j).ts-tTRON(j);
    
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
        
    
    IR = IRon(1);
  
 
    ltr = ltr+1;
   
    L_ON = Lon-IR;
    L_OFF = Loff-IR;
    IR_ON = IRon-IR;
    IR_OFF = IRoff-IR;
    A_ttk = Attk-IR;
    A_tof = Atof-IR;
    s_tmp = stmp-IR;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
     bl(i).Ltr = ltr;
 
   
    
    subplot(4,1,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    


    xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

    

    subplot(4,1,3)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')
        
        
        
         subplot(4,1,4)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,1,1)


    
 line([0 0],[0 ltr],'Color','g','LineWidth',3)
 hold on

 ylim([0 ltr])

tt = strcat('block  ', num2str(i), '  aligned by trial on');
    title(tt)



subplot(4,1,2)
k = 5;
edges = -6:1/k:12; %from -6 befor first lick to 12 after trial on
[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])



ylabel('Firing Rate')



end




end



%% IR on_ diff trial




for i = 1:length(BLON)
    
 
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
     
     
     % long trials
    
for j = 1:length(bl(i).Longtr)
    
   
    
    IRon = bl(i).Longtr(j).IRON-bl(i).Longtr(j).TRON;
    IRoff = bl(i).Longtr(j).IROF-bl(i).Longtr(j).TRON;
    Lon = bl(i).Longtr(j).LICK-bl(i).Longtr(j).TRON;
    Loff = bl(i).Longtr(j).LOFF-bl(i).Longtr(j).TRON;
    Attk = bl(i).Longtr(j).ATTK-bl(i).Longtr(j).TRON;
    Atof = bl(i).Longtr(j).ATOF-bl(i).Longtr(j).TRON;
    stmp = bl(i).Longtr(j).ts-bl(i).Longtr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))  %% only lick & attack trials
        
  
        
    IR = IRon(1);
  
 
    ltr = ltr+1;
   
    L_ON = Lon-IR;
    L_OFF = Loff-IR;
    IR_ON = IRon-IR;
    IR_OFF = IRoff-IR;
    A_ttk = Attk-IR;
    A_tof = Atof-IR;
    s_tmp = stmp-IR;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
     bl(i).Ltr = ltr;
 

    
    subplot(4,2,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

    
    

    subplot(4,2,5)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')
        
        
        
         subplot(4,2,7)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,1)

line([0 0],[0 ltr],'Color','g','LineWidth',3)
hold on

ylim([0 ltr])

tt = strcat('Long block  ', num2str(i), '  aligned by first IR');
    title(tt)
    
 



subplot(4,2,3)

k = 5;


edges = -6:1/k:12; %from -6 befor first lick to 12 after trial on
[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
 Lymax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])



ylabel('Firing Rate')



end



% short trials


    ltr = 0;
     s_tmp_stack = [];

for j = 1:length(bl(i).Shorttr)
    
   
    
    IRon = bl(i).Shorttr(j).IRON-bl(i).Shorttr(j).TRON;
    IRoff = bl(i).Shorttr(j).IROF-bl(i).Shorttr(j).TRON;
    Lon = bl(i).Shorttr(j).LICK-bl(i).Shorttr(j).TRON;
    Loff = bl(i).Shorttr(j).LOFF-bl(i).Shorttr(j).TRON;
    Attk = bl(i).Shorttr(j).ATTK-bl(i).Shorttr(j).TRON;
    Atof = bl(i).Shorttr(j).ATOF-bl(i).Shorttr(j).TRON;
    stmp = bl(i).Shorttr(j).ts-bl(i).Shorttr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
        
  
 
        
    IR = IRon(1);
  
 
    ltr = ltr+1;
   
    L_ON = Lon-IR;
    L_OFF = Loff-IR;
    IR_ON = IRon-IR;
    IR_OFF = IRoff-IR;
    A_ttk = Attk-IR;
    A_tof = Atof-IR;
    s_tmp = stmp-IR;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
     bl(i).Ltr = ltr;
 
    

    
    subplot(4,2,2)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

    
    

    subplot(4,2,6)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')
        
        
        
         subplot(4,2,8)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,2)


line([0 0],[0 ltr],'Color','g','LineWidth',3)
hold on

ylim([0 ltr])

tt = strcat('Short block  ', num2str(i), '  aligned by first IR');
    title(tt)
    


subplot(4,2,4)

k = 5;
edges = -6:1/k:12; %from -6 befor first lick to 12 after trial on

[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
 Symax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])
ylabel('Firing Rate')



subplot(4,2,3)


ylim([0 max(Lymax, Symax)*1.5])


subplot(4,2,4)


ylim([0 max(Lymax, Symax)*1.5])



end






end






%% Only Lick trials PRTH (peri response t histogram)% when attack fixedd
% all trials



for i = 1:length(BLON)
    
    k = TRON(BLON(i)<TRON);
    k = k(k<BLOF(i));
    tTRON = k;
    
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(tTRON)
    
    IRon = bl(i).tr(j).IRON-tTRON(j);
    IRoff = bl(i).tr(j).IROF-tTRON(j);
    Lon = bl(i).tr(j).LICK-tTRON(j);
    Loff = bl(i).tr(j).LOFF-tTRON(j);
    Attk = bl(i).tr(j).ATTK-tTRON(j);
    Atof = bl(i).tr(j).ATOF-tTRON(j);
    stmp = bl(i).tr(j).ts-tTRON(j);
    
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
        
    FL = Lon(1);
    FIR = IRon(1);
 
    ltr = ltr+1;
   
    L_ON = Lon-FL;
    L_OFF = Loff-FL;
    IR_ON = IRon-FL;
    IR_OFF = IRoff-FL;
    A_ttk = Attk-FL;
    A_tof = Atof-FL;
    s_tmp = stmp-FL;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
  bl(i).Ltr = ltr;
    

    
    subplot(4,1,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    


   
    xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

    

    subplot(4,1,3)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')
        
        
        
         subplot(4,1,4)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,1,1)


    
line([0 0],[0 ltr],'Color','b','LineWidth',3)
hold on
line([3 3],[0 ltr],'Color','r','LineWidth',3)
line([6 6],[0 ltr],'Color','r','LineWidth',3)
ylim([0 ltr])

tt = strcat('block  ', num2str(i), '  aligned by first lick');
    title(tt)



subplot(4,1,2)


k = 5;
edges = -6:1/k:12; %from -6 befor first lick to 12 after first lick

[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])

% kkk =  histogram(s_tmp_stack, 'BinWidth',1);

ylabel('Firing Rate')



end




end


%% first lick_ diff trial




for i = 1:length(BLON)
    
 
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
     
     
     % long trials
    
for j = 1:length(bl(i).Longtr)
    
   
    
    IRon = bl(i).Longtr(j).IRON-bl(i).Longtr(j).TRON;
    IRoff = bl(i).Longtr(j).IROF-bl(i).Longtr(j).TRON;
    Lon = bl(i).Longtr(j).LICK-bl(i).Longtr(j).TRON;
    Loff = bl(i).Longtr(j).LOFF-bl(i).Longtr(j).TRON;
    Attk = bl(i).Longtr(j).ATTK-bl(i).Longtr(j).TRON;
    Atof = bl(i).Longtr(j).ATOF-bl(i).Longtr(j).TRON;
    stmp = bl(i).Longtr(j).ts-bl(i).Longtr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))  %% only lick & attack trials
        
  
     FL = Lon(1);
    FIR = IRon(1);
 
    ltr = ltr+1;
   
    L_ON = Lon-FL;
    L_OFF = Loff-FL;
    IR_ON = IRon-FL;
    IR_OFF = IRoff-FL;
    A_ttk = Attk-FL;
    A_tof = Atof-FL;
    s_tmp = stmp-FL;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
  bl(i).Ltr = ltr;
 

    
    subplot(4,2,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

    
    

    subplot(4,2,5)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')
        
        
        
         subplot(4,2,7)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,1)

line([0 0],[0 ltr],'Color','b','LineWidth',3)
hold on

line([6 6],[0 ltr],'Color','r','LineWidth',3)

ylim([0 ltr])

tt = strcat('Long block  ', num2str(i), '  aligned by first Lick');
    title(tt)
    
 



subplot(4,2,3)

k = 5;


edges = -6:1/k:12; %from -6 befor first lick to 12 after trial on
[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
 Lymax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])



ylabel('Firing Rate')



end



% short trials


    ltr = 0;
     s_tmp_stack = [];

for j = 1:length(bl(i).Shorttr)
    
   
    
    IRon = bl(i).Shorttr(j).IRON-bl(i).Shorttr(j).TRON;
    IRoff = bl(i).Shorttr(j).IROF-bl(i).Shorttr(j).TRON;
    Lon = bl(i).Shorttr(j).LICK-bl(i).Shorttr(j).TRON;
    Loff = bl(i).Shorttr(j).LOFF-bl(i).Shorttr(j).TRON;
    Attk = bl(i).Shorttr(j).ATTK-bl(i).Shorttr(j).TRON;
    Atof = bl(i).Shorttr(j).ATOF-bl(i).Shorttr(j).TRON;
    stmp = bl(i).Shorttr(j).ts-bl(i).Shorttr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
        
  
 FL = Lon(1);
    FIR = IRon(1);
 
    ltr = ltr+1;
   
    L_ON = Lon-FL;
    L_OFF = Loff-FL;
    IR_ON = IRon-FL;
    IR_OFF = IRoff-FL;
    A_ttk = Attk-FL;
    A_tof = Atof-FL;
    s_tmp = stmp-FL;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
  bl(i).Ltr = ltr;
    

    
    subplot(4,2,2)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

    
    

    subplot(4,2,6)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')
        
        
        
         subplot(4,2,8)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-6 12])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,2)


line([0 0],[0 ltr],'Color','b','LineWidth',3)
hold on
line([3 3],[0 ltr],'Color','r','LineWidth',3)

ylim([0 ltr])

tt = strcat('Short block  ', num2str(i), '  aligned by first Lick');
    title(tt)
    


subplot(4,2,4)

k = 5;
edges = -6:1/k:12; %from -6 befor first lick to 12 after trial on

[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
 Symax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])
ylabel('Firing Rate')



subplot(4,2,3)


ylim([0 max(Lymax, Symax)*1.5])


subplot(4,2,4)


ylim([0 max(Lymax, Symax)*1.5])



end






end


%% Only Lick trials PRTH (peri response t histogram)
%align by last lick


for i = 1:length(BLON)
    
    k = TRON(BLON(i)<TRON);
    k = k(k<BLOF(i));
    tTRON = k;
    
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(tTRON)
    
    IRon = bl(i).tr(j).IRON-tTRON(j);
    IRoff = bl(i).tr(j).IROF-tTRON(j);
    Lon = bl(i).tr(j).LICK-tTRON(j);
    Loff = bl(i).tr(j).LOFF-tTRON(j);
    Attk = bl(i).tr(j).ATTK-tTRON(j);
    Atof = bl(i).tr(j).ATOF-tTRON(j);
    stmp = bl(i).tr(j).ts-tTRON(j);
    
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
    LL = Loff(end);  %Lon->Loff
  
 
    ltr = ltr+1;
   
    L_ON = Lon-LL;
    L_OFF = Loff-LL;
    IR_ON = IRon-LL;
    IR_OFF = IRoff-LL;
    A_ttk = Attk-LL;
    A_tof = Atof-LL;
    s_tmp = stmp-LL;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
  bl(i).Ltr = ltr;
    

    
    subplot(4,1,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    


   
    xlabel('seconds')
    xlim([-6 6])
    ylabel('trials')

    

    subplot(4,1,3)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-6 6])
    ylabel('trials')
        
        
        
         subplot(4,1,4)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-6 6])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,1,1)


    
line([0 0],[0 ltr],'Color','b','LineWidth',3)
hold on

ylim([0 ltr])

tt = strcat('block  ', num2str(i), '  aligned by last lick');
    title(tt)



subplot(4,1,2)


k = 5;
edges = -6:1/k:6; %from -6 befor first lick to 6 after last lick

[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])

% kkk =  histogram(s_tmp_stack, 'BinWidth',1);

ylabel('Firing Rate')



end




end


%% last lick_ diff trial




for i = 1:length(BLON)
    
 
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
     
     
     % long trials
    
for j = 1:length(bl(i).Longtr)
    
   
    
    IRon = bl(i).Longtr(j).IRON-bl(i).Longtr(j).TRON;
    IRoff = bl(i).Longtr(j).IROF-bl(i).Longtr(j).TRON;
    Lon = bl(i).Longtr(j).LICK-bl(i).Longtr(j).TRON;
    Loff = bl(i).Longtr(j).LOFF-bl(i).Longtr(j).TRON;
    Attk = bl(i).Longtr(j).ATTK-bl(i).Longtr(j).TRON;
    Atof = bl(i).Longtr(j).ATOF-bl(i).Longtr(j).TRON;
    stmp = bl(i).Longtr(j).ts-bl(i).Longtr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))  %% only lick & attack trials
        
   LL = Loff(end);  %Lon->Loff
  
 
    ltr = ltr+1;
   
    L_ON = Lon-LL;
    L_OFF = Loff-LL;
    IR_ON = IRon-LL;
    IR_OFF = IRoff-LL;
    A_ttk = Attk-LL;
    A_tof = Atof-LL;
    s_tmp = stmp-LL;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
  bl(i).Ltr = ltr;
 

    
    subplot(4,2,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-6 6])
    ylabel('trials')

    
    

    subplot(4,2,5)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-6 6])
    ylabel('trials')
        
        
        
         subplot(4,2,7)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-6 6])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,1)

line([0 0],[0 ltr],'Color','b','LineWidth',3)
hold on



ylim([0 ltr])

tt = strcat('Long block  ', num2str(i), '  aligned by last Lick');
    title(tt)
    
 



subplot(4,2,3)

k = 5;


edges = -6:1/k:6; %from -6 befor first lick to 12 after trial on
[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
 Lymax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])



ylabel('Firing Rate')



end



% short trials


    ltr = 0;
     s_tmp_stack = [];

for j = 1:length(bl(i).Shorttr)
    
   
    
    IRon = bl(i).Shorttr(j).IRON-bl(i).Shorttr(j).TRON;
    IRoff = bl(i).Shorttr(j).IROF-bl(i).Shorttr(j).TRON;
    Lon = bl(i).Shorttr(j).LICK-bl(i).Shorttr(j).TRON;
    Loff = bl(i).Shorttr(j).LOFF-bl(i).Shorttr(j).TRON;
    Attk = bl(i).Shorttr(j).ATTK-bl(i).Shorttr(j).TRON;
    Atof = bl(i).Shorttr(j).ATOF-bl(i).Shorttr(j).TRON;
    stmp = bl(i).Shorttr(j).ts-bl(i).Shorttr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
        
  LL = Loff(end);  %Lon->Loff
  
 
    ltr = ltr+1;
   
    L_ON = Lon-LL;
    L_OFF = Loff-LL;
    IR_ON = IRon-LL;
    IR_OFF = IRoff-LL;
    A_ttk = Attk-LL;
    A_tof = Atof-LL;
    s_tmp = stmp-LL;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
  bl(i).Ltr = ltr;
    

    
    subplot(4,2,2)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-6 6])
    ylabel('trials')

    
    

    subplot(4,2,6)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-6 6])
    ylabel('trials')
        
        
        
         subplot(4,2,8)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-6 6])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,2)


line([0 0],[0 ltr],'Color','b','LineWidth',3)
hold on


ylim([0 ltr])

tt = strcat('Short block  ', num2str(i), '  aligned by last Lick');
    title(tt)
    


subplot(4,2,4)

k = 5;
edges = -6:1/k:6; %from -6 befor first lick to 6 after lastlick

[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
 Symax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])
ylabel('Firing Rate')



subplot(4,2,3)


ylim([0 max(Lymax, Symax)*1.5])


subplot(4,2,4)


ylim([0 max(Lymax, Symax)*1.5])



end






end




%% Only Lick trials PRTH (peri response t histogram)
%align by last IR


for i = 1:length(BLON)
    
    k = TRON(BLON(i)<TRON);
    k = k(k<BLOF(i));
    tTRON = k;
    
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(tTRON)
    
    IRon = bl(i).tr(j).IRON-tTRON(j);
    IRoff = bl(i).tr(j).IROF-tTRON(j);
    Lon = bl(i).tr(j).LICK-tTRON(j);
    Loff = bl(i).tr(j).LOFF-tTRON(j);
    Attk = bl(i).tr(j).ATTK-tTRON(j);
    Atof = bl(i).tr(j).ATOF-tTRON(j);
    stmp = bl(i).tr(j).ts-tTRON(j);
    
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
       
    IR = IRoff(end);
  
 
    ltr = ltr+1;
   
    L_ON = Lon-IR;
    L_OFF = Loff-IR;
    IR_ON = IRon-IR;
    IR_OFF = IRoff-IR;
    A_ttk = Attk-IR;
    A_tof = Atof-IR;
    s_tmp = stmp-IR;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
  bl(i).Ltr = ltr;
    

    
    subplot(4,1,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    


   
    xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

    

    subplot(4,1,3)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')
        
        
        
         subplot(4,1,4)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,1,1)


    
line([0 0],[0 ltr],'Color','g','LineWidth',3)
hold on

ylim([0 ltr])

tt = strcat('block  ', num2str(i), '  aligned by last IR');
    title(tt)



subplot(4,1,2)


k = 5;
edges = -10:1/k:5; %from -6 befor first lick to 6 after last lick

[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])

% kkk =  histogram(s_tmp_stack, 'BinWidth',1);

ylabel('Firing Rate')



end




end


%% last IR_ diff trial




for i = 1:length(BLON)
    
 
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
     
     
     % long trials
    
for j = 1:length(bl(i).Longtr)
    
   
    
    IRon = bl(i).Longtr(j).IRON-bl(i).Longtr(j).TRON;
    IRoff = bl(i).Longtr(j).IROF-bl(i).Longtr(j).TRON;
    Lon = bl(i).Longtr(j).LICK-bl(i).Longtr(j).TRON;
    Loff = bl(i).Longtr(j).LOFF-bl(i).Longtr(j).TRON;
    Attk = bl(i).Longtr(j).ATTK-bl(i).Longtr(j).TRON;
    Atof = bl(i).Longtr(j).ATOF-bl(i).Longtr(j).TRON;
    stmp = bl(i).Longtr(j).ts-bl(i).Longtr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))  %% only lick & attack trials
        
   
   
    IR = IRoff(end);
  
 
    ltr = ltr+1;
   
    L_ON = Lon-IR;
    L_OFF = Loff-IR;
    IR_ON = IRon-IR;
    IR_OFF = IRoff-IR;
    A_ttk = Attk-IR;
    A_tof = Atof-IR;
    s_tmp = stmp-IR;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
  bl(i).Ltr = ltr;
 

    
    subplot(4,2,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

    
    

    subplot(4,2,5)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')
        
        
        
         subplot(4,2,7)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,1)

line([0 0],[0 ltr],'Color','g','LineWidth',3)
hold on



ylim([0 ltr])

tt = strcat('Long block  ', num2str(i), '  aligned by last IR');
    title(tt)
    
 



subplot(4,2,3)

k = 5;


edges = -10:1/k:5; %from -6 befor first lick to 12 after trial on
[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
 Lymax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])



ylabel('Firing Rate')



end



% short trials


    ltr = 0;
     s_tmp_stack = [];

for j = 1:length(bl(i).Shorttr)
    
   
    
    IRon = bl(i).Shorttr(j).IRON-bl(i).Shorttr(j).TRON;
    IRoff = bl(i).Shorttr(j).IROF-bl(i).Shorttr(j).TRON;
    Lon = bl(i).Shorttr(j).LICK-bl(i).Shorttr(j).TRON;
    Loff = bl(i).Shorttr(j).LOFF-bl(i).Shorttr(j).TRON;
    Attk = bl(i).Shorttr(j).ATTK-bl(i).Shorttr(j).TRON;
    Atof = bl(i).Shorttr(j).ATOF-bl(i).Shorttr(j).TRON;
    stmp = bl(i).Shorttr(j).ts-bl(i).Shorttr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
        
  
 
     
    IR = IRoff(end);
  
 
    ltr = ltr+1;
   
    L_ON = Lon-IR;
    L_OFF = Loff-IR;
    IR_ON = IRon-IR;
    IR_OFF = IRoff-IR;
    A_ttk = Attk-IR;
    A_tof = Atof-IR;
    s_tmp = stmp-IR;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
  bl(i).Ltr = ltr;

    
    subplot(4,2,2)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

    
    

    subplot(4,2,6)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')
        
        
        
         subplot(4,2,8)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,2)


line([0 0],[0 ltr],'Color','g','LineWidth',3)
hold on


ylim([0 ltr])

tt = strcat('Short block  ', num2str(i), '  aligned by last IR');
    title(tt)
    


subplot(4,2,4)

k = 5;
edges = -10:1/k:5; %from -10 befor first lick to 5 after lastlick

[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
 Symax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])
ylabel('Firing Rate')



subplot(4,2,3)


ylim([0 max(Lymax, Symax)*1.5])


subplot(4,2,4)


ylim([0 max(Lymax, Symax)*1.5])



end






end





%% Only Lick trials PRTH (peri response t histogram)
%align by first Attack


for i = 1:length(BLON)
    
    k = TRON(BLON(i)<TRON);
    k = k(k<BLOF(i));
    tTRON = k;
    
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(tTRON)
    
    IRon = bl(i).tr(j).IRON-tTRON(j);
    IRoff = bl(i).tr(j).IROF-tTRON(j);
    Lon = bl(i).tr(j).LICK-tTRON(j);
    Loff = bl(i).tr(j).LOFF-tTRON(j);
    Attk = bl(i).tr(j).ATTK-tTRON(j);
    Atof = bl(i).tr(j).ATOF-tTRON(j);
    stmp = bl(i).tr(j).ts-tTRON(j);
    
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
       
        
    AT = Attk(1);
  
 
    ltr = ltr+1;
   
    L_ON = Lon-AT;
    L_OFF = Loff-AT;
    IR_ON = IRon-AT;
    IR_OFF = IRoff-AT;
    A_ttk = Attk-AT;
    A_tof = Atof-AT;
    s_tmp = stmp-AT;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
 
     bl(i).Ltr = ltr;
    

    
    subplot(4,1,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    


   
    xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

    

    subplot(4,1,3)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')
        
        
        
         subplot(4,1,4)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,1,1)


    
line([0 0],[0 ltr],'Color','r','LineWidth',3)
hold on

ylim([0 ltr])

tt = strcat('block  ', num2str(i), '  aligned by Attack');
    title(tt)



subplot(4,1,2)


k = 5;
edges = -10:1/k:5; %from -6 befor first lick to 6 after last lick

[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])

% kkk =  histogram(s_tmp_stack, 'BinWidth',1);

ylabel('Firing Rate')



end




end


%% attack_ diff trial




for i = 1:length(BLON)
    
 
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
     
     
     % long trials
    
for j = 1:length(bl(i).Longtr)
    
   
    
    IRon = bl(i).Longtr(j).IRON-bl(i).Longtr(j).TRON;
    IRoff = bl(i).Longtr(j).IROF-bl(i).Longtr(j).TRON;
    Lon = bl(i).Longtr(j).LICK-bl(i).Longtr(j).TRON;
    Loff = bl(i).Longtr(j).LOFF-bl(i).Longtr(j).TRON;
    Attk = bl(i).Longtr(j).ATTK-bl(i).Longtr(j).TRON;
    Atof = bl(i).Longtr(j).ATOF-bl(i).Longtr(j).TRON;
    stmp = bl(i).Longtr(j).ts-bl(i).Longtr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))  %% only lick & attack trials
        
   
   
          
    AT = Attk(1);
  
 
    ltr = ltr+1;
   
    L_ON = Lon-AT;
    L_OFF = Loff-AT;
    IR_ON = IRon-AT;
    IR_OFF = IRoff-AT;
    A_ttk = Attk-AT;
    A_tof = Atof-AT;
    s_tmp = stmp-AT;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
 
     bl(i).Ltr = ltr;
 

    
    subplot(4,2,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

    
    

    subplot(4,2,5)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')
        
        
        
         subplot(4,2,7)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,1)

line([0 0],[0 ltr],'Color','r','LineWidth',3)
hold on



ylim([0 ltr])

tt = strcat('Long block  ', num2str(i), '  aligned by Attack');
    title(tt)
    
 



subplot(4,2,3)

k = 5;


edges = -10:1/k:5; %from -6 befor first lick to 12 after trial on
[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
 Lymax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])



ylabel('Firing Rate')



end



% short trials


    ltr = 0;
     s_tmp_stack = [];

for j = 1:length(bl(i).Shorttr)
    
   
    
    IRon = bl(i).Shorttr(j).IRON-bl(i).Shorttr(j).TRON;
    IRoff = bl(i).Shorttr(j).IROF-bl(i).Shorttr(j).TRON;
    Lon = bl(i).Shorttr(j).LICK-bl(i).Shorttr(j).TRON;
    Loff = bl(i).Shorttr(j).LOFF-bl(i).Shorttr(j).TRON;
    Attk = bl(i).Shorttr(j).ATTK-bl(i).Shorttr(j).TRON;
    Atof = bl(i).Shorttr(j).ATOF-bl(i).Shorttr(j).TRON;
    stmp = bl(i).Shorttr(j).ts-bl(i).Shorttr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
        
  
 
     
        
    AT = Attk(1);
  
 
    ltr = ltr+1;
   
    L_ON = Lon-AT;
    L_OFF = Loff-AT;
    IR_ON = IRon-AT;
    IR_OFF = IRoff-AT;
    A_ttk = Attk-AT;
    A_tof = Atof-AT;
    s_tmp = stmp-AT;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
 
     bl(i).Ltr = ltr;

    
    subplot(4,2,2)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

    
    

    subplot(4,2,6)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')
        
        
        
         subplot(4,2,8)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,2)


line([0 0],[0 ltr],'Color','r','LineWidth',3)
hold on


ylim([0 ltr])

tt = strcat('Short block  ', num2str(i), '  aligned by Attack');
    title(tt)
    


subplot(4,2,4)

k = 5;
edges = -10:1/k:5; %from -10 befor first lick to 5 after lastlick

[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
 Symax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])
ylabel('Firing Rate')



subplot(4,2,3)


ylim([0 max(Lymax, Symax)*1.5])


subplot(4,2,4)


ylim([0 max(Lymax, Symax)*1.5])



end






end





%% Only Lick trials PRTH (peri response t histogram)
%align by trial off


for i = 1:length(BLON)
    
    k = TRON(BLON(i)<TRON);
    k = k(k<BLOF(i));
    tTRON = k;
    
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(tTRON)
    
    IRon = bl(i).tr(j).IRON-tTRON(j);
    IRoff = bl(i).tr(j).IROF-tTRON(j);
    Lon = bl(i).tr(j).LICK-tTRON(j);
    Loff = bl(i).tr(j).LOFF-tTRON(j);
    Attk = bl(i).tr(j).ATTK-tTRON(j);
    Atof = bl(i).tr(j).ATOF-tTRON(j);
    stmp = bl(i).tr(j).ts-tTRON(j);
    
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
       
  
    TF = trof;
  
 
    ltr = ltr+1;
   
    L_ON = Lon-TF;
    L_OFF = Loff-TF;
    IR_ON = IRon-TF;
    IR_OFF = IRoff-TF;
    A_ttk = Attk-TF;
    A_tof = Atof-TF;
    s_tmp = stmp-TF;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
 
     bl(i).Ltr = ltr;
    

    
    subplot(4,1,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    


   
    xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

    

    subplot(4,1,3)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')
        
        
        
         subplot(4,1,4)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,1,1)


    
line([0 0],[0 ltr],'Color','y','LineWidth',3)
hold on

ylim([0 ltr])

tt = strcat('block  ', num2str(i), '  aligned by Attack');
    title(tt)



subplot(4,1,2)


k = 5;
edges = -10:1/k:5; %from -6 befor first lick to 6 after last lick

[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])

% kkk =  histogram(s_tmp_stack, 'BinWidth',1);

ylabel('Firing Rate')



end




end


%% trialOff_ diff trial




for i = 1:length(BLON)
    
 
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
     
     
     % long trials
    
for j = 1:length(bl(i).Longtr)
    
   
    
    IRon = bl(i).Longtr(j).IRON-bl(i).Longtr(j).TRON;
    IRoff = bl(i).Longtr(j).IROF-bl(i).Longtr(j).TRON;
    Lon = bl(i).Longtr(j).LICK-bl(i).Longtr(j).TRON;
    Loff = bl(i).Longtr(j).LOFF-bl(i).Longtr(j).TRON;
    Attk = bl(i).Longtr(j).ATTK-bl(i).Longtr(j).TRON;
    Atof = bl(i).Longtr(j).ATOF-bl(i).Longtr(j).TRON;
    stmp = bl(i).Longtr(j).ts-bl(i).Longtr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))  %% only lick & attack trials
        
   
   
          
    
    TF = trof;
  
 
    ltr = ltr+1;
   
    L_ON = Lon-TF;
    L_OFF = Loff-TF;
    IR_ON = IRon-TF;
    IR_OFF = IRoff-TF;
    A_ttk = Attk-TF;
    A_tof = Atof-TF;
    s_tmp = stmp-TF;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
 
     bl(i).Ltr = ltr;
 

    
    subplot(4,2,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

    
    

    subplot(4,2,5)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')
        
        
        
         subplot(4,2,7)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,1)

line([0 0],[0 ltr],'Color','y','LineWidth',3)
hold on



ylim([0 ltr])

tt = strcat('Long block  ', num2str(i), '  aligned by Attack');
    title(tt)
    
 



subplot(4,2,3)

k = 5;


edges = -10:1/k:5; %from -6 befor first lick to 12 after trial on
[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
 Lymax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])



ylabel('Firing Rate')



end



% short trials


    ltr = 0;
     s_tmp_stack = [];

for j = 1:length(bl(i).Shorttr)
    
   
    
    IRon = bl(i).Shorttr(j).IRON-bl(i).Shorttr(j).TRON;
    IRoff = bl(i).Shorttr(j).IROF-bl(i).Shorttr(j).TRON;
    Lon = bl(i).Shorttr(j).LICK-bl(i).Shorttr(j).TRON;
    Loff = bl(i).Shorttr(j).LOFF-bl(i).Shorttr(j).TRON;
    Attk = bl(i).Shorttr(j).ATTK-bl(i).Shorttr(j).TRON;
    Atof = bl(i).Shorttr(j).ATOF-bl(i).Shorttr(j).TRON;
    stmp = bl(i).Shorttr(j).ts-bl(i).Shorttr(j).TRON;
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
        
  
 
     
        
   
    TF = trof;
  
 
    ltr = ltr+1;
   
    L_ON = Lon-TF;
    L_OFF = Loff-TF;
    IR_ON = IRon-TF;
    IR_OFF = IRoff-TF;
    A_ttk = Attk-TF;
    A_tof = Atof-TF;
    s_tmp = stmp-TF;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
 
     bl(i).Ltr = ltr;

    
    subplot(4,2,2)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    

    xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

    
    

    subplot(4,2,6)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')
        
        
        
         subplot(4,2,8)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end

if ltr ~= 0
    
subplot(4,2,2)


line([0 0],[0 ltr],'Color','y','LineWidth',3)
hold on


ylim([0 ltr])

tt = strcat('Short block  ', num2str(i), '  aligned by Attack');
    title(tt)
    


subplot(4,2,4)

k = 5;
edges = -10:1/k:5; %from -10 befor first lick to 5 after lastlick

[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
 Symax = max(Nt);
set(gca, 'XTick', 0.5:k:length(edges)+0.5)
set(gca, 'XTickLabel', edges(1:k:length(edges)))
xlim([0.5 length(edges)-.5])
ylabel('Firing Rate')



subplot(4,2,3)


ylim([0 max(Lymax, Symax)*1.5])


subplot(4,2,4)


ylim([0 max(Lymax, Symax)*1.5])



end






end




%%



for i = 1:length(BLON)
    
    k = TRON(BLON(i)<TRON);
    k = k(k<BLOF(i));
    tTRON = k;
    
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(tTRON)
    
    IRon = bl(i).tr(j).IRON-tTRON(j);
    IRoff = bl(i).tr(j).IROF-tTRON(j);
    Lon = bl(i).tr(j).LICK-tTRON(j);
    Loff = bl(i).tr(j).LOFF-tTRON(j);
    Attk = bl(i).tr(j).ATTK-tTRON(j);
    Atof = bl(i).tr(j).ATOF-tTRON(j);
    stmp = bl(i).tr(j).ts-tTRON(j);
    trof = bl(i).tr(j).TROF-tTRON(j); % fixed
    
    
    
    
    
    
   
   
   
   if (~isempty(Lon) && ~isempty(Attk))
        
    TF = trof;
  
 
    ltr = ltr+1;
   
    L_ON = Lon-TF;
    L_OFF = Loff-TF;
    IR_ON = IRon-TF;
    IR_OFF = IRoff-TF;
    A_ttk = Attk-TF;
    A_tof = Atof-TF;
    s_tmp = stmp-TF;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
 
     bl(i).Ltr = ltr;
%     
%      if  ~isempty(IR_ON)
%         for h = 1:length(IR_ON)
%         line([IR_ON(h) IR_OFF(h)],[.1 .1],'Color','g','LineWidth',10)
%         end
%     end
%      
%     hold on
%     
%     if ~isempty(L_ON)
%         
%     line([L_ON L_OFF],[0 0],'Color','b','LineWidth',10) 
%     end
%     
    
%     if ~isempty(A_ttk)
%     line([A_ttk A_tof], [.2 .2] ,'Color','r','LineWidth',10)
%     line([A_ttk A_ttk], [0 .2], 'Color', 'r','LineWidth',1)
%        
%     end
%     
    
    subplot(4,1,1)
    if ~isempty(s_tmp)
        for h = 1:length(s_tmp)
        line([s_tmp(h) s_tmp(h)],[ltr-1 ltr],'Color','k','LineWidth',1)
        hold on
        end
        
        
    end
    
%     set(findall(gca, 'Type', 'Line'),'LineWidth',10);
    

    
%     tt = strcat('block  ', num2str(i), '   trial  ' , num2str(j));
%     title(tt)
    xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')
%     yticklabels({'Lick', 'IR', 'Attack', 'Spikes'})
%     yticks([0 .1 .2  .3])
    
    

    subplot(4,1,3)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')
        
        
        
         subplot(4,1,4)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-10 5])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end


if ltr ~=0


subplot(4,1,1)
line([0 0],[0 ltr],'Color','y','LineWidth',3)
hold on

% line([6 6],[0 ltr],'Color','r','LineWidth',3)
% line([6.7994 6.7994],[0 ltr],'Color','r','LineWidth',3)
ylim([0 ltr])

tt = strcat('block  ', num2str(i), '  aligned by trial off');
    title(tt)



subplot(4,1,2)




edges = -10:1:5; %from -10 befor last lick to 5 after attack
[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)


set(gca, 'XTick', 0.5:1:length(edges)+0.5)
set(gca, 'XTickLabel', edges)
xlim([0.5 length(edges)-.5])



% kkk =  histogram(s_tmp_stack, 'BinWidth',1);

ylabel('Firing Rate')



end





end