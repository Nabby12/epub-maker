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

# 入力値を確認
echo -e "\n"
echo -e "${start_yellow_bold}Show config.${end_yellow_bold}"
echo -e "${start_yellow_bold}============${end_yellow_bold}"
echo -e "SERIES: ${start_green}${input_series}${end_green}"
echo -e "SERIES_COUNT: ${start_green}${input_series_count}${end_green}"
echo -e "AUTHOR: ${start_green}${input_author}${end_green}"
echo -e "PUBLISHER: ${start_green}${input_publisher}${end_green}"
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

echo -e "\n"
echo -e "${start_green}setting values successfully finished.${end_green}"
echo -e "\n"
