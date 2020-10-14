import time
import glob
import os
from stt import Transcriber

transcriber = Transcriber(w2letter = '/code/wav2letter', w2vec = 'resources/wav2vec.pt', 
                          am = 'resources/am.bin', tokens = 'resources/tokens.txt', 
                          lexicon = 'resources/lexicon.txt', lm = 'resources/lm.bin',
                          temp_path = './temp',nthread_decoder = 8)
all_samples = glob.glob('data/audio/*.wav')
start_time = time.time()
res = transcriber.transcribe(all_samples)
for index, each in enumerate(all_samples):
    print(os.path.basename(all_samples[index]), ':', res[index])
print('Total time:', time.time()-start_time, 'seconds')