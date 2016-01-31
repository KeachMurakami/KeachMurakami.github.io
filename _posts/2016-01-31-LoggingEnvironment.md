
```
## Error in eval(expr, envir, enclos): object 'opts_chunk' not found
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
readXX(ロガーのID+チャンネル, まとめてほしい日時の範囲, 他引数)
```

```
## Error in eval(expr, envir, enclos): could not find function "readXX"
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
```

```
## Loading required package: methods
## 
## Attaching package: 'lubridate'
## 
## The following objects are masked from 'package:data.table':
## 
##     hour, mday, month, quarter, wday, week, yday, year
```

```
## Error in function_list[[i]](value): could not find function "select"
```

```r
example1
```

```
## Error in eval(expr, envir, enclos): object 'example1' not found
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
```

```
## Warning in data.matrix(data): NAs introduced by coercion
```

```
## Warning in data.matrix(data): NAs introduced by coercion
```

```
## Warning in data.matrix(data): NAs introduced by coercion
```

```
## Warning in data.matrix(data): NAs introduced by coercion
```

```
## Error in filter(., MCH_ID == as.numeric(ID)): object 'MCH_ID' not found
```

```r
example2
```

```
## Error in eval(expr, envir, enclos): object 'example2' not found
```


#### 例3
例1・例2からグラフ化  

```r
# 気温の1時間平均経時データ  
example1$Hourly %>%  
  ggplot(aes(x = Time, y = MeanTemp, col = DayNight, group = DayNight)) +  
  geom_point()
```

```
## Error in eval(expr, envir, enclos): object 'example1' not found
```

```r
# RHの経時データ (生データ)  
example2$Raw %>%  
  ggplot(aes(x = Time, y = RH, col = DayNight, group = DayNight)) +  
  geom_point()
```

```
## Error in eval(expr, envir, enclos): object 'example2' not found
```

```r
# CO2のヒストグラム (生データ)  
example2$Raw %>%  
  ggplot(aes(x = CO2, fill = DayNight, group = DayNight)) +  
  geom_histogram(alpha = .3, position = "identity", col = "grey")
```

```
## Error in eval(expr, envir, enclos): object 'example2' not found
```

## How to use  

パッケージ化がうまくできなかったへたれなので、テキストとして読み込みます  
以下をコンソールにコピペ→実行  

```r
# RCurlパッケージがいるので、インストールされていない場合にインストール
if(class(try(library(RCurl), silent = T)) == "try-error") install.packages("RCurl")
```

```
## Loading required package: bitops
## 
## Attaching package: 'RCurl'
## 
## The following object is masked from 'package:tidyr':
## 
##     complete
```

```r
# Githubから関数の読み込み
eval(parse(text = RCurl::getURL("https://raw.githubusercontent.com/KeachMurakami/Sources/master/Graphtech.R", ssl.verifypeer = FALSE)))
eval(parse(text = RCurl::getURL("https://raw.githubusercontent.com/KeachMurakami/Sources/master/MCH.R", ssl.verifypeer = FALSE)))
```

## PC側の設定
ファイルをread関数に読み込ませるため、ログを一箇所にまとめます  

実験ごとにフォルダを作ってその中に保存という形式はオススメできません   
<b>実験が増えるとフォルダ構造がカオス化し、管理が難しくなります</b>  

GL用・MCH用の親フォルダをそれぞれ作り、その中にログを蓄積します  
<span class="image featured"><img src="/images/2016-01-31/Fig1.png" alt=""></span>


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
## [1] methods   stats     graphics  grDevices utils     datasets  base     
## 
## other attached packages:
## [1] RCurl_1.95-4.7   bitops_1.0-6     lubridate_1.5.0  data.table_1.9.6
## [5] tidyr_0.3.1      ggplot2_2.0.0   
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.2      chron_2.3-47     grid_3.2.3       plyr_1.8.3      
##  [5] gtable_0.1.2     formatR_1.2.1    magrittr_1.5     evaluate_0.8    
##  [9] scales_0.3.0     stringi_1.0-1    tools_3.2.3      stringr_1.0.0   
## [13] munsell_0.4.2    colorspace_1.2-6 knitr_1.11
```
