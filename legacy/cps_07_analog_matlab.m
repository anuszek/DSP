% cps_07_analog_matlab.m
clear all; close all;

N = 8;                   % liczba biegunow transmitancji
f0=10;  f1=10;  f2=100;  % czestotliwosci w Hz [1/s]
Rp = 3; Rs = 100;        % dozwolony poziom oscylacji (dB) w pasmie: pass (p), stop (s)
% [b,a] = butter(N, 2*pi*f0, 'low','s');                    % Butt  LP 
% [b,a] = butter(N, 2*pi*f0, 'high','s');                   % Butt  HP
% [b,a] = butter(N, 2*pi*[f1,f2], 'stop', 's');             % Butt  BS
% [b,a] = butter(N, 2*pi*[f1,f2], 'bandpass', 's');         % Butt  BP
% [b,a] = cheby1(N, Rp, 2*pi*[f1,f2], 'bandpass', 's');     % Cheb1 BP
% [b,a] = cheby2(N, Rs, 2*pi*[f1,f2], 'bandpass', 's');     % Cheb2 BP
  [b,a] = ellip(N, Rp, Rs,2*pi*[f1,f2], 'bandpass', 's');  % Ellip BP
  z=roots(b); p=roots(a); wzm=1;

% ... kontynuuj cps_07_analog_intro.m
