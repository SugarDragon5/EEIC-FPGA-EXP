# EEIC-FPGA-EXP
東京大学工学部電子情報工学科「電気電子情報実験・演習第二」種目13「FPGAを用いたアルゴリズム実装」のレポジトリです。
局所探索法(山登り法)をFPGA上で並列的に動作させ、巡回セールスマン問題をCPUより効率的に解くことを目標としました。

## 資料
[実験最終日の発表資料](./presentation.pdf)
## ディレクトリ構成
```
.
├── CPU_Solver: CPUを用いたソルバ・ビジュアライザです
├── FPGA_Solver: FPGA上で動作するソルバです。
│   ├── TSPTop.v: トップモジュール
│   ├── includer.sv: 各モジュールのインクルーダ
│   ├── module: 機能ごとのモジュール
│   │   ├── TSPTop_wrap.sv: トップモジュールのSystem Verilogによるラッパ
│   │   ├── tsp.sv: 巡回セールスマン問題ソルバモジュール
│   │   ├── graph.sv: グラフモジュール
│   │   ├── swap.sv: 非隣接2点の入れ替えモジュール
│   │   ├── swap_adjacent.sv: 隣接2点の入れ替えモジュール
│   │   ├── distance.v: 距離計算モジュール
│   │   └── xorshift.v: 乱数生成モジュール
│   │   ├── seg7.sv: 7セグメントLED表示モジュール
│   └── testbench: 各モジュール・全体に対するテストベンチ
├── README.MD
└── presentation.pdf: 実験最終日の発表資料
```