---
title: "Impact Factorを比べる"
output: html_document
layout: post
categories: R
tags: lab R
---



# ImpactFacotrの推移を可視化する

## 論文をどこに投稿するか
論文をLetterで出すことを検討している  
読者層やその雑誌の特徴 (生態学より・農学よりなど) を考慮するが  
<b>ImpactFactor</b>もやっぱり気になる  

## ImpactFactor (IF) とは
Thomson Reuters社が公表している論文誌の引用されやすさの指標のようなもの  
高IF誌に乗った論文は、読んでくれる人が多い傾向にある  
「IFが高ければいいってもんじゃない」という意見も多い

<b>「高IF誌に載っている論文 ⇒ 内容が良い」は偽</b>だが  
<b>「内容が良い論文 ⇒ 高IF誌に載っている」は真</b>な気がする  


## ImpactFactorの推移
IFは毎年更新される  
あまり意味はないが、どうせなら右肩上がりの論文誌を狙いたいような気がする  
ので、IFの推移を可視化した  


## データの取得
今回のletterはPlant Scienceっぽいもの  
[Journal Citation Reports (JCR)](http://thomsonreuters.com/en/products-services/scholarly-scientific-research/research-management-and-evaluation/journal-citation-reports.html)にアクセスし、Plant Science分野の論文のIF一覧を取得する  
ここは手作業でぽちぽちした


```r
setwd("~/GitHub/BeeLabR/Entertainment/ImpactFactor/PlantScience/")
dir()
```

```
##  [1] "2001_PlantScience.txt" "2002_PlantScience.txt"
##  [3] "2003_PlantScience.txt" "2004_PlantScience.txt"
##  [5] "2005_PlantScience.txt" "2006_PlantScience.txt"
##  [7] "2007_PlantScience.txt" "2008_PlantScience.txt"
##  [9] "2009_PlantScience.txt" "2010_PlantScience.txt"
## [11] "2011_PlantScience.txt" "2012_PlantScience.txt"
## [13] "2013_PlantScience.txt" "2014_PlantScience.txt"
```

出力の都合で年ごとにログを蓄積


```r
setwd("~/GitHub/BeeLabR/Entertainment/ImpactFactor/PlantScience/")

IFdata <-
  lapply(dir(), function(IF_txt){
    df <-
      IF_txt %>%
      read.csv2(skip = 1, sep = ";", row.names = NULL, stringsAsFactors = F) %>%
      {set_names(., c(colnames(.)[-1], "remove"))}
    
    # 途中で形式が変わっているので処理を分ける
    if(dim(df)[2] < 9){
      df %>%
        transmute(Journal = Abbreviated.Journal.Title,
                  ImpactFactor = as.numeric(Impact.Factor),
                  Year = tidyr::extract_numeric(IF_txt)) %>%
        return
    } else {
      df %>%
        transmute(Journal = Abbreviated.Journal.Title,
                  ImpactFactor = as.numeric(Impact.Factor),
                  EigenFactor = as.numeric(Eigenfactor.Score),
                  ArticleInfluenceScore = as.numeric(Article.Influence.Score),
                  Year = tidyr::extract_numeric(IF_txt)) %>%
        return
      }
    }) %>%
  rbind_all

# 著作権などが怖いので、一応雑誌名を隠す
anonymous <- function(x){
  (x == unique(IFdata$Journal)) %>%
  which %>%
  sprintf("%03.0f", .) %>%
  as.character %>%
  paste0("ID", .)
}

IFdata %<>%
  mutate(Journal = Vectorize(anonymous)(Journal))
```

データを以下のような感じに整形  
JCRがフリーアクセスではないので雑誌名だけ伏せて匿名化  
EigenFactorとArticleInfluenceScoreも雑誌の指標で比較的最近導入されたもの  

```r
IFdata %>%
  head(20) %>%
  kable
```



|Journal | ImpactFactor| Year| EigenFactor| ArticleInfluenceScore|
|:-------|------------:|----:|-----------:|---------------------:|
|ID001   |        0.237| 2001|          NA|                    NA|
|ID002   |        0.068| 2001|          NA|                    NA|
|ID003   |        0.284| 2001|          NA|                    NA|
|ID004   |        0.232| 2001|          NA|                    NA|
|ID005   |        0.235| 2001|          NA|                    NA|
|ID006   |        2.513| 2001|          NA|                    NA|
|ID007   |        0.214| 2001|          NA|                    NA|
|ID008   |        2.463| 2001|          NA|                    NA|
|ID009   |        0.441| 2001|          NA|                    NA|
|ID010   |        1.352| 2001|          NA|                    NA|
|ID011   |        2.787| 2001|          NA|                    NA|
|ID012   |        3.902| 2001|          NA|                    NA|
|ID013   |       17.372| 2001|          NA|                    NA|
|ID014   |        1.361| 2001|          NA|                    NA|
|ID015   |        0.671| 2001|          NA|                    NA|
|ID016   |        1.562| 2001|          NA|                    NA|
|ID017   |        1.237| 2001|          NA|                    NA|
|ID018   |        0.495| 2001|          NA|                    NA|
|ID019   |        0.052| 2001|          NA|                    NA|
|ID020   |        0.130| 2001|          NA|                    NA|

## JCRへ登録されている雑誌数の推移
右肩上がり

```r
# 雑誌数
IFdata$Year %>%
  table %>%
  data.frame %>%
  select_(Year = ".", Number = "Freq") %>%
  ggplot(aes(x = Year, y = Number, group = 1)) +
  geom_line()
```

![plot of chunk JournalNumber](/figure/source/2016-02-21-ImpactFactor/JournalNumber-1.png) 

## IFのヒストグラム
そのままだとポアソン分布っぽい？

```r
# IFの分布
IFdata %>%
  filter(Year == 2014) %>%
  ggplot(aes(x = ImpactFactor, y = ..density..)) +
  geom_density(fill = "pink", col = "red") +
  geom_histogram(col = "grey", alpha = .75)
```

![plot of chunk IFhist](/figure/source/2016-02-21-ImpactFactor/IFhist-1.png) 

対数化すると正規分布っぽい？

```r
IFdata %>%
  filter(Year == 2014) %>%
  ggplot(aes(x = ImpactFactor, y = ..density..)) +
  geom_density(fill = "pink", col = "red") +
  geom_histogram(col = "grey", alpha = .75) +
  scale_x_log10()
```

![plot of chunk IFhist_log10](/figure/source/2016-02-21-ImpactFactor/IFhist_log10-1.png) 


## 雑誌ごとに推移を表示

```r
IFdata %>%
  ggplot(aes(x = Year, y = ImpactFactor, group = Journal, col = Journal)) +
  geom_line() +
  geom_point() +
  guides(col = F)
```

![plot of chunk timecourse1](/figure/source/2016-02-21-ImpactFactor/timecourse1-1.png) 

みづらいので`IF > 1`で範囲を絞る  


```r
IFdata %>%
  filter(ImpactFactor > 1) %>%
  ggplot(aes(x = Year, y = ImpactFactor, group = Journal, col = Journal)) +
  geom_line() +
  geom_point() +
  guides(col = F)
```

![plot of chunk timecourse2](/figure/source/2016-02-21-ImpactFactor/timecourse2-1.png) 

みづらかった  

## {googleVis}で推移を表示  
`googleVis`パッケージを使うといい感じに可視化できる  

```r
IFdata %>%
  select(-ArticleInfluenceScore) %>%
  googleVis::gvisMotionChart(., idvar="Journal", timevar="Year") %>%
  plot
```
ただ、Jekyllに載せる技術はなかったのでスクリーンショットのみ  
![googleVis](/figure/source/2016-02-21-ImpactFactor/IF_googleVis.svg) 

[このページ](https://cran.r-project.org/web/packages/googleVis/vignettes/Using_googleVis_with_knitr.html) にあるようなインタラクティブな可視化が簡単にできる  


## 全体の傾向を掴みたい

なんとなくIFが徐々に高くなっているような気がする  
階層モデルで解析してみるパートに続きたい  

### 参考ページ
[CRAN.R-project.org](https://cran.r-project.org/web/packages/googleVis/vignettes/Using_googleVis_with_knitr.html)  
[Journal Citation Reports](http://thomsonreuters.com/en/products-services/scholarly-scientific-research/research-management-and-evaluation/journal-citation-reports.html)  

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
## [22] highr_0.5.1       Rcpp_0.12.2       xtable_1.8-0     
## [25] formatR_1.2.1     jsonlite_0.9.19   deldir_0.1-9     
## [28] klaR_0.6-12       digest_0.6.8      stringi_1.0-1    
## [31] tools_3.2.3       LearnBayes_2.15   lazyeval_0.1.10  
## [34] cluster_2.0.3     Matrix_1.2-3      assertthat_0.1   
## [37] httr_1.0.0        iterators_1.0.8   R6_2.1.1         
## [40] boot_1.3-17       nlme_3.1-122
```
