clear all; close all; clc;

% Parametry filtra 96 MHz ±1 MHz
fs = 96e6;       % częstotliwość środkowa
B = 2e6;         % szerokość pasma (1 MHz z każdej strony)
fp = [fs-B/2 fs+B/2]; % pasmo przepustowe
fs1 = [fs-3e6 fs+3e6]; % pasmo zaporowe (przyjęto 3 MHz od środka)
Rp = 3;          % zafalowania w paśmie przepustowym [dB]
Rs = 40;         % tłumienie w paśmie zaporowym [dB]

% Projektowanie filtra Butterwortha
[n, Wn] = buttord(fp, fs1, Rp, Rs, 's');
[b, a] = butter(n, Wn, 's');

% Charakterystyka częstotliwościowa
f = linspace(90e6, 102e6, 10000); % zakres częstotliwości
h = freqs(b, a, 2*pi*f);

% Wykres
figure;
subplot(2,1,1);
semilogx(f, 20*log10(abs(h)));
title('Charakterystyka amplitudowa filtra 96 MHz ±1 MHz');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
grid on;
hold on;

% Zaznaczenie punktów charakterystycznych
plot([fp(1) fp(1)], [-100 0], 'r--');
plot([fp(2) fp(2)], [-100 0], 'r--');
plot([fs1(1) fs1(1)], [-100 0], 'g--');
plot([fs1(2) fs1(2)], [-100 0], 'g--');
legend('Charakterystyka', 'Granice pasma przepustowego', 'Granice pasma zaporowego');
ylim([-60 5]);

subplot(2,1,2);
semilogx(f, angle(h)*180/pi);
title('Charakterystyka fazowa');
xlabel('Częstotliwość [Hz]');
ylabel('Faza [stopnie]');
grid on;

%========================================================================================%

% Parametry filtra 96 MHz ±100 kHz
fs = 96e6;       % częstotliwość środkowa
B = 200e3;       % szerokość pasma (100 kHz z każdej strony)
fp = [fs-B/2 fs+B/2]; % pasmo przepustowe
fs1 = [fs-500e3 fs+500e3]; % pasmo zaporowe (przyjęto 500 kHz od środka)
Rp = 3;          % zafalowania w paśmie przepustowym [dB]
Rs = 40;         % tłumienie w paśmie zaporowym [dB]

% Projektowanie filtra Butterwortha
[n, Wn] = buttord(fp, fs1, Rp, Rs, 's');
[b, a] = butter(n, Wn, 's');

% Charakterystyka częstotliwościowa
f = linspace(95e6, 97e6, 10000); % zakres częstotliwości
h = freqs(b, a, 2*pi*f);

% Wykres
figure;
subplot(2,1,1);
semilogx(f, 20*log10(abs(h)));
title('Charakterystyka amplitudowa filtra 96 MHz ±100 kHz');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
grid on;
hold on;

% Zaznaczenie punktów charakterystycznych
plot([fp(1) fp(1)], [-100 0], 'r--');
plot([fp(2) fp(2)], [-100 0], 'r--');
plot([fs1(1) fs1(1)], [-100 0], 'g--');
plot([fs1(2) fs1(2)], [-100 0], 'g--');
legend('Charakterystyka', 'Granice pasma przepustowego', 'Granice pasma zaporowego');
ylim([-60 5]);

subplot(2,1,2);
semilogx(f, angle(h)*180/pi);
title('Charakterystyka fazowa');
xlabel('Częstotliwość [Hz]');
ylabel('Faza [stopnie]');
grid on;