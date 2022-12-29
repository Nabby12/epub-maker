#!/bin/bash

set -e

start_green="\033[0;32m"
end_green="\033[0m"
start_red="\033[0;31m"
end_red="\033[0m"
error_log="${start_red}ERROR: ${end_red}"

# 表紙ファイルがあるかどうかを確認
cover_image_name="cover.jpg"
cover_image=$(find ./assets -name "${cover_image_name}")
if [ -z "$cover_image" ]; then
  echo -n -e ${error_log}
  echo -e "${start_red}'${cover_image_name}' is not found in './assets'.${end_red}\nplease store the '${cover_image_name}' in the directory."
  echo -e "\n"
  exit 1
fi

# 表紙ファイルの他に少なくとも1枚の画像があるかどうかを確認
page_image_count=$(ls -la ./assets | grep .jpg | grep -vE ${cover_image_name} | wc -l)
if [ $page_image_count = 0 ]; then
  echo -n -e ${error_log}
  echo -e "${start_red}image files are not found except for '${cover_image_name}'.${end_red}\nplease store the image files at least 1."
  echo -e "\n"
  exit 1
fi

# .envファイルがあるかどうかを確認
env_file_name=".env"
env_file=$(find ./ -name "${env_file_name}")
if [ -z "$env_file" ]; then
  echo -n -e ${error_log}
  echo -e "${start_red}'${env_file_name}' is not found.${end_red}\nplease store the '${env_file_name}' and set the environmental variables in it."
  echo -e "\n"
  exit 1
fi

echo -e "\n"
echo -e "${start_green}check passed!${end_green}"
echo -e "\n"
