close all; clc; clear;

% Wczytywanie pliku
data = open("lab08_am.mat");

% Wybieranie sygnału zgodnego z przedostatnią cyfrą indeksu
x = data.s4;

% Parametry
Fc = 200;             % częstotliwość nośnej
Fs = 1e3;             % częstotliwość próbkowania
M = 50;               % połowa rzędu filtru
N = 2*M + 1;          % rząd filtru (nieparzysty)
n = -M:M;             % indeksy próbek

% Ręczna definicja filtru Hilberta z oknem (raised cosine window)
h = (1 - cos(pi * n)) ./ (pi * n);   % wzór na filtr Hilberta z oknem
h(M+1) = 0;                          % wartość w n=0 jest osobno nadpisywana

% Opcja z filtrem
xh = filter(h,1,x);

% Konwolucja (pełna)
% xh = conv(x, h);

% Konwolucja (z automatyczna synchronizacją)
% xh = conv(x,h,'same');

% Synchronizacja wejścia i wyjścia filtra
Nx = length(x);
x_sync  = x(M+1 : Nx-M);                          % ucięcie brzegów wejścia
xh_sync = xh(2*M+1 : 2*M+length(x_sync));    % wyrównanie opóźnienia

% Sygnał analityczny
z = x_sync + 1i * xh_sync;
% z = x + 1i * xh;
m = abs(z);     % obwiednia (amplituda chwilowa)

figure;
plot(x,"b"); hold on;
plot(xh,"k"); hold on;
title("Sygnał przed i po Filtrze Hilberta")
xlabel('Numer próbki'); ylabel('Amplituda')
legend('x','HT(x)'); grid on;

figure;
plot(x_sync,"b"); hold on;
plot(xh_sync,"k"); hold on;
plot(m, 'r','LineWidth',1);
title("Sygnał przed i po Filtrze Hilberta (synchroizacja) oraz Obwiednia AM")
xlabel('Numer próbki'); ylabel('Amplituda')
legend('x','HT(x)','amp'); grid on;

% Analiza widmowa
M = abs(fft(m));
norM = M/max(M);
f = (0:length(M)-1)*(Fs/length(M));
figure;
plot(f, norM); xlim([0 100]);  % skup się na niskich częstotliwościach
title("Widmo obwiedni"); xlabel("Częstotliwość [Hz]"); ylabel("Amplituda");
grid on;

% Oś czasu
t = (0:length(m)-1) / Fs;

% Odtworzony sygnał x(t)
x_odtw = m .* cos(2*pi*Fc*t);

% Porównanie z oryginałem
figure;
plot(x_sync, 'b'); hold on;
plot(x_odtw, 'r--');
legend('Oryginalny x(t)', 'Odtworzony x(t)');
title('Porównanie: Oryginalny vs. Odtworzony sygnał');
xlabel('Próbki'); ylabel('Amplituda'); grid on;

% Błąd RMS
blad = rms(x_sync - x_odtw);
fprintf('Błąd rekonstrukcji (RMS): %.4f\n', blad);