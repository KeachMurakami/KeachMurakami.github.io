---
title: "revealjsでincrementalに図を表示する (R"
output: html_document
layout: post
tags: lab R revealjs presentation
---



{revealjs}メモ

最近は基本的に[`revealjs`](https://github.com/hakimel/reveal.js/)でスライドを作るようにしている。スライド内で、差分的に画像を出したい場合のメモ (点プロットで散布図 -> 回帰直線を追加、など)。


```r
fig1 <-
  ggplot2::ggplot(iris, aes(Sepal.Length, Petal.Length, col = Species, group = Species)) +
  ggplot2::geom_point()

fig2 <-
  fig1 +
  ggplot2::geom_smooth(method = "lm")

cowplot::plot_grid(fig1, fig2)
```

![plot of chunk unnamed-chunk-1](/figure/source/2018-03-19-frame_by_frame_fig_in_reveal/unnamed-chunk-1-1.png)

以下のように、rmarkdown上で直接htmlタグを入れてもいいが、面倒。

```
 # <!-- 先に領域を作る -->
 # <div style="position:relative; top:0px; width:800px; height:600px; margin:0 auto;">
 # <!-- 領域内で同じ絶対位置にプロット -->
 # <div style="position:absolute;top:0;left:0;" class = "fragment" data-fragment-index="1">
 # ```{r}
 # fig1
 # ```
 # </div>
 # <div style="position:absolute;top:0;left:0;" class = "fragment" data-fragment-index="3">
 # ```{r}
 # fig2
 # ```
 # </div>
 # </div>
 # 
 # <div class="fragment" data-fragment-index="2">- 散布</divs>
 # <div class="fragment" data-fragment-index="4">- 回帰</div>
```

`knitr`の`hook`で解決する。


```r
hook_fragment <-
  function(before, options, envir) {
    if (before) {
      before_chunk <- paste0("<div class='fragment' data-fragment-index='", options$fragment,"' style='position:absolute;top:0;left:0'>")
    } else {
      after_chunk <- "</div>"
      ## code to be run after a chunk
    }
}
knitr::knit_hooks$set(fragment = hook_fragment)
```


```
# <div style="position:relative; top:0px; width:800px; height:600px; margin:0 auto;">
# ```{r fragment = "1", echo = F}
# fig1
# ```
# ```{r fragment = "3", echo = F}
# fig2
# ```
# </div>
# 
# <div class="fragment" data-fragment-index="2">- 散布</divs>
# <div class="fragment" data-fragment-index="4">- 回帰</div>
```


```
## Error in source("https://raw.githubusercontent.com/KeachMurakami/KeachMurakami.github.io/master/_supplemental/demo/reveal_frame_by_frame_figure.html"): https://raw.githubusercontent.com/KeachMurakami/KeachMurakami.github.io/master/_supplemental/demo/reveal_frame_by_frame_figur:1:1: unexpected '<'
## 1: <
##     ^
```

```
## Warning in download.file(url = "https://raw.githubusercontent.com/
## KeachMurakami/KeachMurakami.github.io/master/_supplemental/
## demo/reveal_frame_by_frame_figure.html", : URL https://
## raw.githubusercontent.com/KeachMurakami/KeachMurakami.github.io/master/
## _supplemental/demo/reveal_frame_by_frame_figure.html: cannot open destfile
## './figure/source/2018-03-19-frame_by_frame_fig_in_reveal/demo.html', reason
## 'No such file or directory'
```

```
## Warning in download.file(url = "https://raw.githubusercontent.com/
## KeachMurakami/KeachMurakami.github.io/master/_supplemental/demo/
## reveal_frame_by_frame_figure.html", : downloaded length 0 != reported
## length 1546074
```

```
## Error in download.file(url = "https://raw.githubusercontent.com/KeachMurakami/KeachMurakami.github.io/master/_supplemental/demo/reveal_frame_by_frame_figure.html", : cannot download all files
```

<iframe src="source/2018-03-19-frame_by_frame_fig_in_reveal/demo.html" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> minimalなRmdファイル -> <strong> <a href="https://github.com/KeachMurakami/KeachMurakami.github.io/blob/master/_supplemental/demo/reveal_frame_by_frame_figure.Rmd" title="reveal_frame_by_frame_figure.Rmd" target="_blank">.Rmd</a> </strong></div>


#### 参考

[hakimel/reveal.js](https://github.com/hakimel/reveal.js/)  
[Hooks](https://yihui.name/knitr/hooks/)  


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
##  colorspace   1.2-6      2015-03-11 CRAN (R 3.3.1)                    
##  cowplot      0.9.1      2017-11-16 CRAN (R 3.3.2)                    
##  devtools     1.12.0     2016-06-24 CRAN (R 3.3.0)                    
##  digest       0.6.13     2017-12-14 cran (@0.6.13)                    
##  evaluate     0.10.1     2017-06-24 cran (@0.10.1)                    
##  ggplot2    * 2.2.1.9000 2018-02-13 Github (thomasp85/ggplot2@7859a29)
##  gtable       0.2.0      2016-02-26 CRAN (R 3.3.1)                    
##  highr        0.6        2016-05-09 CRAN (R 3.3.1)                    
##  knitr        1.17       2017-08-10 cran (@1.17)                      
##  labeling     0.3        2014-08-23 CRAN (R 3.3.1)                    
##  lazyeval     0.2.1      2017-10-29 cran (@0.2.1)                     
##  magrittr     1.5        2014-11-22 CRAN (R 3.3.1)                    
##  memoise      1.0.0      2016-01-29 CRAN (R 3.3.1)                    
##  munsell      0.4.3      2016-02-13 CRAN (R 3.3.1)                    
##  plyr         1.8.4      2016-06-08 CRAN (R 3.3.1)                    
##  Rcpp         0.12.14    2017-11-23 cran (@0.12.14)                   
##  rlang        0.1.6.9003 2018-02-13 Github (tidyverse/rlang@616fd4d)  
##  scales       0.5.0.9000 2017-12-23 Github (hadley/scales@d767915)    
##  stringi      1.1.6      2017-11-17 CRAN (R 3.3.2)                    
##  stringr      1.3.0      2018-02-19 CRAN (R 3.3.1)                    
##  tibble       1.3.4      2017-08-22 cran (@1.3.4)                     
##  withr        2.1.1.9000 2017-12-23 Github (jimhester/withr@df18523)
```
