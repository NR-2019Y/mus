Mathematica 使用示例

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
