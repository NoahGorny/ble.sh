[ Languages: [English](README.md) (英語) | **日本語** ]

<h1 align="center">ble.sh ―Bash Line Editor―</h1>
<p align="center">
[ <b>README</b> | <a href="https://github.com/akinomyoga/ble.sh/wiki/%E8%AA%AC%E6%98%8E%E6%9B%B8-%C2%A71-%E5%9F%BA%E6%9C%AC">説明書</a> |
<a href="https://github.com/akinomyoga/ble.sh/wiki/%E8%B3%AA%E5%95%8F%E3%81%A8%E5%9B%9E%E7%AD%94">Q&A</a> |
<a href="https://github.com/akinomyoga/blesh-contrib"><code>contrib</code></a> |
<a href="https://github.com/akinomyoga/ble.sh/wiki/%E9%80%86%E5%BC%95%E3%81%8D%E3%83%AC%E3%82%B7%E3%83%94">逆引き</a> ]
</p>

`ble.sh` (*Bash Line Editor*) はピュア Bash スクリプトで書かれたコマンドラインエディタで、標準の GNU Readline を置き換える形で動作します。

現在の開発バージョンは 0.4 です。
このスクリプトは `bash-3.0` 以降で利用できますが、速度・機能などの観点から Bash 4.0 以降でお使い頂くことがお薦めです。
現時点では、文字コードとして `UTF-8` のみの対応です。
このスクリプトは [**BSD License**](LICENSE.md) (3条項 BSD ライセンス) の下で提供されます。

## 簡単設定

`ble.sh` インストールには `git`, `make` (GNU make), and `gawk` が必要です。
詳細は、試用またはインストールに関しては [節1.1](#get-from-source) と [節1.2](#get-from-tarball) を、
`~/.bashrc` の設定に関しては [節1.3](#set-up-bashrc) を御覧ください。

```bash
# インストール & .bashrc 簡単設定 (動かない場合は節1.3を御参照下さい)

git clone --recursive https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc

# 簡単お試し (インストールせずにお試しいただけます)

git clone --recursive https://github.com/akinomyoga/ble.sh.git
make -C ble.sh
source ble.sh/out/ble.sh

# 更新 (ble.sh をロードした状態で実行して下さい)

ble-update

# パッケージ作成用コマンド

git clone --recursive https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install DESTDIR=/tmp/blesh-package PREFIX=/usr/local
```

パッケージ管理システムを通じて `ble.sh` をインストールする事もできます (現在 AUR のみ)。

- [AUR (Arch Linux)](https://github.com/akinomyoga/ble.sh/wiki/Manual-A1-Installation#user-content-AUR) `blesh-git` (devel), `blesh` (stable 0.3.3) maintained by [`@oc1024`](https://github.com/oc1024)

## 機能概要

- **構文着色**: `fish` や `zsh-syntax-highlighting` のような文法構造に従った着色を行います。
  `zsh-syntax-highlighting` のような単純な着色ではなく、構文の入れ子構造や複数のヒアドキュメントなども正しく解析して着色します。
- **補完増強**: 補完を大幅に増強します。
  文法構造に応じた補完、クォートやパラメータ展開を展開した上でのプログラム補完、**曖昧補完**に対応しています。
  また、候補をカーソルキーや <kbd>TAB</kbd>, <kbd>S-TAB</kbd> で選択できる**メニュー補完**、
  `fish` や `zsh-autosuggestions` のような**自動補完** (Bash 4.0 以上) の機能もあります。
  更に、従来 `peco` や `fzf` を呼び出さなければならなかった補完候補の絞り込みも**メニュー絞り込み** (Bash 4.0 以上) として自然な形で組み込んでいます。
  他に、**動的略語展開**や、`zsh-abbreviations` のような**静的略語展開**にも対応しています。
- **Vim編集モード**: `set -o vi` による編集モードを増強します。
  挿入・ノーマルモードの他に(行・矩形)ビジュアルモード、置換モードなどの各種モードに対応しています。
  テキストオブジェクト・各種レジスタ・オペレータ・キーボードマクロなどにも対応しています。
  拡張として `vim-surround` も提供しています。

★`ble.sh` はよくある Bash 設定集のようにプロンプト (`PS1`)、エイリアス、関数を提供するものではありません。
`ble.sh` はより低層の基盤を提供するもので、ユーザは自分でプロンプトやエイリアスを設定する必要があります。
勿論 `bash-it` や `oh-my-bash` の様な他の Bash 設定と一緒に使っていただくことも可能です。

> デモ
>
> ![ble.sh demo gif](https://github.com/akinomyoga/ble.sh/wiki/images/trial1.gif)

# 1 使い方

## 1.1 最新の git repository のソースから生成して試す (バージョン ble-0.4)<sup><a id="get-from-source" href="#get-from-source">†</a></sup>

### ble.sh 生成

`ble.sh` を生成する為には `gawk` (GNU awk) と `gmake` (GNU make) が必要です。
以下のコマンドで生成できます。
GNU make が `gmake` という名前でインストールされている場合は、`make` の代わりに `gmake` として下さい。
```console
$ git clone --recursive https://github.com/akinomyoga/ble.sh.git
$ cd ble.sh
$ make
```
スクリプトファイル `ble.sh` がサブディレクトリ `ble.sh/out` 内に生成されます。

### 試用

生成された `ble.sh` は `source` コマンドを用いてお試しいただけます。

```console
$ source out/ble.sh
```

### インストール

指定したディレクトリにインストールするには `make install` コマンドを使用します。

```bash
# ~/.local/share/blesh にインストール
make install

# 指定したディレクトリにインストール
make install INSDIR=/path/to/blesh

# パッケージ作成用 (パッケージ管理者用)
make install DESTDIR=/tmp/blesh-package PREFIX=/usr/local
```

Make 変数 `DESTDIR` または `PREFIX` が指定されている時、`ble.sh` は `$DESTDIR/$PREFIX/share/blesh` にコピーされます。
それ以外で Make 変数 `INSDIR` が指定されている時、直接 `$INSDIR` にインストールされます。
更にそれ以外で環境変数 `$XDG_DATA_HOME` が指定されている時、`$XDG_DATA_HOME/blesh` にインストールされます。
以上の変数が何れも指定されていない時の既定のインストール先は `~/.local/share/blesh` です。

`.bashrc` の設定に関しては[節1.3](#set-up-bashrc)を御覧ください。

## 1.2 GitHub Releases から tar をダウンロードして使う<sup><a id="get-from-tarball" href="#get-from-tarball">†</a></sup>

ダウンロード・試用・インストールの方法については各リリースページの説明を御覧ください。
現在、安定版は開発版に比べてかなり古いので様々な機能が欠けている事にご注意下さい。

- 開発版 [v0.4.0-devel2](https://github.com/akinomyoga/ble.sh/releases/tag/v0.4.0-devel2) (2020-12)
- 安定版 [v0.3.3](https://github.com/akinomyoga/ble.sh/releases/tag/v0.3.3) (2019-02 fork)
- 安定版 [v0.2.6](https://github.com/akinomyoga/ble.sh/releases/tag/v0.2.6) (2018-03 fork)
- 安定版 [v0.1.14](https://github.com/akinomyoga/ble.sh/releases/tag/v0.1.14) (2015-12 fork)

## 1.2 `ble.sh` をダウンロードして試す (旧バージョン ble-0.3 201902版)<sup><a id="get-from-tarball" href="#get-from-tarball">†</a></sup>

`wget` を使う場合:
```console
$ wget https://github.com/akinomyoga/ble.sh/releases/download/v0.3.3/ble-0.3.3.tar.xz
$ tar xJf ble-0.3.3.tar.xz
$ source ble-0.3.3/ble.sh
```
`curl` を使う場合:
```console
$ curl -LO https://github.com/akinomyoga/ble.sh/releases/download/v0.3.3/ble-0.3.3.tar.xz
$ tar xJf ble-0.3.3.tar.xz
$ source ble-0.3.3/ble.sh
```

指定したディレクトリに `ble.sh` を配置するには単に `ble-0.1.7` ディレクトリをコピーします。
```console
$ cp -r ble-0.3.3 /path/to/blesh
```

## 1.3 `.bashrc` に設定する<sup><a id="set-up-bashrc" href="#set-up-bashrc">†</a></sup>

対話シェルで常用する場合には `.bashrc` に設定を行います。
単に `ble.sh` を `source` して頂くだけでも大抵の場合動作しますが、
より確実に動作させる為には以下の様にコードを記述します。
```bash
# bashrc

# .bashrc の先頭近くに以下を追加して下さい。
[[ $- == *i* ]] && source /path/to/blesh/ble.sh --noattach

# 間に通常の bashrc の内容を既述します。

# .bashrc の末端近くに以下を追加して下さい。
[[ ${BLE_VERSION-} ]] && ble-attach
```

## 1.4 初期化スクリプト `~/.blerc` について

ユーザー設定は初期化スクリプト `~/.blerc` (またはもし `~/.blerc` が見つからなければ `${XDG_CONFIG_HOME:-$HOME/.config}/blesh/init.sh`) に記述します。
テンプレートとしてリポジトリの [`blerc`](https://github.com/akinomyoga/ble.sh/blob/master/blerc) というファイルを利用できます。
初期化スクリプトは `ble.sh` ロード時に自動で読み込まれる Bash スクリプトなので、Bash で使えるコマンドを初期化スクリプトの中で利用できます。
初期化スクリプトの位置を変更する場合には、`source ble.sh` 時に `--rcfile INITFILE` を指定します。以下に例を挙げます。

```bash
# in bashrc

# Example 1: ~/.blerc will be used by default
[[ $- == *i* ]] && source /path/to/blesh/ble.sh --noattach

# Example 2: /path/to/your/blerc will be used
[[ $- == *i* ]] && source /path/to/blesh/ble.sh --noattach --rcfile /path/to/your/blerc
```

## 1.5 アップデート

Git (`git'), GNU awk (`gawk`), 及び GNU make (`make`) が必要になります。
`ble-0.3` 以上をお使いの場合は `ble.sh` をロードした状態で `ble-update` を実行して下さい。

```bash
$ ble-update
```

それ以外の場合には、以下のように `git pull` で最新版を入手・インストールできます。

```bash
cd ble.sh   # ※既に持っている git リポジトリに入る
git pull
git submodule update --recursive --remote
make
make INSDIR="$HOME/.local/share/blesh" install
```

## 1.6 アンインストール

基本的に `ble.sh` ディレクトリとユーザの追加した設定を単に削除していただければ問題ありません。

- 全ての `ble.sh` セッション (`ble.sh` をロードしている Bash 対話セッション) を終了します。
- `.bashrc` に追加した行があれば削除します。
- `blerc` 設定ファイル (`~/.blerc` または `~/.config/blesh/init.sh`) があれば削除します。
- `ble.sh` をインストールしたディレクトリを削除します。
- キャッシュディレクトリ `~/.cache/blesh` が生成されていればそれを削除します。
- 一時ディレクトリ `/tmp/blesh` が生成されていればそれを削除します。これは `/tmp` の内容が自動的にクリアされないシステムで必要です。

# 2 基本設定

ここでは `~/.blerc` に記述する基本的な設定を幾つか紹介します。
[質問と回答](https://github.com/akinomyoga/ble.sh/wiki/%E8%B3%AA%E5%95%8F%E3%81%A8%E5%9B%9E%E7%AD%94)、
[逆引きレシピ](https://github.com/akinomyoga/ble.sh/wiki/%E9%80%86%E5%BC%95%E3%81%8D%E3%83%AC%E3%82%B7%E3%83%94)、
[`contrib` リポジトリ](https://github.com/akinomyoga/blesh-contrib/blob/master/README-ja.md) にも便利な設定があります。
その他の全ての設定項目はテンプレート [`blerc`](https://github.com/akinomyoga/ble.sh/blob/master/blerc) に含まれています。
詳細な説明に関しては[説明書](https://github.com/akinomyoga/ble.sh/wiki/%E7%9B%AE%E6%AC%A1)を参照して下さい。

## 2.1 Vim モード

Vim モードについては [Wiki の説明ページ](https://github.com/akinomyoga/ble.sh/wiki/Vi-(Vim)-editing-mode) を御覧ください。

## 2.2 自動補完

自動補完は Bash 4.0 以上で利用することができ、既定で有効化されます。
自動補完機能を無効にするには以下の設定を `~/.blerc` に記述します。

```bash
bleopt complete_auto_complete=
```

完全に自動補完を切るのではなくて、自動補完候補を表示するまでの遅延を設定するには以下のようにします。

```bash
# 例: 遅延を 300 ミリ秒に設定する
bleopt complete_auto_delay=300
```

Bash のコマンド履歴に基づく補完候補を無効にするには以下のようにします。

```bash
bleopt complete_auto_history=
```

## 2.3 曖昧文字幅

設定 `char_width_mode` を用いて、曖昧文字幅を持つ文字 (Unicode 参考特性 `East_Asian_Width` が `A` (Ambiguous) の文字) の幅を制御できます。
現在は 4 つの選択肢 `emacs`, `west`, `east`, `auto` が用意されています。
設定値 `emacs` を指定した場合、GNU Emacs における既定の文字幅と同じ物を使います。
設定値 `west` を指定した場合、全ての曖昧文字幅を 1 (半角) と解釈します。
設定値 `east` を指定した場合、全ての曖昧文字幅を 2 (全角) と解釈します。
設定値 `auto` を指定した場合、`west` か `east` かを端末とのやり取りに基づいて自動判定します。
既定値は `auto` です。この設定項目は、利用している端末の振る舞いに応じて適切に設定する必要があります。
例えば `west` に設定する場合は以下の様にします:

```bash
bleopt char_width_mode='west'
```

## 2.4 文字コード

設定 `input_encoding` は入力の文字コードを制御するのに使います。現在 `UTF-8` と `C` のみに対応しています。
設定値 `C` を指定した場合は、受信したバイト値が直接文字コードであると解釈されます。
既定値は `UTF-8` です。`C` に設定を変更する場合には以下の様にします:

```bash
bleopt input_encoding='C'
```

## 2.5 ベル

設定 `edit_abell` と設定 `edit_vbell` は、編集関数 `bell` の振る舞いを制御します。
`edit_abell` が非空白の文字列の場合、音による通知が有効になります (つまり、制御文字の `BEL` (0x07) が `stderr` に出力されます)。
`edit_vbell` が非空白の文字列の場合、画面での通知が有効になります。既定では音による通知が有効で、画面での通知が無効になっています。

設定 `vbell_default_message` は画面での通知で使用するメッセージ文字列を指定します。既定値は `' Wuff, -- Wuff!! '` です。
設定 `vbell_duration` は画面での通知を表示する時間の長さを指定します。単位はミリ秒です。既定値は `2000` です。

例えば、画面での通知は以下のように設定・有効化できます:
```bash
bleopt edit_vbell=1 vbell_default_message=' BEL ' vbell_duration=3000
```

もう一つの例として、音による通知は以下の様にして無効化できます。
```bash
bleopt edit_abell=
```

## 2.6 着色の設定

構文に従った着色で使用される、各文法要素の色と属性は `ble-color-setface` シェル関数で設定します。
既定の設定は以下のコードに対応します:
```bash
# 編集に関連する着色の設定
ble-color-setface region                    bg=60,fg=white
ble-color-setface region_target             bg=153,fg=black
ble-color-setface region_match              bg=55,fg=white
ble-color-setface region_insert             fg=12,bg=252
ble-color-setface disabled                  fg=242
ble-color-setface overwrite_mode            fg=black,bg=51
ble-color-setface auto_complete             fg=238,bg=254
ble-color-setface menu_filter_fixed         bold
ble-color-setface menu_filter_input         fg=16,bg=229
ble-color-setface vbell                     reverse
ble-color-setface vbell_erase               bg=252
ble-color-setface vbell_flash               fg=green,reverse
ble-color-setface prompt_status_line        fg=231,bg=240

# 構文着色の設定
ble-color-setface syntax_default            none
ble-color-setface syntax_command            fg=brown
ble-color-setface syntax_quoted             fg=green
ble-color-setface syntax_quotation          fg=green,bold
ble-color-setface syntax_expr               fg=26
ble-color-setface syntax_error              bg=203,fg=231
ble-color-setface syntax_varname            fg=202
ble-color-setface syntax_delimiter          bold
ble-color-setface syntax_param_expansion    fg=purple
ble-color-setface syntax_history_expansion  bg=94,fg=231
ble-color-setface syntax_function_name      fg=92,bold
ble-color-setface syntax_comment            fg=242
ble-color-setface syntax_glob               fg=198,bold
ble-color-setface syntax_brace              fg=37,bold
ble-color-setface syntax_tilde              fg=navy,bold
ble-color-setface syntax_document           fg=94
ble-color-setface syntax_document_begin     fg=94,bold
ble-color-setface command_builtin_dot       fg=red,bold
ble-color-setface command_builtin           fg=red
ble-color-setface command_alias             fg=teal
ble-color-setface command_function          fg=92
ble-color-setface command_file              fg=green
ble-color-setface command_keyword           fg=blue
ble-color-setface command_jobs              fg=red
ble-color-setface command_directory         fg=26,underline
ble-color-setface filename_directory        underline,fg=26
ble-color-setface filename_directory_sticky underline,fg=white,bg=26
ble-color-setface filename_link             underline,fg=teal
ble-color-setface filename_orphan           underline,fg=teal,bg=224
ble-color-setface filename_executable       underline,fg=green
ble-color-setface filename_setuid           underline,fg=black,bg=220
ble-color-setface filename_setgid           underline,fg=black,bg=191
ble-color-setface filename_other            underline
ble-color-setface filename_socket           underline,fg=cyan,bg=black
ble-color-setface filename_pipe             underline,fg=lime,bg=black
ble-color-setface filename_character        underline,fg=white,bg=black
ble-color-setface filename_block            underline,fg=yellow,bg=black
ble-color-setface filename_warning          underline,fg=red
ble-color-setface filename_url              underline,fg=blue
ble-color-setface filename_ls_colors        underline
ble-color-setface varname_array             fg=orange,bold
ble-color-setface varname_empty             fg=31
ble-color-setface varname_export            fg=200,bold
ble-color-setface varname_expr              fg=92,bold
ble-color-setface varname_hash              fg=70,bold
ble-color-setface varname_number            fg=64
ble-color-setface varname_readonly          fg=200
ble-color-setface varname_transform         fg=29,bold
ble-color-setface varname_unset             fg=124
```

現在の描画設定の一覧は以下のコマンドでも確認できます (`ble-color-setface` を無引数で呼び出す)。
```console
$ ble-color-setface
```

色コードはシェル関数 `ble-color-show` (`ble.sh` 内で定義) で確認できます。
```console
$ ble-color-show
```

## 2.7 キーバインディング

キーバインディングはシェル関数 `ble-bind` を使って変更できます。
例えば <kbd>C-x h</kbd> を入力した時に "Hello, world!" と挿入させたければ以下のようにします。
```bash
ble-bind -f 'C-x h' 'insert-string "Hello, world!"'
```

<kbd>M-c</kbd> を入力した時にコマンドを実行するには以下のようにします。

```bash
ble-bind -c 'M-c' 'my-command'
```

<kbd>C-r</kbd> を入力した時に、ユーザー定義編集関数 (Bash の `bind -x` で指定するのと同様の物) を実行するには以下のようにします。

```bash
ble-bind -x 'C-r' 'my-edit-function'
```

既存のキーバインディングは以下のコマンドで確認できます。
```console
$ ble-bind -P
```

以下のコマンドでキーバインディングに使える編集関数一覧を確認できます。
```console
$ ble-bind -L
```

# 3 ヒント

## 3.1 複数行モード

コマンドラインに改行が含まれている場合、複数行モード (MULTILINE モード) になります。

<kbd>C-v RET</kbd> または <kbd>C-q RET</kbd> とすると改行をコマンドラインの一部として入力できます。
複数行モードでは、<kbd>RET</kbd> (<kbd>C-m</kbd>) はコマンドの実行ではなく新しい改行の挿入になります。
複数行モードでは、<kbd>C-j</kbd> を用いてコマンドを実行して下さい。

`shopt -s cmdhist` が設定されているとき (既定)、もし <kbd>RET</kbd> (<kbd>C-m</kbd>) を押した時にコマンドラインが構文的に閉じていなければ、コマンドの実行ではなく改行の挿入を行います。

## 3.2 Vim モード

`.bashrc` に `set -o vi` が設定されているとき、または `.inputrc` に `set editing-mode vi` が設定されているとき、vim モードが有効になります。
Vim モードの詳細な設定については [Wiki のページ (英語)](https://github.com/akinomyoga/ble.sh/wiki/Vi-(Vim)-editing-mode) を御覧ください。

## 3.3 自動補完

Bash 4.0 以降では自動補完が有効になり、予測候補が表示されます。
候補を確定するには <kbd>S-RET</kbd> を入力します (編集文字列の末尾にいる時は <kbd>right</kbd>, <kbd>C-f</kbd> または <kbd>end</kbd> でも確定できます)。
表示されている候補の初めの単語だけ部分的に確定する時は <kbd>M-f</kbd> または <kbd>M-right</kbd> を入力します。
現在の候補で確定しそのままコマンドを実行する場合には <kbd>C-RET</kbd> (※お使いの端末が対応している時) を入力します。

## 3.4 静的略語展開

特定の単語を静的略語展開に登録することで好きな文字列に展開することができます。
登録済み単語に一致する単語の直後で <kbd>SP</kbd> を入力した時に静的略語展開が起きます。
例えば、以下の設定をしておくと `command L` まで入力した状態で <kbd>SP</kbd> を押した時に、コマンドラインが `command | less` に展開されます。

```bash
# blerc
ble-sabbrev L='| less'
```

# 4 謝辞

GitHub の Issue/PR を通して多くの方からフィードバックを頂き、皆様に本当に感謝しております。
特に以下の方には大きな寄与を受けたので言及させていただきます。

- [`@cmplstofB`](https://github.com/cmplstofB) 様には vim モードの実装において初期よりテスト及び様々な提案をしていただきました。
- [`@dylankb`](https://github.com/dylankb) 様には `fzf` との互換性や `ble.sh` 初期化に関連して様々な問題報告をいただきました。
- [`@rux616`](https://github.com/rux616) 様には幾つかの問題報告および `.blerc` の既定パス解決のバグ修正をいただきました。
- [`@timjrd`](https://github.com/timjrd) 様には補完の枠組みの高速化に関する PR をいただきました。
- [`@3ximus`](https://github.com/3ximus) 様には広範囲に渡る様々な問題について報告いただきました。
