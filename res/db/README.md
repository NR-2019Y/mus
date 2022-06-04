数据来源 mp3cutterpro.com

### 音源建立示例

#### 1 使用 mp3cutterpro.com 上的音源

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

#### 2 自建音源

源代码见 script 目录：genNote4SecDbADSR.m genNote4SecDbEKS.m

示例

```{matlab}

% https://github.com/Nuullll/music-synthesizer
% https://zhuanlan.zhihu.com/p/378287088

kdb = { ...
  [1,0.20,0.15,0.15,0.10,0.10,0.01,0.05,0.01,0.01,0.003,0.003,0.002,0.002]  ... % 钢琴
  [1 0.35 0.23 0.12 0.04 0.08 0.08 0.08 0.12]                               ... % 吉他
  [0.55 0.95 0.65 0.3 0.1]                                                  ... % 吉他
};
adsrdb = { ...
% A D S R
  [0.05,   0.9,     0.0001,  0.05]                                          ... % 钢琴
  [0.0001, 0.0001,  0.8,     0.99]                                          ... % 吉他
  [0.9,    0.05,    0.0001,  0.05]                                          ... % 管乐
  [0.05,   0.05,    0.0001,  0.9 ]                                          ... % 电话按键音
  [0.05,   0.05,    0.05,    0.05]                                          ... % 拨弦音
  [0.05,   0.25,    0.15,    0.15]                                          ... % 木琴
};

dbk1adsr1 = genNote4SecDbADSR( kdb{1}, adsrdb{1} );

```
