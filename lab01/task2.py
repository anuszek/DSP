import numpy as np
import matplotlib.pyplot as plt

duration = 0.9
amplitude = 230
frequency = 50  

# original signal
t = np.linspace(0, duration, 1000)
signal = amplitude * np.sin(2 * np.pi * frequency * t)

# sampling
fs_0 = 500
T = 1/fs_0
ts_0 = np.arange(0, duration + T, T)
a = amplitude * np.sin(2 * np.pi * frequency * ts_0)

# high resolution time for reconstruction
fs_t = 10_000
ts = np.arange(0, duration + 1/fs_t, 1/fs_t)

def sinc(x):
    return np.where(x ==0, 1.0, np.sin(x) / x)

xhat = np.zeros(len(ts))
for idx, t in enumerate(ts):
  for n in range(len(a)):
    xhat[idx] += a[n] * sinc((t - n*T) * np.pi / T)

x_original = amplitude * np.sin(2 * np.pi * frequency * ts)
xdif = x_original - xhat

plt.figure(figsize=(10, 6))
plt.plot(ts_0, a, 'b-o', label='Sampled')
plt.plot(ts, xhat, 'r-', label='Reconstructed')
plt.plot(ts, x_original, 'g-.', label='Original')
plt.plot(ts, xdif, 'k-.', label='Sampling errors')
plt.legend()
plt.xlabel('Time [s]')
plt.ylabel('Voltage [V]')
plt.grid()
plt.show()