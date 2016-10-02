---
title: "換気回数"
output: html_document
layout: post
tags: lab photosynthesis
---





光合成速度の測定には、[いくつかの方法](http://www.photosynthesis.jp/sokutei.html)がある  
メジャーな方法である開放型[同化箱法 (pdf)](http://eprints.lib.hokudai.ac.jp/dspace/bitstream/2115/39106/1/67-017.pdf)では、サンプル室内への流入CO<sub>2</sub>濃度サンプル室内からの流出CO<sub>2</sub>濃度の差から光合成速度を計算する  
このとき、サンプル室の容積 (*V* mol (空気の物質量換算)) が大きく、換気量 (*Q* mol s<sup>1</sup>) が小さい条件では、サンプル室内の換気に時間を要するため、十分時間待たないと正しく光合成速度を評価できない  

具体的には

- 流路切替により、1台のCO<sub>2</sub>濃度測器により流入出ガス濃度を測定する場合  
- 測定条件を変化させた直後の光合成速度の経時的な推移を評価する場合  

などの場合には注意が必要になる


### 理論

換気回数 (gas exchange rate, *N* = *Q*/*V* s<sup>--1</sup>) を指標として、ガス交換の待機時間を設定する  

- 葉の純光合成速度を*P*<sub>n</sub> µmol s<sup>--1</sup>
- 流入ガス中のCO<sub>2</sub>濃度を*C*<sub>in</sub> µmol mol<sup>--1</sup>
- 流出ガス中のCO<sub>2</sub>濃度 = サンプル室内のCO<sub>2</sub>濃度を *C*<sub>out</sub> µmol mol<sup>--1</sup>

とすると、サンプル室内CO<sub>2</sub>物質量の増加 (*VdC*<sub>out</sub>) は、

$$
  VdC_{\rm {out}} = -P_{\rm {n}}dt + (C_{\rm {in}} - C_{\rm {out}})Qdt
$$

と表される

- 流路切替・条件変更時点をt = 0
- *C*<sub>out,t=0</sub> = *C*<sub>init</sub> = 0
- *P*<sub>n,t>0</sub> = *P*<sub>n</sub> + Δ*P*<sub>n</sub>

とすると、*C*<sub>out,t</sub>は、

$$
  C_{\rm {out,t}} = - \frac{\Delta P_{\rm {n}}}{Q}(e^{-Nt} - 1)
$$

となる


### 実際

LI6400XTが光合成速度測定の標準として使われる  

- LI6400XTのサンプル室内容積は56.4 cm<sup>3</sup>  
- 室内へのガス流量は0--700 µmol s<sup>--1</sup> で可変  
- チャンバに挟む葉面積は6 cm<sup>2</sup> 

流路切替・条件変更による光合成速度変化量を1.0 µmol m<sup>--2</sup> s<sup>--1</sup> とすると、
Δ*P*<sub>n</sub> = 6 * 10<sup>-4</sup> µmol s<sup>--1</sup> 


```r
ChamberVolume <- 56.4 # cm^3
FlowRate <- 500 # µmol s^-1
deltaPn <- 6.0 * 10^-4 # µmol s^-1

N_exchange <- # s^-1
  function(flow = FlowRate, vol = ChamberVolume){
    vol_L <- vol * 0.001
    flow_L_s <- flow * 22.4 * 10^(-6)
    (flow_L_s / vol_L) %>%
      return
  }

delta_decay <-
  function(flow = FlowRate, vol = ChamberVolume){
  data_frame(
    Time = seq(0, 100, 1),
    Conc. = deltaPn * (exp(- N_exchange(flow = flow, vol = vol) * Time) - 1) * 10^6 / flow
    )
  }

Fig_Gas <-
  lapply(seq(100, 700, 200), function(flow){
    delta_decay(flow, vol = ChamberVolume) %>%
      mutate(Flow = paste("  flow rate:", flow))
  }) %>%
    rbind_all %>%
    ggplot(aes(x = Time, y = Conc., group = Flow, col = Flow)) +
    geom_line() +
    geom_point(alpha = .75) +
    xlab("Time [s]") +
    ylab(u_CO2("Conc.sample - Conc.ref", type = "")) +
    gg_x(c(-1, 121)) + 
    guides(col = F)
```

```
## Warning: `rbind_all()` is deprecated. Please use `bind_rows()` instead.
```

```r
directlabels::direct.label(Fig_Gas, "last.points")
```

```
## Error in loadNamespace(name): there is no package called 'directlabels'
```


### つらつらと

デフォルトの流量 500 µmol s<sup>--1</sup>では、30 s 程度で十分に安定する  
S/N比を高めるべく、もう少し流量を落としてもいいかもしれない  
ただ、その場合はサンプル室内の飽差が低下 (相対湿度が上昇) し、結露が起こりやすくなる  
光合成速度が測定条件変更後、即座に変化し安定する、というのはかなり強引な仮定  


### 参考ページ  
[光合成の測定@光合成の森](http://www.photosynthesis.jp/sokutei.html)  
[同化箱法による器官や個体レベルのガス交換 (pdf)](http://eprints.lib.hokudai.ac.jp/dspace/bitstream/2115/39106/1/67-017.pdf)  
[植物組織培養器内環境の基礎的研究 (3) 培養小植物体を含む閉栓容器内の炭酸ガス濃度測定と培養小植物体の純光合成速度の推定](https://www.jstage.jst.go.jp/article/agrmet1943/43/1/43_1_21/_article/-char/ja/)  
[Chamber response time: A neglected issue in gas exchange measurements](http://link.springer.com/article/10.1007/s11099-009-0018-3)  


```r
devtools::session_info()
```

```
## Session info --------------------------------------------------------------
```

```
##  setting  value                       
##  version  R version 3.3.1 (2016-06-21)
##  system   x86_64, darwin13.4.0        
##  ui       X11                         
##  language (EN)                        
##  collate  en_US.UTF-8                 
##  tz       Asia/Tokyo                  
##  date     2016-09-12
```

```
## Packages ------------------------------------------------------------------
```

```
##  package    * version  date       source        
##  assertthat   0.1      2013-12-06 CRAN (R 3.3.1)
##  bitops     * 1.0-6    2013-08-17 CRAN (R 3.3.1)
##  colorspace   1.2-6    2015-03-11 CRAN (R 3.3.1)
##  curl         0.9.7    2016-04-10 CRAN (R 3.3.1)
##  DBI          0.4-1    2016-05-08 CRAN (R 3.3.1)
##  devtools   * 1.12.0   2016-06-24 CRAN (R 3.3.0)
##  digest       0.6.10   2016-08-02 cran (@0.6.10)
##  dplyr      * 0.5.0    2016-06-24 CRAN (R 3.3.1)
##  evaluate     0.9      2016-04-29 CRAN (R 3.3.1)
##  formatR      1.4      2016-05-09 CRAN (R 3.3.1)
##  ggplot2    * 2.1.0    2016-03-01 CRAN (R 3.3.1)
##  gtable       0.2.0    2016-02-26 CRAN (R 3.3.1)
##  httr         1.2.1    2016-07-03 CRAN (R 3.3.0)
##  knitr      * 1.14     2016-08-13 CRAN (R 3.3.1)
##  lazyeval     0.2.0    2016-06-12 CRAN (R 3.3.1)
##  magrittr   * 1.5      2014-11-22 CRAN (R 3.3.1)
##  memoise      1.0.0    2016-01-29 CRAN (R 3.3.1)
##  munsell      0.4.3    2016-02-13 CRAN (R 3.3.1)
##  plyr       * 1.8.4    2016-06-08 CRAN (R 3.3.1)
##  R6           2.1.2    2016-01-26 CRAN (R 3.3.1)
##  Rcpp         0.12.5   2016-05-14 CRAN (R 3.3.1)
##  RCurl      * 1.95-4.8 2016-03-01 CRAN (R 3.3.1)
##  scales       0.4.0    2016-02-26 CRAN (R 3.3.1)
##  stringi      1.1.1    2016-05-27 CRAN (R 3.3.1)
##  stringr    * 1.1.0    2016-08-19 cran (@1.1.0) 
##  tibble       1.2      2016-08-26 CRAN (R 3.3.0)
##  tidyr      * 0.5.1    2016-06-14 CRAN (R 3.3.1)
##  withr        1.0.2    2016-06-20 CRAN (R 3.3.1)
```
