# epub-maker

## Overview

一連の画像ファイルをepub3.0に自動変換するスクリプト

## Required tools

```sh
# 必要ツールをインストール
brew install peco
brew install jpegoptim
brew install pngquant
```

## How to use

- `./assets` フォルダを作成し、フォルダ内に画像を用意
  - 表紙画像 `cover.jpg`
    - トリミングされないのでサイズを合わせておく（ex: 800 x 1280）
  - 任意のファイル名の複数画像
    - 後述のスクリプトでトリミングおよびリネームが実行される
    - タイトル順でページ生成される
      - androidのスクショなら日付が入っているので問題ない
- .envファイルを修正
  - タイトル等、epubファイルの基本情報を設定
  - 後述のepub生成コマンド実行時に対話形式でも設定可能
- コマンドでスクリプト実行し変換を実行

```shell
# outputフォルダにepubファイル生成
make run
```

## Reference

- [http://n.blueblack.net/articles/2012-08-18_01_how_to_make_epub3/](http://n.blueblack.net/articles/2012-08-18_01_how_to_make_epub3/)
- [https://www.apollomaniacs.com/ipod/howto_book_iBooks_makeEPUB.htm#EPUB%E5%BD%A2%E5%BC%8F%E3%81%AE%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E6%A7%8B%E9%80%A0](https://www.apollomaniacs.com/ipod/howto_book_iBooks_makeEPUB.htm#EPUB%E5%BD%A2%E5%BC%8F%E3%81%AE%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E6%A7%8B%E9%80%A0)
- [https://qiita.com/positrium/items/94ee8d72c571671cd9a3](https://qiita.com/positrium/items/94ee8d72c571671cd9a3)
- [https://github.com/positrium/create-epub-with-my-hand/blob/master/create_epub.sh](https://github.com/positrium/create-epub-with-my-hand/blob/master/create_epub.sh)
