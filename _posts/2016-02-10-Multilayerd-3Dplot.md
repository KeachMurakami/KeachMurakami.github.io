---
title: "Multilayered_3Dplot"
output: html_document
layout: page
categories: lab R 
---



# 多層の3Dプロットを作る (メモ

[英語で検索](https://www.google.co.jp/search?q=3D+plot+R+multilayer&source=lnms&tbm=isch&sa=X&ved=0ahUKEwiBrbXvle3KAhVEiKYKHXJNCQMQ_AUIBygB&biw=1280&bih=925)しても、[日本語で検索](https://www.google.co.jp/search?q=R+3%E6%AC%A1%E5%85%83+%E5%B1%A4&source=lnms&tbm=isch&sa=X&ved=0ahUKEwi9r7uJlu3KAhXCqaYKHfeED68Q_AUIBygB&biw=1280&bih=925)しても、[Rcmdrを用いた対話的な3D散布図](https://www1.doshisha.ac.jp/~mjin/R/39/39.html)くらいしか簡単に見つからなかったので (20160210現在)


#### データ作り

```r
df_3d <-
  data_frame(x = rep(1:20, each = 20),
             y = rep(1:20, times = 20),
             z1 = x + y + 0.5 * x * y,
             z2 = 5 * x + 3 * y - 0.5 * x * y) %>%
  tidyr::gather(group, z, -x, -y)

df_3d_group1 <-
  df_3d %>%
  filter(group == "z1")
df_3d_group2 <-
  df_3d %>%
  filter(group == "z2")

df_3d_group1 %>% str
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	400 obs. of  4 variables:
##  $ x    : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ y    : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ group: Factor w/ 2 levels "z1","z2": 1 1 1 1 1 1 1 1 1 1 ...
##  $ z    : num  2.5 4 5.5 7 8.5 10 11.5 13 14.5 16 ...
```

```r
df_3d_group2 %>% str
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	400 obs. of  4 variables:
##  $ x    : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ y    : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ group: Factor w/ 2 levels "z1","z2": 2 2 2 2 2 2 2 2 2 2 ...
##  $ z    : num  7.5 10 12.5 15 17.5 20 22.5 25 27.5 30 ...
```

#### グラフ作り
rglをjekyll生成のページに埋め込むのがきつそうなのでコードのみ

```r
library(rgl)

plot3d(df_3d_group1$x, df_3d_group1$y, df_3d_group1$z, zlim = c(-50, 250))
plot3d(df_3d_group2$x, df_3d_group2$y, df_3d_group2$z, col = "red", zlim = c(-50, 250))
```

曲面を追加する

```r
library(akima)

surf1 <- interp(df_3d_group1$x, df_3d_group1$y, df_3d_group1$z)
surf2 <- interp(df_3d_group2$x, df_3d_group2$y, df_3d_group2$z)

plot3d(df_3d_group1$x, df_3d_group1$y, df_3d_group1$z, col = "grey10", zlim = c(-50, 250))
plot3d(df_3d_group2$x, df_3d_group2$y, df_3d_group2$z, col = "red", zlim = c(-50, 250))

surface3d(surf1$x, surf1$y, surf1$z, col = "grey", alpha = .3)
surface3d(surf2$x, surf2$y, surf2$z, col = "red", alpha = .3)
```

#### 出力 (画像)
![surface](/figure/source/2016-02-10-Multilayerd-3Dplot/figs.svg) 

[参考: 不規則な間隔のデータ点を曲面プロットする](http://qiita.com/yohm13/items/204a2cf9a248ca0cf28a)


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
##  [1] rgl_0.95.1201      akima_0.5-12       RCurl_1.95-4.7    
##  [4] bitops_1.0-6       slackr_1.3.1.9001  tidyr_0.3.1       
##  [7] devtools_1.9.1     pforeach_1.3       scales_0.3.0      
## [10] lubridate_1.5.0    data.table_1.9.6   stringr_1.0.0     
## [13] agricolae_1.2-3    magrittr_1.5       gridExtra_2.0.0   
## [16] foreach_1.4.3      gtable_0.1.2       knitr_1.11        
## [19] xlsx_0.5.7         xlsxjars_0.6.1     rJava_0.9-7       
## [22] reshape2_1.4.1     dplyr_0.4.3        plyr_1.8.3        
## [25] RColorBrewer_1.1-2 ggplot2_2.0.0      MASS_7.3-45       
## 
## loaded via a namespace (and not attached):
##  [1] splines_3.2.3     lattice_0.20-33   colorspace_1.2-6 
##  [4] AlgDesign_1.1-7.3 chron_2.3-47      DBI_0.3.1        
##  [7] sp_1.2-1          registry_0.3      rngtools_1.2.4   
## [10] doRNG_1.6         pkgmaker_0.22     munsell_0.4.2    
## [13] combinat_0.0-8    codetools_0.2-14  coda_0.18-1      
## [16] evaluate_0.8      memoise_0.2.1     doParallel_1.0.10
## [19] parallel_3.2.3    spdep_0.5-92      Rcpp_0.12.2      
## [22] xtable_1.8-0      formatR_1.2.1     jsonlite_0.9.19  
## [25] deldir_0.1-9      klaR_0.6-12       digest_0.6.8     
## [28] stringi_1.0-1     tools_3.2.3       LearnBayes_2.15  
## [31] lazyeval_0.1.10   cluster_2.0.3     Matrix_1.2-3     
## [34] assertthat_0.1    httr_1.0.0        iterators_1.0.8  
## [37] R6_2.1.1          boot_1.3-17       nlme_3.1-122
```
