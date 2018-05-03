---
title: "図のラベルを楽に付けたい"
output: html_document
layout: post
categories: R
tags: lab R ggplot2
---


# expression関数内に変数を動的に組み込みたかった話  

研究生活では、図を書くことが多い  
例えば以下のような図  

```r
plot1 <-
  data_frame(x = seq(from = 0, to = 100, length.out = 500), y = log(x) + rnorm(500, 0, 0.1)) %>%
  ggplot(aes(x = x, y = y)) +
  theme_bw(base_size = 20, base_family = "serif") +
  geom_point(alpha = .5)

plot1 +
  xlab(expression(paste("Light intensity ["  * mu * "mol" ~ m^-2 ~ s^-1 * "]"))) +
  ylab(expression(paste("Net photosynthetic rate [" * mu * "mol" ~ m^-2 ~ s^-1 * "]")))
```

![plot of chunk Example](/figure/source/2016-02-01-label_ggplot2/Example-1.png) 

光の強さに応じて、葉の光合成速度が大きくなるなど  
似たような単位で似たような図をたくさん書く  
単位によく現れるギリシャ文字、上・下付き、イタリックといった書式を  
サポートするのは、`expression`関数だ  
毎度`expression(paste("Light intensity ["  * mu * "mol" ~ m^-2 ~ s^-1 * "]"))`なんて書くのは大変だし、`expression(paste("Net photosynthetic rate ["  * mu * "mol" ~ m^-2 ~ s^-1 * "]"))`に変えるときにコピペするのもキレイではない  
なので、軸のテキスト部分を変数化して楽をしようとした   

#### expression関数の中では文字列を評価してくれない  

```r
labeler1 <- function(text){
  expression(paste(text ~ "["  * mu * "mol" ~ m^-2 ~ s^-1 * "]"))
}
plot1 + xlab(labeler1("value2"))
```

![plot of chunk NG1](/figure/source/2016-02-01-label_ggplot2/NG1-1.png) 

#### pasteを先に実行すると、`mu`がないことを怒られる  

```r
paste(text, "[", mu, "g", m^-2, "]") %>% expression
```

```
## Error in paste(text, "[", mu, "g", m^-2, "]"): object 'mu' not found
```

遅延評価 (lazy evaluation)、変数の作る環境あたりが原因だということはわかった  

## どうすればいいのか  
`base::bquote()`でいけた  

```r
labeler2 <- function(text){
  bquote(.(text) ~ "["  * mu * "mol" ~ m^-2 ~ s^-1 * "]")
}
plot1 + xlab(labeler2("Light intensity")) + ylab(labeler2("Net photosynthetic rate"))   
```

![plot of chunk OK](/figure/source/2016-02-01-label_ggplot2/OK-1.png) 

`bquote()`内では、`.(変数)`とすることで、変数を受け取ることができる  
それ以外は`expression`と同じ使い方  
文字間を詰める場合は`*`で、スペースを開ける場合には`~`で結合  

```r
plot(0, 0, type = "n", xlim = c(0, 1), ylim = c(0, 4), xlab = "", ylab = "")

moji <- letters

par(family = "Times New Roman")
text(.5, 3, labels = bquote(.(moji[1]) ~ "[" * mu * "g" ~ m^-2 * "]"), cex = 2)
text(.5, 2, labels = bquote(.(moji[2]) ~ "[" ~ mu ~ "g" ~ m^-2 ~ "]"), cex = 2)
text(.5, 1, labels = bquote(.(moji[3]) ~ "[" ~~ mu ~~ "g" ~ m^-2 ~~ "]"), cex = 2)
```

![plot of chunk bquoteExamples](/figure/source/2016-02-01-label_ggplot2/bquoteExamples-1.png) 

## [bquote](https://stat.ethz.ch/R-manual/R-devel/library/base/html/bquote.html)の使い方の曖昧和訳  
> ### bquote {base}  
> expression関数に部分的に変数をいれる  
> 
> #### 概要
> LISPのbackquote macroに似たやつ  
> .()で囲まれた部分以外を引数whereで指定された環境の下で評価する    
> 
> #### 使用法
> bquote(expr, where = parent.frame())
> 
> #### 引数
> expr: 言語オブジェクト (name, call, expression)
> where: 言語オブジェクトを評価する環境

## expression関数で同じことできないのか  
要勉強  
[言語オブジェクト](http://d.hatena.ne.jp/tsutatsutatsuta/20120114/1326542583)と環境のあたりをもう少し理解できればうまく行く気がする  

### 参考
[bquote (R Documentation)](https://stat.ethz.ch/R-manual/R-devel/library/base/html/bquote.html)  
[言語オブジェクト (どんな鳥も@Hatena::Diary)](http://d.hatena.ne.jp/tsutatsutatsuta/20120114/1326542583)


```r
session_info()
```

```
##  setting  value                       
##  version  R version 3.2.3 (2015-12-10)
##  system   x86_64, darwin14.5.0        
##  ui       X11                         
##  language (EN)                        
##  collate  en_US.UTF-8                 
##  tz       Asia/Tokyo                  
##  date     2016-04-01                  
## 
##  package      * version    date       source                          
##  agricolae    * 1.2-3      2015-10-06 CRAN (R 3.1.3)                  
##  AlgDesign      1.1-7.3    2014-10-15 CRAN (R 3.1.2)                  
##  assertthat     0.1        2013-12-06 CRAN (R 3.1.0)                  
##  bitops       * 1.0-6      2013-08-17 CRAN (R 3.1.0)                  
##  boot           1.3-17     2015-06-29 CRAN (R 3.2.3)                  
##  chron          2.3-47     2015-06-24 CRAN (R 3.1.3)                  
##  cluster        2.0.3      2015-07-21 CRAN (R 3.2.3)                  
##  coda           0.18-1     2015-10-16 CRAN (R 3.1.3)                  
##  codetools      0.2-14     2015-07-15 CRAN (R 3.2.3)                  
##  colorspace     1.2-6      2015-03-11 CRAN (R 3.1.3)                  
##  combinat       0.0-8      2012-10-29 CRAN (R 3.1.0)                  
##  data.table   * 1.9.6      2015-09-19 CRAN (R 3.1.3)                  
##  DBI            0.3.1      2014-09-24 CRAN (R 3.1.1)                  
##  deldir         0.1-9      2015-03-09 CRAN (R 3.1.3)                  
##  devtools     * 1.9.1      2015-09-11 CRAN (R 3.2.0)                  
##  digest         0.6.8      2014-12-31 CRAN (R 3.1.2)                  
##  doParallel     1.0.10     2015-10-14 CRAN (R 3.1.3)                  
##  doRNG          1.6        2014-03-07 CRAN (R 3.1.2)                  
##  dplyr        * 0.4.3      2015-09-01 CRAN (R 3.1.3)                  
##  evaluate       0.8        2015-09-18 CRAN (R 3.1.3)                  
##  foreach      * 1.4.3      2015-10-13 CRAN (R 3.1.3)                  
##  formatR        1.2.1      2015-09-18 CRAN (R 3.1.3)                  
##  ggplot2      * 2.0.0      2015-12-18 CRAN (R 3.2.3)                  
##  gridExtra    * 2.0.0      2015-07-14 CRAN (R 3.1.3)                  
##  gtable       * 0.1.2      2012-12-05 CRAN (R 3.1.0)                  
##  httr           1.0.0      2015-06-25 CRAN (R 3.1.3)                  
##  iterators      1.0.8      2015-10-13 CRAN (R 3.1.3)                  
##  jsonlite       0.9.19     2015-11-28 CRAN (R 3.1.3)                  
##  klaR           0.6-12     2014-08-06 CRAN (R 3.1.1)                  
##  knitr        * 1.11       2015-08-14 CRAN (R 3.2.3)                  
##  labeling       0.3        2014-08-23 CRAN (R 3.1.1)                  
##  lattice        0.20-33    2015-07-14 CRAN (R 3.2.3)                  
##  lazyeval       0.1.10     2015-01-02 CRAN (R 3.1.2)                  
##  LearnBayes     2.15       2014-05-29 CRAN (R 3.1.0)                  
##  lubridate    * 1.5.0      2015-12-03 CRAN (R 3.2.3)                  
##  magrittr     * 1.5        2014-11-22 CRAN (R 3.1.2)                  
##  MASS         * 7.3-45     2015-11-10 CRAN (R 3.2.3)                  
##  Matrix         1.2-3      2015-11-28 CRAN (R 3.2.3)                  
##  memoise        0.2.1      2014-04-22 CRAN (R 3.1.0)                  
##  munsell        0.4.2      2013-07-11 CRAN (R 3.1.0)                  
##  nlme           3.1-122    2015-08-19 CRAN (R 3.2.3)                  
##  pforeach     * 1.3        2015-12-21 Github (hoxo-m/pforeach@2c44f3b)
##  pkgmaker       0.22       2014-05-14 CRAN (R 3.1.3)                  
##  plyr         * 1.8.3      2015-06-12 CRAN (R 3.1.3)                  
##  R6             2.1.1      2015-08-19 CRAN (R 3.1.3)                  
##  RColorBrewer * 1.1-2      2014-12-07 CRAN (R 3.1.2)                  
##  Rcpp           0.12.2     2015-11-15 CRAN (R 3.1.3)                  
##  RCurl        * 1.95-4.7   2015-06-30 CRAN (R 3.1.3)                  
##  registry       0.3        2015-07-08 CRAN (R 3.1.3)                  
##  reshape2     * 1.4.1      2014-12-06 CRAN (R 3.1.2)                  
##  rJava        * 0.9-7      2015-07-29 CRAN (R 3.1.3)                  
##  rngtools       1.2.4      2014-03-06 CRAN (R 3.1.2)                  
##  scales       * 0.3.0      2015-08-25 CRAN (R 3.1.3)                  
##  slackr       * 1.3.1.9001 2015-12-07 Github (hrbrmstr/slackr@27f777e)
##  sp             1.2-1      2015-10-18 CRAN (R 3.2.3)                  
##  spdep          0.5-92     2015-12-22 CRAN (R 3.2.3)                  
##  stringi        1.0-1      2015-10-22 CRAN (R 3.1.3)                  
##  stringr      * 1.0.0      2015-04-30 CRAN (R 3.1.3)                  
##  tidyr        * 0.3.1      2015-09-10 CRAN (R 3.2.0)                  
##  xlsx         * 0.5.7      2014-08-02 CRAN (R 3.1.1)                  
##  xlsxjars     * 0.6.1      2014-08-22 CRAN (R 3.1.1)                  
##  xtable         1.8-0      2015-11-02 CRAN (R 3.1.3)
```
