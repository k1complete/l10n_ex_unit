L10nExUnit
==========

[Elixir](http://elixir-lang.com/docs/stable/elixir)の地域化パッケージで
ある[Exgettext](http://github.com/k1complete/exgettext)を用いて翻訳され
た、言語リソースです。作者が日本人であることもあり、現在、日本語
リソースのみですが、仕組み的には増やすことが出来ると思います。

言語リソースは、[GNU gettext](https://www.gnu.org/software/gettext/)の
po file(Portable Object)に準拠しています。

なお、l10n_elixirのサブプロジェクトになっています。

ビルド
------

ビルドには、Exgettextが必要ですが、通常はmix deps.getにより
自動的にダウンロードされます。

    |$ git clone https://github.com/k1complete/l10n_ex_unit
    |$ mix deps.get 
    |$ mix compile
    |$ ls -l priv/lang/ja/l10n_ex_unit.exmo

使いかた
--------

ビルド後、日本後リソースと、いくつかの支援モジュールが組込まれますので、
iex -S mixで実行してみます。

    |$ iex -S mix
    |iex(1)> h ExUnit.start
    
                                def start(options \\ [])                            
    
    Starts ExUnit and automatically runs tests right before the VM terminates. It
    accepts a set of options to configure ExUnit (the same ones accepted by
    configure/1).
    
    If you want to run tests manually, you can set :autorun to false.
    
    |iex(2)> import Exgettext.Helper
    nil
    |iex(3)> h ExUnit.start         
    
                                def start(options \\ [])                            
    
    ExUnitを開始し、自動的にテストを走らせ、直後にVMを終了します。 
    ExUnitを構成するための、一組のオプションを受け入れます
    (オプションはconfigure/1と同じです)。
    
    マニュルでテストを走らせたいなら、:autorunをfalseにセット してください。
    
.iex.exsフィアルに import Exgettext.Helperを入れておくことで、日本語の
表示を優先できます。

Ex_doc
-------

ex_docとの連携は、Exgettext側で或る程度準備しています。その上で、
パッチをあてた[ex_doc](https://github.com/k1complete/ex_doc.git)を
クローンしてビルドしてください。

ビルド位置は、elixirのソースのとなりが良いです(elixirのソースへ
cd してから、make docsでレファレンスマニュアルをビルドしますが、
その際の想定位置がそうなっているためです)。

ex_docのビルドが終ったら、elixirのソースへcdし、

  |$> make docs
  
でドキュメントをビルドします。docsディレクトリにリファレンスマニュアル
がHTMLでレンダリングされます。

POファイルの修正
----------------

poフィアルは、GNU gettext互換ですので、emacs po-modeを使うか、
テキストエディタで修正します。

poファイルを修正したら、mix compileでコンパイルすることで、言語リソース
であるexmoファイルがアップデートされます。

内部的にはMix.Tasks.Compile.Poというタスクを作成しています。

ex_unitソース変更への追随
------------------------

ex_unit本体のソースが変更されたら、トークンの拾い出しを行います。
これは、l10n_ex_unitのプロジェクトディレクトリで行います。
--ex-unitというapp名を渡します(--ex_unitではないです。--ex-unit
を渡すことで、内部的にex_unitに変換されます)。

    |$ mix l10n.xgettext --ex-unit path/to/ex_unit/source
    xgettext for l10n_ex_unit
    clean l10n_ex_unit.pot_db
    
    Compiled lib/l10n_ex_unit.ex
    Generated l10n_ex_unit.app
    xgettext l10n_ex_unit.pot_db --output=priv/po/l10n_ex_unit.pot
    collecting document for l10n_ex_unit
    collecting document for elixir

priv/po/l10n_ex_unit.potファイルが生成されます。これと既存の
poファイルとをマージします。

    |$ mix l10n.msgmerge
    msgmerge -o priv/po/ja.pox priv/po/ja.po priv/po/l10n_ex_unit.pot
    .............................................................
    .................................. 完了.
    |$ diff priv/po/ja.po priv/po/ja.pox    

いろいろ差分がでますので、目視で確認してOKならja.poxをja.poへリネーム
します。その後、追加エントリの翻訳を行います。

翻訳後、言語リソースをビルドします。

    |$ mix l10n.msgfmt ## または、
    |$ mix compile

