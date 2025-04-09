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