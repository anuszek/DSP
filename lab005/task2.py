import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import butter, freqs, tf2zpk, impulse, step, tf2ss, tf2zpk, tf2sos, TransferFunction

# Parametry ogólne
orders = [2, 4, 6, 8]
w3dB = 2 * np.pi * 100  # ω_3dB = 2π·100 rad/s
w = np.linspace(10, 2000, 1000)  # zakres pulsacji ω

# Rysowanie charakterystyk amplitudowych i fazowych
plt.figure(figsize=(14, 10))

for i, N in enumerate(orders):
    b, a = butter(N, w3dB, analog=True)
    w_response, h = freqs(b, a, w)
    
    # Amplitudowa - liniowa
    plt.subplot(2, 2, 1)
    plt.plot(w_response, 20 * np.log10(np.abs(h)), label=f'N={N}')
    plt.xlabel('ω [rad/s]')
    plt.ylabel('20log10|H(jω)| [dB]')
    plt.title('Charakterystyka amplitudowa (liniowa)')
    plt.grid(True)
    plt.legend()

    # Amplitudowa - log
    plt.subplot(2, 2, 2)
    plt.semilogx(w_response, 20 * np.log10(np.abs(h)), label=f'N={N}')
    plt.xlabel('ω [rad/s]')
    plt.ylabel('20log10|H(jω)| [dB]')
    plt.title('Charakterystyka amplitudowa (log)')
    plt.grid(True)
    plt.legend()

    # Fazowa
    plt.subplot(2, 2, 3)
    plt.plot(w_response, np.angle(h), label=f'N={N}')
    plt.xlabel('ω [rad/s]')
    plt.ylabel('∠H(jω) [rad]')
    plt.title('Charakterystyka fazowa')
    plt.grid(True)
    plt.legend()

plt.tight_layout()
plt.show()

# Odpowiedź impulsowa i skokowa dla N=4
N = 4
b, a = butter(N, w3dB, analog=True)
system = TransferFunction(b, a)

t_imp, h_imp = impulse(system)
t_step, y_step = step(system)

plt.figure(figsize=(10, 4))
plt.subplot(1, 2, 1)
plt.plot(t_imp, h_imp)
plt.title('Odpowiedź impulsowa (N=4)')
plt.xlabel('t [s]')
plt.grid(True)

plt.subplot(1, 2, 2)
plt.plot(t_step, y_step)
plt.title('Odpowiedź na skok jednostkowy (N=4)')
plt.xlabel('t [s]')
plt.grid(True)
plt.tight_layout()
plt.show()

# Rozmieszczenie biegunów (dla każdego N)
plt.figure(figsize=(10, 10))
theta = np.linspace(0, np.pi, 100)
circle = np.exp(1j * theta) * w3dB  # okrąg dla ω_3dB
plt.plot(circle.real, circle.imag, 'c--', label='|s| = ω₃dB')

for N in orders:
    b, a = butter(N, w3dB, analog=True)
    z, p, _ = tf2zpk(b, a)
    plt.plot(p.real, p.imag, 'x', label=f'N={N} bieguny')

plt.title('Rozmieszczenie biegunów filtrów Butterwortha')
plt.xlabel('Re')
plt.ylabel('Im')
plt.axhline(0, color='gray', lw=1)
plt.axvline(0, color='gray', lw=1)
plt.grid(True)
plt.axis('equal')
plt.legend()
plt.show()
