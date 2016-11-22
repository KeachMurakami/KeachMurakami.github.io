---
title: "博士論文書き"
output: html_document
layout: post
tags: lab memo log
---

全部書いて英文校正に出した  
次は中間発表 (12/2) までスライド作成  

執筆ログ  

```r
devtools::source_url("https://raw.githubusercontent.com/KeachMurakami/Sources/master/MyData/WriteLog.R")

paste0("Thesis_", c("Intro", "Chap2", "Chap3", "Conclusion", "Abst")) %>%
  WriteLog(PubName = ., comment = T) +
  theme(legend.position = "right")
```

<img src="/figure/source/2016-11-23-PhDThesis/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="100%" />

- toXXのXX (イニシャルなど) がコメントを貰ったとき
    - 余計なことを書きがちなので「先生に見てもらう → 減る」が顕著  
    - PRはproof reading
        - 投稿論文にはならない序論と結論の校正は、科研費で校正するのはどうなのか怪しかったので私費 (学振の研究遂行経費) で捻出  
        - 実際どうなんだろう
