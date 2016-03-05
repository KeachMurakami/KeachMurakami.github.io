---
title: "複数層の3次元プロットを1枚の図で (rgl"
output: html_document
layout: post
categories: R
tags: lab R rgl 3D
---



# 多層の3Dプロットを作る (メモ  
[英語で検索](https://www.google.co.jp/search?q=3D+plot+R+multilayer&source=lnms&tbm=isch&sa=X&ved=0ahUKEwiBrbXvle3KAhVEiKYKHXJNCQMQ_AUIBygB&biw=1280&bih=925)しても、[日本語で検索](https://www.google.co.jp/search?q=R+3%E6%AC%A1%E5%85%83+%E5%B1%A4&source=lnms&tbm=isch&sa=X&ved=0ahUKEwi9r7uJlu3KAhXCqaYKHfeED68Q_AUIBygB&biw=1280&bih=925)しても、[Rcmdrを用いた対話的な3D散布図](https://www1.doshisha.ac.jp/~mjin/R/39/39.html)くらいしか簡単に見つからなかったので (20160210現在)

## データ作り  

```r
df_3d <-
  data_frame(x = rep(1:20, each = 20),
             y = rep(1:20, times = 20),
             z1 = x + y + 0.5 * x * y,
             z2 = 5 * x + 3 * y - 0.5 * x * y) %>%
  tidyr::gather(group, z, -x, -y)

df_3d_group1 <-
  df_3d %>%
  filter(group == "z1")
df_3d_group2 <-
  df_3d %>%
  filter(group == "z2")

df_3d_group1 %>% str
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	400 obs. of  4 variables:
##  $ x    : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ y    : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ group: Factor w/ 2 levels "z1","z2": 1 1 1 1 1 1 1 1 1 1 ...
##  $ z    : num  2.5 4 5.5 7 8.5 10 11.5 13 14.5 16 ...
```

```r
df_3d_group2 %>% str
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	400 obs. of  4 variables:
##  $ x    : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ y    : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ group: Factor w/ 2 levels "z1","z2": 2 2 2 2 2 2 2 2 2 2 ...
##  $ z    : num  7.5 10 12.5 15 17.5 20 22.5 25 27.5 30 ...
```

## グラフ作り  
rglをjekyll生成のページに埋め込むのがきつそうなのでコードのみ  

```r
library(rgl)

plot3d(df_3d_group1$x, df_3d_group1$y, df_3d_group1$z, zlim = c(-50, 250))
plot3d(df_3d_group2$x, df_3d_group2$y, df_3d_group2$z, col = "red", zlim = c(-50, 250))
```

曲面を追加する  

```r
library(akima)

surf1 <- interp(df_3d_group1$x, df_3d_group1$y, df_3d_group1$z)
surf2 <- interp(df_3d_group2$x, df_3d_group2$y, df_3d_group2$z)

plot3d(df_3d_group1$x, df_3d_group1$y, df_3d_group1$z, col = "grey10", zlim = c(-50, 250))
plot3d(df_3d_group2$x, df_3d_group2$y, df_3d_group2$z, col = "red", zlim = c(-50, 250))

surface3d(surf1$x, surf1$y, surf1$z, col = "grey", alpha = .3)
surface3d(surf2$x, surf2$y, surf2$z, col = "red", alpha = .3)
```

## 出力 (画像)  
![surface](/figure/source/2016-02-10-Multilayerd-3Dplot/figs.svg)  

### 参考ページ  
[不規則な間隔のデータ点を曲面プロットする (yohm13さん@Qiita)](http://qiita.com/yohm13/items/204a2cf9a248ca0cf28a)


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
##  date     2016-03-05                  
## 
##  package      * version    date       source                          
##  agricolae    * 1.2-3      2015-10-06 CRAN (R 3.1.3)                  
##  akima        * 0.5-12     2015-09-15 CRAN (R 3.2.0)                  
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
##  rgl          * 0.95.1201  2014-12-21 CRAN (R 3.2.0)                  
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
