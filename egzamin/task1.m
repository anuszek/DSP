% cps_02_sygnaly.m
clear all; close all; clc;
fpr=8000;  % czestotliwosc probkowania
Nx=5*fpr;  % liczba probek
dt = 1/fpr;  % okres probkowania
t = dt*(0:Nx-1);  % chwile pobierania probek

% Parametry modulacji AM
f_A = 0.5 * (fpr/100);
k_A = 0.25;

% Parametry modulacji FM
f_0 = 5 * (fpr/100);
f_F = 2 * (fpr/100);
k_F = 5 * (fpr/100);

% Sygnały bazowe
x1 = sin(2*pi*10*(fpr/100)*t);  
x2 = sin(2*pi*1*(fpr/100)*t);   

x_FM = sin(2*pi*(f_0*t - (k_F / (2*pi*f_F)) * cos(2*pi*f_F*t)));

% Sygnał z modulacją AM-FM
x = (1 + k_A*x2) .* x_FM;

% Wykresy
figure;
subplot(3,1,1);
plot(t(1:1000), x2(1:1000), 'b-'); 
grid; title('Sygnał modulujący AM: x2(t)'); xlabel('czas [s]'); ylabel('Amplituda');

subplot(3,1,2);
plot(t(1:1000), x_FM(1:1000), 'r-'); 
grid; title('Sygnał z modulacją FM: x_FM(t)'); xlabel('czas [s]'); ylabel('Amplituda');

subplot(3,1,3);
plot(t(1:1000), x(1:1000), 'g-'); 
grid; title('Sygnał z modulacją AM-FM: x(t)'); xlabel('czas [s]'); ylabel('Amplituda');

% Odsłuchanie sygnału
fprintf('Odtwarzanie sygnału z modulacją AM-FM...\n');
soundsc(x, fpr);