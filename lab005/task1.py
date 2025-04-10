import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

# Zera i bieguny
zeros = [1j*5, -1j*5, 1j*15, -1j*15]
poles = [-0.5 + 1j*9.5, -0.5 - 1j*9.5, 
         -1 + 1j*10, -1 - 1j*10, 
         -0.5 + 1j*10.5, -0.5 - 1j*10.5]

# Konwersja zer i biegunów na współczynniki wielomianów
num = np.poly(zeros)  # numerator
den = np.poly(poles)  # denominator

# Charakterystyka częstotliwościowa
omega = np.linspace(0, 20, 1000)
s = 1j * omega
H = np.polyval(num, s) / np.polyval(den, s)

# Wykres zer i biegunów
plt.figure(figsize=(10, 5))
plt.scatter(np.real(zeros), np.imag(zeros), marker='o', color='b', label='Zera')
plt.scatter(np.real(poles), np.imag(poles), marker='*', color='r', label='Bieguny')
plt.axhline(0, color='k', linestyle='--', linewidth=0.5)
plt.axvline(0, color='k', linestyle='--', linewidth=0.5)
plt.xlabel('Re')
plt.ylabel('Im')
plt.title('Zera i bieguny transmitancji')
plt.grid()
plt.legend()
plt.show()

# Wykres charakterystyki amplitudowo-częstotliwościowej (skala liniowa)
plt.figure(figsize=(10, 5))
plt.plot(omega, np.abs(H))
plt.xlabel('Pulsacja (rad/s)')
plt.ylabel('|H(jω)|')
plt.title('Charakterystyka amplitudowo-częstotliwościowa (skala liniowa)')
plt.grid()
plt.show()

# Wykres charakterystyki amplitudowo-częstotliwościowej (skala decybelowa)
plt.figure(figsize=(10, 5))
plt.plot(omega, 20 * np.log10(np.abs(H)))
plt.xlabel('Pulsacja (rad/s)')
plt.ylabel('20log10|H(jω)| [dB]')
plt.title('Charakterystyka amplitudowo-częstotliwościowa (skala decybelowa)')
plt.grid()
plt.show()


# 1. Typ filtru
#     Filtr jest filtrem pasmowo-przepustowym (band-pass), co widać po:
#     Głębokich minimach (zerach) przy 5 i 15 rad/s (tłumienie tych częstotliwości)
#     Wzmocnieniu w paśmie pomiędzy tymi zerami (około 9-11 rad/s)

# 2. Tłumienie w paśmie zaporowym
#     Minimalne tłumienie (najsłabsze tłumienie poza pasmem przepustowym): ~20 dB
#     Maksymalne tłumienie (przy zerach): Teoretycznie nieskończone (w praktyce ograniczone precyzją numeryczną),
#     bo zera są dokładnie na osi urojonej

# 3. Wzmocnienie w paśmie przepustowym
#    Wzmocnienie w paśmie przepustowym (około 10 rad/s) nie jest równe 1.
#    Obecne wzmocnienie wynosi około 0.25 w skali liniowej (-12 dB w skali logarytmicznej).


# Aby uzyskać wzmocnienie równe 1 w paśmie przepustowym, należy przeskalować transmitancję. 
# Obliczamy współczynnik skalowania dla ω = 10 rad/s (środek pasma przepustowego):

# Obliczenie współczynnika normalizacji
s_at_center = 1j * 10
H_at_center = np.polyval(num, s_at_center) / np.polyval(den, s_at_center)
current_gain = np.abs(H_at_center)
num_normalized = num / current_gain

# Charakterystyka częstotliwościowa po normalizacji
H_normalized = np.polyval(num_normalized, s) / np.polyval(den, s)

# Wykres charakterystyki amplitudowej po normalizacji
plt.figure(figsize=(10, 5))
plt.plot(omega, np.abs(H_normalized))
plt.xlabel('Pulsacja (rad/s)')
plt.ylabel('|H(jω)|')
plt.title('Znormalizowana charakterystyka amplitudowo-częstotliwościowa')
plt.grid()
plt.axhline(1, color='r', linestyle='--')  # Linia wzmocnienia = 1
plt.show()

# Wersja w decybelach
plt.figure(figsize=(10, 5))
plt.plot(omega, 20 * np.log10(np.abs(H_normalized)))
plt.xlabel('Pulsacja (rad/s)')
plt.ylabel('20log10|H(jω)| [dB]')
plt.title('Znormalizowana charakterystyka amplitudowa w dB')
plt.grid()
plt.axhline(0, color='r', linestyle='--')  # 0 dB odpowiada wzmocnieniu 1
plt.show()


# Charakterystyka fazowo-częstotliwościowa

# Obliczenie charakterystyki fazowej
phase = np.angle(H_normalized, deg=True)  # w stopniach

# Unwrapping fazy (usunięcie skoków 2π)
phase_unwrapped = np.unwrap(phase * np.pi/180) * 180/np.pi

# Wykres charakterystyki fazowej
plt.figure(figsize=(12, 6))
plt.plot(omega, phase_unwrapped)
plt.xlabel('Pulsacja (rad/s)')
plt.ylabel('Faza [°]')
plt.title('Charakterystyka fazowo-częstotliwościowa')
plt.grid(True)
plt.axvspan(8, 12, color='green', alpha=0.2, label='Pasmo przepustowe')
plt.legend()
plt.show()
