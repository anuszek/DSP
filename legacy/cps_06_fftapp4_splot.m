% cps_06_fftapps4_splot.m
clear all; close all;

  sig = 2;    % 1/2, sygnal: 1=krotki, 2=dlugi
  if(sig==1)  N=5;    M=3;   x = ones(1,N);  h = ones(1,M);  % sygnaly
  else        N=256;  M=32;  x = randn(1,N); h = randn(1,M); % splatane
  end
  n = 1:N+M-1; nn = 1:N; % indeksy probek sygnalow
  figure;
  subplot(211); stem(x); title('x(n)');
  subplot(212); stem(h); title('h(n)'); pause

% Splot z uzyciem funkcji Matlaba
  y1 = conv(x,h);
        figure; stem(y1); title('y1(n)'); pause

% Szybki splot - poczatek wyniku jest niepoprawny!
  hz = [ h zeros(1,N-M) ];                % dolacz N-M zer tylko na koncu sygnalu krotkiego
  y2 = ifft( fft(x) .* fft(hz) );         % szybki splot, pierwszych M-1 probek jest zlych
  error2 = max(abs(y1(M:N)-y2(M:N))), pause
  figure; plot(nn,y1(nn),'ro',nn,y2(nn),'bx'); title('y1(n) & y2(n)');

% Szybki splot - wszystkie probki wyniku sa poprawne!
  hzz = [ h zeros(1,N-M) zeros(1,M-1) ];  % uzupelnij zerami do dlugosci N+M-1
  xz = [ x zeros(1,M-1) ];                % uzupelnij zerami do dlugosci N+M-1
  y3 = ifft( fft(xz) .* fft(hzz) );       % szybki splot, wszystkie probki sa dobre
  error3 = max(abs(y1-y3)), pause
  figure; plot(n,y1,'ro',n,y3,'bx'); title('y1(n) & y3(n)');

% Szybki splot z podzialem na czesci - metoda OVERLAP-ADD
  if( sig > 1 )                            % tylko dla dlugiego sygnalu
  L = M;                                   % dlugosc fragmentu sygnalu
  K = N/L;                                 % liczba fragmentow sygnalu
  hzz = [ h zeros(1,L-M) zeros(1,M-1) ];   % uzupelnienie zerami odp. impulsowej filtra
  Hzz = fft(hzz);                          % FFT odpowiedzi impulsowej filtra
  y4 = zeros(1,M-1);                       % inicjalizacja sygnalu wynikowego
  for k = 1:K                              % PETLA
      m = 1 + (k-1)*L : L + (k-1)*L;       % indeksy fragmentu sygnalu
      xz = [ x(m) zeros(1,M-1) ];          % pobranie fragmentu sygnalu, dolozenie zer
      YY = fft(xz) .* Hzz;                 % # szybki splot - iloczyn widm FFT
      yy = ifft( YY );                     % # odwrotne FFT
      y4(end-(M-2):end) = y4(end-(M-2):end) + yy(1:M-1); % wynik: czesc overlap-add
      y4 = [ y4, yy(M:L+M-1) ];                          % wynik: czesc uzupelnij
  end
  error4 = max(abs(y1-y4)), pause
  figure; plot(n,y1,'ro',n,y4,'bx'); title('y1(n) & y4(n)');
  end

% ... tutaj generujemy sygnaly x oraz h

% Szybka korelacja wzajemna dwoch sygnalow z uzyciem FFT
  R1 = xcorr( x, h );
  R2 = conv( x, conj( h(end:-1:1) ) );
  Kmax=max(M,N); Kmin=min(M,N); R2 = [ zeros(1,Kmax-Kmin) R2 ];
  m = -(Kmax-1) : 1 : (Kmax-1); 
  figure; plot(m,R1,'ro',m,R2,'bx'); title('R1(n) & R2(n)');
  error5 = max( abs( R1-R2 ) ), pause
