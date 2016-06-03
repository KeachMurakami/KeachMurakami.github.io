---
title: "換気回数"
output: html_document
layout: post
tags: lab photosynthesis
---





光合成速度測定は、サンプル室内への流入CO~2~濃度サンプル室内からの流出CO~2~濃度の差から計算される  
このとき、サンプル室の容積 (*V*; mol (空気体積換算)) が大きく、換気量 (*Q*; mol s^--1^) が小さい条件では、サンプル室内の換気に時間を要するため、十分時間待たないと正しく光合成速度を評価できない  
具体的には

- 流路切替により、1台のCO~2~濃度測器により流入出ガス濃度を測定する場合  
- 測定条件を変化させた直後の光合成速度の経時的な推移を評価する場合  

などの場合には注意が必要になる


### 理論

換気回数 (gas exchange rate; *N* = *Q*/*V*) を指標として、ガス交換の待機時間を設定する  

- 葉の純光合成速度を*P*~n~ µmol s^--1^
- 流入ガス中のCO~2~濃度を*C*~in~ µmol mol^--1^
- 流出ガス中のCO~2~濃度 = サンプル室内のCO~2~濃度を *C*~out~ µmol mol^--1^

とすると、サンプル室内CO~2~物質量の増加 (*VdC*~out~) は、

$$
  VdC_{\rm {out}} = -P_{\rm {n}}dt + (C_{\rm {in}} - C_{\rm {out}})Qdt
$$

と表される

- 流路切替・条件変更時点をt = 0
- *C*~out,t=0~ = *C*~init~
- *P*~n,t>0~ = *P*~n~ + Δ*P*~n~

とすると、*C*~out,t~は、

$$
  C_{\rm {out,t}} = C_{init} - \frac{\Delta P_{\rm {n}}}{Q}(e^{-Nt} - 1)
$$

となる


### 実際

LI6400XTが光合成速度測定の標準として使われる  

- LI6400XTのサンプル室内容積は56.4 cm^3^  
- 室内へのガス流量は100--700 µmol s^--1^ で可変  
- チャンバに挟む葉面積は6 cm^2^ 

流路切替・条件変更による光合成速度変化量を1.0 µmol m^--2^ s^--1^ とすると、
Δ*P*~n~ = 6 * 10^-4^ µmol s^--1^ 


```r
ChamberVolume <- 56.4 # cm3
FlowRate <- 500 # µmol s-1
deltaPn <- 6.0 * 10^-4 # µmol s-1

N_exchange <-
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

directlabels::direct.label(Fig_Gas, "last.points")
```

![plot of chunk GasExchangeDelay](/figure/source/2016-06-03-ExchangeRate/GasExchangeDelay-1.png)


### つらつらと

デフォルトの流量 500 µmol s^--1^では、30 s 程度で十分に安定する  
S/N比を高める目的で流量を落としてもいいかもしれない  
ただ、その場合はサンプル室内の飽差が低下 (相対湿度が上昇) し、結露が起こりやすくなる  


### 参考ページ  
[植物組織培養器内環境の基礎的研究 (3) 培養小植物体を含む閉栓容器内の炭酸ガス濃度測定と培養小植物体の純光合成速度の推定](https://www.jstage.jst.go.jp/article/agrmet1943/43/1/43_1_21/_article/-char/ja/)


```r
devtools::session_info()
```

```
## Session info --------------------------------------------------------------
```

```
##  setting  value                       
##  version  R version 3.2.3 (2015-12-10)
##  system   x86_64, darwin14.5.0        
##  ui       X11                         
##  language (EN)                        
##  collate  en_US.UTF-8                 
##  tz       Asia/Tokyo                  
##  date     2016-06-03
```

```
## Packages ------------------------------------------------------------------
```

```
##  package      * version    date       source        
##  assertthat     0.1        2013-12-06 CRAN (R 3.1.0)
##  bitops       * 1.0-6      2013-08-17 CRAN (R 3.1.0)
##  colorspace     1.2-6      2015-03-11 CRAN (R 3.1.3)
##  curl           0.9.4      2015-11-20 CRAN (R 3.1.3)
##  DBI            0.3.1      2014-09-24 CRAN (R 3.1.1)
##  devtools     * 1.9.1      2015-09-11 CRAN (R 3.2.0)
##  digest         0.6.8      2014-12-31 CRAN (R 3.1.2)
##  directlabels   2015.12.16 2015-12-18 CRAN (R 3.2.3)
##  dplyr        * 0.4.3      2015-09-01 CRAN (R 3.1.3)
##  evaluate       0.8        2015-09-18 CRAN (R 3.1.3)
##  formatR        1.2.1      2015-09-18 CRAN (R 3.1.3)
##  ggplot2      * 2.0.0      2015-12-18 CRAN (R 3.2.3)
##  gtable         0.1.2      2012-12-05 CRAN (R 3.1.0)
##  httr           1.0.0      2015-06-25 CRAN (R 3.1.3)
##  knitr        * 1.13.1     2016-05-26 local         
##  labeling       0.3        2014-08-23 CRAN (R 3.1.1)
##  lazyeval       0.1.10     2015-01-02 CRAN (R 3.1.2)
##  magrittr     * 1.5        2014-11-22 CRAN (R 3.1.2)
##  memoise        0.2.1      2014-04-22 CRAN (R 3.1.0)
##  munsell        0.4.2      2013-07-11 CRAN (R 3.1.0)
##  plyr         * 1.8.3      2015-06-12 CRAN (R 3.1.3)
##  quadprog       1.5-5      2013-04-17 CRAN (R 3.1.0)
##  R6             2.1.1      2015-08-19 CRAN (R 3.1.3)
##  Rcpp           0.12.2     2015-11-15 CRAN (R 3.1.3)
##  RCurl        * 1.95-4.7   2015-06-30 CRAN (R 3.1.3)
##  scales         0.3.0      2015-08-25 CRAN (R 3.1.3)
##  stringi        1.0-1      2015-10-22 CRAN (R 3.1.3)
##  stringr      * 1.0.0      2015-04-30 CRAN (R 3.1.3)
##  tidyr        * 0.3.1      2015-09-10 CRAN (R 3.2.0)
```
