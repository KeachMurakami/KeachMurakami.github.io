
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(googleVis)

ui <-
  dashboardPage(
    dashboardHeader(title="検定力分析"),
    
    dashboardSidebar(
      sidebarMenu(
        menuItem("Plot", tabName = "plot", icon = icon("line-chart")),
        menuItem("Description", tabName = "description", icon = icon("file-text-o")),
        menuItem("Source code", icon(github)),
                 href = "https://github.com/KeachMurakami/KeachMurakami.github.io/_shiny/")
        sliderInput("power", "(a) 検定力", 5, 100, 80),
        sliderInput("noise", "(b) 偶然誤差のSD", 0, 50, 10)
      )
    ),
    
    dashboardBody(
      tabItems(
        tabItem(tabName = "plot",
          h2("Dashboard tab content"),
          textInput("samplesize", "(c) サンプルサイズ (n) の上限値 (縦軸最大値):", 30),
          textInput("signal", "(d) 処理区の平均値の上限値 (横軸最大値):", 50),
          htmlOutput("plot"),
          h4("使い方"),
          h5(
            "対照区・処理区の母平均の差の検定 (t検定) を行う際のサンプルサイズ (いわゆるn) を決定するための事前の検定力分析を行います。", br(),
            "(a)で検定力を指定します。", br(),
            "(b)で偶然誤差のSDを指定します。平均値100に対するSD (= 変動係数) を入力してください。", br(),
            "(c)・(d)で図の表示範囲を設定します", br(),
            "母平均の増加・減少率: 対照区の母平均 (µctrl = 100) に対する処理区の母平均 (µtrtm) の変化率 ( |(µtrtm - µctrl) / µctrl - 1| ) です。", br(),
            "必要となるサンプルサイズ: 対照区・処理区でそれぞれ必要となるnです。", br()
          ),
          
          h4("解釈の仕方"),
          h5(HTML(paste0(
            "図内の線にマウスオーバーすると2つの値が表示されます。",
            tags$span(style="color:red", "上の値 (X)"), "は母平均の増加・減少率、", tags$span(style="color:red", "下の値 (Y)"), "は必要となるnです。"))),
          
          h5("パターン1: X以上の効果がある処理の検出を目標とする場合、効果を十分な確率 (指定した検定力) で評価するために必要なnはYです。"),
          h5("パターン2: 指定した偶然誤差の下で、Y回反復した実験では、指定した検定力を維持して検出できるのは、X以上の効果がある処理のみです。")
          ),
        
      tabItem(tabName = "description",
        h3("検定力分析とは？"),
        h5(
          "サンプルサイズ、効果量、有意水準、検定力のうち、既知の３要素から残りの１要素を決定する手続きです。", br()
        ),
        br(),
        h4("用語の簡単な説明"),
        h4("検定力"),
        h5(
          "= 検出力, power。", br(),
          "対立仮説が真であるとき、帰無仮説を正しく棄却する確率です。", br(),
          "つまり、処理に効果があるときに有意差あり、と判断する確率です。", br(),
          "検定力が小さい場合、実在する効果を見逃す確率が高くなります。", br(),
          "目安は80%、少なくとも50%以上にすべき、であるとされます。"
        ),
        
        h4("効果量"),
        h5(
          "= effect size。", br(),
          "「効果の大きさ」を表す指標で、いくつかの種類があります (参考文献を参照)。", br(),
          "t検定を行う実験の場合、効果による母平均の差と測定値のばらつきを入力値とした関数で表されます。", br(),
          "実用するイメージを持ちやすいよう、効果量を母平均の増加・減少率と偶然誤差にわけて図示しています。"
        ),
        br(),
        
        h4("参考文献"),
        h5(
          a("サンプルサイズの決め方 (永田, 2003)",
            href = "http://www.asakura.co.jp/books/isbn/978-4-254-12665-5/)"),
          br(),
          a("検定力分析入門－Ｒで学ぶ最新データ解析 (豊田, 2009)",
            href = "http://www.tokyo-tosho.co.jp/books/ISBN978-4-489-02065-0.html"),
          br(),
          a("伝えるための心理統計: 効果量・信頼区間・検定力 (大久保・岡田, 2012)",
            href = "http://www.keisoshobo.co.jp/book/b97219.html")
        ), 
        br(),
        
        h6("著作権および免責事項"),
        h6(
          "ソフトウェア、ソースコードとも、ご自由に使用・改変していただいて構いません。",
          "このソフトウェアを使用したことによって生じたすべての障害・損害・不具合等に関しては、私と私の関係者および私の所属するいかなる団体・組織とも、一切の責任を負いません。各自の責任においてご使用ください。"
        )
      )
    )
  )
)


# server.R
server <-
  function(input, output) {
    
    data_set <- reactive({
      
      dif_mean <- input$signal %>% as.numeric # シグナルの最大値を設定
      n_range_max <- input$samplesize %>% as.numeric # サンプルサイズの最大値
      
      SD_rand <- input$noise %>% as.numeric # 偶然誤差
      pwr <- input$power %>% as.numeric # 検定力
      
      
      result_n <- numeric(length = dif_mean)
      for(dif in 1:dif_mean){
        if(class(try(power.t.test(n = NULL, delta = dif, sd = SD_rand, power = pwr/100, sig.level = 0.05))) == "try-error"){
          result_n[dif] <- NA
        } else {
          result_n[dif] <- power.t.test(n = NULL, delta = dif, sd = SD_rand, power = pwr/100, sig.level = 0.05)$n
        }
      }
      data.frame(Δµ = 1:dif_mean, n = result_n, power = pwr, SDrandom = SD_rand, n_max = n_range_max) %>%
        return
    })
    
    output$plot <- renderGvis(
      data_set() %>%
        select(1:2) %>%
        filter(n < data_set()[1, 5]) %>%
        gvisLineChart(
          options = list(
            legend = "none",
            lineWidth = 2, pointSize = 0,
            title =  paste0("検定力: ", data_set()[1, 3], "%; 偶然誤差のSD: ", data_set()[1, 4]),
            vAxis="{title:'必要となるサンプルサイズ'}",
            hAxis = "{title:'母平均の増加・減少率 [%]'}", 
            width = "100%", height = 600)
        )
    )
  }

shinyApp(ui, server)

# shinyapps::deployApp(appDir = "~/Dropbox/KeachMurakami.github.io/_shiny/PowerAnalysis/")