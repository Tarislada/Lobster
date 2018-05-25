%% Selective PSTH analyzer

%% Unit basic analysis


clc
clear


[FileName,PathName] = uigetfile;

filepath = strcat(PathName,FileName);

load(filepath);

%% waveform

su = table2array(SU);

wav = su(:,4:end);

l = size(wav,1);
p = size(wav,2)/4;




z = zeros(l,10);

wave1 = wav(:,1:p);
wave2 = wav(:,p+1:2*p);
wave3 = wav(:,2*p+1:3*p);
wave4 = wav(:,3*p+1:4*p);


mwave1 = mean(wave1);
mwave2 = mean(wave2);
mwave3 = mean(wave3);
mwave4 = mean(wave4);

pwave1 = wave1';
pwave2 = wave2';
pwave3 = wave3';
pwave4 = wave4';

figure
subplot(2,1,1)
x = 1:1:p;
plot(x,pwave1,'b')
hold on
plot(x+p,pwave2,'b')
plot(x+2*p,pwave3,'b')
plot(x+3*p,pwave4,'b')

ylabel('MicroV')

subplot(2,1,2)

plot(x,mwave1,'b','LineWidth',2)
hold on
plot(x+p,mwave2,'b','LineWidth',2)
plot(x+2*p,mwave3,'b','LineWidth',2)
plot(x+3*p,mwave4,'b','LineWidth',2)


ylabel('MicroV')


%% Timesptamps

 ts = su(:,1);
% 
% subplot(4,1,3)
% line([ts ts],[0 1],'Color','b')




%% BehaveParse

[TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF, BLON, BLOF]=GambleRatsBehavParser;


%% How many blocks?



x = [];
for i = 1:length(BLON)

prompt = strcat('What is the attack mean of block ', num2str(i), '      : ');
    
    x = [x  input(prompt)];  % attack mean ber block = x(i)
end


%% BLock_trial_lize

bl = struct;

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
    
    
    
    
    
   
   
   
   if (~isempty(Lon))
        
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
% line([6 6],[0 ltr],'Color','r','LineWidth',3)
% line([6.7994 6.7994],[0 ltr],'Color','r','LineWidth',3)
ylim([0 ltr])

tt = strcat('block  ', num2str(i), '  aligned by last lick');
    title(tt)



subplot(4,1,2)

edges = -6:1:6; %from -6 befor last lick to 6 after last lick
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
    trof = bl(i).tr(j).TROF-tTRON(j); % fixed
    
    
    
    
    
    
   
   
   
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





%% BLock_trial_lize

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
% line([6 6],[0 ltr],'Color','r','LineWidth',3)
% line([6.7994 6.7994],[0 ltr],'Color','r','LineWidth',3)
ylim([0 ltr])

tt = strcat('all blocks aligned by last lick');
    title(tt)



subplot(4,1,2)

edges = -6:1:6; %from -6 befor last lick to 6 after last lick
[N, edges] = histcounts(s_tmp_stack, edges);
 Nt = N/ltr;
 
 bar(Nt)
set(gca, 'XTick', 0.5:1:length(edges)+0.5)
set(gca, 'XTickLabel', edges)
xlim([0.5 length(edges)-.5])

% kkk =  histogram(s_tmp_stack, 'BinWidth',1);

ylabel('Firing Rate')



end





