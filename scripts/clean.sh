#!/bin/bash

set -e

source ./.env

start_green="\033[0;32m"
end_green="\033[0m"

selected_all="all"
target=$(echo -e "${selected_all}\n$(ls ${ASSET_DIR})" | peco)

assets_parent_dir=${ASSET_DIR}
build_parent_dir=$(echo ${BUILD_DIR%%/*})
output_parent_dir=${OUTPUT_DIR}

if [ -z "$target" ]; then
  echo "task canceled."
  exit 0
fi

# 選択した対象を削除
if [ "$target" = "${selected_all}" ]; then
  rm -rf ${assets_parent_dir}/*
  rm -rf ${build_parent_dir}/*
  rm -rf ${output_parent_dir}/*
else
  rm -rf "${assets_parent_dir}/${target}"
  rm -rf "${build_parent_dir}/${target}"
  rm -f "${output_parent_dir}/$(echo ${target} | sed 's/_/ /g').epub"
fi

echo ""
echo -e "${start_green}cleaning '${target}' resources successfully finished.${end_green}"
