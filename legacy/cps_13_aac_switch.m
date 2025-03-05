% cps_13_aac_switch.m
% Demonstracja przelaczania okien dlugie-krotkie w koderze AAC 
clear all; close all;

Nmany = 60;             % liczba ramek audio
Nl = 2048;              % liczba probek okna dlugiego
Ns = 256;               % liczba probek okna krotkiego
Ml = Nl/2;              % przesuniecie okna dlugiego 50%
Ms = Ns/2;              % przesuniecie okna krotkiego 50%

% Okna, macierze
nl = 0 : Nl-1;                                         % indeksy okna dlugiego
ns = 0 : Ns-1;                                         % indeksy okna krotkiego
wl = sin(pi*(nl+0.5)/Nl);                              % okno dlugie
ws = sin(pi*(ns+0.5)/Ns);                              % okno krotkie
wl2s = [ wl(1:Nl/2) ones(1,Nl/2-Ns/2) ws(Ns/2+1:Ns) ]; % okno dlugie-na-krotkie
ws2l = [ ws(1:Ns/2) ones(1,Nl/2-Ns/2) wl(Nl/2+1:Nl) ]; % okno krotkie-na-dlugie

figure;
subplot(221); stem(nl,wl);                             % okno dlugie
subplot(222); stem(ns,ws);                             % okno krotkie
subplot(223); stem(nl,wl2s);                           % okno dlugie-na-krotkie 
subplot(224); stem(nl,ws2l); pause                     % okno krotkie-na-dlugie
subplot(111);

% Macierze MDCT BEZ OKIEN
[nl,kl] = meshgrid(0:(Nl-1),0:(Nl/2-1));               % macierze indeksow okien dlugich
[ns,ks] = meshgrid(0:(Ns-1),0:(Ns/2-1));               % macierze indeksow okien krotkich
Cl = sqrt(2/Ml)*cos(pi/Ml*(kl+1/2).*(nl+1/2+Ml/2));    % macierz anlizy dlugiej
Dl = Cl';                                              % macierz syntezy dlugiej
Cs = sqrt(2/Ms)*cos(pi/Ms*(ks+1/2).*(ns+1/2+Ms/2));    % macierz analizy krotkiej
Ds = Cs';                                              % macierz syntezy krotkiej

% Sygnal przetwarzany
Nx = Nl+Ml*(Nmany-1);                                  % liczba probek
%x = randn(Nx,1); fs=44100;                            % szum losowy
[ x, fs ] = audioread('Bach44100.wav');                % muzyka z dysku
size(x), pause                                         % wymiary wektora
x = x(1:Nx,1); x=x.';                                  % tylko pierwszy kanal jesli stereo
plot(x); pause                                         % pokaz sygnal
if(0) soundsc(x,fs); end                               % zagraj sygnal

% Przetwarzanie

type = [ 1 1 1 2 3 3 3 4 ];       % sekwencja przelaczania okien
%type = [ 1 1 1 1 1 1 1 1 ];      % 1=dlugie, 2=dlugie-na-krotkie, 3=krotkie, 4=krotkie-na-dlugie
type = repmat( type, 30);         % powtorz 30 razy

n1 = 1;                           % zaczynamy od okna dlugiego
y = zeros(1,Nx);                  % inicjalizacja sygnalu wyjsciowego
for k=1:Nmany % ################# % PETLA GLOWNA - START
    what = type(k);               % pobranie rodzaju okna
    if( what~=3)                  % OKNA DLUGIE
      if(what==1) win=wl;   end   % okno dlugie  
      if(what==2) win=wl2s; end   % okno dlugie-na-krotkie
      if(what==4) win=ws2l; end   % okno krotkie-na-dlugie  
      M = Ml; N=Nl;               % wymiary dlugie 
      C = Cl;                     % macierz analizy dlugiej
      D = Dl;                     % macierz syntezy dlugiej                    
    else                          % OKNO KROTKIE
      win = ws;                   % okno krotkie  
      M = Ms; N=Ns;               % wymiary krotkie
      C = Cs;                     % macierz analizy krotkiej
      D = Ds;                     % macierz syntezy krotkiej 
    end  
        
    n1st = n1; nlast = n1+(N-1);  % indeksy: od, do
    n = n1st : nlast;             % indeksy: wszystkie po kolei
    n1 = n1 + N/2;                % zapisz
    bx = x( n );                  % pobranie probek do bufora
    
  % analiza                       % ANALIZA  
    bx = bx.*win;                 % nalozenie okna (okienkowanie)
    BX = C*bx';                   % analiza MDCT
    
  % przetwarzanie w podpasmach    % PRZETWARZANIE          
  % BX(N/4+1:N/2,1)=zeros(N/4,1); % przykladowe 
  
  % synteza                       % SYNTEZA
    by = D*BX;                    % synteza MDCT  
    y( n ) = y( n ) + win.*by';   % dodanie obliczonego fragmentu z oknem
end % ########################### % PETLA GLOWNA - KONIEC   

n=1:Nx;
plot(n,x,'ro',n,y,'bx'); pause    % porownaj sygnaly: wejscie i wyjscie
soundsc(y,fs);                    % odsluchaj sygnal wyjsciowy

m=Ml+1:Nx-Ml;
max_abs_error = max(abs(y(m)-x(m))), pause % blad odtworzenia sygnalu
