%% Gamble Rats LOB sessions event reader

% clear
% clc

%open directory
% thefolder = uigetdir;
% 
% 
% thefiles = dir(thefolder);




[TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF, BLON, BLOF]=GambleRatsBehavParser;






%% Overall firing rate change analysis

figure
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


%% align by Trial ON




    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(TRON)
    
    
    
    
       
    IRon = TR(j).IRON-TRON(j);
    IRoff = TR(j).IROF-TRON(j);
    Lon = TR(j).LICK-TRON(j);
    Loff = TR(j).LOFF-TRON(j);
    Attk = TR(j).ATTK-TRON(j);
    Atof = TR(j).ATOF-TRON(j);
    stmp = TR(j).ts-TRON(j);
    trof = TROF(j)-TRON(j);
    
   
    
    
    
    
    
   
   
   
   if (~isempty(Lon))
        
  
 
    ltr = ltr+1;
   
    L_ON = Lon;
    L_OFF = Loff;
    IR_ON = IRon;
    IR_OFF = IRoff;
    A_ttk = Attk;
    A_tof = Atof;
    s_tmp = stmp;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
 
    
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




%% Only Lick trials PRTH (peri response t histogram)
%align by first IR





    
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(TRON)
    

       
    IRon = TR(j).IRON-TRON(j);
    IRoff = TR(j).IROF-TRON(j);
    Lon = TR(j).LICK-TRON(j);
    Loff = TR(j).LOFF-TRON(j);
    Attk = TR(j).ATTK-TRON(j);
    Atof = TR(j).ATOF-TRON(j);
    stmp = TR(j).ts-TRON(j);
    trof = TROF(j)-TRON(j);
    
    
    
    
    
    
   
   
   
   if (~isempty(Lon))
        
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

    xlabel('seconds')
    xlim([-3 10])
    ylabel('trials')

    

    subplot(4,1,3)
        for h = 1:length(IR_ON)
        line([IR_ON(h) IR_OFF(h)],[ltr-1 ltr-1],'Color','g','LineWidth',2)
        hold on
        end
        xlabel('seconds')
    xlim([-3 10])
    ylabel('trials')
        
        
        
         subplot(4,1,4)
        for h = 1:length(L_ON)
        line([L_ON(h) L_OFF(h)],[ltr-1 ltr-1],'Color','b','LineWidth',2)
        hold on
        end
        
        xlabel('seconds')
    xlim([-3 10])
    ylabel('trials')

   end
    
   
   
   
   
   
   
    
   

   
    
end


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










%% Only Lick trials PRTH (peri response t histogram)% when attack fixedd
%align by first lick




    
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(TRON)
    
     IRon = TR(j).IRON-TRON(j);
    IRoff = TR(j).IROF-TRON(j);
    Lon = TR(j).LICK-TRON(j);
    Loff = TR(j).LOFF-TRON(j);
    Attk = TR(j).ATTK-TRON(j);
    Atof = TR(j).ATOF-TRON(j);
    stmp = TR(j).ts-TRON(j);
    trof = TROF(j)-TRON(j);
    
    
    
    
    
   
   
   
   if (~isempty(Lon))
        
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




%% Only Lick trials PRTH (peri response t histogram)
%align by last lick





    
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(TRON)
    
       IRon = TR(j).IRON-TRON(j);
    IRoff = TR(j).IROF-TRON(j);
    Lon = TR(j).LICK-TRON(j);
    Loff = TR(j).LOFF-TRON(j);
    Attk = TR(j).ATTK-TRON(j);
    Atof = TR(j).ATOF-TRON(j);
    stmp = TR(j).ts-TRON(j);
    trof = TROF(j)-TRON(j);
    
    
    
    
   
   
   
   if (~isempty(Lon))
        
    LL = Loff(end); %Lon->Loff
  
 
    ltr = ltr+1;
   
    L_ON = Lon-LL;
    L_OFF = Loff-LL;
    IR_ON = IRon-LL;
    IR_OFF = IRoff-LL;
    A_ttk = Attk-LL;
    A_tof = Atof-LL;
    s_tmp = stmp-LL;
    s_tmp_stack = [s_tmp_stack; s_tmp];
    
 
    
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
    xlim([-6 6])
    ylabel('trials')
%     yticklabels({'Lick', 'IR', 'Attack', 'Spikes'})
%     yticks([0 .1 .2  .3])
    
    

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





%% Only Lick trials PRTH (peri response t histogram)
%align by last IR





    
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(TRON)
    
      IRon = TR(j).IRON-TRON(j);
    IRoff = TR(j).IROF-TRON(j);
    Lon = TR(j).LICK-TRON(j);
    Loff = TR(j).LOFF-TRON(j);
    Attk = TR(j).ATTK-TRON(j);
    Atof = TR(j).ATOF-TRON(j);
    stmp = TR(j).ts-TRON(j);
    trof = TROF(j)-TRON(j);
    
    
    
    
    
   
   
   
   if (~isempty(Lon))
        
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







%% Only Lick trials PRTH (peri response t histogram)
%align by Attack





    
    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(TRON)
    
      IRon = TR(j).IRON-TRON(j);
    IRoff = TR(j).IROF-TRON(j);
    Lon = TR(j).LICK-TRON(j);
    Loff = TR(j).LOFF-TRON(j);
    Attk = TR(j).ATTK-TRON(j);
    Atof = TR(j).ATOF-TRON(j);
    stmp = TR(j).ts-TRON(j);
    trof = TROF(j)-TRON(j);
    
    
    
    
    
   
   
   
   if (~isempty(Lon))
        

   
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










%% Only Lick trials PRTH (peri response t histogram)
%all block align by trial off




    figure
    
   
     ltr = 0;
     s_tmp_stack = [];
for j = 1:length(TRON)
    
  IRon = TR(j).IRON-TRON(j);
    IRoff = TR(j).IROF-TRON(j);
    Lon = TR(j).LICK-TRON(j);
    Loff = TR(j).LOFF-TRON(j);
    Attk = TR(j).ATTK-TRON(j);
    Atof = TR(j).ATOF-TRON(j);
    stmp = TR(j).ts-TRON(j);
    trof = TROF(j)-TRON(j);
    
    
    
    
   
   
   
   if (~isempty(Lon))
        
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
