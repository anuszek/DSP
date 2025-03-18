import numpy as np
import matplotlib.pyplot as plt
import sounddevice as sd
import matplotlib
matplotlib.use('TkAgg')


def text_to_bits(text):
  return ''.join(format(ord(char), '08b') for char in text)

def play_signal(signal, fpr):
  sd.play(signal, fpr)
  sd.wait()

fs = 16_000
duration = 0.1
freq = 500

signal = np.array([])
t_bit = np.arange(0, duration, 1/fs)

carrier_0 = np.sin(2 * np.pi * freq * t_bit)
carrier_1 = -np.sin(2 * np.pi * freq * t_bit)


name = "Maurycy"
bits = text_to_bits(name)
print(f"bits for '{name}': {bits}")

for bit in bits:
  if bit == '0':
    signal = np.append(signal, carrier_0)
  else:
    signal = np.append(signal, carrier_1)

plt.figure()
plt.plot(signal[:5000])
plt.xlabel("samples")
plt.ylabel("amplitude")
plt.show()

# for fpr in [8000, 16000, 24000, 32000, 48000]:
#   print(f"playback for fpr = {fpr} Hz")
#   play_signal(signal, fpr)

# decoding
samples_per_bit = int(fs * duration)
num_bits = len(bits)

decoded = ''
for i in range(num_bits):
  sample = signal[i*samples_per_bit:(i+1)*samples_per_bit]
  if np.sum(sample * carrier_0) > 0:
    decoded += '0'
  else:
    decoded += '1'

print(f"decoded: {decoded}")

decoded_text = ''.join(chr(int(decoded[i:i+8], 2)) for i in range(0, len(decoded), 8))

print(f"decoded text: {decoded_text}")





