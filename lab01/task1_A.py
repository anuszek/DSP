import numpy as np
import matplotlib.pyplot as plt

amplitude = 230
frequency = 50

# sampling rates
f_s_A = [10_000, 500, 200]


def generate_wave(amp, freq, sampling_rate, duration):
  t = np.linspace(0, duration, int(sampling_rate * duration))
  sine = amp * np.sin(2 * np.pi * freq * t)
  return t, sine


waves_0_1s = [generate_wave(amplitude, frequency, f, duration=0.1) for f in f_s_A]
t = [w[0] for w in waves_0_1s]
sines = [w[1] for w in waves_0_1s]

plt.figure()
plt.plot(t[0], sines[0], 'b-', label='10000 Hz')
plt.plot(t[1], sines[1], 'r-o', label='500 Hz')
plt.plot(t[2], sines[2], 'k-x', label='200 Hz')
plt.legend()
plt.grid()
plt.show()

