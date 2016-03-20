---
title: "dplyr::selectではベクトル出力はできない (メモ"
output: html_document
layout: post
tags: R memo dplyr
---





```r
# デフォルトの列選択
iris[, "Species"] %>%
  head
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```

```r
# データフレーム構造を維持
iris[, "Species", drop = F] %>%
  head
```

```
##   Species
## 1  setosa
## 2  setosa
## 3  setosa
## 4  setosa
## 5  setosa
## 6  setosa
```

と同じイメージで`dplyr::select`でデータフレームからベクトルを取り出そうとして、よく怒られる  

```r
iris %>%
  select(Species, drop = T)
```

```
## Error: All select() inputs must resolve to integer column positions.
## The following do not:
## *  T
```

[Hadley Wickham (dplyrの作成者) が書いている](http://stackoverflow.com/questions/21618423/extract-a-dplyr-tbl-column-as-a-vector)とおり、`dplyr::select`にはデータフレームからベクトルを出力する仕様はない

上のページを見ていると、「`magrittr::extract2`が便利だよ」とあった  

```r
iris %>%
  magrittr::extract2(5) %>%
  head
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```

```r
iris %>%
  magrittr::extract2("Species") %>%
  head
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```


複数列に対する挙動が変なので`extract2`の中身を見てみたら、がっかりした  

```r
iris %>%
  magrittr::extract2(4:5)
```

```
## [1] 0.2
```

```r
print(extract2)
```

```
## .Primitive("[[")
```

#### 参考  
[Extract a dplyr tbl column as a vector (Stack Overflow)](http://stackoverflow.com/questions/21618423/extract-a-dplyr-tbl-column-as-a-vector)  


```r
session_info()
```

```
## Error in eval(expr, envir, enclos): could not find function "session_info"
```
