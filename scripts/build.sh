#!/bin/bash

set -e

source ./.env

start_yellow="\033[0;33m"
end_yellow="\033[0m"
start_green="\033[0;32m"
end_green="\033[0m"

# 対象のファイルを一部表示
echo -e "\n"
echo -e "${start_yellow}==========> target files...${end_yellow}"

ls -la ${ASSET_DIR} | head -10 | xargs -I{} echo {} && echo -e "...\n"

# 必要ファイル生成
echo -e "\n"
echo -e "${start_yellow}==========> setting template...${end_yellow}"
echo "making directories and copying template files."
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
cp ${ASSET_DIR}/cover.${IMAGE_EXTENSION} ${EPUB_IMAGE_DIR}/cover.${IMAGE_EXTENSION}
echo -e "${start_yellow}==========> setting done.${end_yellow}"

# 画像修正（リサイズ・トリミング・名前変更）
echo -e "\n"
echo -e "${start_yellow}==========> processing images...${end_yellow}"
node src/trim_and_rename.js
# 元の画像を別フォルダに退避
mkdir -p "${ASSET_DIR}/${BOOK_TITLE}"
find ${ASSET_DIR} -maxdepth 1 -name "*.${IMAGE_EXTENSION}" | xargs -I{} mv -f {} "${ASSET_DIR}/${BOOK_TITLE}/"
echo -e "${start_yellow}==========> processing done.${end_yellow}"

# ページ生成
echo -e "\n"
echo -e "${start_yellow}==========> generating pages...${end_yellow}"
./scripts/generate.sh
echo -e "${start_yellow}==========> generating done.${end_yellow}"

# epubファイル生成
echo -e "\n"
echo -e "${start_yellow}==========> exporting epub file...${end_yellow}"
## epubファイル出力フォルダを生成
rm -rf ${OUTPUT_DIR}
mkdir -p ${OUTPUT_DIR}

## epub生成
current_dir="$(pwd)"
cd ${BUILD_DIR}
zip -X0 "${current_dir}/${OUTPUT_DIR}/${BOOK_TITLE}.epub" mimetype
zip -r9 "${current_dir}/${OUTPUT_DIR}/${BOOK_TITLE}.epub" * -x mimetype
echo -e "${start_yellow}==========> exporting done.${end_yellow}"

echo -e "\n"
echo -e "${start_green}build epub succeeded!! :)${end_green}"
