% cps_06_fftapp2_loop.m
clear all; close all;

fpr = 8000;              % czestotliwosc probkowania (Hz)
T  = 3;                  % czas trwania sygnalu w sekundach
N  = round(T*fpr);       % liczba probek, 100 albo 1000
dt=1/fpr; t=dt*(0:N-1);  % os czasu
n = 1:1000;              % indeksy probkek sygnalu dla rysunkow

% Sygnal
x1 = sin(2*pi*200*t) + sin(2*pi*800*t);                                    % 2xSIN 
x2 = sin( 2*pi*( 0*t + 0.5*((1/T)*fpr/4)*t.^2 ) );                         % LFM
fm=0.5; x3 = sin(2*pi*((fpr/4)*t - (fpr/8)/(2*pi*fm)*cos(2*pi*fm*t)));     % SFM
x = x1 + 0.5*randn(1,N);                                                   % wybor
figure; plot(t(n),x(n),'b-'); xlabel('t [s]'); title('x(t)'); grid; pause  % rysunek

% Widmo FFT
Mwind = 256; Mstep=16; Mfft=2*Mwind;  Many = floor((N-Mwind)/Mstep)+1;
t = (Mwind/2+1/2)*dt + Mstep*dt*(0:Many-1);         % czas
f = fpr/Mfft*(0:Mfft-1);                            % czestotliwosc    
w = hamming( Mwind )';                              % wybor okna
X1 = zeros(Mfft,Many); X2 = zeros(1,Mfft);          % inicjalizacja STFT i PSD 
for m = 1 : Many                                    % petla analizy
    bx = x( 1+(m-1)*Mstep : Mwind+(m-1)*Mstep );    % kolejny fragment sygnalu 
    bx = bx .* w;                                   % okienkowanie
    X = fft( bx, Mfft )/sum(w);                     % FFT ze skalowaniem
    X1(1:Mfft,m) = X;                               % <--- ! STFT
    X2 = X2 + abs(X).^2;                            % <--- ! Welch PSD
end                                                 % konie petli
X1 = 20*log10( abs(X1) );                           % przeliczenie na decybele
X2 = (1/Many)*X2/fpr;                               % normalizacja PSD
% spectrogram(x,Mwind,Mwind-Mstep,Mfft,fpr); pause  % STFT Matlab

figure;
imagesc(t,f,X1);      % macierz widma amplitudowego jako obraz
c=colorbar; c.Label.String = 'V (dB)'; ax = gca; ax.YDir = 'normal';
xlabel('t (s)'); ylabel('f (Hz)'); title('STFT |X(t,f)|'); pause
figure;
semilogy(f,X2); grid; title('PSD Welcha'); xlabel('f [Hz]'); ylabel('V^2 / Hz'); pause
