---
title: "データフレームからのベクトル出力"
output: html_document
layout: post
tags: R memo dplyr
---



### dplyr::selectでvector出力はできない (メモ


```r
# デフォルトの列選択
iris[, "Species"] %>%
  head
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```

```r
# データフレーム構造を維持
iris[, "Species", drop = F] %>%
  head
```

```
##   Species
## 1  setosa
## 2  setosa
## 3  setosa
## 4  setosa
## 5  setosa
## 6  setosa
```

と同じイメージで`dplyr::select`でデータフレームからベクトルを取り出そうとして、よく怒られる  

```r
iris %>%
  select(Species, drop = T)
```

```
## Error: All select() inputs must resolve to integer column positions.
## The following do not:
## *  T
```

[Hadley Wickham (dplyrの作成者) が書いている](http://stackoverflow.com/questions/21618423/extract-a-dplyr-tbl-column-as-a-vector)とおり、`dplyr::select`にはデータフレームからベクトルを出力する仕様はない

上のページを見ていると、「`magrittr::extract2`が便利だよ」とあった  

```r
iris %>%
  magrittr::extract2(5) %>%
  head
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```

```r
iris %>%
  magrittr::extract2("Species") %>%
  head
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```


複数列に対する挙動が変なので`extract2`の中身を見てみたら、がっかりした  

```r
iris %>%
  magrittr::extract2(4:5)
```

```
## [1] 0.2
```

```r
print(extract2)
```

```
## .Primitive("[[")
```

#### 参考  
[Extract a dplyr tbl column as a vector (Stack Overflow)](http://stackoverflow.com/questions/21618423/extract-a-dplyr-tbl-column-as-a-vector)  


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
##  date     2016-03-20
```

```
## Packages ------------------------------------------------------------------
```

```
##  package    * version date       source        
##  assertthat   0.1     2013-12-06 CRAN (R 3.1.0)
##  DBI          0.3.1   2014-09-24 CRAN (R 3.1.1)
##  devtools     1.9.1   2015-09-11 CRAN (R 3.2.0)
##  digest       0.6.8   2014-12-31 CRAN (R 3.1.2)
##  dplyr      * 0.4.3   2015-09-01 CRAN (R 3.1.3)
##  evaluate     0.8     2015-09-18 CRAN (R 3.1.3)
##  formatR      1.2.1   2015-09-18 CRAN (R 3.1.3)
##  knitr        1.11    2015-08-14 CRAN (R 3.2.3)
##  lazyeval     0.1.10  2015-01-02 CRAN (R 3.1.2)
##  magrittr   * 1.5     2014-11-22 CRAN (R 3.1.2)
##  memoise      0.2.1   2014-04-22 CRAN (R 3.1.0)
##  R6           2.1.1   2015-08-19 CRAN (R 3.1.3)
##  Rcpp         0.12.2  2015-11-15 CRAN (R 3.1.3)
##  stringi      1.0-1   2015-10-22 CRAN (R 3.1.3)
##  stringr      1.0.0   2015-04-30 CRAN (R 3.1.3)
```
