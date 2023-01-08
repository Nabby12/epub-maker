#!/bin/bash

set -e

source ./.env

start_yellow_bold="\033[1;33m"
end_yellow_bold="\033[0m"
start_green="\033[0;32m"
end_green="\033[0m"
start_red="\033[0;31m"
end_red="\033[0m"

# リサイズ値を設定
echo ""
echo -e "${start_yellow_bold}Setting resize values.${end_yellow_bold}"
echo -e "${start_yellow_bold}======================${end_yellow_bold}"

read -p "RESIZE_WIDTH: " input_resize_width
input_resize_width=${input_resize_width:-0}
read -p "RESIZE_HEIGHT: " input_resize_height
input_resize_height=${input_resize_height:-0}

# 拡張子選択
extension_jpg="jpg"
extension_png="png"
echo ""
echo -e "${start_yellow_bold}Select extension below.${end_yellow_bold}"
echo -e "${start_yellow_bold}=======================${end_yellow_bold}"
selection_list=(${extension_jpg} ${extension_png})
selection_count=$((${#selection_list[@]} - 1))

count=0
for selection in ${selection_list[@]}; do
  echo "${count}) ${selection}"
  count=$((count + 1))
done

image_extension=""
echo ""
while true; do
  read -p "INPUT EXTENSION NUMBER ABOVE (0-${selection_count}): " choice
  image_extension=${selection_list[$choice]}
  if [ -n "$image_extension" ] && [ -n "$choice" ]; then
    break
  else
    echo -e "${start_red}invalid option. please select valid option.${end_red}"
  fi
done

if [ "$input_resize_width" == 0 ] || [ "$input_resize_height" == 0 ]; then
  echo -e "${start_red}'0' is invalid values for resizing.${end_red}"
  exit 1
fi

# 入力値を確認
echo ""
echo -e "${start_yellow_bold}Show inpu valurs.${end_yellow_bold}"
echo -e "${start_yellow_bold}=================${end_yellow_bold}"
echo -e "RESIZE_WIDTH: ${start_green}${input_resize_width}${end_green}"
echo -e "RESIZE_HEIGHT: ${start_green}${input_resize_height}${end_green}"
echo -e "IMAGE_EXTENSION: ${start_green}${image_extension}${end_green}"
echo ""

read -p "Is input value ok? [y/N] " answer
answer=${answer:-n}
if [ "$answer" != "y" ]; then
  echo -e "${start_red}input values is not ok.${end_red}"
  exit 1
fi

# リサイズ実行
node ./src/resize.js $input_resize_width $input_resize_height $image_extension
# 元の画像を別フォルダに退避
date_string=$(date +%Y%m%d%H%M%S)
target_dir="${ASSET_DIR}/origin/${date_string}"
mkdir -p "${target_dir}"
find ${ASSET_DIR} -maxdepth 1 -name "*.${image_extension}" | xargs -I{} mv -f {} "${target_dir}/"

echo ""
echo -e "${start_green}resizing images successfully finished.${end_green}"
echo ""
