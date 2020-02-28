# Vietnamese speech recognition with Wav2Vec and Wav2letter
This repository contains pre-trained models for automatic speech recognition. You can quickly make predictions by using:

```
from stt import Transcriber

transcriber = Transcriber(w2letter = '/path/to/wav2letter', w2vec = 'resources/wav2vec.pt', 
                          am = 'resources/am.bin', tokens = 'resources/tokens.txt', 
                          lexicon = 'resources/lexicon.txt', lm = 'resources/lm.bin',
                          temp_path = './temp',nthread_decoder = 4)

transcriber.transcribe(['data/audio/VIVOSSPK01_R001.wav','data/audio/VIVOSSPK01_R002.wav'])
```

