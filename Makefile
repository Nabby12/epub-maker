# epub生成
run: check set-env
	./scripts/build.sh

# assetsファイルに不足がないか確認
check:
	./scripts/check.sh

# envファイルの値を設定
set-env:
	./scripts/set-env.sh
