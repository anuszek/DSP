% csp_11_fmdemod.m - rozniczkowanie sygnalu z uzyciem filtra cyfrowego FIR
% mowa probkowana 44.1 kHz, modulujaca czestotlliwosc kosinusa 7.5 kHz
clear all; close all;

% Parametry
K = 1;                  % opcjonalne K-krotne nad-probkowanie sygnalu mowy 44.1 kHz
fc = 7500;              % czestotliwosc nosnej/kosinus (Hz)
M = 200; N=2*M+1;       % N = 2M+1 = dlugosc projektowanych filtrow FIR

fmax = 4000;            % zalozona maksymalna czestotliwosc mowy (Hz)
DF = 5000;              % 2*DF = wymagane pasmo sygnalu z modulacja FM (Hz)
kf = (DF/fmax-1)*fmax;  % indeks modulacji z reguly Carsona (poszukaj w Internecie)

% Wczytaj sygnal radia FM, modulujacy nosna
[x,fx] = audioread( 'speech44100.wav', [1,1*44100] );  % probki [od,do]
soundsc(x,fx);  x = x';                   % posluchaj
x = resample(x,K,1); fs = K*fx;           % opcjonalnie nad-probkuj
Nx = length(x); dt=1/fs; t=dt*(0:Nx-1);   % uzywane zmienne
figure;
subplot(211); plot(t,x); grid; xlabel('t (s)'); title('x(t)');
subplot(212); spectrogram(x,256,192,512,fs,'yaxis'); title('STFT(1)'); pause

% Modulacja FM 
y =  cos( 2*pi*( fc*t + kf*cumsum(x)*dt ) ); % sygnal zmodulowany w czestotliwosci (FM)
figure; spectrogram(y,256,192,512,fs,'yaxis'); title('STFT(2)'); pause

% Filtr rozniczkujacy i rozniczkowanie sygnalu 
n=-M:M; hD=cos(pi*n)./n; hD(M+1)=0; w = kaiser(2*M+1,10)'; hD = hD .* w; % projekt filtra
y = filter(hD, 1, y);  y = y(N:end);         % filtracja = rozniczkowanie
figure; spectrogram(y,256,192,512,fs,'yaxis'); title('STFT(3)'); pause

% Podniesienie do potegi
y = y.^2;                                    % potegowanie
figure; spectrogram(y,256,192,512,fs,'yaxis'); title('STFT(4)'); pause

% Filtracja dolno-przepustowa
n=-M:M; hLP=sin(2*pi*4000/fs*n)./(pi*n); hLP(M+1)=2*(4000)/fs; hLP = hLP .* w;  % projekt filtra
y = filter(hLP, 1, y ); y = y(N:end);        % filtracja dolno-przepustowa
figure; spectrogram(y,256,192,512,fs,'yaxis'); title('STFT(5)'); pause

% Pomnozenie przez 2 oraz obliczenie pierwiastka kwadratowego 
y = real( sqrt(2*y) );
figure; spectrogram(y,256,192,512,fs,'yaxis'); title('STFT(6)'); pause
 
% Koncowe skalowanie
y = (y - 2*pi*fc/fs)/(2*pi*kf/fs);
figure; spectrogram(y,256,192,512,fs,'yaxis'); title('STFT(7)'); pause

% Wynik koncowy
t=t(2*N-1:Nx); figure;
subplot(211); plot(t,y); grid; xlabel('t (s)'); title('y(n)');
subplot(212); spectrogram(y,256,192,512,fs,'yaxis'); title('STFT(8)'); pause
x = resample(y,1,K);
soundsc(x,fx); pause