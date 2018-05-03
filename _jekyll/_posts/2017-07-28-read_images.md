---
title: "Rの画像読込が遅い"
output: html_document
layout: post
tags: lab R memo
---


```
## Warning: package 'tidyverse' was built under R version 3.3.2
```

```
## Warning: package 'ggplot2' was built under R version 3.3.2
```

```
## Warning: package 'tibble' was built under R version 3.3.2
```

```
## Warning: package 'tidyr' was built under R version 3.3.2
```

```
## Warning: package 'stringr' was built under R version 3.3.2
```

```
##  setting  value                       
##  version  R version 3.3.1 (2016-06-21)
##  system   x86_64, darwin13.4.0        
##  ui       X11                         
##  language (EN)                        
##  collate  en_US.UTF-8                 
##  tz       Asia/Tokyo                  
##  date     2017-07-30                  
## 
##  package    * version date       source                                
##  assertthat   0.1     2013-12-06 CRAN (R 3.3.1)                        
##  broom      * 0.4.1   2016-06-24 CRAN (R 3.3.0)                        
##  cellranger   1.1.0   2016-07-27 cran (@1.1.0)                         
##  colorspace   1.2-6   2015-03-11 CRAN (R 3.3.1)                        
##  DBI          0.4-1   2016-05-08 CRAN (R 3.3.1)                        
##  devtools   * 1.12.0  2016-06-24 CRAN (R 3.3.0)                        
##  digest       0.6.12  2017-01-27 cran (@0.6.12)                        
##  dplyr      * 0.5.0   2016-06-24 CRAN (R 3.3.0)                        
##  evaluate     0.10    2016-10-11 cran (@0.10)                          
##  forcats      0.2.0   2017-01-23 CRAN (R 3.3.2)                        
##  fudukue    * 0.1.0   2017-07-13 Github (KeachMurakami/fudukue@f9e3505)
##  ggplot2    * 2.2.1   2016-12-30 CRAN (R 3.3.2)                        
##  gtable       0.2.0   2016-02-26 CRAN (R 3.3.1)                        
##  haven        1.0.0   2016-09-23 CRAN (R 3.3.0)                        
##  hms          0.3     2016-11-22 CRAN (R 3.3.1)                        
##  httr         1.2.1   2016-07-03 CRAN (R 3.3.0)                        
##  jsonlite     1.5     2017-06-01 cran (@1.5)                           
##  knitr      * 1.15.1  2016-11-22 cran (@1.15.1)                        
##  lattice      0.20-33 2015-07-14 CRAN (R 3.3.1)                        
##  lazyeval     0.2.0   2016-06-12 CRAN (R 3.3.1)                        
##  lubridate  * 1.6.0   2016-09-13 CRAN (R 3.3.0)                        
##  magrittr   * 1.5     2014-11-22 CRAN (R 3.3.1)                        
##  memoise      1.0.0   2016-01-29 CRAN (R 3.3.1)                        
##  mnormt       1.5-4   2016-03-09 CRAN (R 3.3.0)                        
##  modelr       0.1.0   2016-08-31 CRAN (R 3.3.0)                        
##  munsell      0.4.3   2016-02-13 CRAN (R 3.3.1)                        
##  nlme         3.1-128 2016-05-10 CRAN (R 3.3.1)                        
##  plyr         1.8.4   2016-06-08 CRAN (R 3.3.1)                        
##  psych        1.6.6   2016-06-28 CRAN (R 3.3.0)                        
##  purrr      * 0.2.2   2016-06-18 CRAN (R 3.3.0)                        
##  R6           2.2.0   2016-10-05 cran (@2.2.0)                         
##  Rcpp         0.12.12 2017-07-15 cran (@0.12.12)                       
##  readr      * 1.0.0   2016-08-03 CRAN (R 3.3.0)                        
##  readxl       1.0.0   2017-04-18 cran (@1.0.0)                         
##  reshape2     1.4.2   2016-10-22 cran (@1.4.2)                         
##  rvest        0.3.2   2016-06-17 CRAN (R 3.3.0)                        
##  scales       0.4.1   2016-11-09 CRAN (R 3.3.2)                        
##  stringi      1.1.2   2016-10-01 cran (@1.1.2)                         
##  stringr    * 1.2.0   2017-02-18 cran (@1.2.0)                         
##  tibble     * 1.3.0   2017-04-01 cran (@1.3.0)                         
##  tidyr      * 0.6.1   2017-01-10 cran (@0.6.1)                         
##  tidyverse  * 1.1.1   2017-01-27 cran (@1.1.1)                         
##  withr        1.0.2   2016-06-20 CRAN (R 3.3.1)                        
##  xml2         1.1.1   2017-01-24 cran (@1.1.1)
```

Rで画像解析をしているが、遅い


```r
library(EBImage)
```

```
## 
## Attaching package: 'EBImage'
```

```
## The following object is masked from 'package:purrr':
## 
##     transpose
```

```r
library(imager)
```

```
## Warning: package 'imager' was built under R version 3.3.2
```

```
## Loading required package: plyr
```

```
## -------------------------------------------------------------------------
```

```
## You have loaded plyr after dplyr - this is likely to cause problems.
## If you need functions from both plyr and dplyr, please load plyr first, then dplyr:
## library(plyr); library(dplyr)
```

```
## -------------------------------------------------------------------------
```

```
## 
## Attaching package: 'plyr'
```

```
## The following object is masked from 'package:lubridate':
## 
##     here
```

```
## The following objects are masked from 'package:dplyr':
## 
##     arrange, count, desc, failwith, id, mutate, rename, summarise,
##     summarize
```

```
## The following object is masked from 'package:purrr':
## 
##     compact
```

```
## 
## Attaching package: 'imager'
```

```
## The following object is masked from 'package:plyr':
## 
##     liply
```

```
## The following objects are masked from 'package:EBImage':
## 
##     channel, dilate, display, erode, resize, watershed
```

```
## The following object is masked from 'package:stringr':
## 
##     boundary
```

```
## The following object is masked from 'package:magrittr':
## 
##     add
```

```
## The following object is masked from 'package:tidyr':
## 
##     fill
```

```
## The following objects are masked from 'package:stats':
## 
##     convolve, spectrum
```

```
## The following object is masked from 'package:graphics':
## 
##     frame
```

```
## The following object is masked from 'package:base':
## 
##     save.image
```

```r
library(raster)
```

```
## Loading required package: sp
```

```
## 
## Attaching package: 'sp'
```

```
## The following object is masked from 'package:imager':
## 
##     bbox
```

```
## 
## Attaching package: 'raster'
```

```
## The following objects are masked from 'package:EBImage':
## 
##     flip, rotate
```

```
## The following object is masked from 'package:magrittr':
## 
##     extract
```

```
## The following object is masked from 'package:dplyr':
## 
##     select
```

```
## The following object is masked from 'package:tidyr':
## 
##     extract
```

```r
img_path <- "~/Dropbox/KeachMurakami.github.io/images/2017-07-28/large_leaf.jpg"

# EBImage
system.time(readImage(img_path) %>% .@.Data %>% .[,,2])
```

```
##    user  system elapsed 
##   4.310   1.156   5.512
```

```r
# imager
system.time(load.image(img_path) %>% .[, , 1, 2])
```

```
##    user  system elapsed 
##   3.002   1.343   4.515
```

```r
# raster
system.time(brick(img_path) %>% as.matrix)
```

```
##    user  system elapsed 
##   2.812   1.164   4.089
```



```r
session_info()
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
##  date     2017-07-30
```

```
## Packages ------------------------------------------------------------------
```

```
##  package      * version date       source                                
##  abind          1.4-5   2016-07-21 CRAN (R 3.3.0)                        
##  assertthat     0.1     2013-12-06 CRAN (R 3.3.1)                        
##  BiocGenerics   0.20.0  2017-04-20 Bioconductor                          
##  bmp            0.2     2013-08-10 CRAN (R 3.3.0)                        
##  broom        * 0.4.1   2016-06-24 CRAN (R 3.3.0)                        
##  cellranger     1.1.0   2016-07-27 cran (@1.1.0)                         
##  colorspace     1.2-6   2015-03-11 CRAN (R 3.3.1)                        
##  DBI            0.4-1   2016-05-08 CRAN (R 3.3.1)                        
##  devtools     * 1.12.0  2016-06-24 CRAN (R 3.3.0)                        
##  digest         0.6.12  2017-01-27 cran (@0.6.12)                        
##  dplyr        * 0.5.0   2016-06-24 CRAN (R 3.3.0)                        
##  EBImage      * 4.16.0  2017-04-20 Bioconductor                          
##  evaluate       0.10    2016-10-11 cran (@0.10)                          
##  fftwtools      0.9-8   2017-03-25 CRAN (R 3.3.2)                        
##  forcats        0.2.0   2017-01-23 CRAN (R 3.3.2)                        
##  fudukue      * 0.1.0   2017-07-13 Github (KeachMurakami/fudukue@f9e3505)
##  ggplot2      * 2.2.1   2016-12-30 CRAN (R 3.3.2)                        
##  gtable         0.2.0   2016-02-26 CRAN (R 3.3.1)                        
##  haven          1.0.0   2016-09-23 CRAN (R 3.3.0)                        
##  hms            0.3     2016-11-22 CRAN (R 3.3.1)                        
##  httr           1.2.1   2016-07-03 CRAN (R 3.3.0)                        
##  imager       * 0.40.2  2017-04-24 CRAN (R 3.3.2)                        
##  jpeg           0.1-8   2014-01-23 CRAN (R 3.3.0)                        
##  jsonlite       1.5     2017-06-01 cran (@1.5)                           
##  knitr        * 1.15.1  2016-11-22 cran (@1.15.1)                        
##  lattice        0.20-33 2015-07-14 CRAN (R 3.3.1)                        
##  lazyeval       0.2.0   2016-06-12 CRAN (R 3.3.1)                        
##  locfit         1.5-9.1 2013-04-20 CRAN (R 3.3.0)                        
##  lubridate    * 1.6.0   2016-09-13 CRAN (R 3.3.0)                        
##  magrittr     * 1.5     2014-11-22 CRAN (R 3.3.1)                        
##  memoise        1.0.0   2016-01-29 CRAN (R 3.3.1)                        
##  mnormt         1.5-4   2016-03-09 CRAN (R 3.3.0)                        
##  modelr         0.1.0   2016-08-31 CRAN (R 3.3.0)                        
##  munsell        0.4.3   2016-02-13 CRAN (R 3.3.1)                        
##  nlme           3.1-128 2016-05-10 CRAN (R 3.3.1)                        
##  plyr         * 1.8.4   2016-06-08 CRAN (R 3.3.1)                        
##  png            0.1-7   2013-12-03 CRAN (R 3.3.0)                        
##  psych          1.6.6   2016-06-28 CRAN (R 3.3.0)                        
##  purrr        * 0.2.2   2016-06-18 CRAN (R 3.3.0)                        
##  R6             2.2.0   2016-10-05 cran (@2.2.0)                         
##  raster       * 2.5-8   2016-06-02 CRAN (R 3.3.0)                        
##  Rcpp           0.12.12 2017-07-15 cran (@0.12.12)                       
##  readbitmap     0.1-4   2014-09-05 CRAN (R 3.3.0)                        
##  readr        * 1.0.0   2016-08-03 CRAN (R 3.3.0)                        
##  readxl         1.0.0   2017-04-18 cran (@1.0.0)                         
##  reshape2       1.4.2   2016-10-22 cran (@1.4.2)                         
##  rgdal          1.2-8   2017-07-01 CRAN (R 3.3.2)                        
##  rstudioapi     0.6     2016-06-27 CRAN (R 3.3.1)                        
##  rvest          0.3.2   2016-06-17 CRAN (R 3.3.0)                        
##  scales         0.4.1   2016-11-09 CRAN (R 3.3.2)                        
##  sp           * 1.2-3   2016-04-14 CRAN (R 3.3.1)                        
##  stringi        1.1.2   2016-10-01 cran (@1.1.2)                         
##  stringr      * 1.2.0   2017-02-18 cran (@1.2.0)                         
##  tibble       * 1.3.0   2017-04-01 cran (@1.3.0)                         
##  tidyr        * 0.6.1   2017-01-10 cran (@0.6.1)                         
##  tidyverse    * 1.1.1   2017-01-27 cran (@1.1.1)                         
##  tiff           0.1-5   2013-09-04 CRAN (R 3.3.0)                        
##  withr          1.0.2   2016-06-20 CRAN (R 3.3.1)                        
##  xml2           1.1.1   2017-01-24 cran (@1.1.1)
```
