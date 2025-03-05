% cps_04_dtft.m
clear all; close all;

N = 100;                            % liczba probek sygnalu: 100 --> 1000
fpr = 1000; dt=1/fpr; t=dt*(0:N-1); % fpr to liczba probek sygnalu na sekunde
df = 10;                            % krok w czestotliwosci [Hz] dla DtFT: 10 --> 1
fmax = 2.5*fpr;                     % max zakres czestotliwosci w DtFT: 2.5 --> 0.5
fx1 = 100;                          % czestotliwosc skladowej 1 sygnalu
fx2 = 250;  Ax2 =0.001;             % czestotliwosc i amplituda skladowej 2 sygnalu
                                    % 250 --> 110, 0.001 --> 0.00001
% Sygnal
x1 = cos(2*pi*fx1*t);               % pierwsza skladowa
x2 = Ax2*cos(2*pi*fx2*t);           % druga: 250Hz --> 110Hz, 0.001 --> 0.00001
x = x1; % + x2;                     % wybor: x1, x1+x2, 20*log10(0.00001)=-100 dB
stem(x); title('x(n)'); pause       % rysunek analizowanego sygnalu

% Funkcje okien
w1 = boxcar(N)';                    % okno prostokatne
w2 = hanning(N)';                   % okno Hanninga
w3 = chebwin(N,140)';               % okno Czebyszewa, 80, 100, 120, 140
w = w1;                             % w1 --> w2, w3 (80, 100, 120, 140)
stem(w); title('w(n)'); pause       % rysunek okna
x = x .* w;                         % wybor: x = x, w, x.*w
stem(x); title('xw(n)'); pause      % "zokienkowany" sygnal

% DFT - czerwone kolka
% k=0:N-1; n=0:N-1; F = exp(-j*2*pi*(k'*n)); X = (1/N)*F*x;
f0 = fpr/N; f1 = f0*(0:N-1);  % krok df w DF = f0 = 1/(N*dt)
for k = 1:N
    X1(k) = sum( x .* exp(-j*2*pi/N* (k-1) *(0:N-1) ) )/ N;
  % X1(k) = sum( x .* exp(-j*2*pi/N* (f1(k)/fpr) *(0:N-1) ) )/ N;
end
%X1 = N*X1/sum(w);                  % poprawne skalowanie dla dowolnego okna

% DtFT - niebieska linia
f2 = -fmax : df : fmax;             % zakres czestotliwosci: od-krok-do, df=10-->1 first this freq. range 
for k = 1 : length(f2)
    X2(k) = sum( x .* exp(-j*2*pi* (f2(k)/fpr) *( 0:N-1) ) ) / N;
end
%X2 = N*X2/sum(w);                  % poprawne skalowanie dla dowolnego okna

% Figures
figure; plot(f1,abs(X1),'ro',f2,abs(X2),'b-');
xlabel('f (Hz)'); grid; pause
figure; plot(f1,20*log10(abs(X1)),'ro',f2,20*log10(abs(X2)),'b-');
xlabel('f (Hz)'); grid; pause
