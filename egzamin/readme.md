# Zadanie 1
### Problem 2.4

Skrypt demonstruje tworzenie, wizualizację i odtwarzanie połączonego sygnału modulowanego amplitudowo (AM) i modulowanego częstotliwościowo (FM).

Głównym celem tego programu jest zademonstrowanie i nauczenie koncepcji modulacji AM-FM. Odbywa się to w dwóch odrębnych etapach:

1. **Wizualizacja niskiej częstotliwości**: Najpierw tworzy bardzo powolną wersję sygnału. Ta wersja nie jest przeznaczona do słuchania, ale do wykreślenia, aby można było wyraźnie zobaczyć, jak amplituda sygnału (część „AM”) i jego częstotliwość (część „FM”) zmieniają się w czasie.

2. **Generowanie dźwięku o wysokiej częstotliwości**: Następnie tworzy znacznie szybszą, słyszalną wersję tego samego typu sygnału. Pozwala to użytkownikowi usłyszeć, jak brzmi ten rodzaj złożonej modulacji.

Podstawa generacji sygnału
```
AM = 1 + k_A * sin(2*pi*f_A*t); % obwiednia AM
FM = sin(2*pi*f_0*t + k_F * sin(2*pi*f_F*t)); % sygnal FM
```

 - **obwiednia AM** - sinusoida, która oscyluje między 1-0,25 a 1+0,25. Pozwoli to kontrolować „głośność” sygnału końcowego.

 - **sygnał FM** - fala sinusoidalna, której częstotliwość stale się zmienia. Częstotliwość podstawowa to f_0, modulowana przez falę sinusa

Druga sekcja redefiniuje parametry w celu utworzenia sygnału w ludzkim zakresie słyszalności. 

 - f_0 - częstotliwość nośnej, ustawiona na 400 Hz (słyszalny dźwięk)

 - f_A, k_A - modulacja amplitudy, efekt tremolo - k_A kontroluje, jak bardzo amplituda odbiega od linii bazowej równej 1. Większe k_A oznacza, że różnica między najgłośniejszymi i najcichszymi punktami będzie znacznie większa. f_A to po prostu częstotliwość "chybotania".

 - f_F, k_F - modulacja częstotliwości, efekt wibrato - k_F kontroluje, jak daleko wysokość dźwięku odchyla się od częstotliwości środkowej (f_0). Większa wartość k_F spowoduje szerszą, bardziej dramatyczną zmianę wysokości dźwięku, podobnie jak w przypadku wokalisty z bardzo silnym vibrato. f_F kontroluje szybkość chybotania wysokości dźwięku. Ludzkie vibrato zazwyczaj mieści się w zakresie 4-7 Hz.

| Efekt  | To Make it Deeper / Wider (More Intense) | To Make it Faster                      | To Make it Slower                      |
|---------|------------------------------------------|----------------------------------------|----------------------------------------|
| Tremolo | Increase k_A (e.g., to 0.7)              | Increase f_A (e.g., to 100) for a flutter | Decrease f_A (e.g., to 8) for a pulse  |
| Vibrato | Increase k_F (e.g., to 30)               | Increase f_F (e.g., to 300) for a clang   | Decrease f_F (e.g., to 6) for a wobble |

Część FM sygnału używa nowego wzoru:
```
FM = sin(2*pi*f_0*t + k_F * cumsum(mF)*dt);
```
Jest to bardziej poprawny technicznie sposób wykonywania modulacji częstotliwości. `cumsum(mF)*dt` numerycznie całkuje sygnał modulujący (mF), co jest właściwą matematyczną definicją FM. 
W pierwszej części użyto prostszego wzoru (który jest technicznie modulacją fazy), ponieważ jest łatwiejszy do napisania i wystarczający do wizualizacji.

<br><br>

# Zadanie 2
### lab 3, zadanie 4 - Analiza częstotliwościowa sygnału ADSL

Głównym celem tego programu jest analiza sygnału cyfrowego w celu określenia, jak jego zawartość częstotliwościowa zmienia się w czasie. Sygnał jest podzielony na dyskretne bloki danych zwane „ramkami”. Program przetwarza każdą klatkę indywidualnie, aby znaleźć w niej dominującą częstotliwość (lub częstotliwości).

Jest to sposób, w jaki odbiornik może zacząć dekodować sygnał wykorzystujący częstotliwości do kodowania informacji, technikę znaną jako Frequency-Shift Keying (FSK) lub Orthogonal Frequency-Division Multiplexing (OFDM), która jest podstawą nowoczesnych technologii, takich jak Wi-Fi i 4G/5G.

*Krótko mówiąc, program działa jak uproszczony odbiornik radiowy, analizując krótkie fragmenty sygnału, aby sprawdzić, „która nuta jest odtwarzana” w danym momencie.*

**Wyodrębnienie jednej ramki danych z sygnału:**
  ```
  start = i * (M + N) + M 
  ramka = x[start:start + N]  
  ```

**FFT (Fast Fourier Transform)**
```
X = np.fft.fft(ramka)
freq = np.fft.fftfreq(N, d=1/fs)  # Skala częstotliwości
```
> Przekształcenie sygnału ramki z dziedziny czasu (amplituda w funkcji czasu) w dziedzinę częstotliwości (amplituda w funkcji częstotliwości).

**Wykrywanie harmoniczych**
```
threshold = 0.9 * np.max(np.abs(X))
harmonic = freq[np.abs(X) > threshold]
```
> Identyfikuje i wypisuje najbardziej dominującą częstotliwość w ramce. Znajduje amplitudę najsilniejszego piku w widmie i ustawia próg na 90% tej wartości. Jest to prosty, ale skuteczny sposób na wyizolowanie najbardziej znaczących składowych częstotliwości. 

<br><br>

# Zadanie 3
### lab 6, zadanie 3 - odbiornik SDR dla pojedynczej stacji FM

Program działa jak cyfrowe radio FM. Jego celem jest:

- **Odczytać nieprzetworzony sygnał radiowy**, który został przechwycony przez urządzenie SDR. Ten nieprzetworzony sygnał zawiera wiele stacji radiowych w szerokim paśmie częstotliwości.
- **Dostroić się** do jednej konkretnej stacji FM znajdującej się na częstotliwości 0,5 MHz (500 kHz) w tym szerokim sygnale.
- **Odizolować** sygnał tej stacji, odrzucając wszystkie inne sąsiednie stacje.
- **Zdemodulować** sygnał FM w celu wyodrębnienia oryginalnych informacji audio (np. muzyki lub głosu).


#### 1. Dostrajanie (przesunięcie częstotliwości)
```
n = np.arange(N)
wideband_signal_shifted = wideband_signal * np.exp(-1j * 2 * np.pi * fc / fs * n)
```
> Pomnożenie całego sygnału szerokopasmowego przez złożoną sinusoidę -> przesuwa całe spektrum częstotliwości, przesuwając stację docelową zlokalizowaną przy fc = 0,5 MHz w dół do 0 Hz (baseband). Dzięki temu kolejny krok - filtrowanie - jest znacznie łatwiejszy.

#### 2. Filtrowanie kanału
> Teraz, gdy nasza pożądana stacja jest wyśrodkowana na 0 Hz, musimy pozbyć się wszystkich innych stacji. Odbywa się to za pomocą filtra dolnoprzepustowego. Filtr został zaprojektowany tak, aby przepuszczać częstotliwości od -40 kHz do +40 kHz (całkowita szerokość pasma bwSERV = 80 kHz), jednocześnie blokując wszystko inne. To izoluje naszą pojedynczą stację.

#### 3. Dekymacja (Downsampling)
```
x = wideband_signal_filtered[::int(fs / bwSERV)]
```
> Sygnał ma teraz pasmo ograniczone do 80 kHz, ale nadal jest próbkowany z bardzo wysoką częstotliwością (3,2 MHz). Jest to marnotrawstwo mocy  obliczeniowej. Downsampling zmniejsza częstotliwość próbkowania do łatwiejszego do opanowania poziomu. W tym przypadku częstotliwość próbkowania jest zmniejszana z 3,2 MHz do 80 kHz. Znacznie przyspiesza to kolejne etapy przetwarzania.

#### 4. Demodulacja FM
```
dx = x[1:] * np.conj(x[:-1])
y = np.arctan2(np.imag(dx), np.real(dx))
```
> Istota odbiornika FM - wyodrębnia sygnał audio, który został zakodowany w zmianach częstotliwości nośnej. Ta specyficzna metoda oblicza różnicę faz między kolejnymi próbkami. Ponieważ częstotliwość jest szybkością zmiany fazy, ta różnica faz jest wprost proporcjonalna do oryginalnego sygnału audio. `arctan2` jest funkcją, która poprawnie oblicza ten kąt fazowy.

#### 5. Filtr Antyaliasingowy i ponowny Downsampling
> Zdemodulowany sygnał audio `y` ma częstotliwość próbkowania 80 kHz, ale ludzki słuch i typowy dźwięk FM mają tylko około 15-16 kHz. Aby efektywnie zapisać ostateczny plik, skrypt ponownie decymuje sygnał z 80 kHz do 16 kHz (`bwAUDIO`). <br><br>
> Co najważniejsze, przed decymacją należy zastosować antyaliasingowy filtr dolnoprzepustowy, aby usunąć wszelkie częstotliwości powyżej połowy nowej częstotliwości próbkowania (tj. powyżej 8 kHz). To właśnie powinien robić filtr `y_filtered`.

#### 6. Normalizacja
> Usuwa wszelkie przesunięcia DC (stałe przesunięcie pionowe) z dźwięku, a następnie normalizuje głośność tak, aby najgłośniejszy szczyt znajdował się tuż poniżej maksymalnej możliwej wartości. Zapobiega to przycinaniu i zapewnia dobrą głośność odtwarzania.


*Przyczyny szumów na wyjściu o niskiej głośności są kombinacją czynników związanych z rzeczywistymi standardami nadawania i ograniczeniami prostego demodulatora, ale najważniejsze - domyślny sygnał powinien zostać poddany pre-emfazie, a w odbiorniku zastosowany filtr de-emfazy (nie udało mi się napisać).*

<br><br>

# Zadanie 4
### lab 12, zadanie 3 - wyznaczanie konturów obiektów

Głównym celem tego programu jest automatyczne lokalizowanie i izolowanie tablicy rejestracyjnej samochodu na zdjęciu. Nie odczytuje znaków na tablicy, ale wykonuje kluczowy pierwszy krok polegający na znalezieniu prostokątnego obszaru, w którym znajduje się tablica.

Osiąga to za pomocą standardowego potoku przetwarzania obrazu, który systematycznie odfiltrowuje nieistotne informacje (takie jak kolor samochodu, tekstura drogi i inne drobne szczegóły), aż pozostaną tylko najbardziej widoczne prostokątne kształty - z których jednym jest, miejmy nadzieję, tablica rejestracyjna.

Program zaczyna od złożonego kolorowego obrazu i na każdym kroku stosuje filtr, aby go uprościć i odrzucić szum, zbliżając się coraz bardziej do celu.

1. **Pre-processing**: Oczyszczenie obrazu i zmniejszenie jego złożoności.
2. **Segmentacja**: Oddzielenie potencjalnych obiektów zainteresowania od tła.
3. **Ekstrakcja cech**: Znalezienie najważniejszych cech tablicy rejestracyjnej (jej krawędzi).
4. **Filtrowanie morfologiczne**: Oczyszczanie cech i łączenie ich w jednolite kształty.
5. **Wykrywanie obiektów**: Identyfikacja kandydujących kształtów na podstawie ich właściwości (takich jak rozmiar) i wyróżnienie wyniku końcowego.

**Konwersja na skalę szarości**
> Informacje o kolorze zwykle nie są potrzebne do znalezienia tablicy rejestracyjnej. Kształt tablicy i kontrast między jej znakami a tłem są definiowane przez intensywność (jasność), a nie kolor. Praca w skali szarości znacznie upraszcza problem i przyspiesza wszystkie późniejsze obliczenia.

**Rozmycie gaussowskie (filtrowanie dolnoprzepustowe)**
```
h_gaussian = fspecial('gaussian', [10 10], 1);
img_blurred = imfilter(img_gray, h_gaussian, 'replicate');
```
> Jest to krytyczny etap redukcji szumów. Obraz zawiera wiele „szumów” o wysokiej częstotliwości (np. tekstura lakieru samochodu, odbicia, zabrudzenia). Rozmycie wygładza te drobne szczegóły, dzięki czemu większe, bardziej znaczące cechy - takie jak mocne, proste krawędzie tablicy rejestracyjnej - stają się wyraźniejsze w kolejnych krokach.

**Binaryzacja**
> Konwertuje wygładzony obraz w skali szarości na czysty obraz czarno-biały (binarny). Każdy piksel jaśniejszy niż próg staje się biały, a każdy ciemniejszy staje się czarny. \
Jest to znaczne uproszczenie. Segmentuje obraz na potencjalny „pierwszy plan” (obiekty zainteresowania) i „tło”. Dobrze dobrany próg idealnie sprawi, że tablica rejestracyjna będzie wyraźnym białym obszarem na czarnym tle (lub odwrotnie), oddzielając ją od nadwozia samochodu.

**Wykrywanie krawędzi**
> Najbardziej charakterystyczną cechą tablicy rejestracyjnej jest jej prostokątny kształt, który składa się z silnych poziomych i pionowych krawędzi. Algorytmy wykrywania krawędzi zostały zaprojektowane w celu znalezienia tych obszarów ostrych zmian intensywności.
*Canny jest ogólnie lepszy od Sobela w tym zadaniu, ponieważ tworzy cienkie krawędzie o szerokości jednego piksela, które łatwiej jest później połączyć w czysty kontur.*

**Operacje morfologiczne (czyszczenie i kształtowanie)**
 > - `imopen` - usuwa małe, odizolowane piksele, czyści artefakty, które nie są częścią większej krawędzi.
 > - `imclose` - wypełnia małe luki na krawędziach. Ma to kluczowe znaczenie dla połączenia przerywanych linii obramowania tablicy rejestracyjnej w jedną, ciągłą, zamkniętą pętlę.
 > - `bwareaopen`- usuwa on wszystkie białe plamy o powierzchni mniejszej niż 3000 pikseli. Zakłada się, że tablica rejestracyjna jest dużym obiektem, podczas gdy inne losowe krawędzie (z kratki samochodu, świateł itp.) będą tworzyć mniejsze plamy. Ten krok pomaga wyizolować tylko najbardziej prawdopodobne regiony kandydujące.

