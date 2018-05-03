---
title: "purrr::map内で何番目の要素なのか... (R"
output: html_document
layout: post
tags: lab R purrr data-handling
---


```r
library(tidyverse)
knitr::opts_chunk(eval = F, echo = T)
```

```
## Error in eval(expr, envir, enclos): attempt to apply non-function
```

{purrr}メモ

要素数の多いリスト/ベクトルを`purrr::map`に投げてエラーを吐いたとき、コケた位置を知りたい。  


```r
(long_list <- lst(a = 5, b = 10, c = 3, d = 1, e = NA, f = 5))
```

```
## $a
## [1] 5
## 
## $b
## [1] 10
## 
## $c
## [1] 3
## 
## $d
## [1] 1
## 
## $e
## [1] NA
## 
## $f
## [1] 5
```

```r
#> $a
#> [1] 5
#> 
#> $b
#> [1] 10
#> 
#> $c
#> [1] 3
#> 
#> $d
#> [1] 1
#> 
#> $e
#> [1] NA
#> 
#> $f
#> [1] 5

# 範囲を返す
f <-function(x) return(x:x^2)

f(2)
```

```
## [1] 2 3 4
```

```r
#> [1] 2 3 4

f(3)
```

```
## [1] 3 4 5 6 7 8 9
```

```r
#> [1] 3 4 5 6 7 8 9

f(NA)
```

```
## Error in x:x^2: NA/NaN argument
```

```r
#> Error in x:x^2 : NA/NaN argument
```

素直にいくと、エラー位置を教えてもらえない。  

```r
map(long_list, f)
```

```
## Error in x:x^2: NA/NaN argument
```

```r
#> Error in x:x^2 : NA/NaN argument
```

この例だと、`is.na(long_list)`をすればすぐに分かるが、関数が複雑化している場合にはエラー発生位置がよく分からないこともある<sup>1</sup>。

{purrr}の哲学では、map内でインデックスをとることは想定されていないらしい。
関数に引数を追加して、`map2`や`imap`に名前付きリスト/ベクトルを投げる<sup>2</sup>のが筋っぽい。


```r
f1 <-
  function(x, y){
    if(class(try(f(x))) == "try-error"){
        stop(str_glue("Error at '{y}'."))
      } else {
        return(f(x))
      }
  }

# 実行例1

map2(long_list, names(long_list), ~f1(.x, .y))
```

```
## Error in f1(.x, .y): Error at 'e'.
```

```r
#> Error in x:x^2 : NA/NaN argument
#> Error in f1(.x, .y) : Error at 'e'.

# 実行例2

imap(long_list, ~f1(.x, .y))
```

```
## Error in f1(.x, .y): Error at 'e'.
```

```r
#> Error in x:x^2 : NA/NaN argument
#> Error in f1(.x, .y) : Error at 'e'.
```

{purrr}と環境の理解のため、別のアプローチを試す。
以下の関数では、mapの中から環境を遡ってループインデックスの`i`を読み込む。


```r
f2 <-
  function(x){
    if(class(try(f(x), silent = T)) == "try-error"){
        error_at <- eval(parse(text = "i"), envir = parent.frame(n = 1))
        stop(str_glue("Error at {error_at}th"))
      } else {
        return(f(x))
      }
  }

# 実行例

map(long_list, f2)
```

```
## Error in .f(.x[[i]], ...): Error at 5th
```

```r
#> Error in .f(.x[[i]], ...) : Error at 5th
```

関数を毎度作り直すのは手間なので、以下のようなwrapper関数を作る。


```r
error_index <-
  function(FUN, ...){
    arg.names <- as.list(formals(FUN))
    arg.names[["..."]] <- NULL
    arg.names <- names(arg.names)
    
    FUN2 <- function() {
      
      args <-
        lapply(as.list(match.call())[-1L], eval, parent.frame())

      try_FUN <-
        try(do.call(FUN, args = list(eval(parse(text = args)))), silent = T)

      if(class(try_FUN) == "try-error"){
        error_at <-
          eval(parse(text = "i"), envir = parent.frame())

        stop(str_glue("Error at {error_at}th element."))
      } else {
        do.call(FUN, args = list(eval(parse(text = args))))
      }
    }
     
    formals(FUN2) <- formals(FUN)
    
    return(FUN2)
  }
```


このwrapperを使えば、

```r
# 実行例

map(long_list, error_index(f))
```

```
## Error in .f(.x[[i]], ...): Error at 5th element.
```

```r
#> Error in .f(.x[[i]], ...) : Error at 5th


lst(a = c(5, 5, 1), b = c(10, NA, 0)) %>%
  map(error_index(mean, na.rm = T))
```

```
## $a
## [1] 3.666667
## 
## $b
## [1] NA
```
`do.call`、`eval(parse(text = ...))`周りが汚いがOK。

#### 参考

<sup>1</sup>: 粒度を小さくするのが正しいアプローチではあるが...  
<sup>2</sup>: [Get the name of a list item created with purrr::map](https://stackoverflow.com/questions/46909874/get-the-name-of-a-list-item-created-with-purrrmap)  


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
##  date     2018-03-25
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
##  digest       0.6.13     2017-12-14 cran (@0.6.13)                    
##  dplyr      * 0.7.4      2017-09-28 cran (@0.7.4)                     
##  evaluate     0.10.1     2017-06-24 cran (@0.10.1)                    
##  forcats    * 0.2.0      2017-01-23 CRAN (R 3.3.2)                    
##  ggplot2    * 2.2.1.9000 2018-02-13 Github (thomasp85/ggplot2@7859a29)
##  glue         1.2.0      2017-10-29 cran (@1.2.0)                     
##  gtable       0.2.0      2016-02-26 CRAN (R 3.3.1)                    
##  haven        1.1.0      2017-07-09 CRAN (R 3.3.2)                    
##  hms          0.3        2016-11-22 CRAN (R 3.3.1)                    
##  httr         1.3.1      2017-08-20 CRAN (R 3.3.2)                    
##  jsonlite     1.5        2017-06-01 cran (@1.5)                       
##  knitr        1.17       2017-08-10 cran (@1.17)                      
##  lattice      0.20-33    2015-07-14 CRAN (R 3.3.1)                    
##  lazyeval     0.2.1      2017-10-29 cran (@0.2.1)                     
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
##  readxl       1.0.0      2017-04-18 CRAN (R 3.3.2)                    
##  reshape2     1.4.3      2017-12-11 cran (@1.4.3)                     
##  rlang        0.1.6.9003 2018-02-13 Github (tidyverse/rlang@616fd4d)  
##  rstudioapi   0.7        2017-09-07 CRAN (R 3.3.2)                    
##  rvest        0.3.2      2016-06-17 CRAN (R 3.3.0)                    
##  scales       0.5.0.9000 2017-12-23 Github (hadley/scales@d767915)    
##  stringi      1.1.6      2017-11-17 CRAN (R 3.3.2)                    
##  stringr    * 1.3.0      2018-02-19 CRAN (R 3.3.1)                    
##  tibble     * 1.3.4      2017-08-22 cran (@1.3.4)                     
##  tidyr      * 0.8.0      2018-01-29 CRAN (R 3.3.1)                    
##  tidyverse  * 1.2.1      2017-11-14 CRAN (R 3.3.1)                    
##  withr        2.1.1.9000 2017-12-23 Github (jimhester/withr@df18523)  
##  xml2         1.1.1      2017-01-24 cran (@1.1.1)
```
