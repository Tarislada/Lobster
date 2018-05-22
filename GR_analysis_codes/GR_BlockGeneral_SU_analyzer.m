%% Analyzer


figure
% pre lick hestiation

subplot(1,3,1)
plot(Ltr_PreLHd)


subplot(1,3,2)
plot(Ltr_Ld,'b')
hold on

plot(Ltr_HW,'g')
plot(Ltr_Attk,'r')

subplot(1,3,3)

bar(1,mean(Ltr_Ld),'b')
hold on
bar(2,mean(Ltr_HW),'g')
bar(3,mean(Ltr_Attk),'r')