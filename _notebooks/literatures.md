ダウンロードしたことすら忘れるので、ダウンロードした (眠っていた) 論文とそのひとことメモ

-   `低/中/高`は優先度
-   `無`は現時点で(自分にとって)読む必要がないもの
-   `引`は引用に使いそうなもの
-   `未刊`はin press
-   `有償`はアクセス権がなくて有償なもの、おもに書籍
-   <FONT color="green">緑文字</FONT>: Review article
-   <FONT color="blue">青文字</FONT>: Meta analysis

``` r
library(rvest)
library(magrittr)
library(tidyverse)

data_html <-
  "https://github.com/KeachMurakami/KeachMurakami.github.io/blob/master/_supplemental/Literatures.Rmd" %>%
  read_html

num_paper <-
  data_html %>%
  html_nodes("article") %>%
  html_nodes(xpath = "//ul//li//p//a")
  # html_nodes("p") %>%
  html_structure()
```

------------------------------------------------------------------------

-   2017

    -   01

        -   19

            1.  [Gimenez-Ibanez et al. 2017; New Phytol](http://onlinelibrary.wiley.com/wol1/doi/10.1111/nph.14354/abstract); 無
                -   JAZ2 controls stomata dynamics during bacterial invasion
                -   バクテリアの感染と気孔開度の調節の仕組みに関して
                -   感染で一度閉じた気孔を、Coronatineというphytotoxinにより再度開かせる
                -   後輩に投げつける

            2.  [de Vries et al. 2017; Trends Plant Sci](http://www.sciencedirect.com/science/article/pii/S1360138516302060); <FONT color="green">高・未刊</FONT>
                -   Dynamic Plant–Plant– Herbivore Interactions Govern Plant Growth–Defence Integration
                -   光獲得と対被食のトレードオフに関して
                -   R/FR比がメイン
        -   20

            1.  [Ballaré & Pierik 2017; PCE](http://onlinelibrary.wiley.com/wol1/doi/10.1111/pce.12914/abstract); <FONT color="green">高・未刊</FONT>
                -   The shade avoidance syndrome: Multiple signals and ecological consequences
                -   “syndrome”ってつけるとキャッチーだ

            2.  [Uematsu et al. 2017; New Phytol](http://onlinelibrary.wiley.com/wol1/doi/10.1111/nph.14416/abstract); <FONT color="grey">無</FONT>
                -   Foliar uptake of radiocaesium from irrigation water by paddy rice (*Oryza sativa*): an overlooked pathway in contaminated environments
                -   いつか出してやると思っている*New Phytologist*に、研究科の元先輩がacceptされていたので記念に
                -   水田イネへの放射性セシウムの吸い上げについて
        -   21

            1.  [Wientjes et al. 2017; BBA](http://www.sciencedirect.com/science/article/pii/S0005272817300099?np=y); 中
                -   Imaging the Photosystem I/Photosystem II chlorophyll ratio inside the leaf
                -   画像解析 & 蛍光寿命解析でPSII/PSI比を面的に
                -   以下の`Iermak et al. 2016`の発展

            2.  [Iermak et al. 2016; BBA](http://www.sciencedirect.com/science/article/pii/S0005272816305564); 20170121済
                -   Visualizing heterogeneity of photosynthetic properties of plant leaves with two-photon fluorescence lifetime imaging microscopy
                -   `Wientjes et al. 2017`から
                -   two-photonとFLIMで深度情報まで考慮して光化学系組成を解析
                    -   厳密には、LCHII/PSII比とPSII/PSI比
                    -   PSII/PSIエネルギー分配の絶対定量はできない
                -   見逃してたので、投稿論文に追加する？
        -   24

            1.  [Galvão & Fankhauser 2015; Cur Opin Neurobiol](http://www.sciencedirect.com/science/article/pii/S0959438815000227); <FONT color="green">低</FONT>
                -   Sensing the light environment in plants: photoreceptors and early signaling steps
                -   植物の光センシングに関する異分野への概説系レビュー
                -   Chemical寄り

            2.  [Razzak et al. 2017; PCE](http://onlinelibrary.wiley.com/wol1/doi/10.1111/pce.12921/abstract); 高・未刊
                -   Differential response of Scots pine seedlings to variable intensity and ratio of R and FR light
                -   ヨーロッパアカマツ苗の光強度 x R/FR比への応答
                -   胚軸長、色素蓄積など
                -   被子植物・裸子植物の差異を絡めている
                -   abstractだとPCEに載るほどのものはない印象を受けるが...なにかあるんだろう
        -   25

            1.  [Morena et al. 2017; J Photochem Photobiol B](http://www.sciencedirect.com/science/article/pii/S1011134416309733); 低・未刊
                -   *In vitro* antimicrobial activity of LED irradiation on *Pseudomonas aeruginosa*
                -   長波長 (980 nm) LED光での*Pseudomonas aeruginosa* (緑膿菌) 繁殖の抑制
                -   口腔衛生、小児科学などの人たち

            2.  [Munafò et al. 2017; Nat Hum Behav](http://www.nature.com/articles/s41562-016-0021); <FONT color="green">高</FONT>
                -   A manifesto for reproducible science
                -   再現性の担保について
                    -   *P*-hackingとか、そのあたり
                    -   去年のASAのstar-counting 統計の批判以来、流行っている
                    -   *eLife*でも特集されてた
                        -   [ココ](https://elifesciences.org/content/6/e23693)らへん
                        -   癌研究だとか、生体の実験でRCTだときついだろう
                -   探索的な研究だと仕方ない側面もあるよね、と思いつつ、着々と脱検定を進めている

            3.  [Shirai et al. 2017; J Food Eng](http://www.sciencedirect.com/science/article/pii/S0260877416303739); <FONT color="grey">無</FONT>
                -   Penetration of aerobic bacteria into meat: A mechanistic understanding
                -   食肉の表面から内部へのバクテリアの侵入のモデル化
                -   博士の公開審査で聞いたので
                -   「鉛直プロファイルの*in vivo*値とモデル推定値を比較していないのですか」という質問は、まっとうだけどしんどい
        -   26

            1.  [Izumi et al. 2017; Plant Cell](http://www.plantcell.org/content/early/2017/01/25/tpc.16.00637.short?rss=1); 無・未刊
                -   Entire Photodamaged Chloroplasts Are Transported to the Central Vacuole by Autophagy
                -   chlorophagyなるフレーズ
                -   photodamageを受けた葉緑体が液胞中心に移動する
                -   「移動して、そのあとどうなる」が意図的に書かれていなさそう

            2.  [Kono et al. 2017; PCP](https://academic.oup.com/pcp/article/doi/10.1093/pcp/pcw215/2948616/Photoprotection-of-PSI-by-Far-Red-Light-Against); 高
                -   Photoprotection of PSI by Far-Red Light Against the Fluctuating Light-Induced Photoinhibition in Arabidopsis thaliana and Field-Grown Plants
                -   FRで変動光下でのPSI阻害が抑制できる話
                -   内容は既知のものなので、引用されている文献など、知識収集メインで読むべし
        -   28

            1.  [Riikonen 2017; Forest Ecol Manag](http://www.sciencedirect.com/science/article/pii/S0378112716311173); 20170128済
                -   Content of far-red light in supplemental light modified characteristics related to drought tolerance and post-planting growth in Scots pine seedlings
                -   アカマツの苗木にFR添加したときの耐乾燥性とその後の成長
                -   *in situ*水利用効率 (*P*<sub>n</sub>/*g*<sub>s</sub>) をRGB光源で測定した値で議論
                    -   *in situ*な光 (=太陽光) のもとでは？
                    -   典型的な栽培光x測定光の交互作用問題
                -   GLMMで、`ORIG x FR`項の係数を水準ごとに解析できるようダミー変数でバラすテクニック
                    -   TS先生に今度あったときに話そう

            2.  [Pierik & de Wit 2014; JXB](https://academic.oup.com/jxb/article-lookup/doi/10.1093/jxb/ert389); <FONT color="green">低</FONT>
                -   Shade avoidance: phytochrome signalling and other aboveground neighbour detection cues
                -   群落の成長に伴うR/FRの変化と、その他の光質・物理的接触・VOCと関連付けてレビュー

            3.  [Cocetta et al. 2017; BookChap](http://link.springer.com/article/10.1140/epjp/i2017-11298-x); <FONT color="green">低・有償</FONT>
                -   Light use efficiency for vegetables production in protected and indoor environments
                -   37.75 euro
                -   D論周りとぴったしだけど、引用文献を見るにあまり得るものはなさそう...?
                -   年度末に学振の研究遂行経費が残っていれば落とす
        -   30

            1.  [Geigenberger et al. 2017; Trend Plant Sci](http://www.sciencedirect.com/science/article/pii/S1360138516302217); <FONT color="green">中・未刊</FONT>
                -   The Unprecedented Versatility of the Plant Thioredoxin System
                -   Redoxといえばthioredoxin見たいな感じがあるので読んでおこう

            2.  [Endo et al. 1999; FEBS Letters](http://onlinelibrary.wiley.com/wol1/doi/10.1016/S0014-5793(99)00989-8/full); 20170130済
                -   The role of chloroplastic NAD(P)H dehydrogenase in photoprotection
                -   NDHが強光に対するphotoprotectionとして機能していることを主張
                    -   他にはあまりNDH-CEF単体で効いている話がないので、解釈が難しい
                -   MV添加でPSI donorを作ると、ΔndhBでもPSIの励起が抑えられるから、NDH-CEF-PSIが効いてる
                -   いまNDH-光阻害界隈がどうなってるのかはしっかり追えてないが、さほど効果的な防御システムになっているとは考えられていない (と思う, `Nawrocki et al. (2015)`とか)
                    -   Nawrockiはこれ引いてないな...

            3.  [Heyno et al. 2014; Phil Trans R Soc Lond B](http://rstb.royalsocietypublishing.org/content/369/1640/20130228); 20170130済
                -   Putative role of the malate valve enzyme NADP–malate dehydrogenase in H<sub>2</sub>O<sub>2</sub> signalling in *Arabidopsis*
                -   `Geigenberger et al. (2017)`をつらつら読んでいて引っかかったので
                -   Malate valveでのNADP-malate-DHがH<sub>2</sub>O<sub>2</sub>経由のシグナリングとリンクしている
                    -   因果関係をダイレクトに示すものではないように思うが
                -   Supporting Tableの1より大きいphi(II)とは...
        -   31

            1.  [星野・岡田 2006; J Natl Inst Public Health](https://www.niph.go.jp/journal/data/55-3/j55-3.html); <FONT color="green">低</FONT>
                -   傾向スコアを用いた共変量調整による因果効果の推定と臨床医学・疫学・薬学・公衆衛生分野での応用について
                -   `岩波DS Vol. 3`から

            2.  [丹後 2000; J Natl Inst Public Health](https://www.niph.go.jp/journal/data/49-4/j49-4.html); <FONT color="green">20170131済</FONT>
                -   良質の根拠を生む randomization の本質 ー科学研究者としてのセンスー
                -   `星野・岡田 (2006)`の引用文献をちら見して
                -   標準化・ルール整備が重要
                -   実験条件を“揃える”の定義は分野によるのがなんとも
                    -   生態学の`Hurlbert (1984)`は、“揃える”によりシビア
                    -   「条件」を受ける時間が長いと、微差を気にする必要があるから
                    -   その基準は主観

            3.  [Gerszberg & Hnatuszko-Konka 2017; Plant Growth Regul](http://link.springer.com/article/10.1007/s10725-017-0251-x); <FONT color="green">低</FONT>
                -   Tomato tolerance to abiotic stress: a review of most often engineered target sequences
                -   非生物耐性のレビュー

    -   02

        -   01

            1.  [Cai et al. 2017; J Photochem Photobiol B](http://www.sciencedirect.com/science/article/pii/S101113441631065X); 20170201済・未刊
                -   The water-water cycle is a major electron sink in *Camellia* species when CO<sub>2</sub> assimilation is restricted
                -   ツバキ３品種のAEF活性について
                    -   ツバキはなぜか赤青光下で速やかに気孔が閉じる
                -   WWCが強光かつ低*P*<sub>n</sub>条件 (光呼吸条件) で重要になる
                    1.  気孔が閉じてCO<sub>2</sub>供給が遅れる (これはツバキでユニークっぽい)
                    2.  *V*<sub>o</sub>/*V*<sub>c</sub>が上がる
                    3.  ATP/NADPH要求が増える (*V*<sub>o</sub>だと1.5, *V*<sub>c</sub>だと1.75なので)
                    4.  WWCでNADPH生産を減らす
                -   実験・議論ともエレガントで明快

            2.  [Nishikawa et al. 2012; PCP](https://academic.oup.com/pcp/article-lookup/doi/10.1093/pcp/pcs153); 20170202済
                -   PGR5-Dependent Cyclic Electron Transport Around PSI Contributes to the Redox Homeostasis in Chloroplasts Rather Than CO<sub>2</sub> Fixation and Biomass Production in Rice
                -   `Cai et al. 2017`が`Yamori et al. 2015; Sci Rep`と並べて低PFDでのCEF-PSIをサポートするとして引用していたので
                    -   *pgr5*欠損は、強光下での*P*<sub>n</sub>も小さくしている (有意差はないけど)
                    -   *pgr5*欠損は、とくに強光下でpmf (ECS解析) を低下させる
                    -   やや強引な引用なのではないか...?

            3.  [Williamson 2007; Nutrition Bulletin](http://onlinelibrary.wiley.com/doi/10.1111/j.1467-3010.2007.00628.x/abstract); <FONT color="green">無</FONT>
                -   Is organic food better for our health?
                -   まっとうな研究としてまっとうな研究者の本で引用されていたので、気になって
                -   ニュートラル・客観的な論調
        -   02

            1.  [園池 2012; 光合成研究](http://photosyn.jp/journal.html#64); 20170202済
                -   果実の光合成
                -   文章に優しさが溢れている
        -   03

            1.  [Shimakawa et al. 2017; Plant Physiol](http://www.plantphysiol.org/content/early/2017/02/02/pp.16.01038.short?rss=1); 低・未刊
                -   The liverwort, *Marchantia*, drives alternative electron flow using a flavodiiron protein to protect PSI
                -   cyanobacteria同様、ゼニゴケにもFLV経由のAEFがあり、PSIを保護する
                -   高等植物ではFLV経路が機能しないので、自分にとって必要という感じではない
                -   このグループは勢いが凄まじい

            2.  [Chaux et al. 2015; Front Plant Sci](http://journal.frontiersin.org/article/10.3389/fpls.2015.00875/full); <FONT color="green">20170202済</FONT>
                -   A security network in PSI photoprotection: regulation of photosynthetic control, NPQ and O<sub>2</sub> photoreduction by cyclic electron flow
                -   “photosynthetic control”をテクニカルタームとして使っているが、流行らない気がする
                -   Cyt *b*<sub>6</sub>*f*の制御というよりはPSIの収率の制御だと、自分は思っている

            3.  [Joliot & Johnson 2011; PNAS](http://www.sciencedirect.com/science/article/pii/S0005272808000972); 20170203済 (再)
                -   Regulation of cyclic and linear electron flow in higher plants
                -   arabidopsisでCEFモードの起動・終了の時間を議論
                    -   起動は20秒程度の飽和赤色光で十分
                    -   終了の1/2tはdarkで20秒程度
                -   光化学反応の時定数 *k*<sub>psii</sub> を定量する話は[Joliot & Joliot 2008; BBA](http://www.sciencedirect.com/science/article/pii/S0005272808000972)
                -   励起エネルギー分配との区分にやや困る
                -   非常にエレガントな論文だと再読して気づく
        -   04

            1.  [Zhang et al. 2017; Comput Electron Agric](http://www.sciencedirect.com/science/article/pii/S0168169917300820); 無
                -   Leaf image based cucumber disease recognition using sparse representation classification
                -   Sparse modelかと思ったら違った
                -   可視障害の病斑箇所をK-meansでクラスタ分析して、そのパターンからSparse representationで障害の種類を診断
                -   生データを出せば病斑認識データセットとしてよく引用されそうだけども...
                -   この雑誌をほとんど見たことがなかったけど、好みなのでフォロー

            2.  [Dang et al. 2014; Plant Cell](http://www.plantcell.org/content/26/7/3036.abstract); 20170205済
                -   Combined Increases in Mitochondrial Cooperation and Oxygen Photoreduction Compensate for Deficiency in Cyclic Electron Flow in *Chlamydomonas reinhardtii*
                -   WTと*pgr*5の電子伝達のPFD・CO<sub>2</sub>応答を網羅的に解析している労力が凄まじい研究
                -   根底には、「PGR-CEFの欠損によりATP不足がWTよりさらに厳しい状態で、電子伝達はどう対応しているのか？」がある
                -   Malate valve (mitorespiration) とO<sub>2</sub>還元 (FLV・Mehler) がATP不足をサポートする
                -   *pgr*5はRCIを減らして系I結合LHCIIを増やしている...？
                -   変動光下ではやっぱり成育阻害が起こる
                -   Ruuska、Drieverあたりでも思ったがMIMSいいな
        -   06

            1.  [Li et al. 2017; Plant Physiol](http://www.plantcell.org/content/early/2017/01/30/tpc.16.00768.short?rss=1); 低・未刊
                -   Protein Degradation Rate in Arabidopsis thaliana Leaf Growth and Development
                -   タンパク分解をsystems biologyっぽく

            2.  [Atherton et al. 2016; Remote Sens Environ](http://www.sciencedirect.com/science/article/pii/S0034425715302571); 低
                -   Using Spectral Chlorophyll Fluorescence and the Photochemical Reflectance Index to Predict Physiological Dynamics
                -   リモートセンシング系雑誌をまったくカバーしていなかったので、feedを集め始めた
                -   簡単には読めないが、

            3.  [Bailleul et al. 2010; Photosynth Res](http://link.springer.com/article/10.1007/s11120-010-9579-z); <FONT color="green">20170206済 (再)</FONT>
                -   Electrochromism: a useful probe to study algal photosynthesis
                -   ECS解析のレビュー (ECSの知識はほぼこれのみ)
        -   07

            1.  [Feild et al. 1998; Plant Physiol](http://www.plantphysiol.org/content/116/4/1209.long); 20170207済
                -   Nonphotochemical Reduction of the Plastoquinone Pool in Sunflower Leaves Originates from Chlororespiration
                -   *F*<sub>o</sub>と阻害剤を多用した暗条件下でのchlororesprationの挙動の解析
                -   ヒマワリのpreincubation条件を振って、postilluminationでdark下での*F*<sub>o</sub>を観察
                    -   illuminationが10 min 1000 µmol m<sup>-2</sup> s<sup>-1</sup>なのにそれにincubation条件がキャンセルされないのが新鮮
                -   この論文のchlororespirationのターンオーバ速度を、0.1 mmolChl m<sup>-2</sup>でフラックスに換算すると、mmole<sup>-1</sup> molChl<sup>-1</sup> s<sup>-1</sup> ~ 10<sup>-1</sup> µmole<sup>-1</sup> m<sup>-2</sup> s<sup>-1</sup>で、暗条件でのPQへの電子伝達は、0.07 µmole<sup>-1</sup> m<sup>-2</sup> s<sup>-1</sup>程度の微弱なもの
                -   rotenoneを加えてNDH経路を止めてもPQの再還元が起こる理由を、“Although this may indicate a rotenone-insensitive pathway for dark PQ reduction, it is equally likely that incomplete infiltration of rotenone into the leaves is the explanation.”と書いているが、単純にrotenone耐性の2型NDHなのでは...?
                    -   追っかければわかりそうだけど、深入りしない
        -   09

            1.  [Yan et al. 2017; Global Change Biol](http://onlinelibrary.wiley.com/wol1/doi/10.1111/gcb.13654/abstract); <FONT color="blue">低・未刊</FONT>
                -   Contrasting responses of leaf stomatal characteristics to climate change: a considerable challenge to predict carbon and water cycles
                -   CO<sub>2</sub>、temperature、droughtで気孔密度をメタ解析
                -   標高・時代を交絡因子として扱っているっぽい
                -   メタ解析、いつかやってみたいので
        -   10

            1.  [Vialet-Chabrand et al. 2017; Plant Physiol](http://www.plantphysiol.org/content/early/2017/02/09/pp.16.01767.short?rss=1); 高・未刊
                -   Importance of fluctuations in light on pant photosynthetic acclimation
                -   タイトルがtypoってる (pantじゃなくてplantだろう、たぶん)
                -   変動光、はやってる
        -   12

            1.  [Mishanin et al. 2017; Photosynth Res](http://link.springer.com/article/10.1007/s11120-017-0339-1); 20170219済
                -   Acclimation of shade-tolerant and light-resistant *Tradescantia* species to growth light: chlorophyll *a* fluorescence, electron transport, and xanthophyll content
                -   Tikhonovのグループ
                    -   このグループも含め、なんとなくロシア・バルトあたりの論文は個人的に読みづらく感じる
                    -   と思ってたらこの人のはめちゃくちゃ読みやすかったのでサンプリングバイアス
                -   ツユクサの陰性・陽性を弱光(LL)・強光(HL)で栽培して光合成特性を解析
                -   *F*<sub>685</sub>/*F*<sub>740</sub>比に注力
                    -   NPQ・state transition・chloroplast movementの３要素に分解
                    -   NPQ: 早い
                    -   State transition: 中間程度
                    -   chloroplast movement: *t*<sub>1/2</sub> ~ 10 min (Ptushenko et al. 2017)
                -   LLだと77K蛍光ピーク強度比のstate transitionが単相だが、HLだと二相？
                -   *T*<sub>light</sub>/*T*<sub>dark</sub>の絶対値の議論には意味がない
                    -   *T*<sub>dark</sub>が小さい場合に安定しないので
        -   13

            1.  [Michelet et al. 2013; Front Plant Sci](http://journal.frontiersin.org/article/10.3389/fpls.2013.00470/full); <FONT color="green">低</FONT>
                -   Redox regulation of the Calvin–Benson cycle: something old, something new
                -   カルビン回路の活性化についてレビュー
                -   PQ-redoxではなく、thiore系のredox
                -   `Mishanin et al. 2017`から

            2.  [Mishanin et al. 2016; Photosynth Res](http://link.springer.com/article/10.1007%2Fs11120-016-0252-z); 中
                -   Light acclimation of shade-tolerant and light-resistant *Tradescantia* species: induction of chlorophyll *a* fluorescence and P<sub>700</sub> photooxidation, expression of PsbS and Lhcb1 proteins
                -   `Mishanin et al. 2017`から

            3.  [Davis et al. 2011; PCE](http://onlinelibrary.wiley.com/wol1/doi/10.1111/j.1365-3040.2011.02402.x/full); 中
                -   Changes in leaf optical properties associated with light-dependent chloroplast movements
                -   `Mishanin et al. 2017`から
                -   葉緑体の動きが吸収率に及ぼす影響が栽培条件で異なる話らしい
                    -   “who examined how leaf anatomy in uenced chloroplast movements in 24 plant species, reported that chloroplast movement-dependent changes in leaf absorptance were greatest in shade species, in which absorptance changes of &gt;10% were observed between HL and LL treatment”
                -   あまり引用されていないので知らなかったが、良さそう
        -   15

            1.  [Kawase et al. 2016; Climatic Change](http://link.springer.com/article/10.1007%2Fs10584-016-1781-3); 無
                -   Enhancement of heavy daily snowfall in central Japan due to global warming as projected by large ensemble of regional climate simulations
                -   [気候シナリオシンポ@つくば](mailto:気候シナリオシンポ@つくば) (2017/02/14) の発表者の論文
                -   門外漢だけどとても話が面白かったので
                -   温暖化 (海温上昇) により気象現象の極端化が進むと、日本海側の山間部で豪雪が生じる危険性がある
        -   16
            -   査読対応のため、T先生 (1985) の論文のフォロワー掘り

            1.  [Vogelmann et al. 1989; Phil Trans R Soc Lond B](http://rstb.royalsocietypublishing.org/content/323/1216/411); 20170216済
                -   Photosynthetic Light Gradients and Spectral Regime within Leaves of Medicago sativa
                -   細胞の集光レンズ効果の話

            2.  [Pantaleoni et al. 2009; Planta](http://link.springer.com/article/10.1007/s00425-009-1004-5); 20170216済
                -   Photosystem II organisation in chloroplasts of *Arum italicum* leaf depends on tissue location
                -   Aroのグループ
                -   光合成系の組成を、柵状・海綿状組織に加え、葉柄柔組織 (parenchyma w/ chl)、葉柄通気組織 (aerenchyma w/o chl) で解析するやや博物学的要素が強い論文
                -   State transitionとphotosystem stoichiometry以外で光分配が制御されていることを示してある
                    -   2016で引用すべきだった
                    -   こっちを主題で書けばいいのに、と勝手に思う
                -   この植物は部位ごとに分けるのに便利な様子
                    -   “*Arum italicum* Miller (Araceae) leaf ... allows analysing separately four different photosynthetic tissues: the palisade and the spongy tissues, which form the lamina mesophyll, and the outer chlorenchyma and the inner aerenchyma, which form the petiole parenchyma”
                -   単子葉類は、PSII超複合体が不安定で、LHCII-trimerを過大評価しがち
                    -   “in monocots the presence of less stable PSII supercomplexes could reduce the sensitivity of BN-PAGE analysis and lead to overestimation of the amount of LHCII trimers and misleading results (Ciambella et al. 2005)”
                -   Palisade vs spongy の解析で、spongyの77K蛍光のPSI側が増えている
                    -   free LHCII trimerが増えて熱放散、という解釈
                        -   2D-PAGEとも整合的
                        -   preparation/77K計測までの条件で変わりそう (非NPQ形成状態でやったらstoichiometry影響が見えそう)
                    -   明快、という感じではないが、リーズナブル

            3.  [Kanervo et al. 2005; Photochem Photobiol Sci](http://pubs.rsc.org/en/content/articlelanding/2005/pp/b507866k/unauth#!divAbstract); <FONT color="green">低</FONT>
                -   Functional flexibility and acclimation of the thylakoid membrane
                -   Aroグループ (Pantaleoniから)
                -   知らない雑誌だ
                    -   植物率低そうだけど、一応 feed を取る
        -   17

            1.  [Chow et al. 1987; Physiol Plant](http://onlinelibrary.wiley.com/wol1/doi/10.1111/j.1399-3054.1987.tb06131.x/full); 20170217済・引
                -   The composition and function of thylakoid membranes from pea plants grown under white or green light with or without far-red light
                -   “the amounts of light-harvesting and electron transport components may be regulated by photosynthesis itself”
                -   FR照射は、励起バランスが崩すのはかなり堅いはなし
                -   しかし、FR照射で光合成系の組成が大きく変化する話は (知っている限り) ない
                -   自分のデータ (2016, Physiol Plant) もそうだし
                -   結局、やっぱりよくわからない部分があるなぁ
        -   20

            1.  [Smirnakou et al. 2017; Front Plant Sci](http://journal.frontiersin.org/article/10.3389/fpls.2017.00188/full); 低
                -   Continuous Spectrum LEDs Promote Seedling Quality Traits and Performance of *Quercus ithaburensis* var. *macrolepis*
                -   タルボガシなる木の苗について
                -   調べるのが面倒だからスペクトル出してほしい...
                -   根の外観の話をするなら写真を...なんで紙媒体じゃないのにスペースをケチるのか
        -   22

            1.  [Vavasseur & Raghavendra 2005; New Phytol](http://onlinelibrary.wiley.com/wol1/doi/10.1111/j.1469-8137.2004.01276.x/full); <FONT color="green">低</FONT>
                -   Guard cell metabolism and CO<sub>2</sub> sensing
                -   第二著者の本 (Photosynthesis) を裁断するにあたり、なんとなく調べた
        -   27

            1.  [Motohashi & Myouga 2015; bio-protocol](http://www.bio-protocol.org/e1464); 20170227済
                -   Chlorophyll Fluorescence Measurements in *Arabidopsis* Plants Using a Pulse-amplitude-modulated (PAM) Fluorometer
                -   学部生なんかへのMINI-PAMの使い方の説明によさそう
                -   ただ、abstractの1文目からの`Fv = Fm ± Fo`はいかん...
                -   bio-protocolは論文でいいのか...?
        -   28

            1.  [Granier & Vile 2014; Cur Opin Plant Biol](http://www.sciencedirect.com/science/article/pii/S1369526614000259); 20170228済
                -   Phenotyping and beyond: modelling the relationships between traits
                -   phenotyping系のレビューが乱立しているような

            2.  [Bos et al. 2017; BBA](http://www.sciencedirect.com/science/article/pii/S0005272817300403); 無
                -   Multiple LHCII antennae can transfer energy efficiently to a single Photosystem I
                -   Croce, Wientjesグループ
                -   複数のLCHIIが単一PSIへEET
                -   このグループのは、ちょっともう厳しい (物理すぎて)

    -   3

        -   01

            1.  [Kalaji et al. 2016; Photosynthe Res](https://link.springer.com/article/10.1007%2Fs11120-016-0318-y); <FONT color="green">低・引</FONT>
                -   Frequently asked questions about chlorophyll fluorescence, the sequel
                -   `Kalaji et al. 2014`の続編

            2.  [Singh et al. 2017; Plant Cell Tiss Organ Cult](https://link.springer.com/article/10.1007/s11240-017-1170-2); 低
                -   High light intensity stress as the limiting factor in micropropagation of sugar maple (*Acer saccharum* Marsh.)
                -   PFD 3水準 x 光質 2水準で育てて2DのイメージングPAM
                -   メープルは陰性植物らしい
                -   “40 µmol 程度の光でも強光ストレスがあり、最適とは言えない”という結論だが、ストレスの根拠はred pigmentationであり、ダイレクトではない
                -   平行したクロロフィルの減少が、バイオマス (FW・DW) 減少につながっていないし、あまり納得できない
                -   結論ありきの研究という印象

            3.  [Baerr et al. 2005; Physiol Plant](http://onlinelibrary.wiley.com/wol1/doi/10.1111/j.1399-3054.2005.00506.x/abstract); 20170307済・引
                -   Differential photosynthetic compensatory mechanisms exist in the *immutans* mutant of *Arabidopsis thaliana*
                -   `Kanervo et al. 2005`から
                    -   “the IM-knock-out mutants were recently shown to be more susceptible to photoinhibition than the wild type Arabidopsis plants”
                -   この論文の意図には反しており、あまりよい引用ではない
                    -   どちらかというと、「*im*、思ったより光阻害でない。でも斑入り程度によって阻害程度が異なるのは面白い。」
                    -   “We found, on both a whole plant and individual leaf basis, that there were minimal differences in susceptibility to photoinhibition between im and the wild-type, as determined by the Fv/Fm ratios (Fig. 4). However, the general trend pointed towards an increased susceptibility in im, with the green sectors of the imw leaves being somewhat more susceptible than the img leaves (Fig. 4)”
                -   斑なし部 (green部) が斑入り部 (im部) の成長を補填している、という考え方

            4.  [van Langevelde et al. 2017; Biol Lett](http://rsbl.royalsocietypublishing.org/content/13/3/20160874?rss=1); 無
                -   Artificial night lighting inhibits feeding in moths
                -   蛾への光害
        -   02

            1.  [McMillan et al. 1970; Genetics](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1212449/); 無・引
                -   Quantitative Genetics of Fertility I. Lifetime Egg Production of *DROSOPHILA MELANOGASTER*---THEORETICAL
                -   上がって下がる三角形の経時パターンのモデル化
                -   ショウジョウバエの産卵数

            2.  [古在 2017; 植物環境工学](https://www.jstage.jst.go.jp/article/shita/29/1/29_3/_article/-char/ja/); <FONT color="green">201703XX済・引</FONT>
                -   植物工場研究に関する用語と単位
                -   PPF vs PPFD論争は果たして...
                    -   “米国園芸学会では、PPFDをPPFと表記するように求めているようだが、いずれ修正されるであろう (p. 6)”

            3.  [Suga et al. 2017; Nature](http://www.nature.com/nature/journal/v543/n7643/full/nature21400.html); 無
                -   Light-induced structural changes and the site of O=O bond formation in PSII caught by XFEL
                -   沈グループ (岡山)
                -   構造解析とかそこら辺は全然わからん
                -   が、とりあえず落とす

            4.  [Fukao 2017; Proc R Soc B](http://rspb.royalsocietypublishing.org/content/284/1850/20162650); 無
                -   Vine tendrils use contact chemoreception to avoid conspecific leaves
                -   田無の農場の先生
                -   この時代に単著とはすごい...
        -   03

            1.  [Dhondt et al. 2013; Trend Plant Sci](http://www.sciencedirect.com/science/article/pii/S1360138513000812); <FONT color="green">低・未刊</FONT>
                -   Cell to whole-plant phenotyping: the best is yet to come
                -   レベル (器官とか細胞とか) 別のphenotyping手法など
                -   スケール貫通で統一的にやるには？

            2.  [Zhen & van Iersel, 2017; J Plant Physiol](http://www.sciencedirect.com/science/article/pii/S0176161716302826); 20170303済
                -   Far-red light is needed for efficient photochemistry and photosynthesis
                -   所属・引用文献を見る限り、ガチ光合成の人ではなく、親近感を覚える
                -   FR添加に対して、PSIIの光化学反応は速やかに応答してEmerson様の*Y*<sub>II</sub>上昇が生じるが、NPQ形成には時間遅れがある
                -   FR-doseに関してはほとんどなし、これはPSIIリミットがすぐに解消されて律速の切り替わりが起こるから
                -   Pn/PPFDを出すことで、FRの影響を除いたPAR領域の利用率に言及
                    -   藻類時代の片側enhancementのあたりで誰かやってたはず
                    -   `Inada (1978)`も高等植物でやってた
                -   多項式回帰で*P* = .nnn を書くのはややアレではないか
                    -   単回帰でも切片か係数か不明だからアレではあるが、誤認は難しいので許容できる
                -   `Murakami et al. (2016)`も引用していただきたかった...

            3.  [van Iersel & Gianino, 2017; HortScience](http://hortsci.ashspublications.org/content/52/1/72.abstract); 無
                -   An Adaptive Control Approach for Light-emitting Diode Lights Can Reduce the Energy Costs of Supplemental Lighting in Greenhouses
                -   閾値制御でPWM-LED補光を行うシステム
                -   このラボはうちに似ているなぁ...
        -   05

            1.  [Schmidt & Gaudin 2017; Trend Plant Sci](http://www.sciencedirect.com/science/article/pii/S1360138517300249); <FONT color="green">無</FONT>
                -   Toward an Integrated Root Ideotype for Irrigated Systems
                -   灌水系での根域の理想形
                -   根、流行ってる
                -   次はblue revolutionと言われるだけあり、金も人もかかっている
        -   06

            1.  [Lechenet et al. 2017; Nat Plant](http://www.nature.com/articles/nplants20178); <FONT color="green">無</FONT>
                -   Reducing pesticide use while preserving crop productivity and profitability on arable farms
                -   Natureハイライトから
                -   あんまりご縁はなさそう
        -   07

            1.  [Puthiyaveetil et al. 2017; Nat Plant](http://www.nature.com/articles/nplants201720); 無
                -   Surface charge dynamics in photosynthetic membranes and the structural consequences
                -   Kirchhoffグループ
                -   PSII-supercomplex内でのvan der Waalsと静電相互作用を分解
                -   abstすらついていけないレベル

            2.  [Votoshkina et al. 2017; Physiol Plant](http://onlinelibrary.wiley.com/wol1/doi/10.1111/ppl.12560/abstract); 中・未刊
                -   Involvement of the chloroplast plastoquinone pool in the Mehler reaction
                -   はじめて見るかも、Borisova-Mubarakshinaグループ

            3.  [Santabarbara et al. 2017; Phys Chem Chem Phys](http://pubs.rsc.org/en/content/articlelanding/2017/cp/c7cp00554g#!divAbstract); 低・未刊
                -   Kinetics and Heterogeneity of Energy Transfer from Light Harvesting Complex II to Photosystem I in the Supercomplex Isolated from Arabidopsis

            4.  [Semchonok et al. 2017; BBA](http://www.sciencedirect.com/science/article/pii/S0005272817300439); 低・未刊
                -   Interaction between the photoprotective protein LHCSR3 and C<sub>2</sub>S<sub>2</sub> Photosystem II supercomplex in *Chlamydomonas reinhardtii*
                -   LHCSR3はdimerとしてPSIへ結合する
                -   LHCSR3のPSIへの結合部位は複数ある...?

            5.  [Rosso et al. 2006](http://www.plantphysiol.org/content/142/2/574.short); 20170308済・引
                -   IMMUTANS does not act as a stress-induced safety valve in the protection of the photosynthetic apparatus of Arabidopsis during steady-state photosynthesis
                -   PTOX (IM) を6-fold or 16-foldにOXしたナズナで光阻害耐性を調査
                -   言い切り論文は引用しやすくて助かる
                -   `Ort & Baker (2002)`をサポーティング
                -   “強光✕低温で成育する高山植物にはPTOXが多く含まれ、PQを酸化よりに維持する作用により光阻害を防ぐ”という`Streb et al. (2005)`を否定する
                    -   低温成育植物では、光合成能力が向上する場合があるので、IMには関係ないのでは？という解釈
                -   むしろ*im*でWTより酸化気味、OX系でWTより還元気味 1 - qP (or 1- qL) なデータ
                    -   “... inactivating IM has induced the expression and biosynthesis of yet another plastoqui- nol oxidase in the chloroplast, which is more effective than IM.”
                    -   もしくは、“... an up-regulation of the metabolic electron sink capacity at the acceptor side of PSI.”
        -   08

            1.  [Joët et al. 2002; J Biol Chem](http://www.jbc.org/content/277/35/31623.long); 低
                -   Involvement of a Plastid Terminal Oxidase in Plastoquinone Oxidation as Evidenced by Expression of the Arabidopsis thaliana Enzyme in Tobacco

            2.  [Heyno et al. 2009; J Biol Chem](http://www.jbc.org/content/284/45/31174.full); 低
                -   Plastid Alternative Oxidase (PTOX) promotes oxidative stress when overexpressed in Tobacco.

            3.  [Nikolova et al. 2017; Plant Physiol](http://www.plantphysiol.org/content/early/2017/03/07/pp.17.00110.short?rss=1); 無・未刊
                -   Temperature induced remodeling of the photosynthetic machinery tunes photosynthesis in a thermophyllic alga
                -   落とすのみ

            4.  [Tomeo & Rosenthal 2017; Plant Physiol](http://www.plantphysiol.org/content/early/2017/03/07/pp.16.01940.short?rss=1); 無・未刊
                -   Mesophyll conductance among soybean cultivars sets a tradeoff between photosynthesis and water-use
                -   落とすのみ

            5.  [Peltier et al. 2010; Photosynth Res](https://link.springer.com/article/10.1007/s11120-010-9575-3); <FONT color="green">低</FONT>
                -   Auxiliary electron transport pathways in chloroplasts of microalgae

            6.  [McDonald et al. 2011; BBA](http://www.sciencedirect.com/science/article/pii/S0005272810007425); <FONT color="green">低</FONT>
                -   Flexibility in photosynthetic electron transport: The physiological role of plastoquinol terminal oxidase (PTOX)
        -   10

            1.  [Knoblauch & Peters 2017; JIPB](http://onlinelibrary.wiley.com/wol1/doi/10.1111/jipb.12532/abstract); <FONT color="green">低</FONT>
                -   What actually is the Münch hypothesis? A short history of assimilate transport by mass flow
                -   圧流説の歴史系レビュー
        -   11

            1.  [Ogawa et al. 2017; Photosynth Res](https://link.springer.com/article/10.1007%2Fs11120-017-0367-x); 低
                -   Estimation of photosynthesis in cyanobacteria by pulse-amplitude modulation chlorophyll fluorescence: problems and solutions
                -   園池グループ
                -   藻類はstate transitionやらFLVやら多くて手に負えないという印象
        -   13

            1.  [Onoda et al. 2017; New Phytol](http://onlinelibrary.wiley.com/wol1/doi/10.1111/nph.14496/abstract); <FONT color="blue">低・引</FONT>
                -   Physiological and structural tradeoffs underlying the leaf economics spectrum
                -   カッコイイ研究だ
                -   そして錚々たる顔ぶれだ...
        -   14

            1.  [Wang et al. 2015; Plant Growth Regul](https://link.springer.com/article/10.1007/s10725-015-0046-x); 20170314済
                -   Green light augments far-red-light-induced shade response
                -   Foltaグループ
                -   緑とFRが上記のpetiole/leaf比に対して加法的に作用する
                    -   避陰反応の判断基準として妥当か？
                    -   比に対して加法的ということはつまり？
                -   cryでも緑が効いているので、青/緑の可逆ではない
                -   検定と相性の悪い実験計画だ

            2.  [Li et al. 2017; Int J Hydrogen Energy](http://www.sciencedirect.com/science/article/pii/S0360319917302756); 高・未刊
                -   Light conversion film promotes CO<sub>2</sub> assimilation by increasing cyclic electron flow around Photosystem I in *Arabidopsis thaliana*
                -   初見の雑誌 & グループ
                -   これで光質が“significantly altered”は無茶だろう...
                    -   conclusionではslightlyだけども
                -   conclusionで触れているように、要因をCEFのみに限定できる実験系ではないので、タイトル詐欺気味だと思う
                -   そもそもなぜこの内容で光合成系のジャーナルに出さないのか、とか個人的な第一印象が非常に悪い
        -   15

            1.  [遠藤 2017; 領域融合レビュー](http://leading.lifesciencedb.jp/6-e001/); <FONT color="green">無</FONT>
                -   植物における概日リズムの組織特異性および組織間での時間情報の伝達
                -   とりあえずダウンロード
                -   新着論文レビューの同著者の[シロイヌナズナは組織特異的な概日時計をもつ (2014)](http://first.lifesciencedb.jp/archives/9444)も参照

            2.  [Tikhonov & Vershubskii 2017; Photosynth Res](http://link.springer.com/article/10.1007/s11120-017-0349-z);
                -   Connectivity between electron transport complexes and modulation of photosystem II activity in chloroplasts
                -   Tikhonovグループ
                -   ちょっと超えてる
        -   16

            1.  [Takagi et al. 2017; Physiol Plant](http://onlinelibrary.wiley.com/wol1/doi/10.1111/ppl.12562/abstract); 中・引
                -   Diversity of strategies for escaping reactive oxygen species production within photosystem I among land plants: P700 oxidation system is prerequisite for alleviating photoinhibition in photosystem I
                -   三宅グループ、相変わらず勢いすごい...
                -   PSI周りのalternative flowを属別に解析
                -   Cytが能動的に役割を果たす、というのはどうも違和感がある考え方
                -   因果関係をさらうべき
        -   21

            1.  [Karasov et al.2017; Plant Cell](http://www.plantcell.org/content/early/2017/03/20/tpc.16.00931.short?rss=1); <FONT color="green">低</FONT>
                -   Mechanisms to mitigate the tradeoff between growth and defense
        -   22

            1.  [Dierck et al. 2017; Sci Hort](http://www.sciencedirect.com/science/article/pii/S0304423817301012); 低
                -   Light quality regulates plant architecture in different genotypes of *Chrysanthemum morifolium* Ramat
                -   ベルギーILVOグループ
                -   あまり心は惹かれないなぁ

            2.  [Scheres & van der Putten 2017; Nature](http://www.nature.com/nature/journal/v543/n7645/full/nature22010.html); <FONT color="green">中</FONT>
                -   The plant perceptron connects environment to development
                -   ホルモンを介したbiotic/abioticな応答のレビュー
                -   ニューラルネットを想起させる図

            3.  [Zipfel & Oldroyd 2017; Nature](http://www.nature.com/nature/journal/v543/n7645/full/nature22009.html); <FONT color="green">低</FONT>
                -   Plant signalling in symbiosis and immunity
                -   共生・免疫流行ってる感がある

            4.  [Ilík et al. 2017; New Phytol](http://onlinelibrary.wiley.com/wol1/doi/10.1111/nph.14536/full); 中
                -   Alternative electron transport mediated by flavodiiron proteins is operational in organisms from cyanobacteria up to gymnosperms
                -   鹿内グループ
                -   flvも気にしないといけなくなるのか...?

            5.  [Chloroplast: Current Research and Future Trends](http://www.caister.com/chloroplasts)
                -   Kirchhoffの編集
                -   およそ37000 yen
                -   Caister Academic Pressの本ははじめて
                    -   １回だけアクセスできるページからpdfで配布する形式
                    -   リンクが403エラーで死んだので、ヒヤヒヤしながらコンタクトしたら、即座に対応してくれて印象グッド
        -   24

            1.  [Kume 2017; J Plant Res](https://link.springer.com/article/10.1007/s10265-017-0910-z); 低
                -   Importance of the green color, absorption gradient, and spectral absorption of chloroplasts for the radiative energy balance of leaves

            2.  [Silva-Pérez et al. 2017; PCE](http://onlinelibrary.wiley.com/wol1/doi/10.1111/pce.12953/abstract); 低・未刊
                -   Biochemical model of C<sub>3</sub> photosynthesis applied to wheat at different temperatures
                -   Evansグループ
                -   C3光合成モデルの応答解析をフィールド、温室、チャンバレベルのwheatで
        -   26

            1.  [Tcherkez et al. 2017; New Phytol](http://onlinelibrary.wiley.com/wol1/doi/10.1111/nph.14527/full); <FONT color="green">20170326済・引</FONT>
                -   Tracking the origins of the Kok effect, 70 years after its discovery
                -   Kok効果のレビュー
                -   弱光下での光合成が専門だけど、Kok効果を実感したことがない。
                -   分解能も効いてるのかな
                    -   “A recommendation to solve this problem is to have a sufficient number of measurements: typically, at least three in the 0--10 lmol m<sup>-2</sup> s<sup>-1</sup> region.”
                -   ecosystemレベルでもKok効果様の挙動があるらしい (`Bruhn et al. 2011`)
                    -   線形の項が多数重なったらそうなるだろう

            2.  [Yin et al. 2014; Photosynth Res](https://link.springer.com/article/10.1007%2Fs11120-014-0030-8); 20170417済
                -   Accounting for the decrease of photosystem photochemical efficiency with increasing irradiance to estimate quantum yield of leaf photosynthesis
                -   Y<sub>II</sub>を測定することで、ガス交換の最大量子収率を上方修正する手法について
                    -   利用側ではなく、理解側の観点がつよい
                -   `Tcherkez et al. 2017`から
                    -   “... both the light partition to PSII (a) and the photochemical yield of PSII (ΦPSII) have been found to increase at low light (Oberhuber et al., 1993; Yin et al., 2014)”
                    -   PSIなら見たことあるが、PSIIでも起こるというのはは直感に反する
                    -   Fig. 3aのことを言っているのか？引用怪しい
                -   “Actually the maximum photochemical efficiency of PSII as revealed by chlorophyll fluorescence for the dark-adapted leaves is generally not higher than 0.83 (Björkman and Demmig 1987; Schreiber et al. 1995; Morales et al. 1991), and the photochemical efficiency of PSII under strictly limiting light is only about 0.84- 0.95 of the value for the dark-adapted leaves (Bernacchi et al. 2003; Yin et al. 2009)”
        -   27

            1.  [Kudoh 2016; New Phytol](http://onlinelibrary.wiley.com/wol1/doi/10.1111/nph.13733/abstract); <FONT color="green">低</FONT>
                -   Molecular phenology in plants: in natura systems biology for the comprehensive understanding of seasonal responses under natural environments
                -   農業気象で聞いたので
                -   ハクサンハタザオは
                    -   adaptiveに自然繁殖している
                    -   目視により栄養生長期か生殖成長期かがわかる
                    -   Arabidopsisと近縁なので遺伝的手法との相性がよい
                -   環境調節勢としては計測項目 (~説明変数) を増やしたくなるが、ロバストさは下がる

            2.  [Aikawa et al. 2010; PNAS](http://www.pnas.org/content/107/25/11632.long); 低
                -   Robust control of the seasonal expression of the *Arabidopsis FLC* gene in a fluctuating environment
                -   `Kudoh 2016`と発表から
                -   尤度関数の局所解が、日数に対してはセンシティブ、温度閾値に対しては鈍い
                -   ロバストな応答系のためにはこうあるべきだ、という話

            3.  [Haxo & Blinks 1950; J Gen Physiol](http://jgp.rupress.org/content/33/4/389); 低
                -   Photosynthetic action spectra of marine algae
                -   光合成作用スペクトルで寺島先生が引いていた

    -   4
        -   異動してからIPがなかなか支給されず、非常に滞っている
        -   他大に来てわかる東大クオリティ (UT-article linkは優秀だった)

        -   03

            1.  [Aasamaa & Aphalo, 2015; EEB](http://www.sciencedirect.com/science/article/pii/S0098847215000131); 20170404済
                -   Effect of vegetational shade and its components on stomatal responses to red, blue and green light in two deciduous tree species with different shade tolerance
                -   植生による遮蔽が気孔応答に及ぼす影響を２品種で比較
                -   遮蔽による光質変化のうち、UVが気孔応答のセンシティブさに効いているらしいというデータを、Full sunlight, neutral shade (70%), UV cut, vs vegetational shadeの比較で示す
                    -   植生によるUVのカットが、気孔の応答性を高めるらしい
                    -   “stomatal conductance (in high light) is lowered in plants grown under supplementary UV (Nogués et al., 1998, 1999; Yao and Liu, 2006; Martínez-Lüscher et al., 2013) and increased in plants grown under UV absorbing filters (Albert et al., 2011; Berli et al., 2013; Kataria et al., 2013)”
                -   葉内CO<sub>2</sub>濃度に応答した気孔開度変化の話
                    -   “The subsequent decrease in \[CO2\] of intercellular spaces (Roelfsema et al., 2002; Young et al., 2006; Araújo et al., 2011) and increase in balance between photosyn- thetic electron transport and carbon assimilation processes (Messinger et al., 2006; Busch, 2014) are signals for stomatal opening.”
                -   Greenの気孔開度影響の話
                    -   GreenでのBlue開度の打ち消し効果は、UV cutで育った葉には顕著に現れるが、vegetational shadeで育った葉には生じない
                    -   “the ecological role of the green-light reversal effect can be the prevention of excessive leaf water loss through stomata under (green light-rich) vegetational shade, where the potential for photosynthesis is small (Talbott et al., 2006)”
        -   06

            1.  [Takagi et al. 2017; Plant J](http://onlinelibrary.wiley.com/wol1/doi/10.1111/tpj.13566/abstract); 中・未刊
                -   Chloroplastic ATP synthase builds up *proton motive force* for preventing reactive oxygen species production in photosystem I
                -   神戸大三宅グループ
                -   変異体作成からやってるしんどそうな研究
                -   abstractを見た感じ、あんまり新しい要素がなさそうに思えるが...

            2.  [Ibaraki & Matsuura 2005; J Agric Meteorol](https://www.jstage.jst.go.jp/article/agrmet/60/5/60_1073/_article/-char/ja/); 20170407済
                -   Non-destructive evaluation of the photosynthetic capacity of PSII in micropropagated plants
                -   *F*<sub>v</sub>/*F*<sub>m</sub>イメージング
                -   *F*<sub>v</sub>/*F*<sub>m</sub>既知のreference葉を並べて測定することで、距離係数のkを算出
        -   07

            1.  [Charbonnier et al. 2017; PCE](http://onlinelibrary.wiley.com/wol1/doi/10.1111/pce.12964/abstract); 高・未刊
                -   Increased Light-Use Efficiency Sustains Net Primary Productivity of Shaded Coffee Plants In Agroforestry System
                -   知らない人ばかり
                -   植生による遮光下での受光量の低下と光利用効率の向上を個体レベルから圃場レベルで解析

            2.  [Trouwborst et al. 2016; EEB](); 20170407済 (再)
                -   Plasticity of photosynthesis after the ‘red light syndrome’ in cucumber
                -   PFD vs Φ<sub>II</sub>の部分を確認するついでに読み直し
        -   09

            1.  [Harbinson & Yin 2017; Physiol Plant](http://onlinelibrary.wiley.com/wol1/doi/10.1111/ppl.12572/abstract); 高・未刊
                -   A model for the irradiance responses of photosynthesis
                -   ある程度かぶっていそうな、嫌な予感がする

            2.  [Luján et al. 2017; Photosynth Res](https://link.springer.com/article/10.1007/s11120-017-0375-x); 低
                -   A simple and efficient method to prepare pure dimers and monomers of the cytochrome *b*<sub>6</sub>*f* complex from spinach
                -   簡単ならやりたいが、single size-exclusion chromatography (？) という技術が必要

            3.  [Fujiuchi et al. 2017; Biothechnol Bioeng](http://onlinelibrary.wiley.com/doi/10.1002/bit.26303/full); 無
                -   Effects of plant density on recombinant hemagglutinin yields in an *Agrobacterium*-mediated transient gene expression system using *Nicotiana benthamiana* plants
                -   藤内さん
        -   12

            1.  [Jokinen et al. 2017; Sci Rep](http://www.nature.com/articles/srep45707); 無
                -   Solar eclipse demonstrating the importance of photochemistry in new particle formation
                -   Helsinkiの物理グループ
                -   植物じゃなかった...
                -   OA誌でちゃんとSupplementalを出すのは良いこと
        -   13

            1.  [Walker et al. 2017; Photosynth Res](https://link.springer.com/article/10.1007/s11120-017-0369-8); 低
                -   Uncertainty in measurements of the photorespiratory CO<sub>2</sub> compensation point and its impact on models of leaf photosynthesis
                -   Ortグループ
                -   どこかの項が0に漸近する系の誤差の出方なんだろうと思う
        -   14

            1.  [Pearce et al. 2017; Plant Physiol](http://www.plantphysiol.org/content/early/2017/04/13/pp.17.00361.short?rss=1); 低・未刊
                -   Night-break experiments shed light on the Photoperiod 1-mediated flowering
                -   タイトルがいかしている

            2.  [Karpinska et al. 2017; PCE](http://onlinelibrary.wiley.com/wol1/doi/10.1111/pce.12960/abstract); 中・未刊
                -   The redox state of the apoplast influences the acclimation of photosynthesis and leaf metabolism to changing irradiance
                -   Foyerグループ
        -   16

            1.  [Demmig-Adams et al. 2017; Cur Opin Plant Biol](http://www.sciencedirect.com/science/article/pii/S1369526616301704); <FONT color="green">20170416済</FONT>
                -   Environmental regulation of intrinsic photosynthetic capacity: an integrated view
                -   最大光合成能力の環境応答を制御する要因について
                    -   おもに気温・光に着目
                -   conduitsってなんだと思ったら導管

            2.  [Hüner et al. 2016; J Plant Physiol](http://www.sciencedirect.com/science/article/pii/S0176161716300360); <FONT color="green">中</FONT>
                -   Photosynthetic acclimation, vernalization, crop productivity and ‘the grand design of photosynthesis’
                -   `Demmig-Adams et al. 2017`から
                -   J M Anderson のあれをイメージさせるなぁ

            3.  [Yin et al. 2009; PCE](http://onlinelibrary.wiley.com/wol1/doi/10.1111/j.1365-3040.2009.01934.x/full); 高
                -   Using combined measurements of gas exchange and chlorophyll fluorescence to estimate parameters of a biochemical C<sub>3</sub> photosynthesis model: a critical appraisal and a new integrated approach applied to leaves in a wheat (*Triticum aestivum*) canopy
                -   `Yin et al. 2014`から
                    -   “To estimate Φ<sub>2LL</sub>, we used the equation that describes the decline of Φ<sub>2</sub> with increasing irradiance (Yin et al. 2009).”

            4.  [Zhang et al. 2017; Front Plant Sci](http://journal.frontiersin.org/article/10.3389/fpls.2017.00328/full); 低
                -   Can the responses of photosynthesis and stomatal conductance to water and nitrogen stress combinations be modeled using a single set of parameters?
                -   前にメールで`Murakami et al. 2016`への質問をくれた人
                -   ヘヴィな実験っぽい
        -   18

            -   Plant DirectというOA論文が、SEB、ASPB、Wileyのコラボで始まるらしい
                -   ちょっと気になる

            1.  [Singsaas et al. 2001; Oecologia](https://link.springer.com/article/10.1007/s004420000624); <FONT color="blue">20170418済</FONT>
                -   Variation in measured values of photosynthetic quantum yield in ecophysiological studies
                -   `Yin et al. 2014`から
                -   “初期勾配が文献で結構小さいけど、変じゃない？ちゃんと測定できてないだけじゃない？”という渋い話
                    -   PFD-*P*<sub>n</sub>カーブの非直線領域まで入れるな
                    -   *C*<sub>i</sub>をちゃんと固定しろ
                -   光質一緒じゃないのに議論になるのか？
                -   あたりまえ感を受けるが、生態学系の論文だとこれでもOKなのか？

            2.  [Matthews et al. 2017; Plant Physiol](http://www.plantphysiol.org/content/early/2017/04/17/pp.17.00152.short?rss=1); 低・未刊
                -   Diurnal variation in gas exchange: the balance between carbon fixation and water loss

            3.  [Belgio et al. 2017; Photosynth Res](https://link.springer.com/article/10.1007/s11120-017-0385-8); 低
                -   High light acclimation of *Chromera velia* points to photoprotective NPQ
                -   [Chromera](http://photosyn.jp/pwiki/index.php?%E3%82%AF%E3%83%AD%E3%83%A1%E3%83%A9%E9%A1%9E)はchl *a*のみを持つ単細胞生物
                -   強光成育株は、PSIIコア-コア間の距離が遠くなり、エネルギー遷移が起こりにくい
                    -   強光成育株で、アンテナ/コア比が上がっているような絵
                    -   生態的には逆のような...？

            4.  [Neto et al. 2017; Plant Biol](http://onlinelibrary.wiley.com/wol1/doi/10.1111/plb.12573/abstract); 低・未刊
                -   Cyclic electron flow, NPQ and photorespiration are crucial for the establishment of young plants of *Ricinus communis* and *Jatropha curcas* exposed to drought
                -   乾燥に対して耐性のJatropha vs 非耐性のRicinusの幼植物で、drought時のexcess energyの逃し方について比較
                -   JatrophaではNPQ・CEF、Ricinusでは光呼吸が上昇、両方ともAPX・SODは増える
                -   “the modulation of different photoprotective mechanisms is crucial to mitigate the effects caused by the excess energy”
                -   matureだとどうなるのか？
        -   19

            -   PRI (`Gamon et al. 1997`) の文献掘り

            1.  [Gamon & Surfus 1999; New Phytol](http://onlinelibrary.wiley.com/wol1/doi/10.1046/j.1469-8137.1999.00424.x/abstract); 高
                -   Assessing leaf pigment content and activity with a reflectometer

            2.  [Peñuelas & Filella 1998; Trend in Plant Sci](http://www.sciencedirect.com/science/article/pii/S1360138598012138); <FONT color="green">20170420済</FONT>
                -   Visible and near-infrared reflectance techniques for diagnosing plant physiological status
                -   ざっくりレビュー

            3.  [Sims & Gamon 2002; Remote Sens Environ](http://www.sciencedirect.com/science/article/pii/S003442570200010X); 中
                -   Relationships between leaf pigment content and spectral reflectance across a wide range of species, leaf structures and developmental stages
                -   Systemic regulationのSims (`Sims et al. 1997`)と同一人物？

            4.  [Barton & North 2001; Remote Sens Environ](http://www.sciencedirect.com/science/article/pii/S0034425701002243); 中
                -   Remote sensing of canopy light use efficiency using the photochemical reflectance index: Model and sensitivity analysis
                -   入射角度なんかの感度分析

            5.  [Garbulsky et al. 2011; Remote Sens Environ](http://www.sciencedirect.com/science/article/pii/S0034425710002634)<FONT color="green">高・引</FONT>
                -   The photochemical reflectance index (PRI) and the remote sensing of leaf, canopy and ecosystem radiation use efficiencies: A review and meta-analysis

            6.  [Filella et al. 2009; Int J Remote Sens](http://www.tandfonline.com/doi/full/10.1080/01431160802575661?scroll=top&needAccess=true); 高
                -   PRI assessment of long-term changes in carotenoids/chlorophyll ratio and short-term changes in de-epoxidation state of the xanthophyll cycle

            7.  [Gamon et al. 2001; Photosynth Res](https://link.springer.com/article/10.1023%2FA%3A1010677605091?LI=true); 20170424済・引
                -   Assessing photosynthetic downregulation in sunflower stands with an optically-based model
                -   standに対してPRIで光合成機能の評価
                -   下葉だとEPSとPRIが完全にはリンクしない
                -   推定Pn自体は、値が小さいせいもあり、ずれていないように見えるが、これは推定がうまくいっているという訳ではない
                    -   最下部葉から新出葉への光合成産物系のシグナル自体は、無視してもいいと解釈できる
                    -   シグナリングの重みづけがさほど重要ではないということ
                -   間違いなく引用することになるが、この論文は力技でねじ込んでる感あるなぁ
                    -   “the results of this study are consistent with a large body of literature...”
                    -   “remote sensing can be applied to predict whole-stand photosynthesis using the simple light-use efficiency model depicted in Equation (2).”

            8.  [Peñuelas et al. 2011; New Phytol](http://onlinelibrary.wiley.com/wol1/doi/10.1111/j.1469-8137.2011.03791.x/full); <FONT color="green">20170419済・引</FONT>
                -   Photochemical reflectance index (PRI) and remote sensing of plant CO<sub>2</sub> uptake
                -   衛星ベースのPRIの限界について、`Grace et al. 2007`を簡単にまとめると、群落構造、バックグラウンドから来るドリフト、反射強度の入射角・計測角に対する依存性
                    -   “In brief, these problems are related to the structural differences of the canopies, to varying ‘background effects’ (e.g. soil color, moisture, shadows, or presence of other nongreen landscape components) or to the different reflectance signals derived from illumination and viewing angles variations (Filella et al., 2004; Sims et al., 2006; Hilker et al., 2010).”
                    -   環境調節条件下であれば、いずれも軽減できるので、自分の研究ではあまり影響なし

            9.  [Grace et al. 2007; Global Change Biol](http://onlinelibrary.wiley.com/wol1/doi/10.1111/j.1365-2486.2007.01352.x/full); <FONT color="green">中</FONT>
                -   Can we measure terrestrial photosynthesis from space directly, using spectral reflectance and fluorescence?

            10. [Gamon et al. 1990; Oecologia](https://link.springer.com/article/10.1007%2FBF00317336?LI=true); 20170420済
                -   Remote sensing of xanthophyll cycle and chlorophyll fluorescence in sunflower leaves and canopies
                -   531, 685, 738 nm の光照射開始後の変化を調べ、その出所を解析
                -   PRIのスタート

            11. [Porcar-Castell et al. 2012; Oecologia](https://link.springer.com/article/10.1007/s00442-012-2317-9); 中
                -   Physiology of the seasonal relationship between the photochemical reflectance index and photosynthetic light use efficiency
                -   PRIは短期的には、うまく光合成状態を反映するが、長期的には色素組成の変化に影響される
                -   `Porcar-Castell et al. 2014; JXB`も深いし、この人はフォローすべき
                    -   “the seasonal variation in leaf-level PRI seems to be controlled by the slow changes in pigment pools rather than NPQ (Stylinski et al., 2002; Filella et al., 2009; Porcar-Castell et al., 2012).”

            12. [Zhang et al. 2016; Remote Sens](http://www.mdpi.com/2072-4292/8/9/677/htm); <FONT color="green">中</FONT>
                -   Affecting Factors and Recent Improvements of the Photochemical Reflectance Index (PRI) for Remotely Sensing Foliar, Canopy and Ecosystemic Radiation-Use Efficiencies
        -   20

            1.  [Renzaglia et al. 2017; Plant Physiol](http://www.plantphysiol.org/content/early/2017/04/18/pp.17.00156.short?rss=1); 無
                -   Hornwort stomata: Architecture and fate shared with 400 million year old fossil plants without leaves
                -   原始的な植物であるツノゴケを使って、気孔の起源と機能を解析

            2.  [Bernacchi et al. 2013; PCE](http://onlinelibrary.wiley.com/wol1/doi/10.1111/pce.12118/full); <FONT color="green">低</FONT>
                -   Modelling C<sub>3</sub> photosynthesis from the chloroplast to the ecosystem

            3.  [Nomura et al. 2012; Nat Commun](https://www.nature.com/articles/ncomms1926); 低
                -   Chloroplast-mediated activation of plant immune signalling in *Arabidopsis*
                -   ゼミで引用されていた、葉緑体免疫シグナルについて
                -   いちおう[プレスリリース](http://www.kpu.ac.jp/contents_detail.php?frmId=2667)

            4.  [Peñuelas et al. 1995; New Phytol](http://onlinelibrary.wiley.com/wol1/doi/10.1111/j.1469-8137.1995.tb03064.x/abstract); 20170420済
                -   Assessment of photosynthetic radiation-use efficiency with spectral reflectance
                -   光強度変化への応答は、PRIではY<sub>ii</sub>より遅い
                -   “some species exhibited additional complicating features that could have influenced *R*<sub>531</sub>, including significant chloro- plast movement in *Phaseolus vulgaris* and a small xanthophyll content in the shade-adapted leaves of *Hedera canariensis* (unpublished).”

            5.  [Gamon et al. 1992; Remote Sens Environ](http://www.sciencedirect.com/science/article/pii/003442579290059S); 20170420済
                -   A narrow-waveband spectral index that tracks diurnal changes in photosynthetic efficiency
                -   `Gamon et al. 1990`で、531 nm がxanthophyll cycleを反映することを示し、この論文では正規化のref波長を主成分分析で決定
                -   この論文だと、refは550 nm だけど、後続は570 nm がメイン
        -   21

            1.  [Albanese et al. 2017; BBA](http://www.sciencedirect.com/science/article/pii/S0005272816305710?dgcid=Newsletters%20%26%20Alerts_email_SDPR-EXP3-VAR1); 中
                -   Dynamic reorganization of photosystem II supercomplexes in response to variations in light intensities
                -   トリノ工科大学のBioSolar Labなる機関のグループ
                -   PSII超複合体の構造 (リン酸化かな？) の短期的な光強度応答

            2.  [Willocquet et al. 2017; Trend Plant Sci](http://www.sciencedirect.com/science/article/pii/S1360138517300237?dgcid=Newsletters%20%26%20Alerts_email_SDPR-EXP3-VAR1); <FONT color="green">無・未刊</FONT>
                -   とりあえず

            3.  [Weng et al. 2010; Tree Physiol](https://academic.oup.com/treephys/article/30/4/469/1682565/Relationship-between-photochemical-efficiency-of); 高
                -   Relationship between photochemical efficiency of photosystem II and the photochemical reflectance index of mango tree: merging data from different illuminations, seasons and leaf colors
                -   PRIとY<sub>ii</sub>の相関を、光条件、季節、葉色の異なる複数条件からマージ
        -   22

            1.  [Earles et al. 2017; Plant Physiol](http://www.plantphysiol.org/content/early/2017/04/21/pp.17.00223.short?rss=1); 高・未刊
                -   Excess diffuse light absorption in upper mesophyll limits CO<sub>2</sub> drawdown and depresses photosynthesis
                -   散乱光は、個葉レベルではCO<sub>2</sub>固定にネガティブ
                    -   1次元の有限要素法で鉛直方向の光環境をシミュレートしているらしい
                    -   Rで組んだよ、とのことなのでコードを読みたい
                -   葉-個体-群落の光系スケーリングでは、多くの場合、スケーリングが成り立つがこれはそうでもないらしく、結構おどろき
                -   Brodersenは、Vogelmannとよく組んでるあの人と同一っぽい
                    -   ミドルネーム入れるか入れないか、統一してほしいなぁ

            2.  [Armbruster et al. 2017; Cur Opin Plant Biol](http://www.sciencedirect.com/science/article/pii/S136952661730002X); <FONT color="green">20170422済</FONT>
                -   The regulation of the chloroplast proton motive force plays a key role for photosynthesis in fluctuating light
                -   pmfの概説に良かった
                    -   pmfのうち、ψとΔpHはそれぞれPSII阻害・PSI阻害に対応するイメージ
                    -   後者の方が、修復しにくい点でネガティブ
                -   γ-subunitの構造変化で、ATP合成へのpmf要求度が変わる
                    -   “Flux of protons via the chloro- plast ATP synthase, and thus pmf, can additionally be regulated by structural changes in the g-subunit, which occur in response to oxidation/reduction of two redox sensitive cysteines and change the requirement for pmf to drive ATP synthesis \[22,23\].”
                -   最近の英語って、なんだかカンマが減っているような感じがする
                    -   “When grown in the field *best1/vccn1* mutants have increased levels of PSII photoinhibition”
                    -   “in the filed”のあとに入れたくなる
        -   24

            1.  [Junge & Nelson 2015; Annu Rev Biochem](http://www.annualreviews.org/doi/full/10.1146/annurev-biochem-060614-034124#article-denial); <FONT color="green">低・引</FONT>
                -   ATP synthase
                -   えらいばっくりしたタイトルだけど、とりあえず

            2.  [Hikosaka 2005; Ann Bot](https://academic.oup.com/aob/article/95/3/521/322923/Leaf-Canopy-as-a-Dynamic-System-Ecophysiology-and); <FONT color="green">低</FONT>
                -   Leaf canopy as a dynamic system: ecophysiology and optimality in leaf turnover
                -   `Hikosaka et al. 1994`の横に這わせる実験を参考にしていて
        -   25

            1.  [Zhu et al. 2012; Cur Opin Plant Biol](http://www.sciencedirect.com/science/article/pii/S1369526612000222); <FONT color="green">高</FONT>
                -   Elements of a dynamic systems model of canopy photosynthesis
                -   

            -   生態学会誌の葉寿命特集号

            1.  [及川 & 長田 2013; 日本生態学会誌](http://ci.nii.ac.jp/naid/110009604255); <FONT color="green">高</FONT>
                --------------------------------------------------------------------------------------------------------

            2.  \[長田ら 2013; 日本生態学会誌\]
                -   環境条件に応じた葉寿命の種内変異：一般的傾向と機能型間の差異
