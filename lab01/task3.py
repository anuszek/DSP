import numpy as np
from scipy import io
import os


mat_data = io.loadmat(os.path.join(os.path.dirname(__file__), 'adsl_x.mat'))
x = mat_data['x'].flatten()

# signal parameters
K = 4  # repetition factor
M = 32  # prefix length
N = 512  # block length

prefix_starts = np.zeros(K)

for k in range(K):
    idx_start = k * (M + N)
    prefix = x[idx_start:idx_start + M]

    # cross correlation between prefix and signal
    r = np.correlate(x, prefix, mode='full')
    lags = np.arange(-(len(r)//2), len(r)//2 + 1)

    # find the index of the prefix start in the signal
    idx = np.argmax(np.abs(r))
    current_prefix_start = lags[idx]

    prefix_starts[k] = current_prefix_start 

print(np.abs(prefix_starts))

import matplotlib.pyplot as plt
plt.figure(figsize=(12, 6))
plt.plot(x)
for start in prefix_starts:
  plt.axvline(x=int(start), color='r', linestyle='--')
plt.title('Signal with Detected Prefixes')
plt.xlabel('Sample')
plt.ylabel('Amplitude')
plt.grid(True)
plt.show()