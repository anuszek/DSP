clear all; close all; clc;

% Wczytanie obrazu
img = imread('car1.jpg');

% Konwersja do skali szarości jeśli potrzeba
if size(img, 3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

% 1. Filtracja dolnoprzepustowa (rozmycie Gaussa)
h_gaussian = fspecial('gaussian', [10 10], 1);
img_blurred = imfilter(img_gray, h_gaussian, 'replicate');

% 2. Binaryzacja (imcontrast do znalezienia progu)
threshold = 0.43; % dostosuj przez imcontrast
img_binary = imbinarize(img_blurred, threshold);

% 3. Filtry krawędziowe
% Sobel
h_sobel = fspecial('sobel');
img_sobel = imfilter(double(img_binary), h_sobel);

% Canny
img_canny = edge(img_binary, 'canny');

% 4. Wydobycie konturów tablicy rejestracyjnej
% Operacje morfologiczne
se = strel('rectangle', [1 1]);
img_morph = imopen(img_canny, se);
img_morph = imclose(img_morph, se);

% Wypełnianie obszarów
img_filled = imfill(img_morph, 'holes');

% Usuwanie małych obiektów
img_clean = bwareaopen(img_filled, 3000);

% Znajdowanie i zaznaczanie konturów tablicy
[B, L] = bwboundaries(img_clean, 'noholes');
img_with_contours = img;


figure;
subplot(3, 3, 1);
imshow(img);
title('Oryginalny obraz');

subplot(3, 3, 2);
imshow(img_gray);
title('Skala szarości');

subplot(3, 3, 3);
imshow(img_blurred);
title('Po filtracji Gaussa');

subplot(3, 3, 4);
imshow(img_binary);
title('Po binaryzacji');

subplot(3, 3, 5);
imshow(img_sobel, []);
title('Filtr Sobel');

subplot(3, 3, 6);
imshow(img_canny);
title('Filtr Canny');

subplot(3, 3, 7);
imshow(img_clean);
title('Po operacjach morfologicznych');

subplot(3, 3, 8);
imshow(img);
title('Wykryte kontury tablicy');
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end
hold off