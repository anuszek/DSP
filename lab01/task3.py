import numpy as np
from scipy import io
import os


def my_correlate():
    return

mat_data = io.loadmat(os.path.join(os.path.dirname(__file__), 'adsl_x.mat'))
x = mat_data['x'].flatten()

# signal parameters
K = 4  # repetition factor
M = 32  # prefix length
N = 512  # block length

prefix_starts = np.zeros(K)

for k in range(K):
    idx_start = (k + 1) * N
    prefix = x[idx_start-M-1:idx_start-1]

    # cross correlation between prefix and signal
    r = np.correlate(x, prefix, mode='full')

    # find the index of the prefix start in the signal
    idx = np.argmax(r)
    prefix_starts[k] = idx

print(np.abs(prefix_starts - M + 1))

# import matplotlib.pyplot as plt
# for start in prefix_starts:
#     plt.figure(figsize=(12, 6))
#     plt.plot(x)
#     plt.axvline(x=int(start), color='r', linestyle='--')
# plt.title('Signal with Detected Prefixes')
# plt.xlabel('Sample')
# plt.ylabel('Amplitude')
# plt.grid(True)
# plt.show()