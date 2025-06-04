clc; clear all; close all

% Wczytanie fragmentu pliku (pierwsze 5 sekund)
[x, Fs] = audioread('DontWorryBeHappy.wav');
x = x(1:min(5*Fs, length(x)), :); % Tylko pierwsze 5 sekund
x = mean(x, 2); % Konwersja do mono

% Odtworzenie oryginalnego dźwięku
soundsc(x, Fs);

% Spektrogram oryginalny
figure(1)
subplot(2,1,1)
plot((0:length(x)-1)/Fs, x);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnał oryginalny w dziedzinie czasu');
grid on;

subplot(2,1,2)
specgram(x, 2048, Fs, 2000);
title('Spektrogram sygnału oryginalnego');
colorbar;

% Funkcja do kodowania podpasmowego (uproszczona)
function [y, bps] = kodowanie_podpasmowe(x, num_bands, bits)
% Długość sygnału
N = length(x);
% Podział na podpasma
y_bands = zeros(N, num_bands);
for i = 1:num_bands
  % Filtr pasmowo-przepustowy (uproszczone podejście)
  % Unikamy częstotliwości 0 dla pierwszego pasma
  band_start = max((i-1)/num_bands, 0.01);
  band_end = min(i/num_bands, 0.99);

  % Projektowanie filtru (częstotliwości znormalizowane 0-1)
  [b, a] = butter(4, [band_start band_end], 'bandpass');
  y_bands(:,i) = filter(b, a, x);

  % Normalizacja do zakresu -1..1
  max_val = max(abs(y_bands(:,i)));
  if max_val > 0
    y_bands(:,i) = y_bands(:,i) / max_val;
  end

  % Kwantyzacja
  if length(bits) == 1
    n_bits = bits;
  else
    n_bits = bits(min(i, length(bits)));
  end
  y_bands(:,i) = floor(y_bands(:,i) * (2^(n_bits-1)-0.5)) / (2^(n_bits-1)-0.5);

  % Przywrócenie oryginalnej skali
  if max_val > 0
    y_bands(:,i) = y_bands(:,i) * max_val;
  end
end

% Sumowanie podpasm
y = sum(y_bands, 2);

% Obliczenie średniej liczby bitów na próbkę
if length(bits) == 1
  bps = bits;
else
  bps = mean(bits);
end
end

% Funkcja do dynamicznego kodera podpasmowego
function [coded_data] = koder_dynamiczny(x, num_bands, frame_size, total_bits)
% Długość sygnału
N = length(x);
num_frames = ceil(N / frame_size);

% Struktura wynikowa
coded_data = struct();
coded_data.num_bands = num_bands;
coded_data.frame_size = frame_size;
coded_data.num_frames = num_frames;
coded_data.total_bits = total_bits;
coded_data.frames = cell(num_frames, 1);

% Minimum bitów na podpasmo (aby uniknąć 0 bitów)
min_bits = 1;
max_bits = 12;

for frame_idx = 1:num_frames
  % Wyznaczenie granic ramki
  start_idx = (frame_idx - 1) * frame_size + 1;
  end_idx = min(frame_idx * frame_size, N);
  x_frame = x(start_idx:end_idx);

  % Dopełnienie ramki zerami jeśli jest krótsza
  if length(x_frame) < frame_size
    x_frame = [x_frame; zeros(frame_size - length(x_frame), 1)];
  end

  % Filtracja na podpasma i obliczenie energii
  band_energy = zeros(num_bands, 1);
  y_bands = zeros(frame_size, num_bands);
  max_vals = zeros(num_bands, 1);

  for i = 1:num_bands
    % Filtr pasmowo-przepustowy
    band_start = max((i-1)/num_bands, 0.01);
    band_end = min(i/num_bands, 0.99);

    [b, a] = butter(4, [band_start band_end], 'bandpass');
    y_bands(:,i) = filter(b, a, x_frame);

    % Obliczenie energii podpasma
    band_energy(i) = sum(y_bands(:,i).^2);

    % Zapisanie maksymalnej wartości dla denormalizacji
    max_vals(i) = max(abs(y_bands(:,i)));
  end

  % Dynamiczny przydział bitów na podstawie energii
  % Normalizacja energii
  total_energy = sum(band_energy);
  if total_energy > 0
    energy_ratio = band_energy / total_energy;
  else
    energy_ratio = ones(num_bands, 1) / num_bands;
  end

  % Przydział bitów proporcjonalny do energii
  bits_allocation = round(energy_ratio * total_bits);

  % Zapewnienie minimum i maksimum bitów
  bits_allocation = max(bits_allocation, min_bits);
  bits_allocation = min(bits_allocation, max_bits);

  % Korekcja sumy bitów do zadanej wartości
  while sum(bits_allocation) ~= total_bits
    if sum(bits_allocation) < total_bits
      % Dodaj bit do podpasma o największej energii
      [~, max_idx] = max(energy_ratio .* (bits_allocation < max_bits));
      if bits_allocation(max_idx) < max_bits
        bits_allocation(max_idx) = bits_allocation(max_idx) + 1;
      end
    else
      % Usuń bit z podpasma o najmniejszej energii
      [~, min_idx] = min(energy_ratio .* (bits_allocation > min_bits));
      if bits_allocation(min_idx) > min_bits
        bits_allocation(min_idx) = bits_allocation(min_idx) - 1;
      end
    end
  end

  % Kwantyzacja każdego podpasma
  quantized_bands = zeros(frame_size, num_bands);

  for i = 1:num_bands
    if max_vals(i) > 0
      % Normalizacja
      normalized_band = y_bands(:,i) / max_vals(i);

      % Kwantyzacja
      n_bits = bits_allocation(i);
      quantized_bands(:,i) = floor(normalized_band * (2^(n_bits-1)-0.5)) / (2^(n_bits-1)-0.5);

      % Denormalizacja
      quantized_bands(:,i) = quantized_bands(:,i) * max_vals(i);
    end
  end

  % Zapisanie danych ramki
  frame_data = struct();
  frame_data.bits_allocation = bits_allocation;
  frame_data.max_vals = max_vals;
  frame_data.quantized_bands = quantized_bands;
  frame_data.actual_length = end_idx - start_idx + 1;

  coded_data.frames{frame_idx} = frame_data;
end
end

% Funkcja do dekodowania
function [y] = dekoder_dynamiczny(coded_data)
% Rekonstrukcja sygnału
total_length = coded_data.num_frames * coded_data.frame_size;
y = zeros(total_length, 1);

for frame_idx = 1:coded_data.num_frames
  frame_data = coded_data.frames{frame_idx};

  % Sumowanie podpasm dla danej ramki
  frame_signal = sum(frame_data.quantized_bands, 2);

  % Wstawienie do wynikowego sygnału
  start_idx = (frame_idx - 1) * coded_data.frame_size + 1;
  end_idx = start_idx + coded_data.frame_size - 1;

  y(start_idx:end_idx) = frame_signal;
end

% Przycięcie do oryginalnej długości jeśli potrzeba
if coded_data.num_frames > 0
  last_frame = coded_data.frames{end};
  actual_total_length = (coded_data.num_frames - 1) * coded_data.frame_size + last_frame.actual_length;
  y = y(1:actual_total_length);
end
end

% Wariant 1: 8 podpasm, 6 bitów na każde podpasmo
[y1, bps1] = kodowanie_podpasmowe(x, 8, 6);
figure(2)
subplot(2,1,1)
plot((0:length(y1)-1)/Fs, y1);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnał po kompresji (8 podpasm, 6 bitów)');
grid on;

subplot(2,1,2)
specgram(y1, 2048, Fs, 2000);
title(sprintf('Spektrogram po kompresji (8 podpasm, 6 bitów)\nŚrednia liczba bitów na próbkę: %1.2f', bps1));
colorbar;

% Wariant 2: 32 podpasma, 6 bitów na każde podpasmo
[y2, bps2] = kodowanie_podpasmowe(x, 32, 6);
figure(3)
subplot(2,1,1)
plot((0:length(y2)-1)/Fs, y2);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnał po kompresji (32 podpasma, 6 bitów)');
grid on;

subplot(2,1,2)
specgram(y2, 2048, Fs, 2000);
title(sprintf('Spektrogram po kompresji (32 podpasma, 6 bitów)\nŚrednia liczba bitów na próbkę: %1.2f', bps2));
colorbar;

% Wariant 3: 32 podpasma, zmienna liczba bitów [8,8,7,6,4]
[y3, bps3] = kodowanie_podpasmowe(x, 32, [8 8 7 6 4]);
figure(4)
subplot(2,1,1)
plot((0:length(y3)-1)/Fs, y3);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnał po kompresji (32 podpasma, zmienna liczba bitów)');
grid on;

subplot(2,1,2)
specgram(y3, 2048, Fs, 2000);
title(sprintf('Spektrogram po kompresji (32 podpasma, zmienna liczba bitów)\nŚrednia liczba bitów na próbkę: %1.2f', bps3));
colorbar;

% Obliczenie stopnia kompresji
original_bps = 16; % Zakładamy 16-bitowy plik WAV
compression1 = (original_bps - bps1) / original_bps * 100;
compression2 = (original_bps - bps2) / original_bps * 100;
compression3 = (original_bps - bps3) / original_bps * 100;

fprintf('Stopień kompresji:\n');
fprintf('1. 8 podpasm, 6 bitów: %.2f%% redukcji\n', compression1);
fprintf('2. 32 podpasma, 6 bitów: %.2f%% redukcji\n', compression2);
fprintf('3. 32 podpasma, zmienna liczba bitów: %.2f%% redukcji\n', compression3);

% Identyfikacja elementów tonalnych i szumowych
figure(5)
subplot(2,1,1)
plot((0:length(x)-1)/Fs, x);
hold on;
% Zaznaczenie fragmentów tonalnych (np. śpiew)
tonal_start = 1.2; tonal_end = 1.8;
plot([tonal_start tonal_start], [-1 1], 'r--');
plot([tonal_end tonal_end], [-1 1], 'r--');
xlabel('Czas [s]');
ylabel('Amplituda');
title('Identyfikacja elementów tonalnych (czerwone linie) i szumowych');
grid on;

subplot(2,1,2)
specgram(x, 2048, Fs, 2000);
hold on;
plot([tonal_start tonal_end], [1000 1000], 'r-', 'LineWidth', 2);
title('Spektrogram z zaznaczonymi elementami tonalnymi');
colorbar;

% DEMONSTRACJA DYNAMICZNEGO KODERA PODPASMOWEGO

% Parametry dla dynamicznego kodera
frame_size = 1024;  % Rozmiar ramki
num_bands = 16;     % Liczba podpasm
total_bits = 96;    % Całkowita liczba bitów do rozdziału

% Kodowanie z dynamicznym przydziałem bitów
fprintf('\nKodowanie z dynamicznym przydziałem bitów...\n');
coded_data = koder_dynamiczny(x, num_bands, frame_size, total_bits);

% Dekodowanie
fprintf('Dekodowanie sygnału...\n');
y_dynamic = dekoder_dynamiczny(coded_data);

% Wyświetlenie wyników
figure(6)
subplot(3,1,1)
plot((0:length(x)-1)/Fs, x);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnał oryginalny');
grid on;

subplot(3,1,2)
plot((0:length(y_dynamic)-1)/Fs, y_dynamic);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnał po dynamicznym kodowaniu podpasmowym');
grid on;

subplot(3,1,3)
error_signal = y_dynamic - x(1:length(y_dynamic));
plot((0:length(error_signal)-1)/Fs, error_signal);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Błąd rekonstrukcji');
grid on;

% Spektrogramy porównawcze
figure(7)
subplot(2,1,1)
specgram(x, 2048, Fs, 2000);
title('Spektrogram sygnału oryginalnego');
colorbar;

subplot(2,1,2)
specgram(y_dynamic, 2048, Fs, 2000);
title('Spektrogram po dynamicznym kodowaniu');
colorbar;

% Analiza przydziału bitów dla pierwszych kilku ramek
figure(8)
num_frames_to_show = min(5, coded_data.num_frames);
for i = 1:num_frames_to_show
  subplot(num_frames_to_show, 1, i)
  bar(coded_data.frames{i}.bits_allocation);
  title(sprintf('Przydział bitów - Ramka %d', i));
  xlabel('Numer podpasma');
  ylabel('Liczba bitów');
  ylim([0, 12]);
  grid on;
end

% Obliczenie średniej liczby bitów na próbkę
total_allocated_bits = 0;
total_samples = 0;
for i = 1:coded_data.num_frames
  frame_bits = sum(coded_data.frames{i}.bits_allocation);
  frame_samples = coded_data.frames{i}.actual_length;
  total_allocated_bits = total_allocated_bits + frame_bits;
  total_samples = total_samples + frame_samples;
end
avg_bps_dynamic = total_allocated_bits / total_samples;

% Obliczenie SNR
mse = mean((y_dynamic - x(1:length(y_dynamic))).^2);
signal_power = mean(x.^2);
snr_db = 10 * log10(signal_power / mse);

% Wyświetlenie statystyk
fprintf('\n=== STATYSTYKI DYNAMICZNEGO KODERA ===\n');
fprintf('Liczba ramek: %d\n', coded_data.num_frames);
fprintf('Rozmiar ramki: %d próbek\n', frame_size);
fprintf('Liczba podpasm: %d\n', num_bands);
fprintf('Całkowita liczba bitów na ramkę: %d\n', total_bits);
fprintf('Średnia liczba bitów na próbkę: %.2f\n', avg_bps_dynamic);
fprintf('SNR: %.2f dB\n', snr_db);

% Porównanie z oryginalnym koderem
original_bps = 16;
compression_dynamic = (original_bps - avg_bps_dynamic) / original_bps * 100;
fprintf('Stopień kompresji dynamicznej: %.2f%% redukcji\n', compression_dynamic);

% Wyświetlenie przykładu przydziału bitów
fprintf('\n=== PRZYKŁAD PRZYDZIAŁU BITÓW (pierwsza ramka) ===\n');
first_frame = coded_data.frames{1};
for i = 1:num_bands
  fprintf('Podpasmo %2d: %d bitów\n', i, first_frame.bits_allocation(i));
end

% Odtworzenie zdekodowanego sygnału
fprintf('\nOdtwarzanie zdekodowanego sygnału...\n');
soundsc(y_dynamic, Fs);