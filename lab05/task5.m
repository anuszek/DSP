clear all; close all; clc;

% Parametry filtra 96 MHz ±1 MHz
fc = 96e6;       % częstotliwość środkowa
B = 2e6;         % szerokość pasma (±1 MHz)
fp = [fc - B/2, fc + B/2]; % pasmo przepustowe [95, 97] MHz
fs1 = [fc - 3e6, fc + 3e6]; % pasmo zaporowe [93, 99] MHz
Rp = 3;          % tętnienia w paśmie przepustowym [dB]
Rs = 40;         % tłumienie w paśmie zaporowym [dB]

% Projektowanie filtra Butterwortha (analogowy -> 's')
[n, Wn] = buttord(2*pi*fp, 2*pi*fs1, Rp, Rs, 's');
[b, a] = butter(n, 2*pi*[fp(1), fp(2)], 'bandpass', 's');

% Charakterystyka częstotliwościowa
f = linspace(80e6, 112e6, 10000); % zakres od 80 MHz do 112 MHz
w = 2*pi*f;
h = freqs(b, a, w);

% Wykres amplitudowy
figure;
subplot(2,1,1);
plot(f/1e6, 20*log10(abs(h)), 'b', 'LineWidth', 1.5);
title('Charakterystyka amplitudowa filtra analogowego 96 MHz ±1 MHz');
xlabel('Częstotliwość [MHz]');
ylabel('Amplituda [dB]');
grid on;
hold on;

% Linie pomocnicze
plot([fp(1)/1e6, fp(1)/1e6], [-60, 5], 'r--', 'LineWidth', 1);
plot([fp(2)/1e6, fp(2)/1e6], [-60, 5], 'r--', 'LineWidth', 1);
plot([fs1(1)/1e6, fs1(1)/1e6], [-60, 5], 'g--', 'LineWidth', 1);
plot([fs1(2)/1e6, fs1(2)/1e6], [-60, 5], 'g--', 'LineWidth', 1);
plot([0, 200], [0, 0], 'k--', 'LineWidth', 0.5); % Linia 0 dB
legend('Charakterystyka', 'Granice pasma przepustowego', 'Granice pasma zaporowego');
ylim([-60, 5]);
xlim([80, 112]);

% Wykres fazowy
subplot(2,1,2);
plot(f/1e6, unwrap(angle(h))*180/pi, 'b', 'LineWidth', 1.5);
title('Charakterystyka fazowa');
xlabel('Częstotliwość [MHz]');
ylabel('Faza [stopnie]');
grid on;
xlim([80, 112]);

%========================================================================================%

% Parametry filtra 96 MHz ±100 kHz
fc = 96e6;       % częstotliwość środkowa
B = 200e3;       % szerokość pasma (±100 kHz)
fp = [fc - B/2, fc + B/2]; % pasmo przepustowe [95.9, 96.1] MHz
fs1 = [fc - 500e3, fc + 500e3]; % pasmo zaporowe [95.5, 96.5] MHz
Rp = 3;          % tętnienia w paśmie przepustowym [dB]
Rs = 40;         % tłumienie w paśmie zaporowym [dB]

% Projektowanie filtra Butterwortha (analogowy -> 's')
[n, Wn] = buttord(2*pi*fp, 2*pi*fs1, Rp, Rs, 's');
[b, a] = butter(n, 2*pi*[fp(1), fp(2)], 'bandpass', 's');

% Charakterystyka częstotliwościowa
f = linspace(95e6, 97e6, 10000); % zakres od 95 MHz do 97 MHz
w = 2*pi*f;
h = freqs(b, a, w);

% Wykres amplitudowy
figure;
subplot(2,1,1);
plot(f/1e6, 20*log10(abs(h)), 'b', 'LineWidth', 1.5);
title('Charakterystyka amplitudowa filtra analogowego 96 MHz ±100 kHz');
xlabel('Częstotliwość [MHz]');
ylabel('Amplituda [dB]');
grid on;
hold on;

% Linie pomocnicze
plot([fp(1)/1e6, fp(1)/1e6], [-60, 5], 'r--', 'LineWidth', 1);
plot([fp(2)/1e6, fp(2)/1e6], [-60, 5], 'r--', 'LineWidth', 1);
plot([fs1(1)/1e6, fs1(1)/1e6], [-60, 5], 'g--', 'LineWidth', 1);
plot([fs1(2)/1e6, fs1(2)/1e6], [-60, 5], 'g--', 'LineWidth', 1);
plot([0, 200], [0, 0], 'k--', 'LineWidth', 0.5); % Linia 0 dB
legend('Charakterystyka', 'Granice pasma przepustowego', 'Granice pasma zaporowego');
ylim([-60, 5]);
xlim([95, 97]);

% Wykres fazowy
subplot(2,1,2);
plot(f/1e6, unwrap(angle(h))*180/pi, 'b', 'LineWidth', 1.5);
title('Charakterystyka fazowa');
xlabel('Częstotliwość [MHz]');
ylabel('Faza [stopnie]');
grid on;
xlim([95, 97]);