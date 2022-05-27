数据来源 mp3cutterpro.com

#### 音源建立示例

mid文件：90个音符，分别5s（各音符之间3s的间隔），乐器是Oboe，相应的mathematica代码：

```{mathematica}
Export["notes90_Oboe.mid", Sound[ Apply[Join, Map[{SoundNote[#, 5, "Oboe"], SoundNote[None, 3]} &, Range[-39, 50]]] ]]
```
notes90_Oboe.mid 上传到 mp3cutterpro.com，转成音频文件（这里用flac格式），设置参数：44100Hz，1 channel

得到的notes90_Oboe.flac用MATLAB处理：

```{matlab}

[y, Fs] = audioread('notes90_Oboe.flac'); y = y';
fs = 44100;
LEN = ceil(fs / 8) * 32;
VLEN = 1:LEN;
dbOboe.c4idx = 40;
dbOboe.v = arrayfun(@(x) y((x-1)*8*Fs + VLEN), 1:90, 'UniformOutput', false); 
save('db/dbOboe.mat', 'dbOboe');

```
