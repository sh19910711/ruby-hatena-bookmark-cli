# hatena-bookmark-cli

はてなブックマークをコマンドライン（w3mなど）から利用するためのツールです。

## インストール方法

    $ gem install hatena-bookmark-cli

## 使い方

### 基本設定

* `hatena-bookmark-auth`を実行して、認証用サーバーを起動
* `~/.hatena-bookmark/config.yml`にConsumer KeyとConsumer Secretを記述
* ブラウザから `http://localhost:48080` にアクセス
* [ログイン]ボタンを押す
* 補完が必要な場合は「更新」ボタンを押す
* `hatena-bookmark {url}`を実行するとブックマークのタグやコメントを設定するためのプロンプトが表示される

#### config.yml

```yaml
:consumer_key:    Consumer Key
:consumer_secret: Consumer Secret

```

### w3mから利用する場合

#### ~/.w3m/keymap

```
keymap m EXTERN "hatena-bookmark '%s'"
```

`m`キーを押すと、表示しているページのURLをはてなブックマークに登録することができます。

## Contributing

1. Fork it ( http://github.com/<my-github-username>/hatena-bookmark-cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### リンク集

* http://b.hatena.ne.jp/
* http://mattn.kaoriya.net/software/w3m/20090801214718.htm

