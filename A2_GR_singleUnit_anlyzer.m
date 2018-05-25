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

%% FR
% 
% subplot(4,1,4)
% kkk =  histogram(ts, 'BinWidth',60)
% ylabel('Firing Rate')


