#!/bin/bash

set -e

source ./.env

# content.opf修正

# 基本情報修正
date_string=$(date +%Y%m%d%H%M%S)
dc_date_string=$(date +%Y-%m-%d)
book_id="${BOOK_ID_PREFIX}${date_string}"
dc_book_id_identifier="\<dc\:identifier id\=\"BookId\"\>${book_id}\<\/dc\:identifier\>"
dc_publisher="\<dc\:publisher>${PUBLISHER}\<\/dc\:publisher\>"
dc_creator="\<dc\:creator>${AUTHOR}\<\/dc\:creator\>"
dc_title="\<dc\:title>${BOOK_TITLE}\<\/dc\:title\>"
dc_date="\<dc\:date opf\:event\=\"modification\" xmlns\:opf\=\"http\:\/\/www.idpf.org\/2007\/opf\"\>${dc_date_string}\<\/dc\:date\>"
meta_series="\<meta content\=\"${SERIES}\" name\=\"calibre\:series\" \/\>"
meta_series_count="\<meta content\=\"${SERIES_COUNT}\" name\=\"calibre:series_index\" \/\>"

sed -i -e "s/<dc:identifier\s*.*/${dc_book_id_identifier}/" ${OEBPS_DIR}/content.opf
sed -i -e "s/<dc:publisher\s*.*/${dc_publisher}/" ${OEBPS_DIR}/content.opf
sed -i -e "s/<dc:creator\s*.*/${dc_creator}/" ${OEBPS_DIR}/content.opf
sed -i -e "s/<dc:title\s*.*/${dc_title}/" ${OEBPS_DIR}/content.opf
sed -i -e "s/<dc:date\s*.*/${dc_date}/" ${OEBPS_DIR}/content.opf
sed -i -e "s/<meta content=.*calibre:series\".*/${meta_series}/" ${OEBPS_DIR}/content.opf
sed -i -e "s/<meta content=.*calibre:series_index.*/${meta_series_count}/" ${OEBPS_DIR}/content.opf

# page向けxml修正・生成
book_title_string="<title>${BOOK_TITLE}<\/title>"
for file in $(find ${EPUB_IMAGE_DIR} -name '*.jpg'); do
  image_file=$(basename "${file}")
  page_number=$(echo ${image_file} | grep -o '[0-9]*')
  if [ -n "$page_number" ]; then
    if ! [ "$page_number" = "0001" ]; then
      previous_number=$((${page_number} - 1))
      previous_number=$(printf "%04d" ${previous_number})

      # content.opfにページ情報追加
      # itemタグ追加
      search_string_item="<item id\=\"page${previous_number}\""
      item_jpg_string="\t\t<item id\=\"image${page_number}\" href\=\"Images\/page${page_number}.jpg\" media-type\=\"image\/jpeg\"\/\>"
      item_xhtml_string="\t\t<item id\=\"page${page_number}\" href\=\"Text\/page${page_number}.xhtml\" media-type\=\"application\/xhtml\+xml\"\/\>"
      sed -i -e "/${search_string_item}/a \\${item_jpg_string}\n${item_xhtml_string}" ${OEBPS_DIR}/content.opf

      # itemrefタグ追加
      search_string_itemref="<itemref idref\=\"page${previous_number}\" \/>"
      itemref_string="\t\t<itemref idref\=\"page${page_number}\" \/>"
      sed -i -e "/${search_string_itemref}/a \\${itemref_string}" ${OEBPS_DIR}/content.opf
    fi

    # xhtmlファイル生成（xhtmlはpage0001も処理が必要なのでif文の外で処理を実行）
    target_page_xhtml_file=${EPUB_TEXT_DIR}/page${page_number}.xhtml
    cp template/OEBPS/Text/page.xhtml ${target_page_xhtml_file}

    sed -i -e "s/<title>*.*/${book_title_string}/" ${target_page_xhtml_file}

    sed -i -e "s/\[PAGE_JPG\]/${image_file}/" ${target_page_xhtml_file}
    sed -i -e "s/\[EPUB_PAGE_WIDTH\]/${EPUB_PAGE_WIDTH}/" ${target_page_xhtml_file}
    sed -i -e "s/\[EPUB_PAGE_HEIGHT\]/${EPUB_PAGE_HEIGHT}/" ${target_page_xhtml_file}
  fi
done | sort

# cover.xhtml, nav.xhtml修正
target_cover_xhtml_file=${EPUB_TEXT_DIR}/cover.xhtml
sed -i -e "s/<title>*.*/${book_title_string}/" ${target_cover_xhtml_file}
sed -i -e "s/\[EPUB_PAGE_WIDTH\]/${EPUB_PAGE_WIDTH}/" ${target_cover_xhtml_file}
sed -i -e "s/\[EPUB_PAGE_HEIGHT\]/${EPUB_PAGE_HEIGHT}/" ${target_cover_xhtml_file}

sed -i -e "s/<title>*.*/${book_title_string}/" ${EPUB_TEXT_DIR}/nav.xhtml

echo "modifying '${OEBPS_DIR}/content.opf' succeeded."
echo "adding '${EPUB_TEXT_DIR}/page.xhtml' files succeeded."
