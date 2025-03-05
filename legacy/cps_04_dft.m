% cps_04_dft.m

clear all; close all
% Macierze transformacji DFT
N = 100;                    % wymiar macierzy
k = (0:N-1); n=(0:N-1);     % wiersze=funkcje/sygnaly bazowe, kolumny=probki
A = exp(-j*2*pi/N*k'*n);    % macierz analizy DFT, z innym skalowaniem niz poprzednio
S = A';                     % macierz syntezy DFT: sprzezenie + transpozycja
% S = exp(j*2*pi/N*n'*k); A = S';  % z lab. o transformatach ortogonalnych
% diag(S*A), pause          % sprawdzenie ortogonalnosci macierzy, N na przekanej

% Signal
fs=1000; dt=1/fs; t=dt*(0:N-1).';  % skalowanie osi czasu, czas pionowo!
T=N*dt; f0=1/T; fk = f0*(0:N-1);   % fskalowanie osi czestotliwosci
x1 = 1*cos(2*pi*(10.5*f0)*t);        % sygnal 1
x2 = 1*cos(2*pi*(10.5*f0)*t);      % sygnal 2 
x3 = 0.001*cos(2*pi*(20.5*f0)*t);    % sygnal 3
x = x1 + x3;                            % wybor: x1, x2, x3, x1+x2, x2+x3

figure;                            % wynik
subplot(211); plot(real(x),'bo-'); title('real(x(n))'); grid;
subplot(212); plot(imag(x),'bo-'); title('imag(x(n))'); grid;

% Funkcja "okna"
w1 = boxcar(N);                    % okno prostokatne, N - dlugosc
w2 = chebwin(N,100);               % okno Czebyszewa, liczba - poziom listkow bocznych
w = w2; scale = 1/sum(w);          % wybor: w1, w2 albo inne, dodane okno

% Windowing
x = x.*w;                          % "okienkowanie" sygnalu

figure;                            % wynik
subplot(211); plot(real(x),'bo-'); title('real(x(n))'); grid;
subplot(212); plot(imag(x),'bo-'); title('imag(x(n))'); grid;

% DFT of the signal
X1 = A*x;                          % nasz kod DFT
X2 = fft(x);                       % funkcja Matlaba DFT (Fast Fourier Transform)
error1 = max(abs(X1-X2)),          % blad wzgledem Matlaba, powinno byc prawie zero
X = X2;                            % wybor: X1 albo X2

% Interpretacja widma DFT, skalowanie
X = scale*X;                       % skalowanie amplitudy
figure;
subplot(211); plot(fk,real(X),'o-'); title('real(X(f))'); grid;
subplot(212); plot(fk,imag(X),'o-'); title('imag(X(f))'); grid;
figure;
subplot(211); plot(fk,20*log10(abs(X)),'o-'); title('abs(X(f)) [dB]'); grid;
subplot(212); plot(fk,angle(X),'o-'); title('angle(X(f)) [rad]'); grid;

% Modyfikacja widma DFT - przyklad
% X(1+10)=0; X(N-10+1)=0;          % usuniecie sygnalu x1 o czestotliwosci 10*f0

% Odwrotne DFT - synteza sygnalu na podstawie jego widma
y = S*X;                           % synteza sygnalu
error2 = max(abs(x-y)),            % blad odtworzenia sygnalu
figure;                            % wynik
subplot(211); plot(real(y),'bo-'); title('real(y(n))'); grid;
subplot(212); plot(imag(y),'bo-'); title('imag(y(n))'); grid;
