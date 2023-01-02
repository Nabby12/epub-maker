#!/bin/bash

set -e

source ./.env

start_yellow_bold="\033[1;33m"
end_yellow_bold="\033[0m"
start_green="\033[0;32m"
end_green="\033[0m"
start_red="\033[0;31m"
end_red="\033[0m"

echo -e "\n"
echo -e "${start_yellow_bold}Setting env values.${end_yellow_bold}"
echo -e "${start_yellow_bold}===================${end_yellow_bold}"

# 書籍タイトル（シリーズ名）を設定
read -p "SERIES [${SERIES}]: " input_series
input_series=${input_series:-$SERIES}

# 書籍巻数を設定
read -p "SERIES_COUNT [${SERIES_COUNT}]: " input_series_count
input_series_count=${input_series_count:-$SERIES_COUNT}

# 著者を設定
read -p "AUTHOR [${AUTHOR}]: " input_author
input_author=${input_author:-$AUTHOR}

# 出版社を設定
read -p "PUBLISHER [${PUBLISHER}]: " input_publisher
input_publisher=${input_publisher:-$PUBLISHER}

# トリム位置を設定
read -p "TRIM_LEFT [${TRIM_LEFT} (0/0)]: " input_trim_left
input_trim_left=${input_trim_left:-$TRIM_LEFT}
read -p "TRIM_TOP [${TRIM_TOP} (227/0)]: " input_trim_top
input_trim_top=${input_trim_top:-$TRIM_TOP}

# トリミングサイズを設定
read -p "IMAGE_WIDTH [${IMAGE_WIDTH} (1080/580)]: " input_image_width
input_image_width=${input_image_width:-$IMAGE_WIDTH}
read -p "IMAGE_HEIGHT [${IMAGE_HEIGHT} (1706/917)]: " input_image_height
input_image_height=${input_image_height:-$IMAGE_HEIGHT}

# 入力値を確認
echo -e "\n"
echo -e "${start_yellow_bold}Show config.${end_yellow_bold}"
echo -e "${start_yellow_bold}============${end_yellow_bold}"
echo -e "SERIES: ${start_green}${input_series}${end_green}"
echo -e "SERIES_COUNT: ${start_green}${input_series_count}${end_green}"
echo -e "AUTHOR: ${start_green}${input_author}${end_green}"
echo -e "PUBLISHER: ${start_green}${input_publisher}${end_green}"
echo -e "TRIM_LEFT: ${start_green}${input_trim_left}${end_green}"
echo -e "TRIM_TOP: ${start_green}${input_trim_top}${end_green}"
echo -e "IMAGE_WIDTH: ${start_green}${input_image_width}${end_green}"
echo -e "IMAGE_HEIGHT: ${start_green}${input_image_height}${end_green}"
echo -e "\n"

read -p "Is input value ok? [y/N] " answer
answer=${answer:-n}
if [ "$answer" != "y" ]; then
  echo -e "${start_red}env values is not ok.${end_red}"
  exit 1
fi

# .envを入力値で修正
sed -i -e "s/SERIES\=\"\s*.*/SERIES\=\"${input_series}\"/" .env
sed -i -e "s/SERIES_COUNT\=\"\s*.*/SERIES_COUNT\=\"${input_series_count}\"/" .env
sed -i -e "s/AUTHOR\=\"\s*.*/AUTHOR\=\"${input_author}\"/" .env
sed -i -e "s/PUBLISHER\=\"\s*.*/PUBLISHER\=\"${input_publisher}\"/" .env
sed -i -e "s/^TRIM_LEFT\=\s*.*/TRIM_LEFT\=${input_trim_left}/" .env
sed -i -e "s/^TRIM_TOP\=\s*.*/TRIM_TOP\=${input_trim_top}/" .env
sed -i -e "s/^IMAGE_WIDTH\=\s*.*/IMAGE_WIDTH\=${input_image_width}/" .env
sed -i -e "s/^IMAGE_HEIGHT\=\s*.*/IMAGE_HEIGHT\=${input_image_height}/" .env

echo -e "\n"
echo -e "${start_green}setting values successfully finished.${end_green}"
echo -e "\n"
