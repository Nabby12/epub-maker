include .env

# epub生成
run: check
	./scripts/build.sh

# assetsファイルに不足がないか確認
check:
	./scripts/check.sh
