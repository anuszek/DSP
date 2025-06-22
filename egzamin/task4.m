% Wczytanie obrazu
img = imread('car2.jpg'); % Można też 'car2.jpg'
figure, imshow(img), title('Oryginalny obraz');

% Konwersja do skali szarości jeśli potrzeba
if size(img, 3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

% 1. Filtracja dolnoprzepustowa (rozmycie Gaussa)
h_gaussian = fspecial('gaussian', [10 10], 1);
img_blurred = imfilter(img_gray, h_gaussian, 'replicate');
figure, imshow(img_blurred), title('Po filtracji Gaussa');

% 2. Binaryzacja - użyj imcontrast do znalezienia progu
% Tutaj zakładamy, że wybrałeś próg np. 0.6 (dostosuj)
threshold = 0.43; % Przykładowa wartość - dostosuj przez imcontrast
img_binary = imbinarize(img_blurred, threshold);
figure, imshow(img_binary), title('Po binaryzacji');

% 3. Filtry krawędziowe
% Sobel
h_sobel = fspecial('sobel');
img_sobel = imfilter(double(img_binary), h_sobel);
figure, imshow(img_sobel, []), title('Filtr Sobela');

% Prewitt
h_prewitt = fspecial('prewitt');
img_prewitt = imfilter(double(img_binary), h_prewitt);
figure, imshow(img_prewitt, []), title('Filtr Prewitta');

% Canny
img_canny = edge(img_binary, 'canny');
figure, imshow(img_canny), title('Filtr Canny');

% 4. Opcjonalne - wydobycie konturów tablicy rejestracyjnej
% Operacje morfologiczne
se = strel('rectangle', [1 1]);
img_morph = imopen(img_canny, se);
img_morph = imclose(img_morph, se);

% Wypełnianie obszarów
img_filled = imfill(img_morph, 'holes');

% Usuwanie małych obiektów
img_clean = bwareaopen(img_filled, 3000); 
figure, imshow(img_clean), title('Po operacjach morfologicznych');

% Znajdowanie i zaznaczanie konturów tablicy
[B, L] = bwboundaries(img_clean, 'noholes');
figure, imshow(img), title('Wykryte kontury tablicy');
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end
hold off
