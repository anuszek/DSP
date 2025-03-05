
% cps_01_audio.m
clear all; close all;

% Akwizycja sygnalu audio
fpr = 8000;      % czestotliwosc probkowania (probki na sekunde):
                 % 8000, 11025, 16000, 22050, 32000, 44100, 48000, 96000,
bits = 8;        % liczba bitow na probke: 8, 16, 24, 32
channels = 1;    % liczba kanalow: 1 albo 2 (mono/stereo)

recorder = audiorecorder(fpr, bits, channels);  % tworzenie obiektu
disp('Nacisnij klawisz i nagraj audio'); pause  % pauza przed nagraniem
record(recorder);                               % start nagrania
pause(2);                                       % nagranie 2 sekund
stop(recorder);                                 % stop nagrania
play(recorder);                                 % odsluch
audio = getaudiodata( recorder, 'single' );     % import danych
 
% Weryfikacja - odsluch, rysunek
sound(audio,fpr);           % odtworz nagrany dzwiek
x = audio; clear audio;     % skopiuj audio, wyzeruj audio
Nx = length(x);             % pobierz liczbe probek 
n= 0:Nx-1;                  % indeksy probek
dt = 1/fpr;                 % oblicz okres probkowania sygnalu
t = dt*n;                   % oblicz chwile probkowania
figure; plot(x,'bo-'); xlabel('numer probki n'); title('x(n)'); grid;
figure; plot(t,x,'b-'); xlabel('t (s)'); title('x(t)'); grid; pause

% Zapisz na dysk i odczytaj z dysku
audiowrite('speech.wav',x,fpr,'BitsPerSample',bits); % zapisz nagranie
[y,fpr] = audioread('speech.wav');                   % odczytaj je z dysku
sound(y,fpr);                                        % odtworz nagranie
