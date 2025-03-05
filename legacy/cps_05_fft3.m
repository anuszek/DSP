% cps_05_fft3.m

% Algorytm radix-2 DIT (decimation in time) FFT
clear all; close all;

N=8;
x=0:N-1;
Nbit=log2(N);  % N=8, Nbit=3

% Przestawienie probek (odwrocenie bitow numeru probki)
for n=0:N-1
    nc = n;                      % stary numer probki - skopiowanie
    m = 0;                       % nowy numer - inicjalizacja wartosci
    for k=1:Nbit                 % sprawdzenie wszystkich bitow
        if(rem(n,2)==1)          % sprawdzenie bitu zerowego           
        m = m + 2^(Nbit-k);      % akumulowanie wartosci "m" z nowa waga bitu
           n = n - 1;            % liczba nieparzysta --> parzysta
        end
        n=n/2;                   % przesun bity o jeden bit w prawo 
    end
    y(m+1) = x(nc+1);            % skopiuj probke na nowa pozycje position
end
y, pause                         % pokaz wynik

% Seria obliczen motylkowych
Nlev=Nbit;
for lev=1:Nlev % LEVELS
    bw=2^(lev-1);                % szerokosc motylka
    nbb=2^(lev-1);               % liczba motylkow w bloku
    sbb=2^lev;                   % przesuniecie pomiedzy blokami
    nbl=N/2^lev;                 % liczba blokow
    W=exp(-j*2*pi/2^lev);        % wspolczynnik korekcji
    for bu=1:nbb            % MOTYLKI
        Wb=W^(bu-1);                             % korekcja dla motylka
        for bl=1:nbl        % BLOKI
            up   = 1    + (bu-1) + (bl-1)*sbb;   % numer probki gornej
            down = 1+bw + (bu-1) + (bl-1)*sbb;   % numer probki dolnej
            temp = Wb * y(down);                 % wartosc robocza
            y(down) = y(up) - temp;              % nowa wartosc gornej probki
            y(up)   = y(up) + temp;              % nowa wartosc dolnej probki
        end
    end    
end
ERROR = max( abs( fft(x) - y ) ), pause
