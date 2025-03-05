% cps_01_szum.m
clear all; close all;

Nx = 10000;
s1 = rand(1,Nx);    % s1 = 0.1*(2*(s1-0.5)); % rownomierny, skalowanie do [-0.1,0.1]
s2 = randn(1,Nx);   % s2 = 0.1*s2;           % gaussowski, skalowanie do std=0.1

figure;
subplot(221); plot(s1,'.-'); grid; title('Szum rownomierny [0,1]');
subplot(222); plot(s2,'.-'); grid; title('Szum gaussowski');
subplot(223); hist(s1,20); title('Histogram szumu rownomiernego');
subplot(224); hist(s2,20); title('Histogram szumu gaussowskiego');
