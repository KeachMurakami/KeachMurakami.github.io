---
title: "論文タイトルのweb scraping (rvest"
output: html_document
layout: post
tags: lab R rvest
---

論文のタイトルはとても重要  
近年のトレンドを追いかける意味も込めて、web scrapingした  


### 対象

- UIが好みなので、Wileyの雑誌からタイトルを抜き出す  
- 今回は`rvest`に慣れるため、自分でコードを作成  
    - [ここ<sup>1</sup>](https://ytake2.github.io/ldastan/lda.html)とか[ここ<sup>2</sup>](https://www.r-bloggers.com/how-to-search-pubmed-with-rismed-package-in-r/)を踏まえると、出版社に依らず全文献情報を解析できる (はず)  


```r
library(tidyverse) # ggplotとかdplyrとか
library(rvest) # webスクレイピング用
library(XML) # rvestで必要なので
```

```
## Warning: package 'XML' was built under R version 3.3.2
```

```r
library(stringr) # 文字列操作用
library(knitr)
```


#### 概要

フローチャート

1. ISSNからcurrent issueページへ遷移する
2. 同ページから、タイトルを取得する
3. previous issueページへ遷移する
4. 2--3を繰り返し、適当な数のタイトルを取得


##### 実装1

- [ここ<sup>3</sup>](https://book.mynavi.jp/manatee/detail/id=59386)を参考にしつつ、2と3を実装
    - current issueページを起点に、掲載論文のタイトルを取得  
    - previous issueページのURLを抽出  


```r
extract_titles <-
  function(issue_url){
    html_issue <- 
      issue_url %>%
      read_html
    
    # 雑誌名、出版年月、巻号を取得。
    journal <-
      html_issue %>%
      html_nodes("h1#productTitle") %>% # タグがh1, IDがproductTitle
      html_text
    date <-
      html_issue %>%
      html_nodes("h2.noMargin") %>% # タグがh2, クラスがnoMargin
      html_text
    issue_volume <-
      html_issue %>%
      html_nodes("p.issueAndVolume") %>% # タグがp, クラスがissueAndVolume
      html_text
    
    # タイトル一覧を抽出
    titles_issue <-
      html_issue %>%
      # タグがdiv, クラスがcitation.tocArticle以下のaタグのついた要素を抜き出す
      html_nodes("div.citation.tocArticle a") %>%
      html_text %>%
      data_frame(title = .) %>%
      # いくつか余計な要素が含まれているので、文字列の一致不一致で抽出箇所を限定する
      filter(str_detect(title, "pages")) %>% # extract titles
      filter(!str_detect(title, "Issue Information")) %>% # exclude issue info
      mutate(journal = journal,
             date = date,
             issue_volume = issue_volume)

    # 該当Issueの１号前のIssueのTOCのURLを取得する
    previous_url <-
      html_issue %>%
      html_nodes("a.previous") %>% # タグがa, クラスがprevious
      html_attr("href") %>% # href (URLリンク) 要素を抽出
      paste0("http://onlinelibrary.wiley.com/", .)
    
    return(list(titles_issue, previous_url))
  }
```


##### 実装2

- フローの1を実装
    - ISSNからcurrent issueページへのURLリンクを抽出
    - `extract_titles`関数を再帰的にあてる
        - closureが未だに使えないのでコードがひどい


```r
extract_ISSN <-
  function(ISSN, number_parse = 10){
    # get Current issue URL from ISSN
    current_url <-
      paste0("http://onlinelibrary.wiley.com/journal/10.1111/(ISSN)", ISSN, "/issues") %>%
      read_html %>%
      html_nodes("a#currentIssueLink") %>%
      html_attr("href") %>%
      paste0("http://onlinelibrary.wiley.com/", .)

    lapply(1:number_parse, function(i){
      extract_titles(current_url) %>%
        {
          current_url <<- .[[2]] # 親環境で結果を保存
          cat("ISSN", ISSN, "; finish: volume", i, "\n", sep = "")
          .[[1]] %>% return
        }
    })
  }
```


#### 実行

- 複数のISSNを与えてWiley系のいくつかの雑誌からタイトルを抽出する
    - 最近よく見る[{purrr}<sup>4</sup>](https://github.com/hadley/purrr)がなかなか
        - 入れ子状のデータ構造につよい
    - 正規表現+`tidyr::extract`の使い勝手がよい
        - r-wakalangでちら見したヤツ


```r
NP <- "1469-8137" #New Phytologist
PCE <- "1365-3040"  # Plant, Cell & Environment
PJ <- "1365-313X" # The Plant Journal
PP <- "1399-3054" # Physiologia Plantarum
PB <- "1438-8677" # Plant Biology

title_list <-
  lapply(c(NP, PCE, PJ, PP, PB), function(i) extract_ISSN(ISSN = i, number_parse = 3))
```

```
## ISSN1469-8137; finish: volume1
## ISSN1469-8137; finish: volume2
## ISSN1469-8137; finish: volume3
## ISSN1365-3040; finish: volume1
## ISSN1365-3040; finish: volume2
## ISSN1365-3040; finish: volume3
## ISSN1365-313X; finish: volume1
## ISSN1365-313X; finish: volume2
## ISSN1365-313X; finish: volume3
## ISSN1399-3054; finish: volume1
## ISSN1399-3054; finish: volume2
## ISSN1399-3054; finish: volume3
## ISSN1438-8677; finish: volume1
## ISSN1438-8677; finish: volume2
## ISSN1438-8677; finish: volume3
```

```r
# これだとエラー
# title_list %>%
#   dplyr::bind_rows 
# 入れ子リストだから

# purrr::flatten_XXXだと一発
# {purrr}はまだしっくり来てないがつよい  

title_df <-
  title_list %>%
  flatten_df %>%
  tidyr::extract(col = title, into = c("title", "start", "end"), regex = "(.+)\\(pages(.+[0-9]+)–([0-9]+)") %>% # remove pages
  tidyr::extract(col = issue_volume, into = c("vol", "issue"), regex = "([0-9]+).+([0-9]+)") %>% # separate volume and issue
  tidyr::extract(col = date, into = c("month", "year"), regex = "([a-zA-Z]+).([0-9]+)") # separate month and year
```


#### 結果

無事に抽出できている


```r
title_df %>%
  arrange(title) %>%
  head(20) %>%
  kable 
```



|title                                                                                                                                                                |start |end  |journal                   |month    |year |vol |issue |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----|:----|:-------------------------|:--------|:----|:---|:-----|
|14-3-3 protein mediates plant seed oil biosynthesis through interaction with AtWRI1                                                                                  |228   |235  |The Plant Journal         |October  |2016 |88  |2     |
|A consortium of non-rhizobial endophytic microbes from Typha angustifolia functions as probiotic in rice and improves nitrogen metabolism                            |938   |946  |Plant Biology             |November |2016 |18  |6     |
|A global meta-analysis of soil phosphorus dynamics after afforestation                                                                                               |181   |192  |New Phytologist           |January  |2017 |213 |1     |
|A grapevine cytochrome P450 generates the precursor of wine lactone, a key odorant in wine                                                                           |264   |274  |New Phytologist           |January  |2017 |213 |1     |
|A liquid chromatography–mass spectrometry platform for the analysis of phyllobilins, the major degradation products of chlorophyll in Arabidopsis thaliana           |505   |518  |The Plant Journal         |November |2016 |88  |3     |
|A multilevel investigation to discover why Kandelia candel thrives in high salinity                                                                                  |2486  |2497 |Plant, Cell & Environment |November |2016 |39  |1     |
|A putative molybdate transporter LjMOT1 is required for molybdenum transport in Lotus japonicus                                                                      |331   |340  |Physiologia Plantarum     |November |2016 |158 |3     |
|A roadmap for improving the representation of photosynthesis in Earth system models                                                                                  |22    |42   |New Phytologist           |January  |2017 |213 |1     |
|A user-friendly means to scale from the biochemistry of photosynthesis to whole crop canopies and production in time and space – development of Java WIMOVAC         |51    |55   |Plant, Cell & Environment |January  |2017 |40  |1     |
|ABNORMAL VASCULAR BUNDLES regulates cell proliferation and procambium cell establishment during aerial organ development in rice                                     |275   |286  |New Phytologist           |January  |2017 |213 |1     |
|Accumulation of sugars in the xylem apoplast observed under water stress conditions is controlled by xylem pH                                                        |2350  |2360 |Plant, Cell & Environment |November |2016 |39  |1     |
|Activation tagging in indica rice identifies ribosomal proteins as potential targets for manipulation of water-use efficiency and abiotic stress tolerance in plants |2440  |2459 |Plant, Cell & Environment |November |2016 |39  |1     |
|Adaptive evolution and functional innovation of Populus-specific recently evolved microRNAs                                                                          |206   |219  |New Phytologist           |January  |2017 |213 |1     |
|Aging and/or tissue-specific regulation of patchoulol and pogostone in two Pogostemon cablin (Blanco) Benth. cultivars                                               |272   |283  |Physiologia Plantarum     |November |2016 |158 |3     |
|Alistair M. Hetherington                                                                                                                                             |48    |49   |New Phytologist           |January  |2017 |213 |1     |
|Altered expression of the bZIP transcription factor DRINK ME affects growth and reproductive development in Arabidopsis thaliana                                     |437   |451  |The Plant Journal         |November |2016 |88  |3     |
|Alternating temperature combined with darkness resets base temperature for germination (Tb) in photoblastic seeds of Lippia and Aloysia (Verbenaceae)                |41    |45   |Plant Biology             |January  |2017 |19  |1     |
|Alternative oxidase respiration maintains both mitochondrial and chloroplast function during drought                                                                 |560   |571  |New Phytologist           |January  |2017 |213 |2     |
|Aluminium effects on mechanical properties of cell wall analogues                                                                                                    |382   |388  |Physiologia Plantarum     |December |2016 |158 |4     |
|Amelioration of drought tolerance in wheat by the interaction of plant growth-promoting rhizobacteria                                                                |992   |1000 |Plant Biology             |November |2016 |18  |6     |

<br>
<br>


#### 明日しらべる

- 流行り単語
- 経時トレンド
- 雑誌ごとの特徴


#### 参考ページ

[<sup>1</sup>StanでLDA: wordcloudクラスタリング](https://ytake2.github.io/ldastan/lda.html)  
[<sup>2</sup>How to Search PubMed with RISmed package in R](https://www.r-bloggers.com/how-to-search-pubmed-with-rismed-package-in-r/)  
[<sup>3</sup>rvestによるWebスクレイピング](https://book.mynavi.jp/manatee/detail/id=59386)  
[<sup>4</sup>hadley/purrr](https://github.com/hadley/purrr)  
