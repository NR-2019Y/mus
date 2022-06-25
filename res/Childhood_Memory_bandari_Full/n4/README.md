####  简谱文件

EFULL.TXT HFULL.TXT L8VA.TXT

整理得到 cmn4.wl

网页版简谱：cmn4_4c.html

#### 生成音频(mathematica)

```{mathematica}
Import["cmn4.wl"];
mus1[[-1, 2, 2]] = mus1[[-1, 2, 2]] + 32;
mus2[[-1, 2, 2]] = mus2[[-1, 2, 2]] + 32;

ToneAdjust[None, n_] = None;
ToneAdjust[x_, n_] := x + n;
Len[None] = 1;
Len[x_] := Max[1, Length[x]];

nadjust = -4;
tmul = 103/1000;
sd = Sound[Join[
    Map[SoundNote[ToneAdjust[#[[1]], nadjust], #[[2]]*tmul, "Harp", 
       SoundVolume -> 1/Sqrt[Len[#[[1]]]]] &, mus0], 
    Map[SoundNote[ToneAdjust[#[[1]], nadjust], #[[2]]*tmul, "Piano", 
       SoundVolume -> 1/Sqrt[Len[#[[1]]]]] &, mus0], 
    Map[SoundNote[ToneAdjust[#[[1]], nadjust], #[[2]]*tmul, "Piano", 
       SoundVolume -> 1/Sqrt[Len[#[[1]]]]] &, mus1], 
    Map[SoundNote[ToneAdjust[#[[1]], nadjust], #[[2]]*tmul, "Harp", 
       SoundVolume -> 0.8/Sqrt[Len[#[[1]]]]] &, mus2]
    ]];
(* Export["mma/cmn4-4_Harp_Piano_mma.flac", sd] *)

```



