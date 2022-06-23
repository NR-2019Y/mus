####  简谱文件

EFULL.TXT HFULL.TXT L8VA.TXT

整理得到 cmn4.wl

#### 生成音频(mathematica)

```{mathematica}
Import["cmn4.wl"];

ToneAdjust[None, n_] = None;
ToneAdjust[x_, n_] := x + n;
nadjust = 0;
Len[None] = 1;
Len[x_] := Max[1, Length[x]];

nadjust = 0;
tmul = 103/ 1000;

mus1[[-1]] = {21, {1856, 1920}};
mus2[[-1]] = {{9, 16, 21}, {1872, 1920}};
sd = Sound[Join[
  Map[SoundNote[ToneAdjust[#[[1]], nadjust], #[[2]]*tmul, "Harp",  SoundVolume -> 1  /Sqrt[Len[#[[1]]]]] &, mus0],
  Map[SoundNote[ToneAdjust[#[[1]], nadjust], #[[2]]*tmul, "Piano", SoundVolume -> 1  /Sqrt[Len[#[[1]]]]] &, mus0], 
  Map[SoundNote[ToneAdjust[#[[1]], nadjust], #[[2]]*tmul, "Piano", SoundVolume -> 1  /Sqrt[Len[#[[1]]]]] &, mus1],
  Map[SoundNote[ToneAdjust[#[[1]], nadjust], #[[2]]*tmul, "Harp",  SoundVolume -> 0.8/Sqrt[Len[#[[1]]]]] &, mus2]
]];
(* Export["cmn4f2_Harp_Piano.flac", sd] *)

```



