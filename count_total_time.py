import wave
import glob
import contextlib

def count_duration(file_path: str):
    with contextlib.closing(wave.open(file_path,'r')) as f:
        frames = f.getnframes()
        rate = f.getframerate()
        duration = frames / float(rate)
        return duration

all_samples = glob.glob('data/audio/*.wav')
all_durations = [count_duration(each) for each in all_samples]
print('Total duration:', sum(all_durations), 'seconds')