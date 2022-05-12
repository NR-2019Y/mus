### 1. use MATLAB

```{MATLAB}

tbh = readtable('H.TXT'); vcth = tbh{:,2}';
tbl = readtable('L.TXT'); vctl = tbl{:,2}';
t32 = 60/75/8;
fs  = 44100;

eval(sprintf('datMus1 = %s', fileread('dat_HOE_H_matlab.txt')));
eval(sprintf('datMus2 = %s', fileread('dat_HOE_L_matlab.txt')));

tadj = 8;
cmus1 = cellfun(@(x) BasicMusNoteEKS(x + tadj),datMus1,'UniformOutput',false); 
cmus2 = cellfun(@(x) BasicMusNoteEKS(x + tadj),datMus2,'UniformOutput',false); 
mus1 = MusJoin(cmus1, vcth, 't32', t32); 
mus2 = MusJoin(cmus2, vctl, 't32', t32); 
mus = vecadd(mus1, mus2); mus = mus / max(abs(mus));
clear sound; sound(mus, fs);

```


### 2. use mathematica

```{mathematica}
Import["outHOE.wl"];
ToneAdjust[None, n_] = None;
ToneAdjust[x_, n_] := x + n;
nadjust = -8;
Sound[ Map[ SoundNote[ToneAdjust[#[[1]], nadjust], #[[2]], "Atmosphere", SoundVolume -> 1] &, Join[mus1, mus2]] ]

```
