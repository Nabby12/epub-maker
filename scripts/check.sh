#!/bin/bash

set -e

start_green="\033[0;32m"
end_green="\033[0m"
start_red="\033[0;31m"
end_red="\033[0m"
error_log="${start_red}ERROR: ${end_red}"

ASSET_DIR="./assets"

extension_jpg="jpg"
extension_png="png"
extension_jpg_for_mediatype="jpeg"
extension_png_for_mediatype="png"

# 表紙ファイルがあるかどうかを確認
cover_image_prefix="cover."
cover_image=$(find ${ASSET_DIR} -maxdepth 1 -name "${cover_image_prefix}*")
image_extension=$(echo ${cover_image} | awk -F . '{print $NF}')
cover_image_name="${cover_image_prefix}${image_extension}"
if [ "$image_extension" != "$extension_jpg" ] && [ "$image_extension" != "$extension_png" ]; then
  echo -n -e ${error_log}
  echo -e "${start_red}'cover image (jpg/png)' is not found in '${ASSET_DIR}'.${end_red}\nplease store the '${cover_image_prefix}${extension_jpg}/${extension_png}' in the directory."
  echo -e "\n"
  exit 1
fi

# 表紙ファイルの他に少なくとも1枚の画像があるかどうかを確認
page_image_count=$(ls -la ${ASSET_DIR} | grep .${image_extension} | grep -vE ${cover_image_name} | wc -l)
if [ $page_image_count = 0 ]; then
  echo -n -e ${error_log}
  echo -e "${start_red}image files are not found except for '${cover_image_name}'.${end_red}\nplease store the image files (${image_extension}) at least 1."
  echo -e "\n"
  exit 1
fi

# .envファイルがあるかどうかを確認
env_file_name=".env"
env_file=$(find ./ -maxdepth 1 -name "${env_file_name}")
if [ -z "$env_file" ]; then
  echo -n -e ${error_log}
  echo -e "${start_red}'${env_file_name}' is not found.${end_red}\nplease store the '${env_file_name}' and set the environmental variables in it."
  echo -e "\n"
  exit 1
fi

# .envファイルの拡張子を修正
image_extension_for_mediatype=""
case "$image_extension" in
  $extension_jpg)
    image_extension_for_mediatype=${extension_jpg_for_mediatype}
    ;;
  $extension_png)
    image_extension_for_mediatype=${extension_png_for_mediatype}
    ;;
  *)
    echo -n -e ${error_log}
    echo -e "${start_red}'image extension' is invalid.${end_red}\nplease check the image files."
    echo -e "\n"
    exit 1
    ;;
esac
sed -i -e "s/IMAGE_EXTENSION\=\"\s*.*/IMAGE_EXTENSION\=\"${image_extension}\"/" .env
sed -i -e "s/IMAGE_EXTENSION_FOR_MEDIATYPE\=\"\s*.*/IMAGE_EXTENSION_FOR_MEDIATYPE\=\"${image_extension_for_mediatype}\"/" .env

echo -e "\n"
echo -e "${start_green}check passed!${end_green}"
echo -e "\n"
