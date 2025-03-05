% cps_06_fftapp3_wigner.m
clear all; close all;

N  = 1000;                                   % liczba probek sygnalu
fpr = 1000;                                  % czestotliwosc probkowania (Hz)
dt=1/fpr; t=dt*(0:N-1);                      % os czasu
x = exp( j*2*pi*(0*t + 0.5*(fpr/2)*t.^2));   % sygnal LFM
spectrogram(x,128,128-16,256,fpr); pause     % STFT sygnalu
xx = x .* conj(x(end:-1:1));                 % jadro Wignera dla sygnalu x(n)
X = fft( xx )/N;                             % FFT
stem( abs( X ) );                            % detekcja tylko jednej czestotliwosci
