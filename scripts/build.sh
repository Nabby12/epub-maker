#!/bin/bash

set -e

source ./.env

# 対象のファイルを一部表示
echo -e "\n==========> target files..."

ls -la ${ASSET_DIR} | head -10 | xargs -I{} echo {} && echo -e "...\n"

# 必要ファイル生成
echo -e "\n==========> setting template..."
## 必要フォルダ作成
rm -rf ${BUILD_DIR}
mkdir -p ${META_DIR}
mkdir -p ${EPUB_IMAGE_DIR}
mkdir -p ${EPUB_STYLE_DIR}
mkdir -p ${EPUB_TEXT_DIR}

## テンプレートコピー
cp template/mimetype ${BUILD_DIR}/mimetype
cp template/META-INF/container.xml ${META_DIR}/container.xml
cp template/OEBPS/content.opf ${OEBPS_DIR}/content.opf
cp template/OEBPS/Styles/style.css ${EPUB_STYLE_DIR}/style.css
cp template/OEBPS/Text/cover.xhtml ${EPUB_TEXT_DIR}/cover.xhtml
cp template/OEBPS/Text/nav.xhtml ${EPUB_TEXT_DIR}/nav.xhtml
cp ${ASSET_DIR}/cover.jpg ${EPUB_IMAGE_DIR}/cover.jpg
echo "==========> setting done."

# 画像修正（リサイズ・トリミング・名前変更）
echo -e "\n==========> processing images..."
node src/trim_and_rename.js
echo "==========> processing done."

# ページ生成
echo -e "\n==========> generating pages..."
./scripts/generate.sh
echo "==========> generating done."

# epubファイル生成
echo -e "\n==========> exporting epub file..."
## epubファイル出力フォルダを生成
rm -rf ${OUTPUT_DIR}
mkdir -p ${OUTPUT_DIR}

## epub生成
current_dir="$(pwd)"
cd ${BUILD_DIR}
zip -X0 "${current_dir}/${OUTPUT_DIR}/${BOOK_TITLE}.epub" mimetype
zip -r9 "${current_dir}/${OUTPUT_DIR}/${BOOK_TITLE}.epub" * -x mimetype
echo "==========> exporting done."

echo -e "\nbuild epub succeeded!! :)"
