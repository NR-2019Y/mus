#### 1 原简谱（复杂版）

1TO20HH.TXT

1TO20HL.TXT

1TO20L.TXT



#### 2 原简谱（简化版）

h.txt

l.txt


#### 3 整理后的简谱（用于Mathematica演奏）

简化版 outNEW1_NC.wl

（导入 mus0，mus1，mus2）

复杂版 outNEW1.wl

（导入 mus1Nc，mus2Nc）

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
