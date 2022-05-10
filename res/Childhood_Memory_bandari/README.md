#### 1. Mathematica 使用示例

```
Import["mmadat0.wl"];
Import["mmadat1.wl"];
Import["mmadat2.wl"];
(* import : mus0, mus1, mus2 *)

ToneAdjust[None, n_] = None;
ToneAdjust[x_, n_] := x + n;
MusToneAdjust[mus_, n_] := Map[Join[SoundNote[ToneAdjust[#[[1]], n]], #[[2 ;;]]] &, mus];

nadjust = 2;
Sound[Join[
  {"SopranoSax"},     MusToneAdjust[Join[mus0, mus1],       nadjust], 
  {"BrightPiano"},    MusToneAdjust[Join[mus0, mus1, mus2], nadjust]
]]
(* 可导出mid *)
```

#### 2. MATLAB 使用示例

```
fs = 44100;

eval(sprintf('datMus1 = %s', fileread('dat_Childhood_Memory_bandari_E_matlab.txt')));
eval(sprintf('datMus2 = %s', fileread('dat_Childhood_Memory_bandari_H_matlab.txt')));
eval(sprintf('datMus3 = %s', fileread('dat_Childhood_Memory_bandari_L_matlab.txt')));

tbe = readtable('E.TXT'); vcte = tbe{:,2}';
tbh = readtable('H.TXT'); vcth = tbh{:,2}';
tbl = readtable('L.TXT'); vctl = tbl{:,2}';

t32 = 6/7/8;

%% KS
cmus1 = cellfun(@BasicMusNoteKS,datMus1,'UniformOutput',false); 
cmus2 = cellfun(@BasicMusNoteKS,datMus2,'UniformOutput',false); 
cmus3 = cellfun(@BasicMusNoteKS,datMus3,'UniformOutput',false); 
mus1 = MusJoin(cmus1, vcte, 't32', t32); 
mus2 = MusJoin(cmus2, vcth, 't32', t32); 
mus3 = MusJoin(cmus3, vctl, 't32', t32); 
mus  = mus1 + mus2 + mus3; mus = mus / max(abs(mus));
clear sound; sound(mus, fs);
% audiowrite("cm_mat_ks.flac", mus, fs)                           %% 生成flac音频文件

%% EKS
cmus1 = cellfun(@BasicMusNoteEKS,datMus1,'UniformOutput',false); 
cmus2 = cellfun(@BasicMusNoteEKS,datMus2,'UniformOutput',false); 
cmus3 = cellfun(@BasicMusNoteEKS,datMus3,'UniformOutput',false); 
mus1 = MusJoin(cmus1, vcte, 't32', t32); 
mus2 = MusJoin(cmus2, vcth, 't32', t32); 
mus3 = MusJoin(cmus3, vctl, 't32', t32); 
mus  = mus1 + mus2 + mus3; mus = mus / max(abs(mus));
clear sound; sound(mus, fs);

```

