
```
## Loading required package: MASS
## Loading required package: ggplot2
## Loading required package: RColorBrewer
## Loading required package: grid
## Loading required package: plyr
## Loading required package: dplyr
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:plyr':
## 
##     arrange, count, desc, failwith, id, mutate, rename, summarise,
##     summarize
## 
## The following object is masked from 'package:MASS':
## 
##     select
## 
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
## 
## Loading required package: reshape2
## Loading required package: xlsx
## Loading required package: rJava
## Loading required package: methods
## Loading required package: xlsxjars
## Loading required package: knitr
## Loading required package: gtable
## Loading required package: foreach
## Loading required package: gridExtra
## Loading required package: magrittr
## Loading required package: agricolae
## Loading required package: stringr
## Loading required package: data.table
## 
## Attaching package: 'data.table'
## 
## The following objects are masked from 'package:reshape2':
## 
##     dcast, melt
## 
## The following objects are masked from 'package:dplyr':
## 
##     between, last
## 
## Loading required package: lubridate
## 
## Attaching package: 'lubridate'
## 
## The following objects are masked from 'package:data.table':
## 
##     hour, mday, month, quarter, wday, week, yday, year
## 
## The following object is masked from 'package:plyr':
## 
##     here
## 
## Loading required package: scales
## Loading required package: pforeach
## Loading required package: devtools
## Loading required package: tidyr
## 
## Attaching package: 'tidyr'
## 
## The following object is masked from 'package:magrittr':
## 
##     extract
## 
## Loading required package: slackr
## Loading required package: RCurl
## Loading required package: bitops
## 
## Attaching package: 'RCurl'
## 
## The following object is masked from 'package:tidyr':
## 
##     complete
## 
## The following object is masked from 'package:rJava':
## 
##     clone
```

# データロガーに収録された栽培環境情報をさくっとまとめたい。  
[**蛇口を捻れば水が出る**](https://github.com/dichika/jaguchi)かのように、簡単に栽培環境の情報をとってきたい  


## Introduction
現所属研究室では、植物を栽培条件下での温度をはじめとした、  
いくつかの環境要素 (以下、ログ) を計測しています  
毎年、研究室の新入生がログをまとめるのに、  
多大な時間を浪費しているような気がします  
データの扱いを覚える機会としては悪くはないのですが  
自分の研究について考えるプロセスにもう少し時間を割いた方がいいようにも思えます  

なので、これらのデータをさくっとまとめるR用関数を作成しました  


## Overview

日常的な栽培時に記録している環境要素とその測器は以下の通り  
温度: [**midiLOGGERシリーズ, GRAPHTECH**](http://www.graphtec.co.jp/site_instrument/instrument/gl220/) + 熱電対
相対湿度、CO<sub>2</sub>濃度: [**MCH383-SD, 佐藤商事**](http://www.ureruzo.com/gas/CO2mch.htm)

とくにRHとCO<sub>2</sub>濃度の測定精度はさほど高くないので、  
栽培に問題がなかったことを確認することが主目的です  

readGL()、readMCH()関数に情報を与えて結果を受け取ります。


```r
# readXX(ロガーのID+チャンネル, まとめてほしい日時の範囲, 他引数)
```

## 出力
リストを返します。
リストの中身は

1. $Raw: 生値
2. $Hourly: 1時間の平均値 (昼夜別)  
3. $Daily: 1日の平均値 (昼夜別)  
4. $Span: 指定した期間の平均値 (昼夜別)  
5. $inputs: 入力値

## 例1
対象: Graphtec (ID B) のch. 3  
期間: 2015年5月1日15:00から2015年5月15日13:00  
明期暗期: 7:00から明期、23:00から暗期  

```r
example1 <-
  readGL(ID = "B", ch = 3, StartDay = "150501", EndDay = "150515",
         StartTime = "150000", EndTime = "130000",
         ONtime = 7, OFFtime = 23)
example1
```

```
## $Raw
## Source: local data frame [31,100 x 5]
## 
##       ID    ch DayNight     Temp                Time
##    (chr) (dbl)    (chr)    (dbl)              (time)
## 1      B     3      Day 20.90140 2015-05-03 15:01:05
## 2      B     3      Day 20.90140 2015-05-03 15:01:35
## 3      B     3      Day 20.80264 2015-05-03 15:02:05
## 4      B     3      Day 20.80264 2015-05-03 15:02:35
## 5      B     3      Day 20.80264 2015-05-03 15:03:05
## 6      B     3      Day 20.90140 2015-05-03 15:03:35
## 7      B     3      Day 20.80264 2015-05-03 15:04:05
## 8      B     3      Day 20.90140 2015-05-03 15:04:35
## 9      B     3      Day 20.80264 2015-05-03 15:05:05
## 10     B     3      Day 20.80264 2015-05-03 15:05:35
## ..   ...   ...      ...      ...                 ...
## 
## $Hourly
## Source: local data frame [262 x 9]
## 
##       ID    ch DayNight        Day  Hour       DayHour MeanTemp     SDTemp
##    (chr) (dbl)    (chr)      (chr) (chr)         (chr)    (dbl)      (dbl)
## 1      B     3      Day 2015/05/03    15 2015/05/03 15 20.87964 0.04679585
## 2      B     3      Day 2015/05/03    16 2015/05/03 16 20.98699 0.05570774
## 3      B     3      Day 2015/05/03    17 2015/05/03 17 21.10796 0.04615344
## 4      B     3      Day 2015/05/03    18 2015/05/03 18 21.21824 0.05262496
## 5      B     3      Day 2015/05/03    19 2015/05/03 19 21.45525 0.09941356
## 6      B     3      Day 2015/05/03    20 2015/05/03 20 21.85357 0.12595932
## 7      B     3      Day 2015/05/03    21 2015/05/03 21 22.25682 0.13425309
## 8      B     3      Day 2015/05/03    22 2015/05/03 22 22.66665 0.11562380
## 9      B     3      Day 2015/05/04    07 2015/05/04 07 24.21217 0.04952267
## 10     B     3      Day 2015/05/04    08 2015/05/04 08 24.30434 0.05104388
## ..   ...   ...      ...        ...   ...           ...      ...        ...
## Variables not shown: Time (time)
## 
## $Daily
## Source: local data frame [26 x 7]
## 
##       ID    ch DayNight        Day MeanTemp     SDTemp       Time
##    (chr) (dbl)    (chr)      (chr)    (dbl)      (dbl)     (time)
## 1      B     3      Day 2015/05/03 21.55455 0.61113358 2015-05-03
## 2      B     3      Day 2015/05/04 24.74905 0.35300078 2015-05-04
## 3      B     3      Day 2015/05/05 25.90835 0.47731110 2015-05-05
## 4      B     3      Day 2015/05/06 25.20394 0.71490965 2015-05-06
## 5      B     3      Day 2015/05/07 21.84030 0.19567388 2015-05-07
## 6      B     3      Day 2015/05/08 21.47300 0.41274297 2015-05-08
## 7      B     3      Day 2015/05/09 21.00710 0.09871691 2015-05-09
## 8      B     3      Day 2015/05/10 20.34883 0.15184000 2015-05-10
## 9      B     3      Day 2015/05/11 22.41119 2.72058883 2015-05-11
## 10     B     3      Day 2015/05/12 25.00987 0.66481569 2015-05-12
## ..   ...   ...      ...        ...      ...        ...        ...
## 
## $Span
## Source: local data frame [2 x 5]
## 
##      ID    ch DayNight MeanTemp   SDTemp
##   (chr) (dbl)    (chr)    (dbl)    (dbl)
## 1     B     3      Day 23.25996 2.158215
## 2     B     3    Night 22.06997 2.129000
## 
## $inputs
## $inputs$ID
## [1] "B"
## 
## $inputs$ch
## [1] 3
## 
## $inputs$StartDay
## [1] "150501"
## 
## $inputs$EndDay
## [1] "150515"
## 
## $inputs$StartTime
## [1] "150000"
## 
## $inputs$EndTime
## [1] "130000"
## 
## $inputs[[7]]
## [1] 7
## 
## $inputs[[8]]
## [1] 23
## 
## $inputs[[9]]
## [1] "~/Dropbox/GL_log/"
```


## 例2
対象: MCH (ID 3)  
期間: 2015年5月25日15:00から2015年5月28日13:00  
明期暗期: 7:00から明期、23:00から暗期  

```r
example2 <-
  readMCH(ID = 3, StartDay = 150525, EndDay = 150528,
          StartTime = "150000", EndTime = "130000",
          ONtime = 7, OFFtime = 23)
example2
```

```
## $Raw
## Source: local data frame [8,400 x 6]
## 
##       ID DayNight       RH      CO2     Temp                Time
##    (dbl)    (chr)    (dbl)    (dbl)    (dbl)              (time)
## 1      3      Day 87.05881 469.7310 24.05757 2015-05-25 15:00:24
## 2      3      Day 81.37755 469.7310 24.15947 2015-05-25 15:00:54
## 3      3      Day 75.99532 469.7310 24.15947 2015-05-25 15:01:24
## 4      3      Day 69.11801 465.6701 24.15947 2015-05-25 15:01:54
## 5      3      Day 61.84202 462.6244 24.15947 2015-05-25 15:02:24
## 6      3      Day 55.66241 462.6244 24.15947 2015-05-25 15:02:54
## 7      3      Day 51.47623 462.6244 24.15947 2015-05-25 15:03:24
## 8      3      Day 48.28675 464.6548 24.05757 2015-05-25 15:03:54
## 9      3      Day 45.99432 464.6548 24.05757 2015-05-25 15:04:24
## 10     3      Day 44.29991 464.6548 23.95568 2015-05-25 15:04:54
## ..   ...      ...      ...      ...      ...                 ...
## 
## $Hourly
## Source: local data frame [70 x 12]
## 
##       ID DayNight        Day  Hour       DayHour   MeanRH     SDRH
##    (dbl)    (chr)      (chr) (chr)         (chr)    (dbl)    (dbl)
## 1      3      Day 2015/05/25    15 2015/05/25 15 56.51460 18.77620
## 2      3      Day 2015/05/25    16 2015/05/25 16 55.90744 19.05601
## 3      3      Day 2015/05/25    17 2015/05/25 17 55.37005 18.77320
## 4      3      Day 2015/05/25    18 2015/05/25 18 55.55942 18.81829
## 5      3      Day 2015/05/25    19 2015/05/25 19 55.60510 19.02215
## 6      3      Day 2015/05/25    20 2015/05/25 20 55.68401 18.84566
## 7      3      Day 2015/05/25    21 2015/05/25 21 55.84431 18.96733
## 8      3      Day 2015/05/25    22 2015/05/25 22 55.93402 18.88802
## 9      3      Day 2015/05/26    07 2015/05/26 07 67.90202 22.20060
## 10     3      Day 2015/05/26    08 2015/05/26 08 56.61095 18.81475
## ..   ...      ...        ...   ...           ...      ...      ...
## Variables not shown: MeanTemp (dbl), SDTemp (dbl), MeanCO2 (dbl), SDCO2
##   (dbl), Time (time)
## 
## $Daily
## Source: local data frame [8 x 10]
## 
##      ID DayNight        Day   MeanRH     SDRH MeanTemp    SDTemp  MeanCO2
##   (dbl)    (chr)      (chr)    (dbl)    (dbl)    (dbl)     (dbl)    (dbl)
## 1     3      Day 2015/05/25 55.80237 18.82733 23.49885 0.5106091 474.0203
## 2     3      Day 2015/05/26 56.85182 19.32588 23.42619 0.6344708 428.8400
## 3     3      Day 2015/05/27 56.38420 18.93679 23.48027 0.6281561 566.2179
## 4     3      Day 2015/05/28 58.37665 19.63416 23.62367 0.7231484 465.1822
## 5     3    Night 2015/05/25 68.36632 23.47597 20.10149 1.7875547 385.3909
## 6     3    Night 2015/05/26 81.32460 16.74095 19.58479 0.6990125 377.8390
## 7     3    Night 2015/05/27 81.18392 16.72176 19.53162 0.6097357 393.9537
## 8     3    Night 2015/05/28 83.83053 13.48349 19.55368 0.3583857 373.8765
## Variables not shown: SDCO2 (dbl), Time (time)
## 
## $Span
## Source: local data frame [2 x 8]
## 
##      ID DayNight   MeanRH     SDRH MeanTemp    SDTemp  MeanCO2     SDCO2
##   (dbl)    (chr)    (dbl)    (dbl)    (dbl)     (dbl)    (dbl)     (dbl)
## 1     3      Day 56.70555 19.15514 23.48339 0.6279739 489.2213 122.52050
## 2     3    Night 81.46868 16.46434 19.57952 0.6844201 382.3695  13.68579
## 
## $inputs
## $inputs$ID
## [1] 3
## 
## $inputs$StartDay
## [1] 150525
## 
## $inputs$EndDay
## [1] 150528
## 
## $inputs$StartTime
## [1] "150000"
## 
## $inputs$EndTime
## [1] "130000"
## 
## $inputs[[6]]
## [1] 7
## 
## $inputs[[7]]
## [1] 23
## 
## $inputs[[8]]
## [1] "~/Dropbox/MCH_log/"
```


#### 例3
例1・例2からグラフ化  

```r
# 気温の1時間平均経時データ  
example1$Hourly %>%  
  ggplot(aes(x = Time, y = MeanTemp, col = DayNight, group = DayNight)) +  
  geom_point()
```

![plot of chunk demo3](/figure/source/2016-01-31-LoggingEnvironment/demo3-1.png) 

```r
# RHの経時データ (生データ)  
example2$Raw %>%  
  ggplot(aes(x = Time, y = RH, col = DayNight, group = DayNight)) +  
  geom_point()
```

![plot of chunk demo3](/figure/source/2016-01-31-LoggingEnvironment/demo3-2.png) 

```r
# CO2のヒストグラム (生データ)  
example2$Raw %>%  
  ggplot(aes(x = CO2, fill = DayNight, group = DayNight)) +  
  geom_histogram(alpha = .3, position = "identity", col = "grey")
```

![plot of chunk demo3](/figure/source/2016-01-31-LoggingEnvironment/demo3-3.png) 

## How to use  

パッケージ化がうまくできなかったへたれなので、テキストとして読み込みます  
以下をコンソールにコピペ→実行  

```r
# RCurlパッケージがいるので、インストールされていない場合にインストール
if(class(try(library(RCurl), silent = T)) == "try-error") install.packages("RCurl")

# Githubから関数の読み込み
eval(parse(text = RCurl::getURL("https://raw.githubusercontent.com/KeachMurakami/Sources/master/Graphtech.R", ssl.verifypeer = FALSE)))
eval(parse(text = RCurl::getURL("https://raw.githubusercontent.com/KeachMurakami/Sources/master/MCH.R", ssl.verifypeer = FALSE)))
```

## PC側の設定
ファイルをread関数に読み込ませるため、ログを一箇所にまとめます  

実験ごとにフォルダを作ってその中に保存という形式はオススメできません   
<b>実験が増えるとフォルダ構造がカオス化し、管理が難しくなります</b>  

GL用・MCH用の親フォルダをそれぞれ作り、その中にログを蓄積します  
<span class="image featured"><img src="/figure/2016-01-31-LoggingEnvironment/fig4.png" alt=""></span>


この親フォルダのパスをreadXX関数の引数 (LogPath) に与えます  
親フォルダの中には以下が含まれます  

1. 校正係数を載せたファイル (CalbXXX.csv)  

```r
# 独立変数に真値、従属変数に各プローブの表示値を
# プロットした校正直線の回帰係数
data.table::fread("~/Dropbox/GL_log/CalbGL.csv") %>% head
```

```
##    GL_ID GL_ch     Slope  Intercept     Date       by
## 1:     A     1 1.0192722 -0.7056802 20131023 Murakami
## 2:     A     2 0.9994111 -0.1126028 20131023 Murakami
## 3:     A     3 1.0189965 -0.5498772 20131023 Murakami
## 4:     A     4 1.0131886 -0.3151192 20131023 Murakami
## 5:     A     5 1.0028633 -0.1227717 20131023 Murakami
## 6:     A     6 1.0157949 -0.3449836 20131023 Murakami
```

```r
data.table::fread("~/Dropbox/MCH_log/CalbMCH.csv") %>% head
```

```
##    MCH_ID SlopeHum InterceptHum  DateHum   byHum SlopeTemp InterceptTemp
## 1:      1   1.0356       2.1540 20150311 Maeyama    0.9673        1.2431
## 2:      2   0.9775       1.8640 20150311 Maeyama    0.9840        0.4114
## 3:      3   1.0033       1.2539 20150311 Maeyama    0.9814        0.6899
## 4:      4   1.1114       1.8477 20150311 Maeyama    0.9721        1.2599
## 5:      5   1.1848       5.2259 20150311 Maeyama    0.9871        0.3717
## 6:      6   1.0983       2.7121 20150311 Maeyama    0.9898        0.1107
##       DateTemp  byTemp SlopeCO2 InterceptCO2  DateCO2   byCO2
## 1: 20153021-24 Maeyama   0.9934        1.301 20150311 Maeyama
## 2: 20153021-24 Maeyama   1.0051        9.600 20150311 Maeyama
## 3: 20153021-24 Maeyama   0.9850       17.315 20150311 Maeyama
## 4: 20153021-24 Maeyama   1.0093        6.488 20150311 Maeyama
## 5: 20153021-24 Maeyama   0.9927       15.925 20150311 Maeyama
## 6: 20153021-24 Maeyama   0.9900        0.506 20150311 Maeyama
```
2. ロガーのIDごとの子フォルダ (YYMMDD)  

```r
dir("~/Dropbox/GL_log/")
```

```
## [1] "A"          "B"          "CalbGL.csv" "D"
```

```r
dir("~/Dropbox/MCH_log/")
```

```
##  [1] "CalbMCH.csv" "No01"        "No02"        "No03"        "No05"       
##  [6] "No06"        "No07"        "No09"        "No13"        "No13_未整理"
## [11] "No14"
```
子フォルダの中には収録開始日を名前としたフォルダを作り、ログを蓄積します  

```r
dir("~/Dropbox/GL_log/A")
```

```
##  [1] "150928" "150930" "151011" "151013" "151019" "151022" "151026"
##  [8] "151028" "151101" "151105" "151106" "151109" "151117" "151124"
## [15] "151125" "151129" "151203" "151207" "151216" "151221" "151222"
## [22] "151224" "151225" "151231" "160104" "160106" "160114" "160120"
```

```r
dir("~/Dropbox/MCH_log/No03")
```

```
##  [1] "150413" "150425" "150508" "150525" "150615" "150805" "151008"
##  [8] "151015" "151026" "151109" "151117" "151121" "151202" "151208"
## [15] "151216" "151229" "160109" "160115" "160126"
```

### データの保存について  
#### Graphtecの場合  
収録開始とともに、その日 (YYMMDD形式, 2015年12月31日なら151231) の名前でフォルダが生成され、その中に.CSVが作成されます  
なのでGraphtec用USB内のフォルダをそのままコピー&ペーストすればOK  
  
#### MCHの場合  
.XLSファイルに上書きを繰り返すのでやや面倒です  
一回の測定が終わったら、SDカードから.XLSを吸い上げます  
PC側に測定開始日 (YYMMDD形式) を名前としたフォルダを作り、  
その中に.XLSファイルをカット&ペーストします  
<b>MCH側には.XLSを残しません</b> 

## Future prospect  
データをメディアから直接アップロードし、クラウドから取り出す形にしたい (無線内蔵USB的な)   

# Summary
データロガーのデータをさくっとまとめる関数ができました。  

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
