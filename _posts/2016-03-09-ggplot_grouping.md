---
title: "aes(group)"
output: html_document
layout: post
tags: lab ggplot2 R memo
---



# ggplot2のaes(group)内で処理をする (メモ

`aes(group = paste(グループ化したい変数1, 変数2))`とすると楽

```r
data_yield <-
  data_frame(
    ExptID = rep(letters[1:3], each = 10),
    Water = rep(c(0.1, 1), times = 15),
    Fertilizer = rep(1:10, times = 3),
    Yield = Fertilizer * 5 +  Water * 10 + rnorm(30, 0, 1)
    )

data_yield %>%
  kable
```



|ExptID | Water| Fertilizer|     Yield|
|:------|-----:|----------:|---------:|
|a      |   0.1|          1|  6.480397|
|a      |   1.0|          2| 18.317569|
|a      |   0.1|          3| 18.155836|
|a      |   1.0|          4| 30.403439|
|a      |   0.1|          5| 24.459607|
|a      |   1.0|          6| 39.736409|
|a      |   0.1|          7| 35.137086|
|a      |   1.0|          8| 47.915313|
|a      |   0.1|          9| 44.787005|
|a      |   1.0|         10| 59.454424|
|b      |   0.1|          1|  6.855722|
|b      |   1.0|          2| 18.931382|
|b      |   0.1|          3| 15.562121|
|b      |   1.0|          4| 32.662525|
|b      |   0.1|          5| 26.116259|
|b      |   1.0|          6| 42.219367|
|b      |   0.1|          7| 35.488436|
|b      |   1.0|          8| 51.765649|
|b      |   0.1|          9| 46.429980|
|b      |   1.0|         10| 61.630145|
|c      |   0.1|          1|  5.982216|
|c      |   1.0|          2| 20.304380|
|c      |   0.1|          3| 14.347317|
|c      |   1.0|          4| 31.393094|
|c      |   0.1|          5| 26.376162|
|c      |   1.0|          6| 40.750593|
|c      |   0.1|          7| 36.164834|
|c      |   1.0|          8| 51.742972|
|c      |   0.1|          9| 45.366011|
|c      |   1.0|         10| 57.830253|

```r
data_yield %>%
  ggplot(aes(x = Fertilizer, y = Yield, col = ExptID, group = Water)) + 
  geom_point() +
  geom_line()
```

![plot of chunk unnamed-chunk-1](/figure/source/2016-03-09-ggplot_grouping/unnamed-chunk-1-1.png) 

```r
data_yield %>%
  ggplot(aes(x = Fertilizer, y = Yield, col = ExptID, group = ExptID)) + 
  geom_point() +
  geom_line()
```

![plot of chunk unnamed-chunk-1](/figure/source/2016-03-09-ggplot_grouping/unnamed-chunk-1-2.png) 

```r
# こうじゃなくて
data_yield %>%
  mutate(Groups = paste0(ExptID, "_", Water)) %>%
  ggplot(aes(x = Fertilizer, y = Yield, col = ExptID, group = Groups)) + 
  geom_point() +
  geom_line()
```

![plot of chunk unnamed-chunk-1](/figure/source/2016-03-09-ggplot_grouping/unnamed-chunk-1-3.png) 

```r
# こう
data_yield %>%
  ggplot(aes(x = Fertilizer, y = Yield, col = ExptID, group = paste0(ExptID, Water))) + 
  geom_point() +
  geom_line()
```

![plot of chunk unnamed-chunk-1](/figure/source/2016-03-09-ggplot_grouping/unnamed-chunk-1-4.png) 


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
##  highr          0.5.1      2015-09-18 CRAN (R 3.1.3)                  
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
