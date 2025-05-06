clear all; close all; clc;

%% Parametry sygnału
fs = 400e3;            % Częstotliwość próbkowania sygnału radiowego [Hz]
fc1 = 100e3;           % Częstotliwość nośna pierwszej stacji [Hz]
fc2 = 110e3;           % Częstotliwość nośna drugiej stacji [Hz]
dA = 0.25;              % Głębokość modulacji

%% Wczytanie sygnałów mowy
[x1, fsx] = audioread('mowa8000.wav');
x2 = flipud(x1);        % Sygnał od tyłu

% Normalizacja sygnałów
x1 = x1 / max(abs(x1)) * dA;
x2 = x2 / max(abs(x2)) * dA;

%% Nadpróbkowanie sygnałów modulujących
upsample_factor = fs / fsx;
x1_up = interp(x1, upsample_factor);
x2_up = interp(x2, upsample_factor);

% Dopasowanie długości
N = min(length(x1_up), length(x2_up));
x1_up = x1_up(1:N);
x2_up = x2_up(1:N);
t = (0:N-1)'/fs;

%% Implementacja własnego filtra Hilberta
M = 100;                % Rząd filtra
n = -M:M;
h = (1 - cos(pi * n)) ./ (pi * n);   % Filtr Hilberta z oknem
h(M+1) = 0;                          % Wartość w n=0

% Filtracja Hilberta
x1h = conv(x1_up, h, 'same');
x2h = conv(x2_up, h, 'same');

%% Generacja sygnałów zmodulowanych

% 1. DSB-C (Double Side Band with Carrier)
y_DSB_C = (1 + x1_up) .* cos(2*pi*fc1*t) + (1 + x2_up) .* cos(2*pi*fc2*t);

% 2. DSB-SC (Double Side Band with Suppressed Carrier)
y_DSB_SC = x1_up .* cos(2*pi*fc1*t) + x2_up .* cos(2*pi*fc2*t);

% 3. SSB-SC (Single Side Band with Suppressed Carrier)
% Dla pierwszej stacji używamy wersji z górną wstęgą boczną (USB, znak "-")
% Dla drugiej stacji używamy wersji z dolną wstęgą boczną (LSB, znak "+")
y_SSB_SC = 0.5 * x1_up .* cos(2*pi*fc1*t) - 0.5 * x1h .* sin(2*pi*fc1*t) ...
         + 0.5 * x2_up .* cos(2*pi*fc2*t) + 0.5 * x2h .* sin(2*pi*fc2*t);

%% Wykresy w dziedzinie czasu i częstotliwości
figure;

% DSB-C
subplot(3,2,1);
plot(t(1:1000), y_DSB_C(1:1000));
title('DSB-C w dziedzinie czasu');
xlabel('Czas [s]');
ylabel('Amplituda');

subplot(3,2,2);
plot_spectrum(y_DSB_C, fs);
title('Widmo DSB-C');
xlim([0 fs/2]);

% DSB-SC
subplot(3,2,3);
plot(t(1:1000), y_DSB_SC(1:1000));
title('DSB-SC w dziedzinie czasu');
xlabel('Czas [s]');
ylabel('Amplituda');

subplot(3,2,4);
plot_spectrum(y_DSB_SC, fs);
title('Widmo DSB-SC');
xlim([0 fs/2]);

% SSB-SC
subplot(3,2,5);
plot(t(1:1000), y_SSB_SC(1:1000));
title('SSB-SC w dziedzinie czasu');
xlabel('Czas [s]');
ylabel('Amplituda');

subplot(3,2,6);
plot_spectrum(y_SSB_SC, fs);
title('Widmo SSB-SC');
xlim([0 fs/2]);

%% Funkcja do wyświetlania widma
function plot_spectrum(signal, fs)
    N = length(signal);
    f = (0:N-1)*fs/N;
    spectrum = abs(fft(signal))/N;
    plot(f(1:N/2), spectrum(1:N/2));
    xlabel('Częstotliwość [Hz]');
    ylabel('Amplituda');
    grid on;
end