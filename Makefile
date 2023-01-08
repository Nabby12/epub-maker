# epub生成
run: check set-env
	./scripts/build.sh

# assetsファイルに不足がないか確認
check:
	./scripts/check.sh

# envファイルの値を設定
set-env:
	./scripts/set-env.sh

# 素材画像や生成物を削除
clean:
	./scripts/clean.sh

# その他コマンド

# 画像リサイズ
resize:
	./scripts/resize.sh
