
# expression関数内に変数を動的に組み込みたかった話  

研究生活では、図を書くことが多い  
例えば以下のような図  


```r
plot1 <-
  data_frame(x = seq(from = 0, to = 100, length.out = 500), y = log(x) + rnorm(500, 0, 0.1)) %>%
  ggplot(aes(x = x, y = y)) +
  theme_bw(base_size = 20, base_family = "serif") +
  geom_point(alpha = .5)

plot1 +
  xlab(expression(paste("Light intensity ["  * mu * "mol" ~ m^-2 ~ s^-1 * "]"))) +
  ylab(expression(paste("Net photosynthetic rate [" * mu * "mol" ~ m^-2 ~ s^-1 * "]")))
```

![plot of chunk unnamed-chunk-1](/figure/source/2016-02-01-Label-ggplot/unnamed-chunk-1-1.png) 
  
光の強さ (PPFD) に応じて、葉の光合成速度が大きくなるなど  
似たような単位で似たような図をたくさん書く  

単位によく現れるギリシャ文字、上・下付き、イタリックといった書式を  
サポートするのは、expression関数だ  

この関数の書体の指定はword使いの僕にはしんどい  
なので、軸のテキスト部分を変数化して楽をしようとした   


#### しかし、expression関数の中では文字列を評価してくれない

```r
labeler1 <- function(text){
  expression(paste(text ~ "["  * mu * "mol" ~ m^-2 ~ s^-1 * "]"))
}
plot1 + xlab(labeler1("value2"))
```

![plot of chunk unnamed-chunk-2](/figure/source/2016-02-01-Label-ggplot/unnamed-chunk-2-1.png) 

#### pasteを先に実行すると、`mu`がないことを怒られる  

```r
paste(text, "[", mu, "g", m^-2, "]") %>% expression
```

```
## Error in paste(text, "[", mu, "g", m^-2, "]"): object 'mu' not found
```

遅延評価 (lazy evaluation)、変数の作る環境あたりが原因だということはわかった  

#### どうすればいいのか  
`base::bquote()`でいけた

```r
labeler2 <- function(text){
  bquote(.(text) ~ "["  * mu * "mol" ~ m^-2 ~ s^-1 * "]")
}
plot1 + xlab(labeler2("Light intensity")) + ylab(labeler2("Net photosynthetic rate"))   
```

![plot of chunk unnamed-chunk-4](/figure/source/2016-02-01-Label-ggplot/unnamed-chunk-4-1.png) 


bquote内では、.(変数)とすることで、変数を受け取ることができる  
それ以外は概ねexpressionと同じ使い方  
文字間を詰める場合は*で、スペースを開ける場合には~で結合  

```r
plot(0, 0, type = "n", xlim = c(0, 1), ylim = c(0, 4), xlab = "", ylab = "")

moji <- letters

par(family = "Times New Roman")
text(.5, 3, labels = bquote(.(moji[1]) ~ "[" * mu * "g" ~ m^-2 * "]"), cex = 2)
text(.5, 2, labels = bquote(.(moji[2]) ~ "[" ~ mu ~ "g" ~ m^-2 ~ "]"), cex = 2)
text(.5, 1, labels = bquote(.(moji[3]) ~ "[" ~~ mu ~~ "g" ~ m^-2 ~~ "]"), cex = 2)
```

![plot of chunk bquoteExamples](/figure/source/2016-02-01-Label-ggplot/bquoteExamples-1.png) 

#### 以下、bquoteの使い方の曖昧和訳
> ### bquote {base}  
> expression関数に部分的に変数をいれる  
> 
> #### 概要
> LISPのbackquote macroに似たやつ  
> .()で囲われた部分以外を引数whereで指定された環境の下で評価する    
> 
> #### 使用法
> bquote(expr, where = parent.frame())
> 
> #### 引数
> expr: 言語オブジェクト (name, call, expression)
> where: 言語オブジェクトを評価する環境
> [https://stat.ethz.ch/R-manual/R-devel/library/base/html/bquote.html]  


未消化気味ではあるが、Rと少し仲良くなれた気がする  
言語オブジェクト→ 
  [http://d.hatena.ne.jp/tsutatsutatsuta/20120114/1326542583]


## expression関数で同じことできないの？
要勉強



```r
sessionInfo()
```

```
## R version 3.2.3 (2015-12-10)
## Platform: x86_64-apple-darwin14.5.0 (64-bit)
## Running under: OS X 10.11.3 (El Capitan)
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] methods   grid      stats     graphics  grDevices utils     datasets 
## [8] base     
## 
## other attached packages:
##  [1] RCurl_1.95-4.7     bitops_1.0-6       slackr_1.3.1.9001 
##  [4] tidyr_0.3.1        devtools_1.9.1     pforeach_1.3      
##  [7] scales_0.3.0       lubridate_1.5.0    data.table_1.9.6  
## [10] stringr_1.0.0      agricolae_1.2-3    magrittr_1.5      
## [13] gridExtra_2.0.0    foreach_1.4.3      gtable_0.1.2      
## [16] knitr_1.11         xlsx_0.5.7         xlsxjars_0.6.1    
## [19] rJava_0.9-7        reshape2_1.4.1     dplyr_0.4.3       
## [22] plyr_1.8.3         RColorBrewer_1.1-2 ggplot2_2.0.0     
## [25] MASS_7.3-45       
## 
## loaded via a namespace (and not attached):
##  [1] splines_3.2.3     lattice_0.20-33   colorspace_1.2-6 
##  [4] AlgDesign_1.1-7.3 chron_2.3-47      DBI_0.3.1        
##  [7] sp_1.2-1          registry_0.3      rngtools_1.2.4   
## [10] doRNG_1.6         pkgmaker_0.22     munsell_0.4.2    
## [13] combinat_0.0-8    codetools_0.2-14  coda_0.18-1      
## [16] evaluate_0.8      memoise_0.2.1     labeling_0.3     
## [19] doParallel_1.0.10 parallel_3.2.3    spdep_0.5-92     
## [22] Rcpp_0.12.2       xtable_1.8-0      formatR_1.2.1    
## [25] jsonlite_0.9.19   deldir_0.1-9      klaR_0.6-12      
## [28] digest_0.6.8      stringi_1.0-1     tools_3.2.3      
## [31] LearnBayes_2.15   lazyeval_0.1.10   cluster_2.0.3    
## [34] Matrix_1.2-3      assertthat_0.1    httr_1.0.0       
## [37] iterators_1.0.8   R6_2.1.1          boot_1.3-17      
## [40] nlme_3.1-122
```
