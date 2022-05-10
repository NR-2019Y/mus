
#### 1 原简谱（复杂版）

1TO20HH.TXT

1TO20HL.TXT

1TO20L.TXT



#### 2 原简谱（简化版）

h.txt

l.txt


#### 3 整理后的简谱（用于Mathematica演奏）

简化版 outNEW1_NC.wl

（导入 mus1Nc，mus2Nc）

复杂版 outNEW1.wl

（导入 mus0，mus1，mus2）

使用示例：
```
Import["outNEW1.wl"];
Import["outNEW1_NC.wl"];
(* Sound[Join[{"BrightPiano"},mus0, mus1, mus2]] *)

ToneAdjust[None, n_] = None;
ToneAdjust[x_, n_] := x + n;
(* MusToneAdjust[mus_, n_] := Map[Join[SoundNote[ToneAdjust[#[[1]], n]], #[[2 ;;]]] &, mus]; *)

mus1NcCut = mus1Nc[[25;;-32]];
nadjust = -8;
Sound[
  Join[
    (* {"Violin"}, MusToneAdjust[mus1NcCut, nadjust], *)
     Map[ SoundNote[ToneAdjust[#[[1]], nadjust], #[[2]], "Violin"] &, mus1NcCut ], 
     Map[ SoundNote[ToneAdjust[#[[1]], nadjust], #[[2]], "BrightPiano", SoundVolume -> 0.75] &, Join[mus0, mus1, mus2] ]
  ]
]
```

#### 4 整理后的简谱（用于MATLAB演奏，不含音符时长信息）

dat_snowdreams_HH_matlab.txt

dat_snowdreams_HL_matlab.txt

dat_snowdreams_L_matlab.txt


```{m}
fs = 44100;

 tbhh = readtable('1TO20HH.TXT');
vcthh = tbhh{:,2}';
 tbhl = readtable('1TO20HL.TXT');
vcthl = tbhl{:,2}';
 tbl = readtable('1TO20L.TXT');
vctl = tbl{:,2}';
t32 = 3/4/8;

eval(sprintf('datMus0 = %s', fileread('dat_snowdreams_HH_matlab.txt')));
eval(sprintf('datMus1 = %s', fileread('dat_snowdreams_HL_matlab.txt')));
eval(sprintf('datMus2 = %s', fileread('dat_snowdreams_L_matlab.txt')));

%% Karplus-Strong Algorithm
% 升降调 cmus0 = cellfun(@(x) BasicMusNoteKS(x + 12),datMus0,'UniformOutput',false);  
cmus0 = cellfun(@(x) BasicMusNoteKS(x),datMus0,'UniformOutput',false); 
cmus1 = cellfun(@(x) BasicMusNoteKS(x),datMus1,'UniformOutput',false); 
cmus2 = cellfun(@(x) BasicMusNoteKS(x),datMus2,'UniformOutput',false); 
mus0 = MusJoin(cmus0, vcthh, 't32', t32); 
mus1 = MusJoin(cmus1, vcthl, 't32', t32); 
mus2 = MusJoin(cmus2, vctl,  't32', t32); 
mus = mus0 + mus1 + mus2; mus = mus / max(abs(mus));
clear sound; sound(mus, fs);

%% Extended Karplus-Strong Algorithm
cmus0 = cellfun(@(x) BasicMusNoteEKS(x),datMus0,'UniformOutput',false); 
cmus1 = cellfun(@(x) BasicMusNoteEKS(x),datMus1,'UniformOutput',false); 
cmus2 = cellfun(@(x) BasicMusNoteEKS(x),datMus2,'UniformOutput',false); 
mus0 = MusJoin(cmus0, vcthh, 't32', t32); 
mus1 = MusJoin(cmus1, vcthl, 't32', t32); 
mus2 = MusJoin(cmus2, vctl,  't32', t32); 
mus = mus0 + mus1 + mus2; mus = mus / max(abs(mus));
clear sound; sound(mus, fs);

```
