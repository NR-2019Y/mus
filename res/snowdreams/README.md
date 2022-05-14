
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
```{mathematica}
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

dat_snowdreams_HH_matlab.dat.m

dat_snowdreams_HL_matlab.dat.m

dat_snowdreams_L_matlab.dat.m



使用示例：
```{MATLAB}
fs = 44100;

 tbhh = readtable('1TO20HH.TXT');
vcthh = tbhh{:,2}';
 tbhl = readtable('1TO20HL.TXT');
vcthl = tbhl{:,2}';
 tbl = readtable('1TO20L.TXT');
vctl = tbl{:,2}';
t32 = 3/4/8;

eval(sprintf('datMus0 = %s', fileread('dat_snowdreams_HH_matlab.dat.m')));
eval(sprintf('datMus1 = %s', fileread('dat_snowdreams_HL_matlab.dat.m')));
eval(sprintf('datMus2 = %s', fileread('dat_snowdreams_L_matlab.dat.m')));

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iadj = 12;
cvcthh = cumsum(vcthh); IDXHH = ((cvcthh > 416) & (cvcthh <= 704)) | ((cvcthh > 1248) & (cvcthh <= 1536)) | ((cvcthh > 1792) & (cvcthh <= 2368)); 
cvcthl = cumsum(vcthl); IDXHL = ((cvcthl > 416) & (cvcthl <= 704)) | ((cvcthl > 1248) & (cvcthl <= 1536)) | ((cvcthl > 1792) & (cvcthl <= 2336)); 
cvctl  = cumsum(vctl);  IDXL  = ((cvctl  > 416) & (cvctl  <= 704)) | ((cvctl  > 1248) & (cvctl  <= 1536)) | ((cvctl  > 1792) & (cvctl  <= 2368)); 
ndatMus0 = arrayfun(@(x, b) { x{1} + b * iadj }, datMus0, IDXHH);
ndatMus1 = arrayfun(@(x, b) { x{1} + b * iadj }, datMus1, IDXHL);
ndatMus2 = arrayfun(@(x, b) { x{1} + b * iadj }, datMus2, IDXL );
% ndatMus2 = datMus2;
sidx1 = cellfun(@length, ndatMus1) > 1;
ndatMus1(sidx1) = cellfun(@(x) {x(end)}, ndatMus1(sidx1));
sidx2 = cellfun(@length, ndatMus2) > 1;
ndatMus2(sidx2) = cellfun(@(x) {x(1)  }, ndatMus2(sidx2));

tadj = 0;
ncmus0 = cellfun(@(x) BasicMusNote(x + tadj), ndatMus0, 'UniformOutput',false); 
ncmus1 = cellfun(@(x) BasicMusNote(x + tadj), ndatMus1, 'UniformOutput',false); 
ncmus2 = cellfun(@(x) BasicMusNote(x + tadj), ndatMus2, 'UniformOutput',false); 
nmus0 = MusJoin(ncmus0, vcthh, 't32', t32); 
nmus1 = MusJoin(ncmus1, vcthl, 't32', t32); 
nmus2 = MusJoin(ncmus2, vctl,  't32', t32); 
nmus = nmus0 + nmus1 + nmus2; nmus = nmus / max(abs(nmus)); 
clear sound; sound(nmus, fs);

```
