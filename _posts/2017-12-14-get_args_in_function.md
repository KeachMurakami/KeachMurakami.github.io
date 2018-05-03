---
title: "関数への全引数をmutateで追加する (R"
output: html_document
layout: post
tags: lab R datahandling 
---



はまったのでメモ。

複数パラメータを引数にとる自作関数で感度分析するとき、出力のデータフレームには入力したパラメータがあってほしい。
引数が多くなると`result %>% mutate(input1, input2, ....) %>% return` が長くなるし、修正に不便なので、引数を一括で足したい。


```r
library(tidyverse)

f1 <- 
  function(a = 3, b = 2, c){
    args <- as.list(environment())
    
    tibble::tibble(result = a + b + c) %>%
      dplyr::mutate(rlang::UQS(args))
  }

f2 <-
  function(a = 3, b = 2, c){
    args <- as.list(match.call())[-1]
    
    tibble::tibble(result = a + b + c) %>%
      dplyr::mutate(rlang::UQS(args))
  }
```


```r
f1(a = 3, b = 2, c = 1)
```

```
## # A tibble: 1 x 4
##   result     a     b     c
##    <dbl> <dbl> <dbl> <dbl>
## 1      6     3     2     1
```

```r
f2(a = 3, b = 2, c = 1)
```

```
## # A tibble: 1 x 4
##   result     a     b     c
##    <dbl> <dbl> <dbl> <dbl>
## 1      6     3     2     1
```

```r
1:2 %>%
  purrr::map(~ f1(c = .))
```

```
## [[1]]
## # A tibble: 1 x 4
##   result     a     b     c
##    <dbl> <dbl> <dbl> <int>
## 1      6     3     2     1
## 
## [[2]]
## # A tibble: 1 x 4
##   result     a     b     c
##    <dbl> <dbl> <dbl> <int>
## 1      7     3     2     2
```

```r
1:2 %>%
  purrr::map(~ f2(c = .))
```

```
## [[1]]
## # A tibble: 1 x 2
##   result                c
##    <dbl>         <tibble>
## 1      6 <tibble [1 x 1]>
## 
## [[2]]
## # A tibble: 1 x 2
##   result                c
##    <dbl>         <tibble>
## 1      7 <tibble [1 x 1]>
```

```r
1:2 %>%
  purrr::map(~ f2(a = 3, b = 2, c = .))
```

```
## [[1]]
## # A tibble: 1 x 4
##   result     a     b                c
##    <dbl> <dbl> <dbl>         <tibble>
## 1      6     3     2 <tibble [1 x 1]>
## 
## [[2]]
## # A tibble: 1 x 4
##   result     a     b                c
##    <dbl> <dbl> <dbl>         <tibble>
## 1      7     3     2 <tibble [1 x 1]>
```

`match.call()`はよく実装されているけど、いまいち使いこなせていない。
デフォルトだと初期値指定した引数を受け取らないうえに、プレースホルダで受け取るとネストしたデータが戻る。
`match.call()`自体の動作する環境をうまく指定すればいけそう？
`environment()`でOKではあるが、関数内環境でのオブジェクトを全部受け取る感じなので、ネストしはじめると怖いような気もする。

#### 参考

[Get all Parameters as List](https://stackoverflow.com/questions/11885207/get-all-parameters-as-list?noredirect=1&lq=1)


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
##  date     2017-12-14
```

```
## Packages ------------------------------------------------------------------
```

```
##  package    * version    date       source                            
##  assertthat   0.2.0      2017-04-11 cran (@0.2.0)                     
##  bindr        0.1        2016-11-13 cran (@0.1)                       
##  bindrcpp     0.2        2017-06-17 CRAN (R 3.3.2)                    
##  broom        0.4.3      2017-11-20 CRAN (R 3.3.2)                    
##  cellranger   1.1.0      2016-07-27 cran (@1.1.0)                     
##  cli          1.0.0      2017-11-05 CRAN (R 3.3.2)                    
##  colorspace   1.2-6      2015-03-11 CRAN (R 3.3.1)                    
##  crayon       1.3.4      2017-09-16 CRAN (R 3.3.2)                    
##  devtools     1.12.0     2016-06-24 CRAN (R 3.3.0)                    
##  digest       0.6.12     2017-01-27 cran (@0.6.12)                    
##  dplyr      * 0.7.4      2017-09-28 cran (@0.7.4)                     
##  evaluate     0.10.1     2017-06-24 cran (@0.10.1)                    
##  forcats    * 0.2.0      2017-01-23 CRAN (R 3.3.2)                    
##  ggplot2    * 2.2.1.9000 2017-08-08 Github (tidyverse/ggplot2@53a22cd)
##  glue         1.2.0      2017-10-29 cran (@1.2.0)                     
##  gtable       0.2.0      2016-02-26 CRAN (R 3.3.1)                    
##  haven        1.1.0      2017-07-09 CRAN (R 3.3.2)                    
##  hms          0.3        2016-11-22 CRAN (R 3.3.1)                    
##  httr         1.3.1      2017-08-20 CRAN (R 3.3.2)                    
##  jsonlite     1.5        2017-06-01 cran (@1.5)                       
##  knitr      * 1.17       2017-08-10 cran (@1.17)                      
##  lattice      0.20-33    2015-07-14 CRAN (R 3.3.1)                    
##  lazyeval     0.2.0      2016-06-12 CRAN (R 3.3.1)                    
##  lubridate    1.7.1      2017-11-03 CRAN (R 3.3.2)                    
##  magrittr     1.5        2014-11-22 CRAN (R 3.3.1)                    
##  memoise      1.0.0      2016-01-29 CRAN (R 3.3.1)                    
##  mnormt       1.5-4      2016-03-09 CRAN (R 3.3.0)                    
##  modelr       0.1.1      2017-07-24 CRAN (R 3.3.2)                    
##  munsell      0.4.3      2016-02-13 CRAN (R 3.3.1)                    
##  nlme         3.1-128    2016-05-10 CRAN (R 3.3.1)                    
##  pkgconfig    2.0.1      2017-03-21 cran (@2.0.1)                     
##  plyr         1.8.4      2016-06-08 CRAN (R 3.3.1)                    
##  psych        1.6.6      2016-06-28 CRAN (R 3.3.0)                    
##  purrr      * 0.2.4      2017-10-18 cran (@0.2.4)                     
##  R6           2.2.2      2017-06-17 cran (@2.2.2)                     
##  Rcpp         0.12.14    2017-11-23 cran (@0.12.14)                   
##  readr      * 1.1.1      2017-05-16 CRAN (R 3.3.2)                    
##  readxl       1.0.0      2017-04-18 cran (@1.0.0)                     
##  reshape2     1.4.2      2016-10-22 cran (@1.4.2)                     
##  rlang        0.1.4      2017-11-05 cran (@0.1.4)                     
##  rstudioapi   0.7        2017-09-07 CRAN (R 3.3.2)                    
##  rvest        0.3.2      2016-06-17 CRAN (R 3.3.0)                    
##  scales       0.4.1.9002 2017-08-09 Github (hadley/scales@4bc0ccb)    
##  stringi      1.1.5      2017-04-07 cran (@1.1.5)                     
##  stringr    * 1.2.0      2017-02-18 cran (@1.2.0)                     
##  tibble     * 1.3.4      2017-08-22 cran (@1.3.4)                     
##  tidyr      * 0.7.2      2017-10-16 CRAN (R 3.3.2)                    
##  tidyverse  * 1.2.1      2017-11-14 CRAN (R 3.3.1)                    
##  withr        2.0.0      2017-08-08 Github (jimhester/withr@190d293)  
##  xml2         1.1.1      2017-01-24 cran (@1.1.1)
```
