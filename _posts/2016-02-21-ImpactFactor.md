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
なので、IFの推移を可視化した  

## データの取得  
今回のletterはPlant Science分野のもの  
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
そのままだとポアソン分布っぽい (整数データではないので不適切)？  

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
[このページ](https://cran.r-project.org/web/packages/googleVis/vignettes/Using_googleVis_with_knitr.html)   にあるようなインタラクティブな可視化が簡単にできる  


## 全体の傾向を掴みたい  
なんとなくIFが徐々に高くなっているような気がする  
階層モデルで解析してみるパートに続きたい  

### 参考ページ
[CRAN.R-project.org](https://cran.r-project.org/web/packages/googleVis/vignettes/Using_googleVis_with_knitr.html)  
[Journal Citation Reports](http://thomsonreuters.com/en/products-services/scholarly-scientific-research/research-management-and-evaluation/journal-citation-reports.html)  

```r
session_info()
```

```
##  setting  value                       
##  version  R version 3.2.3 (2015-12-10)
##  system   x86_64, darwin14.5.0        
##  ui       X11                         
##  language (EN)                        
##  collate  en_US.UTF-8                 
##  tz       Asia/Tokyo                  
##  date     2016-03-05                  
## 
##  package      * version    date       source                          
##  agricolae    * 1.2-3      2015-10-06 CRAN (R 3.1.3)                  
##  AlgDesign      1.1-7.3    2014-10-15 CRAN (R 3.1.2)                  
##  assertthat     0.1        2013-12-06 CRAN (R 3.1.0)                  
##  bitops       * 1.0-6      2013-08-17 CRAN (R 3.1.0)                  
##  boot           1.3-17     2015-06-29 CRAN (R 3.2.3)                  
##  chron          2.3-47     2015-06-24 CRAN (R 3.1.3)                  
##  cluster        2.0.3      2015-07-21 CRAN (R 3.2.3)                  
##  coda           0.18-1     2015-10-16 CRAN (R 3.1.3)                  
##  codetools      0.2-14     2015-07-15 CRAN (R 3.2.3)                  
##  colorspace     1.2-6      2015-03-11 CRAN (R 3.1.3)                  
##  combinat       0.0-8      2012-10-29 CRAN (R 3.1.0)                  
##  data.table   * 1.9.6      2015-09-19 CRAN (R 3.1.3)                  
##  DBI            0.3.1      2014-09-24 CRAN (R 3.1.1)                  
##  deldir         0.1-9      2015-03-09 CRAN (R 3.1.3)                  
##  devtools     * 1.9.1      2015-09-11 CRAN (R 3.2.0)                  
##  digest         0.6.8      2014-12-31 CRAN (R 3.1.2)                  
##  doParallel     1.0.10     2015-10-14 CRAN (R 3.1.3)                  
##  doRNG          1.6        2014-03-07 CRAN (R 3.1.2)                  
##  dplyr        * 0.4.3      2015-09-01 CRAN (R 3.1.3)                  
##  evaluate       0.8        2015-09-18 CRAN (R 3.1.3)                  
##  foreach      * 1.4.3      2015-10-13 CRAN (R 3.1.3)                  
##  formatR        1.2.1      2015-09-18 CRAN (R 3.1.3)                  
##  ggplot2      * 2.0.0      2015-12-18 CRAN (R 3.2.3)                  
##  gridExtra    * 2.0.0      2015-07-14 CRAN (R 3.1.3)                  
##  gtable       * 0.1.2      2012-12-05 CRAN (R 3.1.0)                  
##  highr          0.5.1      2015-09-18 CRAN (R 3.1.3)                  
##  httr           1.0.0      2015-06-25 CRAN (R 3.1.3)                  
##  iterators      1.0.8      2015-10-13 CRAN (R 3.1.3)                  
##  jsonlite       0.9.19     2015-11-28 CRAN (R 3.1.3)                  
##  klaR           0.6-12     2014-08-06 CRAN (R 3.1.1)                  
##  knitr        * 1.11       2015-08-14 CRAN (R 3.2.3)                  
##  labeling       0.3        2014-08-23 CRAN (R 3.1.1)                  
##  lattice        0.20-33    2015-07-14 CRAN (R 3.2.3)                  
##  lazyeval       0.1.10     2015-01-02 CRAN (R 3.1.2)                  
##  LearnBayes     2.15       2014-05-29 CRAN (R 3.1.0)                  
##  lubridate    * 1.5.0      2015-12-03 CRAN (R 3.2.3)                  
##  magrittr     * 1.5        2014-11-22 CRAN (R 3.1.2)                  
##  MASS         * 7.3-45     2015-11-10 CRAN (R 3.2.3)                  
##  Matrix         1.2-3      2015-11-28 CRAN (R 3.2.3)                  
##  memoise        0.2.1      2014-04-22 CRAN (R 3.1.0)                  
##  munsell        0.4.2      2013-07-11 CRAN (R 3.1.0)                  
##  nlme           3.1-122    2015-08-19 CRAN (R 3.2.3)                  
##  pforeach     * 1.3        2015-12-21 Github (hoxo-m/pforeach@2c44f3b)
##  pkgmaker       0.22       2014-05-14 CRAN (R 3.1.3)                  
##  plyr         * 1.8.3      2015-06-12 CRAN (R 3.1.3)                  
##  R6             2.1.1      2015-08-19 CRAN (R 3.1.3)                  
##  RColorBrewer * 1.1-2      2014-12-07 CRAN (R 3.1.2)                  
##  Rcpp           0.12.2     2015-11-15 CRAN (R 3.1.3)                  
##  RCurl        * 1.95-4.7   2015-06-30 CRAN (R 3.1.3)                  
##  registry       0.3        2015-07-08 CRAN (R 3.1.3)                  
##  reshape2     * 1.4.1      2014-12-06 CRAN (R 3.1.2)                  
##  rJava        * 0.9-7      2015-07-29 CRAN (R 3.1.3)                  
##  rngtools       1.2.4      2014-03-06 CRAN (R 3.1.2)                  
##  scales       * 0.3.0      2015-08-25 CRAN (R 3.1.3)                  
##  slackr       * 1.3.1.9001 2015-12-07 Github (hrbrmstr/slackr@27f777e)
##  sp             1.2-1      2015-10-18 CRAN (R 3.2.3)                  
##  spdep          0.5-92     2015-12-22 CRAN (R 3.2.3)                  
##  stringi        1.0-1      2015-10-22 CRAN (R 3.1.3)                  
##  stringr      * 1.0.0      2015-04-30 CRAN (R 3.1.3)                  
##  tidyr        * 0.3.1      2015-09-10 CRAN (R 3.2.0)                  
##  xlsx         * 0.5.7      2014-08-02 CRAN (R 3.1.1)                  
##  xlsxjars     * 0.6.1      2014-08-22 CRAN (R 3.1.1)                  
##  xtable         1.8-0      2015-11-02 CRAN (R 3.1.3)
```
