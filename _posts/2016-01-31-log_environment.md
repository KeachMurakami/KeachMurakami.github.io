---
title: "実験環境のデータをまとめる"
output: html_document
layout: post
categories: R
tags: lab R
---



# データロガーに収録された栽培環境情報をさくっとまとめたい。  

[**蛇口を捻れば水が出る**](https://github.com/dichika/jaguchi)かのように、簡単に栽培環境の情報をとってきたい  


## 背景  
現所属研究室では、植物を栽培する条件下での、温度などの環境要素を記録している  
毎年、研究室の新入生がログをまとめるのに、多大な時間を浪費しているような気がしている  
データの扱いを覚える機会としては悪くはないが、それだけで時間を使いすぎては意味がない    
なので、栽培環境情報をさくっとまとめるR用関数を作成した  

## 概要  
日常的に記録している環境要素とその測器は以下の通り  
温度: [**midiLOGGERシリーズ, GRAPHTECH**](http://www.graphtec.co.jp/site_instrument/instrument/gl220/) + 熱電対  
相対湿度・CO<sub>2</sub>濃度: [**MCH383-SD, 佐藤商事**](http://www.ureruzo.com/gas/CO2mch.htm)  
RHとCO<sub>2</sub>濃度の測定精度はさほど高くないので、栽培に問題 (湿度が異常に低いなど) がなかったことを確認すること が主目的  

## 関数の機能  
`readGL()`、`readMCH()`関数に情報を与えて結果を受け取る  

```r
readMCH(ID, # ロガーのID
       StartDay, EndDay, StartTime, EndTime, # まとめたい日時の範囲
       ONtime, OFFtime, # 昼 (明期)、夜 (暗期) の開始時間
       LogPath) # ログを蓄積しているフォルダのパス
readGL(ID, ch, # ロガーのID, チャンネル
       StartDay, EndDay, StartTime, EndTime, # まとめたい日時の範囲
       ONtime, OFFtime, # 昼 (明期)、夜 (暗期) の開始時間
       LogPath) # ログを蓄積しているフォルダのパス 
```

以下の内容を含むリストを返す  
1. $Raw: 生の出力値
2. $Hourly: 1時間の平均値と標準偏差 (昼夜別)  
3. $Daily: 1日の平均値と標準偏差 (昼夜別)  
4. $Span: 指定した期間の平均値と標準偏差 (昼夜別)  
5. $inputs: `readXXX`関数への入力値

#### 例1  
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

#### 例2  
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

![plot of chunk demo3](/figure/source/2016-01-31-log_environment/demo3-1.png) 

```r
# RHの経時データ (生データ)  
example2$Raw %>%  
  ggplot(aes(x = Time, y = RH, col = DayNight, group = DayNight)) +  
  geom_point()
```

![plot of chunk demo3](/figure/source/2016-01-31-log_environment/demo3-2.png) 

```r
# CO2のヒストグラム (生データ)  
example2$Raw %>%  
  ggplot(aes(x = CO2, fill = DayNight, group = DayNight)) +  
  geom_histogram(alpha = .3, position = "identity", col = "grey")
```

![plot of chunk demo3](/figure/source/2016-01-31-log_environment/demo3-3.png) 

## 使い方  
#### R側の準備  
技術不足ゆえにパッケージ化はできない  
以下をRのコンソールにコピペ→実行  

```r
# RCurlパッケージがいるので、インストールされていない場合にインストール
if(class(try(library(RCurl), silent = T)) == "try-error") install.packages("RCurl")

# Githubから関数の読み込み
eval(parse(text = RCurl::getURL("https://raw.githubusercontent.com/KeachMurakami/Sources/master/Graphtech.R", ssl.verifypeer = FALSE)))
eval(parse(text = RCurl::getURL("https://raw.githubusercontent.com/KeachMurakami/Sources/master/MCH.R", ssl.verifypeer = FALSE)))
```

#### PC側の準備  
ファイルを`readXXX`関数に読み込ませるため、ログを一箇所にまとめる  
実験ごとにフォルダを作ってその中に保存という形式はオススメできない   
<b>実験が増えるとフォルダ構造がカオス化し、管理が難しくなることが理由</b>  

元データは図のように一元管理する  
![plot of chunk demo4](/figure/source/2016-01-31-log_environment/fig4.svg)  
MCH用・GL用の親フォルダをそれぞれ作り、その中にログを蓄積する  
必要に応じて`readXXX`関数を使って、元データをまとめてレポートを作成することが望ましい  
この親フォルダのパスを`readXX`関数の引数 (LogPath) に与える  
上の図でいうと、`readMCH`では`LogPath = "~/MCH_log`、`readGL`では`LogPath = "~/GL_log"`と指定する  
親フォルダの中身は以下の通り

校正係数を載せたファイル (CalbXXX.csv)  

```r
# 独立変数に真値、従属変数に各プローブの表示値を
# プロットした校正直線の回帰係数
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

```r
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

ロガーのIDを名前にした子フォルダ   

```r
dir("~/Dropbox/MCH_log/")
```

```
##  [1] "CalbMCH.csv" "No01"        "No02"        "No03"        "No05"       
##  [6] "No06"        "No07"        "No09"        "No13"        "No13_未整理"
## [11] "No14"
```

```r
dir("~/Dropbox/GL_log/")
```

```
## [1] "A"          "B"          "CalbGL.csv" "D"
```

子フォルダの中  

```r
# 収録開始日 (YYMMDD) を名前にしたフォルダを作り、ログを蓄積する  
dir("~/Dropbox/MCH_log/No03")
```

```
##  [1] "150413" "150425" "150508" "150525" "150615" "150805" "151008"
##  [8] "151015" "151026" "151109" "151117" "151121" "151202" "151208"
## [15] "151216" "151229" "160109" "160115" "160126"
```

```r
dir("~/Dropbox/GL_log/A")
```

```
##  [1] "150928" "150930" "151011" "151013" "151019" "151022" "151026"
##  [8] "151028" "151101" "151105" "151106" "151109" "151117" "151124"
## [15] "151125" "151129" "151203" "151207" "151216" "151221" "151222"
## [22] "151224" "151225" "151231" "160104" "160106" "160114" "160120"
## [29] "160131" "160201" "160204" "160216"
```

#### ロガーからのデータの吸い上げについて  
MCHの場合  
.XLSファイルに上書きを繰り返すのでやや面倒  
一回の測定が終わったら、SDカードから.XLSを吸い上げる 
PC側に測定開始日 (YYMMDD形式) を名前としたフォルダを作り、  
その中に.XLSファイルをカット&ペースト  
<b>MCH側には.XLSを残さない</b> 

Graphtecの場合  
収録開始とともに、その日 (YYMMDD形式, 2015年12月31日なら151231) の名前でフォルダが生成され、その中に.CSVが作成される  
なのでGraphtec用USB内のフォルダをそのままコピペすればOK  

## 展望  
データをUSBから直接オンラインにアップロード、各時の環境で取り出す形にしたい (無線内蔵USB的なものを使う)   

## まとめ  
データロガーのデータをさくっとまとめる関数ができました。  

### 参考ページ  
[jaguchi (dichikaさん@Github)](https://github.com/dichika/jaguchi)  

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
##  date     2016-03-07                  
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
