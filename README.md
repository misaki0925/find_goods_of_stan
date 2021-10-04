# find_goods_of_stan
# ジャニーズの私物特定通知サービス

## サービス概要
ジャニーズ(今回はSixTONESに特定)の私物をファンがスムーズに購入できるようにする

## 登場人物
SixTONESのファン
SixTONESの私物を特定している人
管理者

## ユーザーが抱える課題
ジャニーズがyoutube等を解禁した為、私物をファンが目にする機会が多くなった。「コンサート等に自分の推しが来ていた服を着て行くこと」や「推しがつけているアクセサリー等を真似して自分も日常的につけること」がよくある。
これらのことが重なって、Twitterで私物特定のためのツイートが流行っている。
だが、注目度が高まったことにより、私物が特定され次第ファンが殺到して即完売。「後から気づいた自分は買えな買った。」ということがよくある。

## 解決方法
私物に関するツイートがされた際に通知が届くようにする。(=売り切れ前に購入できるように)
SixTONESの私物の一覧ページを作成し、検索機能をつけて探しやすくする。
また、私物の詳細ページから購入サイトへ飛べるようにする。

### 流れ
1. youtube や instagram live が配信される。
2. 私服特定アカウントが着用服を探してツイートしてくれる。
3. Twitter APIでタグ「Taiga _Six衣装」等でツイートの内容を取得する。
4. 内容をLINEで通知
5. LINE内に間違いがあればこちらに連絡できるように、ボタンor間違いを受け付けるサイト等のURLを付属してLINEを送る

・5のように間違いが判明した時に管理者が修正できるように管理画面を作成する。
・ツイートの内容からキーワードを探し、そのキーワードで検索がすぐできるようにURLをつける
・Twitter APIを使用し、ツイートの内容を取得、LINE API を使用して通知する。

## プロダクト
ジャニーズ(今回はSixTONESに特定)の私物のツイートがされたら、LINEで自動通知する。(Twitterの通知機能でもいいが、自分の推しの私物に関するツイートのみを求めている場合は、他の通知はいらないため。)
Twitterで私物を検索することはタグが統一されていなく面倒なので、私物一覧ページを作成し、探しやすくする。

## 作成で苦労したこと
1. Twitter API と LINE API を使用してメソッドを作成すること
2. Twitter API 用のRSpecモックの作成
3. 正規表現を使用したメソッドを作成すること(twitterの発信者によってツイート内容の記載方法が違うのでそれぞれに対応させる必要があった。)
4. LINE のトーク画面からgoogleの検索画面に飛べるようにデザインすること

## マーケット
SixTONESのファン

## 画面遷移図
https://www.figma.com/file/pFrYU4hSwDQFn4da2XSTyh/Untitled?node-id=32%3A2

## ER図
https://drive.google.com/file/d/10gO9reC8SdPK9OE3ZZntfC9CflYIkJHv/view?usp=sharing