import numpy as np
import matplotlib.pyplot as plt
import sounddevice as sd
import matplotlib
matplotlib.use('TkAgg')


def text_to_bits(text):
  return ''.join(format(ord(char), '08b') for char in text)


def generate_signal(bits, fpr=16000, fc=500, T=0.1):
  samples_per_bit = int(fpr * T)
  t = np.linspace(0, T, samples_per_bit, endpoint=False)
  signal = np.concatenate([np.sin(2 * np.pi * fc * t) if bit == '0' else -np.sin(2 * np.pi * fc * t) for bit in bits])
  return signal


def play_signal(signal, fpr):
  sd.play(signal, fpr)
  sd.wait()


name = "Janek"
bits = text_to_bits(name)
print(f"bits for '{name}': {bits}")

signal = generate_signal(bits)

plt.figure(figsize=(10, 4))
plt.plot(signal[:5000])
plt.xlabel("samples")
plt.ylabel("amplitude")
plt.show()

for fpr in [8000, 16000, 24000, 32000, 48000]:
  print(f"playback for fpr = {fpr} Hz")
  play_signal(signal, fpr)

# Szybsza transmisja bitów
# Aby przyspieszyć transmisję, można:
#
# Skrócić czas trwania pojedynczego bitu (T).
# Zastosować transmisję wielopoziomową, np.:
# Modulację amplitudy (ASK): różne amplitudy dla różnych kombinacji bitów.
# Modulację fazy (PSK): przesunięcie fazowe dla różnych bitów.
# Modulację częstotliwości (FSK): inne częstotliwości sinusoidy dla różnych bitów.
# Jeśli mamy 2 bity na raz, możemy użyć 4 poziomów amplitudy lub fazy (np. 0°, 90°, 180°, 270°), co podwoiłoby prędkość transmisji. Przy 3 bitach można użyć 8 poziomów itd.
