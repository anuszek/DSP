% cps 13_obraz.m
% Podstawy przetwarzania obrazow - wymagany Image Processing Toolbox 
% Znajdz obrazy demo Matlaba: C:\Program Files\MATLAB\Rxxxxab\toolbox\images\imdata
% Dolacz obrazy Lena.BMP oraz Friends.JPG/Friends.PNG z wykladu
clear all; close all;

% Wczytaj obraz, przeksztalc kolory #######################################
% Inicjalizacja - wczytaj oraz (x) oraz palete kolorow (cmap), jesli kolory sa indeksowane
  [x,cmap] = imread('bike.jpg');       % color (gray-scale), RGB MxNx3, cmap=empty
% [x,cmap] = imread('cameraman.tif');  % BW, MxNx1, cmap=brak
% [x,cmap] = imread('corn.tif');       % color, MxNx1, size(cmap)=256x3=equal=[0,1]?
% [x,cmap] = imread('kids.tif');       % color, MxNx1, size(cmap)=256x3=equal=[0,1]?
% [x,cmap] = imread('trees.tif');      % color, MxNx1, size(cmap)=256x3=equal=[0,1]?
% [x,cmap] = imread('peppers.png');    % color, RGB MxNx3, cmap=brak
% [x,cmap] = imread('hands1.jpg');     % color, RGB MxNx3, cmap=brak
% [x,cmap] = imread('office_4.jpg');   % color, RGB MxNx3, cmap=brak
% [x,cmap] = imread('Lena2.bmp');      % BW, MxNx1, size(cmap)=256x3=equal=[0,1]

disp('Na wejsciu:');
pal = size(cmap), [M, N, K] = size(x), % wymiary palety, M-wierszy, N-kolumn, K=skladowych koloru
xmin = min(min(x)), xmax = max(max(x)),             % wartosci pikseli min, max
x_copy = x;                                         % skopiuj obraz
cmap_copy = cmap;                                   % skopiuj palete kolorow 
    figure; imshow(x,cmap), title('Obraz'); pause   % wyswietl obraz uzywajac jego palety

if( ~isempty(cmap) & K==1 ) x=ind2gray(x,cmap); cmap = []; end   % dla indeksow kolorow (np. TIF)
if(  isempty(cmap) & K==3 ) % dla kolorow RGB - brak cmap 
    if(1)  x = rgb2gray(x); % 3 skladowe kolory RGB --> indeks koloru, paleta szara 
    else   x = x(:,:,2);    % wybierz tylko jedna plaszczyzne koloru: 1=R, 2=G, 3=B
    end
end

disp('Na wyjsciu:'); pal=size(cmap), [M, N, K]=size(x), % M-wierszy, N-kolumn, K-skladowych koloru
    figure; imshow(x,cmap), title('Obraz'); pause      % wyswietl obraz uzywajac jego palety
    disp('Prosze, obroc macierz obrazu!');             % wyswietl obraz jako siatke  
    figure; mesh(x); title('Image'); pause             % oraz obroc go recznie

% 2D-DCT OBRAZU ORAZ FILTRACJA WYKORZYSTUJACA 2D DCT #################################
x = double( x );                                % wartosci uint8 na double
xmin = min(min(x)), xmax = max(max(x)), pause   % min/max = ?
[m,n] = meshgrid(1:N,1:M); MN=max(M,N);         % indeksy maski filtra m,n
H(1:M,1:N) = exp(-(m.^2+n.^2)/(0.075*MN)^2);    % wartosci maski filtra LP w dziedzinie 2D-DCT
%H = ones(M,N) - H;                             % wartosci maski filtra HP w dziedzinie 2D-DCT                         
X1 = dct2( x ); % <============================ % 2D-DCT Matlaba - analiza obrazu
X2 = dct( dct( x ).' ).';                       % 2D-DCT jako sekwencja 1D-DCT
err_dct = max(max(abs(X1-X2))),                 % blad
X = X1; Xmin = min(min(X)), Xmax = max(max(X)), pause   % min/max widma 2D-DCT
X = X.*H;  % <================================= % modyfikacja widma 2D-DCT obrazu
y = idct2( X ); % <============================ % 2D-IDCT Matlaba - synteza obrazu    
    figure;
    subplot(221); imshow(x, cmap);          title('Obraz');
    subplot(222); imshow(scaledB(X), cmap); title('2D DCT');
    subplot(223); imshow(scaledB(H), cmap); title('Maska filtra');
    subplot(224); imshow(y, cmap);          title('Obraz po filtracji'); pause
  
% FILTRACJA 2D Z UZYCIEM SPLOTU 2D  #######################################
% filry dolno-przepustowe:                                      hLP1,...,hLP4,
% filtry krawedziowe -|\/ (Sobel, Prewitt, Roberts, Gradient):  hS1,hS2,hP1,hP2,hR1,hR2,hG1,hG2
% filtry podwojnie rozniczkujace (Laplasjany):                  hL1,...,hL6
filterweights                  % dolacz zbior (z wykladu) z wagami roznych filtrow 2D
y = conv2(x, hLP4,'same');     % filtr dolno-przepustowy
    figure;
    subplot(121); imshow(x,cmap); title('PRZED filtracja');
    subplot(122); imshow(y,cmap); title('PO filtracji'); pause
y1 = conv2(y, hS1,'same');     % filtr Sobel1, Prewitt 1 ==, Roberts 1 //
y2 = conv2(y, hS2,'same');     % filtr Sobel2, Prewitt 2 ||, Roberts 2 \\
y12 = sqrt(y1.^2 + y2.^2);     % dodaj dwa obrazy = krawedzie we wszystkich kierunkach
    figure;
    subplot(221); imshow(x,cmap);   title('PRZED filtracja');
    subplot(222); imshow(y1,cmap);  title('PO filtracji == lub //');
    subplot(223); imshow(y12,cmap); title('PO filtracji ==|| lub \\//');
    subplot(224); imshow(y2,cmap);  title('PO filtracji || lub \\'); pause

% BINARYZACJA, PRZETWARZANIE MORFOLOGICZNE ##################################
% z = imbinarize( y12 );                          % funkcja Matlaba #1
% level = graythresh(y12); z = im2bw(y12,level);  % funkcja Matlaba #2
[ixy] = find( y12 > 100 );                        % # nasza binaryzacja
z = zeros(M,N); z(ixy) = 255*ones(size(ixy));     % #
    figure; subplot(131); imshow(z,cmap); title('PO binaryzacji');
z = imerode( z,  [ 1 1 1; 1 0 1; 1 1 1] );        % erozja (zawezenie)
    subplot(132); imshow(z,cmap); title('PO erozji');
z = imdilate( z, [ 1 1 1; 1 0 1; 1 1 1] );        % dylatacja (rozszerzenie)
    subplot(133); imshow(z,cmap); title('PO dylatacji'); pause

% Image Studio - miksowanie obrazow ############################################    
% Ten fragment jest tylko poprawny dla obrazow RGB, np. JPG/PNG, np. "hand1.jpg"
figure; hist(x(:),50); title('Histogram'); pause
THR = 155; % prog poprawny dla obrazu hand1.jpg, ustaw go dla innych obrazow
if( 0 )    % jeden wybrany kolor tla, obecnie zolty R=1, G=1, B=0 
   y(:,:,1) = 255*ones(M,N);  % Red
   y(:,:,2) = 255*ones(M,N);  % Green
   y(:,:,3) =   0*ones(M,N);  % Blue
   y = uint8( y ); 
else       % drugi obraz jest wykorzystywany jako tlo dla fragmentu naszego obrazu
  [y,cmap] = imread('Friends.png'); y = y(end-M+1:end,1:N,:);
end
for m=1:M
    for n=1:N
        if( x(m,n) < THR ) y(m,n,:) =  x_copy(m,n,:); end
    end
end
    figure; imshow(y); title('Wynik miksowania obrazow'); pause

%########################    
function XdB = scaledB(X)
% skalowanie logarytmiczne wartosci pikseli obrazu
XdB = log10(abs(X)+1); maxXdB = max(max(XdB)); minXdB = min(min(XdB));
XdB = (XdB-minXdB)/(maxXdB-minXdB)*255;
end    
