import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from scipy.signal import periodogram

matplotlib.use('TkAgg')

# D 1
fs1 = pow(10, 3)
fb = 50
fm = 1
df = 5
b = df/(fm*2*np.pi)
time = 1
t_size = int(time*fs1)

t = np.linspace(0, time, t_size, endpoint=True)
sin = b*np.sin(2*np.pi*fm*t)
SFM = np.sin(2*np.pi*fb*t - b*np.cos(2*np.pi*fm*t))
sin_dm = np.sin(2*np.pi*fb*t)

plt.plot(t, sin, label="Modulujący")
plt.plot(t, SFM, label="Po modulacji")
#plt.plot(t, sin_dm, label="Przed modulacji")
plt.legend()
plt.grid()
plt.show()

# D 2

fs2 = 25
t_size = int(time*fs2)
t2 = np.linspace(0, time, t_size, endpoint=True)

SFM2 = np.sin(2*np.pi*fb*t2 - b*np.cos(2*np.pi*fm*t2))
error = SFM - np.interp(t, t2, SFM2)

plt.plot(t2, SFM2, label="Mniejsze próbkowanie 25Hz")
plt.plot(t, SFM, label="Próbkowanie 10kHz")
plt.legend()
plt.grid()
plt.show()
plt.plot(t, error, label="Błędy modulacji")
plt.legend()
plt.grid()
plt.show()

# D 3

freq1, power1 = periodogram(SFM, fs1)
freq2, power2 = periodogram(SFM2, fs2)

plt.plot(freq1, power1, label="Widmowa gęstość przed zmianą próbkowania")
plt.xlim(0, 100)
plt.legend()
plt.grid()
plt.show()
plt.plot(freq2, power2, label="Widmowa gęstść mocy po zmianie próbkowania")
plt.legend()
plt.grid()
plt.show()