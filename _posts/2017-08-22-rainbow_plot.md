---
title: "波長に応じた色でプロットする (R"
output: html_document
layout: post  
tags: lab R ggplot2
---

研究でしばしば波長に関係するデータを出すため、波長に応じた色でプロットしたい場合が多い。

波長から色の変換の各種定数は、[このページ](http://www.natural-science.or.jp/article/20160513143413.php)から。文字列から色コードへの変換が汚いが、いちおうOK。

#### 関数


```r
library(tidyverse)
library(stringr)

lambda2color <-
  Vectorize(
    function(lambda){
      # central wavelength [nm]
      central <- 
        c(red = 700.0,
          green = 546.1,
          blue = 435.8,
          orange = 605.0,
          yellow = 580.0,
          cyan = 490.0,
          purple = 400.0)
  
      # half width [nm]
      half_width <-
        c(red = 90,
          green = 80,
          blue = 80,
          orange = 60,
          yellow = 50,
          cyan = 50,
          purple = 40)
  
      # intensity of seven colors
      intensity <-
        c(red = .95,
          green = .74,
          blue = .75,
          orange = .40,
          yellow = .10,
          cyan = .30,
          purple = .30)
  
      norms <-
        intensity * exp( - (lambda - central)^2 / half_width^2)
      
      r <- sum(norms[c("red", "orange", "purple")])
      g <- sum(norms[c("green", "orange", "yellow", "cyan", "purple")] * c(1, .715, .83, 1, .5))
      b <- sum(norms[c("blue", "orange", "cyan", "purple")] * c(1, .23, 1, 1))
      
      r_8bit <- min(255, round(r*255, 0))
      g_8bit <- min(255, round(g*255, 0))
      b_8bit <- min(255, round(b*255, 0))
      
      # to hexadecimal
      
      to_hex <-
        function(x){
          hexed <-
            as.hexmode(x) %>%
            as.character
          if(str_count(hexed) == 1){
            paste0("0", hexed) %>% return
          } else {
            hexed
          }
        }
      
      # #rrggbb
      paste0("#", to_hex(r_8bit), to_hex(g_8bit), to_hex(b_8bit)) %>%
        return
    }
  )

color_scale_bar <-
  function(wavelength, y, ...){
    lapply(wavelength, function(i){
      annotate(geom = "point", x = i, y = y, col = lambda2color(i), ...)
    })
  }
```

#### デモ


```r
test_df <-
  data_frame(wavelength = 400:800, value = sin(wavelength/2 / pi))

test_df %>%
  ggplot(aes(x = wavelength, y = value, col = factor(wavelength))) +
  guides(col = F) +
  geom_point() +
  geom_line(aes(group = NA)) +
  scale_color_manual(values = lambda2color(test_df$wavelength))
```

![plot of chunk demo](/figure/source/2017-08-22-rainbow_plot/demo-1.png)

```r
test_df %>%
  ggplot(aes(x = wavelength, y = value)) +
  guides(col = F) +
  geom_point() +
  geom_line(aes(group = NA)) +
  color_scale_bar(wavelength = 400:800, y = -1)
```

![plot of chunk demo](/figure/source/2017-08-22-rainbow_plot/demo-2.png)


#### 参考ページ  

[光の波長からRGBを算出する関数の定義](http://www.natural-science.or.jp/article/20160513143413.php)  


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
##  date     2017-08-22
```

```
## Packages ------------------------------------------------------------------
```

```
##  package    * version    date       source                            
##  assertthat   0.2.0      2017-04-11 cran (@0.2.0)                     
##  bindr        0.1        2016-11-13 cran (@0.1)                       
##  bindrcpp     0.2        2017-06-17 CRAN (R 3.3.2)                    
##  broom        0.4.1      2016-06-24 CRAN (R 3.3.0)                    
##  cellranger   1.1.0      2016-07-27 cran (@1.1.0)                     
##  colorspace   1.2-6      2015-03-11 CRAN (R 3.3.1)                    
##  devtools     1.12.0     2016-06-24 CRAN (R 3.3.0)                    
##  digest       0.6.12     2017-01-27 cran (@0.6.12)                    
##  dplyr      * 0.7.2      2017-07-20 cran (@0.7.2)                     
##  evaluate     0.10.1     2017-06-24 cran (@0.10.1)                    
##  forcats      0.2.0      2017-01-23 CRAN (R 3.3.2)                    
##  ggplot2    * 2.2.1.9000 2017-08-08 Github (tidyverse/ggplot2@53a22cd)
##  glue         1.1.1      2017-06-21 cran (@1.1.1)                     
##  gtable       0.2.0      2016-02-26 CRAN (R 3.3.1)                    
##  haven        1.0.0      2016-09-23 CRAN (R 3.3.0)                    
##  highr        0.6        2016-05-09 CRAN (R 3.3.1)                    
##  hms          0.3        2016-11-22 CRAN (R 3.3.1)                    
##  httr         1.2.1      2016-07-03 CRAN (R 3.3.0)                    
##  jsonlite     1.5        2017-06-01 cran (@1.5)                       
##  knitr        1.16       2017-05-18 cran (@1.16)                      
##  labeling     0.3        2014-08-23 CRAN (R 3.3.1)                    
##  lattice      0.20-33    2015-07-14 CRAN (R 3.3.1)                    
##  lazyeval     0.2.0      2016-06-12 CRAN (R 3.3.1)                    
##  lubridate    1.6.0      2016-09-13 CRAN (R 3.3.0)                    
##  magrittr     1.5        2014-11-22 CRAN (R 3.3.1)                    
##  memoise      1.0.0      2016-01-29 CRAN (R 3.3.1)                    
##  mnormt       1.5-4      2016-03-09 CRAN (R 3.3.0)                    
##  modelr       0.1.0      2016-08-31 CRAN (R 3.3.0)                    
##  munsell      0.4.3      2016-02-13 CRAN (R 3.3.1)                    
##  nlme         3.1-128    2016-05-10 CRAN (R 3.3.1)                    
##  pkgconfig    2.0.1      2017-03-21 cran (@2.0.1)                     
##  plyr         1.8.4      2016-06-08 CRAN (R 3.3.1)                    
##  psych        1.6.6      2016-06-28 CRAN (R 3.3.0)                    
##  purrr      * 0.2.3      2017-08-02 cran (@0.2.3)                     
##  R6           2.2.2      2017-06-17 cran (@2.2.2)                     
##  Rcpp         0.12.12    2017-07-15 cran (@0.12.12)                   
##  readr      * 1.0.0      2016-08-03 CRAN (R 3.3.0)                    
##  readxl       1.0.0      2017-04-18 cran (@1.0.0)                     
##  reshape2     1.4.2      2016-10-22 cran (@1.4.2)                     
##  rlang        0.1.1      2017-05-18 cran (@0.1.1)                     
##  rvest        0.3.2      2016-06-17 CRAN (R 3.3.0)                    
##  scales       0.4.1.9002 2017-08-09 Github (hadley/scales@4bc0ccb)    
##  stringi      1.1.5      2017-04-07 cran (@1.1.5)                     
##  stringr    * 1.2.0      2017-02-18 cran (@1.2.0)                     
##  tibble     * 1.3.3      2017-05-28 cran (@1.3.3)                     
##  tidyr      * 0.6.3      2017-05-15 cran (@0.6.3)                     
##  tidyverse  * 1.1.1      2017-01-27 CRAN (R 3.3.2)                    
##  withr        2.0.0      2017-08-08 Github (jimhester/withr@190d293)  
##  xml2         1.1.1      2017-01-24 cran (@1.1.1)
```
