import numpy as np
import matplotlib.pyplot as plt

amplitude = 1
sampling_freq = 10_000
carrier_freq = 50
mod_freq = 1
mod_depth = 5

t = np.linspace(0, 1, int(sampling_freq))

modulating_signal = np.sin(2 * np.pi * mod_freq * t)
instantaneous_freq = carrier_freq + mod_depth * modulating_signal
phase = 2 * np.pi * np.cumsum(instantaneous_freq) / sampling_freq
sfm_signal = amplitude * np.sin(phase)

plt.plot(t, sfm_signal)
plt.title('Sinusoidal Frequency Modulated Signal')
plt.xlabel('Time [s]')
plt.ylabel('Amplitude')
plt.show()