% csp_13_mowa.m
% Kompresja mowy z uzyciem liniowej predykcji
clear all; close all;

ifigs = 0;             %  0/1 - czy wyswietlac rysunki w petli analizy-syntezy? 

% Parametry
Mlen=240;              % dlugosc jednego, analizowanego fragmentu probek mowy
Mstep=180;             % przesuniecie pomiedzy blokami (w probkach)
Np=10;                 % rzad predykcji liniowej (rzad filtra IIR/AR)
where=181;             % pierwsze polozenie pobudzenia dzwiecznego "1" (reszta to "0")
roffset=20;            % przesuniecie w funkcji autokorelacji podczas szukania jej  maksimum
lpc=[];                % tablica na wspolczynniki [T, gain, a(1)...a(10)]
s=[];                  % cala mowa zsyntezowana
ss=[];                 % aktualny fragment mowy zsyntezowanej

% Wczytaj sygnal mowy, ustaw wartosci parametrow kodera LPC-10
[x,fs]=audioread('speech8000.wav');% wczytaj sygnal mowy 8000 Hz (audio/wav/read)
figure; plot(x); title('x(n)');    % narysuj go
soundsc(x,fs); pause               % odsluchaj go na glosniku (sluchawkach)
N=length(x);                       % dlugosc sygnalu
bs=zeros(1,Np);                    % bufor na fragment zsyntezowanej mowy
Nblocks=floor((N-Mlen)/Mstep+1);   % liczba fragmentow (ramek) sygnalu mowy do analizy

% x = filter([1 -0.9735], 1, x);  % opcjonalna pre-emfaza (podbicie wysokich czestotliwosci)
   
% PETLA GLOWNA
for  nr = 1 : Nblocks
   % pobierz nowy fragment probek mowy
     n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;       % indeksy probek
     bx = x(n);                                      % wstawienie do bufora
   % bx = bx .* hamming(Mlen);                       % opcjonalne okienkowanie
   % ANALIZA - oblicz wartosci parametrow dla modelu syntezy mowy
     bx = bx - mean(bx);                             % usun wartosc srednia
     for k = 0 : Mlen-1
         r(k+1)=sum( bx(1:Mlen-k) .* bx(1+k:Mlen) ); % oblicz autokorelacje
     end                                             % sprobuj: r=xcorr(x,'unbiased')
     if(ifigs==1)
       subplot(411); plot(n,bx); title('ANALIZOWANY fragment mowy x(n)');
       subplot(412); plot(r); title('Jego autokorelacja rxx(k)');
     end
     [rmax,imax] = max( r(roffset : Mlen)  );        % znajdz maksimum funkcji autokorelacji
     imax = imax+(roffset-1);                        % indeks maximum (z przesunieciem)
   % if ( rmax > 0.35*r(1) )  T=imax; else T=0; end  % czy mowa jest okresowa/dzwieczna?
     if ( ( r(1) > 0.2 ) & (rmax > 0.35*r(1)) )  T=imax; else T=0; end  % czy mowa jest okresowa/dzwieczna?
     if (T>80) T=round(T/2); end                     % znaleziono druga podharmoniczna
     T, % pause                                      % pokaz wartosc okresu powtarzania mowy T
     rr(1:Np,1)=(r(2:Np+1))';                        % utworz wektor z autokorelacji 
     for m=1:Np                                      %
         R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];	     % zbuduj macierz z autokorelacji
     end                                             % a=lpc(x,Np), a=levinson(x,Np)
     a=-inv(R)*rr;                                   % znajdz wsp. filtra liniowej predykcji (LP)
     gain=r(1)+r(2:Np+1)*a;                          % znajdz wzmocnienie filtra
     H=freqz(1,[1;a]);                               % oblicz ch-ke czestotliwosciowa filtra
     if(ifigs==1) subplot(413); plot(abs(H)); title('Ch-ka czestotliwosciowa filtra'); end
   % lpc=[lpc; T; gain; a; ];                        % zapisz obliczone wartosci dla syntezatora

   % SYNTEZA - mowy z uzyciem obliczonych parametrow modelu mowienia
   % T = 0; % round(1.75*T); % usun "%" oraz wybierz: T = 80, 50, 30, 0; T = round(1.75*T)
     if (T~=0) where=where-Mstep; end                % pierwsze pobudzenie, pozycja dla "1"
     for n=1:Mstep                                   % START PETLI SYNTEZY
         if( T==0)                                   % pobudzenie szumowe
           % exc=2*(rand(1,1)-0.5); where=271;       % szum losowy rownomierny
             exc=0.25*randn(1,1); where=271;         % szum losowy gaussowski
         else                                        % pobudzenie impulsowe 1/0
            if (n==where) exc=1; where=where+T;      % pobudzenie = 1
            else exc=0; end                          % pobudzenie = 0
         end                                         %
         ss(n) = gain*exc - bs*a;                    % filtracja pobudzenia
         bs = [ss(n) bs(1:Np-1) ];                   % zapisanie zsyntezowanej probki mowy do bufora
     end                                             % KONIEC PETLI SYNTEZY
     s = [s ss];                                     % zapamietaj zsyntezowany fragment mowy
     if(ifigs==1) subplot(414); plot(ss); title('ZSYNTEZOWANY fragment mowy s(n)'); pause, end
end

% Koniec!
% s = filter(1,[1 -0.9735],s); % opcjonalna de-emfaza (obnizenie wysokich czestotliwosci)
figure; plot(s); title('Zsyntezowana mowa'); pause   % zobacz wynik
soundsc(s,fs)                                        % odsluchaj wynik
