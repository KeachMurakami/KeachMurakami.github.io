---
title: "knitr figure"
output: html_document
layout: post
tags: lab knitr memo R
---

## knitr + rmarkdown での作図出力に関するメモ

### knitr + rmarkdownで図の大きさ調節

- fig.width/height
    - 図のプロットのサイズ
    - インチ単位
- out.width/height
    - 図を出力した際のサイズ
    - 拡大/縮小コピー的な
        - LaTeX: .8\\linewidth, 3in, 8cm, 40% (= 0.4\linewidth)...
        - HTML: 300px, 5cm, 3in, 40%...
- out.extra
    - out.extra='angle=90'など
    - 任意文字を引数として受け取るので、自由に編集できるらしい
    - html images にも使える (extra options will be written into the <img /> tag, e.g. out.extra='style="display:block;"')


```r
# {r, fig.width = 5, fig.height = 5, out.width = '50%'}
plot(sin(1:100), type = "l")
```

<img src="/figure/source/2016-08-01-FigsinKnitr/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="50%" />


```r
# {r, fig.width = 2, fig.height = 2, out.width = '50%'}
# 小さく書いたのを拡大するイメージ
plot(sin(1:100), type = "l")
```

<img src="/figure/source/2016-08-01-FigsinKnitr/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="50%" />


```r
# {r, fig.width = 7, fig.height = 7, out.width = '50%'}
# 大きく書いたのを縮小するイメージ
plot(sin(1:100), type = "l")
```

<img src="/figure/source/2016-08-01-FigsinKnitr/unnamed-chunk-3-1.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="50%" />


### 図のキャプションにhtmlタグを直打ちする

図のキャプションに特殊文字、上付き文字、斜体を使う場合など  
chunk optionにそのままhtmlタグ入りの文字列を入れると、`fig.cap`以下の引数が無視される  


```r
caption_html <- 
  "with html tag <i>test</i><sup>test</sup>."
caption_plain <- 
  "without html tag testtest."

knitr::opts_chunk$set(fig.width = 5)
```

htmlタグなしの場合のhtmlのソース  
`{r, fig.cap = caption_plain}`  

```
<img src="略=" alt="without html tag testtest." width="480">
<p class="caption">
without html tag testtest.
</p>
```


htmlタグありの場合のhtmlのソース  
`{r, fig.cap = caption_html}`  
`.&quot;`のあたりでタグがコンタミしているため、fig.widthに引数が届いていない  

```
<img src="略=" alt="with html tag &lt;i&gt;test&lt;/i&gt;&lt;sup&gt;test&lt;/sup&gt;.&quot; width=“480” /&gt;
&lt;p class=" caption">
with html tag <i>test</i><sup>test</sup>.
</p>
```

こういうときのために`knit_hooks`がある  
chunkの表示だったり実行だったりを自分好みにする  
setup chunkで読み込むのがよい  


```r
knitr::knit_hooks$set(html.cap = function(before, options, envir) {
  if(!before) {
    paste0('<p class="caption">', options$html.cap, "</p>")
  }
})
```

hookしたタグありの場合のhtmlのソース  
`{r, html.cap = caption_html}`

```
<img src="略=" width="480" />
<p class="caption">
with html tag <i>test</i><sup>test</sup>.
</p>
```


### ローカルの画像を直接貼り付ける

Drawソフトで書いた画像、あるいは写真を貼付ける、といった場合、２つの方法がある

1. html部にmarkdown記法 (直書き)  
html部に`![図のキャプション](/path/to/image)`と直書きする
図のキャプションをhtml書きしないといけなかったり、変数として扱えなかったり、と面倒が多い  

2. chunk内にknitr::include_graphics  

```r
knitr::include_graphics(path = "path/to/image")
```


#### 参考ページ  
[R markdown(knitr)パッケージのchunk optionまとめ](http://d.hatena.ne.jp/teramonagi/20130615/1371303616)  
[Chunk options and package options](http://yihui.name/knitr/options/)  
[caption in the html output of knitr](http://stackoverflow.com/questions/15010732/caption-in-the-html-output-of-knitr)  
[How to set size for local image using knitr for markdown?](http://stackoverflow.com/questions/15625990/how-to-set-size-for-local-image-using-knitr-for-markdown)  


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
##  date     2016-08-01
```

```
## Packages ------------------------------------------------------------------
```

```
##  package  * version date       source        
##  devtools   1.9.1   2015-09-11 CRAN (R 3.2.0)
##  digest     0.6.8   2014-12-31 CRAN (R 3.1.2)
##  evaluate   0.8     2015-09-18 CRAN (R 3.1.3)
##  formatR    1.2.1   2015-09-18 CRAN (R 3.1.3)
##  knitr      1.13.1  2016-05-26 local         
##  magrittr   1.5     2014-11-22 CRAN (R 3.1.2)
##  memoise    0.2.1   2014-04-22 CRAN (R 3.1.0)
##  stringi    1.0-1   2015-10-22 CRAN (R 3.1.3)
##  stringr    1.0.0   2015-04-30 CRAN (R 3.1.3)
```
