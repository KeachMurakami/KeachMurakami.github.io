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


```r
# htmlタグなし
# {r, fig.cap = caption_plain}

plot(1:10)
```

![without html tag testtest.](/figure/source/2016-08-01-FigsinKnitr/unnamed-chunk-5-1.png)

タグなしの場合のhtmlのソース


```html
<img src="略=" alt="without html tag testtest." width="480">
<p class="caption">
without html tag testtest.
</p>
```



```r
# hook + htmlタグ
# {r, fig.cap = caption_html}

plot(1:10)
```

![with html tag <i>test</i><sup>test</sup>.](/figure/source/2016-08-01-FigsinKnitr/unnamed-chunk-7-1.png)

タグありの場合のhtmlのソース  
`.&quot;`のあたりでタグがコンタミしているため、fig.widthに引数が届いていない  


```html
<img src="略=" alt="with html tag &lt;i&gt;test&lt;/i&gt;&lt;sup&gt;test&lt;/sup&gt;.&quot; width=“480” /&gt;
&lt;p class=" caption">
with html tag <i>test</i><sup>test</sup>.
</p>
```

こういうときのために`knit_hooks`がある  
chunkの表示だったり実行だったりを自分好みにする  
setup chunkで読み込むのがよい  


```r
# hook + htmlタグ
# {r, html.cap = caption_html}

knitr::knit_hooks$set(html.cap = function(before, options, envir) {
  if(!before) {
    paste0('<p class="caption">', options$html.cap, "</p>")
  }
})

plot(1:10)
```

![plot of chunk unnamed-chunk-9](/figure/source/2016-08-01-FigsinKnitr/unnamed-chunk-9-1.png)<p class="caption">with html tag <i>test</i><sup>test</sup>.</p>

hookしたタグありの場合のhtmlのソース  


```html
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
session_info()
```

```
## Error in eval(expr, envir, enclos): could not find function "session_info"
```
