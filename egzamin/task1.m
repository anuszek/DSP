clear all; close all; clc;
fpr=100;  % czestotliwosc probkowania
Nx=1000;  % liczba probek
dt = 1/fpr;  % okres probkowania
t = dt*(0:Nx-1);  % chwile pobierania probek

% Parametry AM-FM
f_A = 0.5;    % Hz, czestotliwosc modulacji AM
k_A = 0.25;   % glebokosc modulacji AM
f_0 = 5;      % Hz, czestotliwosc nosna FM
f_F = 2;      % Hz, czestotliwosc modulujaca FM
k_F = 5;      % glebokosc modulacji FM

AM = 1 + k_A * sin(2*pi*f_A*t); % obwiednia AM
FM = sin(2*pi*f_0*t + k_F * sin(2*pi*f_F*t)); % sygnal FM

x = AM .* FM; % sygnal AM-FM

plot(t, x, 'b-');
grid; title('Sygnał AM-FM');
xlabel('czas [s]'); ylabel('Amplituda');

% Obwiednia amplitudy (AM)
figure;
plot(t, x, 'b', t, AM, 'r--', t, -AM, 'r--');
grid; title('Sygnał AM-FM z obwiednią AM');
xlabel('czas [s]'); ylabel('Amplituda');
legend('Sygnał x', 'Obwiednia +AM', 'Obwiednia -AM');



%% Zwiększona częstotliwość próbkowania i proporcjonalne częstotliwości

fpr = 8000;
Nx = 5*fpr;
dt = 1/fpr;
t = dt*(0:Nx-1);

% Proporcjonalnie zwiększone częstotliwości
f_A = 0.5 * 80;    % 40 Hz
k_A = 0.25;
f_0 = 5 * 80;      % 400 Hz
f_F = 2 * 80;      % 160 Hz
k_F = 5;

% Definicje z tabeli 2.2
mA = sin(2*pi*f_A*t); % sygnał modulujący AM
AM = 1 + k_A * mA;    % obwiednia AM

mF = sin(2*pi*f_F*t); % sygnał modulujący FM
FM = sin(2*pi*f_0*t + k_F * cumsum(mF)*dt); % FM zgodnie z tabelą

x = AM .* FM; % sygnał AM-FM

soundsc(x, fpr); % odsłuch sygnału

% wykres fragmentu sygnału
figure;
plot(t(1:1000), x(1:1000));
title('Fragment sygnału AM-FM');
xlabel('czas [s]'); ylabel('Amplituda');
grid;