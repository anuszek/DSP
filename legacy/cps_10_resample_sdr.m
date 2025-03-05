
% cps_10_resample_sdr.m
clear all; close all;

FileName = 'SDRSharp_FMRadio_101600
kHz_IQ.wav';  T=3;  demod=1; % sygnal radia FM

inf = audioinfo(FileName), pause                      % co jest wewnatrz zbioru IQ?
fs = inf.SampleRate;                                  % czestotliwosc probkowania
[x,fs] = audioread(FileName,[1,T*fs]);                % wczytaj tylko T sekund 
whos,                                                 % co jest w pamieci?
Nx = length(x),                                       % dlugosc sygnalu

% Odtworzenie sygnalu zespolonego IQ z dwoch kolumn zbioru WAV, jesli konieczne dodaj Q=0
x = x(:,1) - j*x(:,2); % else x = x(1:Nx,1) + j*zeros(Nx,1); end 

bwSERV=200e+3; bwAUDIO=25e+3;                         % czestotliwosci: serwisu FM, probkowania audio
D1 = round(fs/bwSERV); D2 = round(bwSERV/bwAUDIO);    % rzad pod-probkowania
f0 = -0.59e+6; x = x .* exp(-j*2*pi*f0/fs*(0:Nx-1)'); % ktora stacja? przesuniecie czestotliwosci do 0 Hz 
x = resample(x,1,D1);                                 % pod-probkowanie do czestotliwosci serwisu FM
x = real(x(2:end)).*imag(x(1:end-1))-real(x(1:end-1)).*imag(x(2:end)); % demodulacja FM
x = resample(x,1,D2);                                 % pod-probkowanie do czestotliwosci audio
soundsc(x,bwAUDIO);                                   % odsluchanie programu radia FM
