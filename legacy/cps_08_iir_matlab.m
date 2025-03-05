% cps_08_matlab.m
clear all; close all;
fpr=2000; f1=400; f2=600; N=8; Rp=3; Rs=80;         % 1) wymagania dla filtra  
[b,a] = ellip(N, Rp, Rs, [f1,f2]/(fpr/2), 'stop');  % 2) projekt filtra
Npunkt=1000; freqz(b,a,Npunkt,fpr);                 % 3) sprawdzenie H(f) filtra
Nx=1000; dt=1/fpr; t=dt*(0:Nx-1); fx1=10; fx2=500;  % 4) wymagania dla sygnalu
x = sin(2*pi*fx1*t) + sin(2*pi*fx2*t);              % 5) generacja sygnalu  
y = filter(b,a,x);                                  % 6) filtracja sygnału - dwie sumy
figure; plot(t,x,'b-',t,y,'r-'); title('We/Wy');    % 7) wynik filtracji

