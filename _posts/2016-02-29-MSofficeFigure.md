---
title: "Excel作図で困ること"
output: html_document
layout: post
tags: lab MSoffice R Shiny
---




最近はMSoffice離れが進み、作図はR、たまにInkscapeで微調整という感じに落ち着いた  
Excel+Powerpointでもそこそこ頑張れる  
キレイに作図したいときはExcel上で図をコピーして、Powerpointに拡張メタファイル (.emf) 形式で貼付け (Winでは`Alt+E → S`)、グループ化を解除すれば、要素に分解して微調整ができる   
が、こんなことが起こる  

![sine_noise](/figure/source/2016-02-29-MSofficeFigure/sine_noise.svg)

線の折り返し部分が妙な感じになる  
この原因は、Excel上で作られた線が枠+内部の2つの情報を持っていること  
どうやらExcelでの作図では、すべてのオブジェクトがこのような袋構造になるようで、いかんともしがたい  
少なくともExcel2003までは、Excel上で表示される線には線の情報しかなかったので、このようなことは起こらなかった  
  
この描画問題で困っている人がいた    
Rに限らず、全員がなんらかのソフトで作図できるようになればいいがそうもいかない  
個々人に教えるのはあまりにも大変なので、どうにかしたい  

ということで、Shinyで[データからpdf画像を作成するアプリ](https://keachmurakami.shinyapps.io/Scatter/)を作った  
emfで出力しても、Shiny越しだとpowerpoint上で分解できる形式にならなかったのでpdfで妥協  
[ここ](http://d.hatena.ne.jp/hoxo_m/20121228/p1)でも触れられているように、最近はなんでもRでやろうとするからダメ  

## 使い方
csvファイルをアップロードし、downloadボタンを押すとpdf画像が保存できる  
アップロードしたcsvファイルの第1カラムが横軸、以降のカラムが縦軸に表示される  
とりあえず散布図にだけ対応  
「pdfファイルで出力 → ドローソフト (Illustratorとか) で分解 → メタファイル出力してPowerpointへ」とやることになるんだけど、かなり面倒だ  

## 結局　
各自がローカルでやるのがいいのだろう  
ローカルだと3行で終わる話   

```r
# Macだとemfを書き込むためにパッケージが必要
# Winだとデフォルトの関数でいける
devEMF::emf(file = "test.emf")
plot(1:10)
dev.off()
```

「ハイクオリティな図が作りたいけど、そういうソフトを使うのは難しそうだし、ちょっと...。でもドローソフトは使えます！」なんていう人はかなりレアなので、出番はなさそう  

### 参考ページ
[Scatter (keachmurakami@shinyapps.io)](https://keachmurakami.shinyapps.io/Scatter/)  
[RStudio Shiny TIPS (ほくそ笑む@Hatena::Diary)](http://d.hatena.ne.jp/hoxo_m/20121228/p1)  
[File Downloads (Shiny by RStudio)](http://shiny.rstudio.com/reference/shiny/latest/downloadHandler.html)  

### 実行環境
Mac: Office 2016 for Mac
Win: Office 2013

以下、[Shinyのコード](https://github.com/KeachMurakami/KeachMurakami.github.io/blob/master/_shiny/MakeScatter/app.R)

```r
library(shiny)
library(ggplot2)
library(dplyr)
library(reshape2)

ui <-
  shinyUI(
    pageWithSidebar(
      headerPanel(title="Scatter plot drawer"),
      sidebarPanel(
        fileInput("file", label="Input File:"),
        downloadLink('downloadData', 'Download')),
      mainPanel(
        h4("File Information:"),
        verbatimTextOutput("info"),
        h4("Figure"),
        plotOutput("plot")
      )
    ))

# server.R
server <-
  function(input, output) {
    output$info <- reactiveText(function(){
      file <- input$file
      if(is.null(file)) {
        "please upload file"
      } else {
        name <- paste("File Name: ", iconv(file$name, from="latin1", to="UTF-8"))
        size <- paste("File Size: ", file$size, "B")
        type <- paste("File Type: ", file$type)
        paste(name, size, type, sep="\n")
      }
    })
    output$plot <- reactivePlot(function() {
      file <- input$file
      if(is.null(file)) {
        "please upload file"
      } else {
        filepath <- file$datapath
        data <-
          read.csv(filepath) 
        data %>%
          melt(id.vars = colnames(data)[1]) %>%
          ggplot(aes_string(x = colnames(data)[1], y = "value", col = "variable")) +
          geom_line()
      }
    })
    output$downloadData <- downloadHandler(
      filename = function() {paste0(Sys.Date(), 'data.pdf')},
      content = function(file){
        pdf(file)
        csv_file <- input$file
        filepath <- csv_file$datapath
        data <-
          read.csv(filepath) 
        fig <-
          data %>%
          melt(id.vars = colnames(data)[1]) %>%
          ggplot(aes_string(x = colnames(data)[1], y = "value", col = "variable")) +
          geom_line()
          print(fig)
        dev.off()
      },
      contentType = "image/pdf"
    )
  }
```


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
## [16] evaluate_0.8      memoise_0.2.1     doParallel_1.0.10
## [19] parallel_3.2.3    spdep_0.5-92      Rcpp_0.12.2      
## [22] xtable_1.8-0      formatR_1.2.1     jsonlite_0.9.19  
## [25] deldir_0.1-9      klaR_0.6-12       digest_0.6.8     
## [28] stringi_1.0-1     tools_3.2.3       LearnBayes_2.15  
## [31] cluster_2.0.3     Matrix_1.2-3      assertthat_0.1   
## [34] httr_1.0.0        iterators_1.0.8   R6_2.1.1         
## [37] boot_1.3-17       nlme_3.1-122
```
