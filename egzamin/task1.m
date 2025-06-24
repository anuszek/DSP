clear all; close all; clc;
fpr = 100;  % czestotliwosc probkowania
Nx = 1000;  % liczba probek
dt = 1/fpr;  % okres probkowania
t = dt*(0:Nx-1);  % chwile pobierania probek

% Parametry AM-FM
f_A = 0.5;    % Hz, czestotliwosc modulacji AM
k_A = 0.25;   % glebokosc modulacji AM
f_0 = 5;      % Hz, czestotliwosc nosna FM
f_F = 2;      % Hz, czestotliwosc modulujaca FM
k_F = 5;      % glebokosc modulacji FM

% Generowanie sygnału AM-FM
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


%% Zwiększona częstotliwość próbkowania

fpr = 8000;
Nx = 5*fpr;  % 5 sekund sygnału
dt = 1/fpr;
t = dt*(0:Nx-1);

% Proporcjonalnie zwiększone częstotliwości
f_0 = 400;

f_A = 20;
k_A = 0.125;
f_F = 3;
k_F = 25;

% Definicje z tabeli 2.2
mA = sin(2*pi*f_A*t);  % sygnał modulujący AM
AM = 1 + k_A * mA;  % obwiednia AM

mF = sin(2*pi*f_F*t);  % sygnał modulujący FM
FM = sin(2*pi*f_0*t + k_F * cumsum(mF)*dt);  % FM zgodnie z tabelą

x = AM .* FM;  % sygnał AM-FM

x = x / max(abs(x));  % normalizacja sygnału przed odtworzeniem
soundsc(x, fpr);  % odsłuch sygnału

figure;
% plot(t(1:1000), x(1:1000));
plot(t(1:10000), x(1:10000));
title('Fragment sygnału AM-FM');
xlabel('czas [s]'); ylabel('Amplituda');
grid;