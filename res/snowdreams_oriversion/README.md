### 简谱来源

主要乐谱来源：https://www.tan8.com/yuepu-48628.html

部分根据 https://www.bilibili.com/video/BV1bW411v7ra 进行修正

AH.TXT 高音部分

AL.TXT 低音部分

ATube.TXT 管乐器演奏的部分，根据AH.TXT得到，去掉了和弦

### MATLAB播放

```{matlab}

% cd 您的res文件夹
% addpath 您的script文件夹

fs = 44100;
t32 = 0.90 / 8;

load('db/dbOboe.mat');
load('db/dbPiano.mat');
load('db/dbBrightPiano.mat');

tb1 = readtable('snowdreams_oriversion/AH.TXT');
tb2 = readtable('snowdreams_oriversion/AL.TXT');
notes1 = cellfun(@MusNoteParse, tb1{:, 1}', 'UniformOutput', false);
notes2 = cellfun(@MusNoteParse, tb2{:, 1}', 'UniformOutput', false);

tbNTube = readtable('snowdreams_oriversion/ATube.TXT');
notesNTube = cellfun(@MusNoteParse, tbNTube{:, 1}', 'UniformOutput', false);

db = dbPiano;
mus1     = NoteJoinFromDb ( notes1,     tb1{:, 2}',     db,     t32, 4); 
mus2     = NoteJoinFromDb ( notes2,     tb2{:, 2}',     db,     t32, 4); 
musTube  = NoteJoinFromDb1( notesNTube, tbNTube{:, 2}', dbOboe, t32, 4-12); 
mus = musTube + 0.6 * (mus1 + mus2); mus = mus / max(abs(mus)); 
audiowrite("snowdreams_oriversion/snowdreams_oriversion_Oboe-12_0.6Piano.flac", mus, fs)

db = dbBrightPiano;
mus1     = NoteJoinFromDb ( notes1,     tb1{:, 2}',     db,     t32, 4); 
mus2     = NoteJoinFromDb ( notes2,     tb2{:, 2}',     db,     t32, 4); 
musTube  = NoteJoinFromDb1( notesNTube, tbNTube{:, 2}', dbOboe, t32, 4-12); 
mus = musTube + 0.6 * (mus1 + mus2); mus = mus / max(abs(mus)); 
audiowrite("snowdreams_oriversion/snowdreams_oriversion_Oboe-12_0.6BrightPiano.flac", mus, fs)

```
