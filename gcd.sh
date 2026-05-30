#!/bin/bash

# 評価項目：正しい入出力チェック（引数の個数確認）
if [ $# -ne 2 ]; then
    echo "エラー: 引数はちょうど2つ入力してください。 (現在: $#個)" >&2
    echo "使い方: $0 自然数1 自然数2" >&2
    exit 1
fi

# 評価項目：正しい入出力チェック（自然数かどうかの正規表現判定）
for arg in "$1" "$2"; do
    if [[ ! "$arg" =~ ^[1-9][0-9]*$ ]]; then
        echo "エラー: 引数 '$arg' は自然数（1以上の整数）ではありません。" >&2
        exit 1
    fi
done

# 評価項目：数値演算（ユークリッドの互除法の実装）
a=$1
b=$2

while [ "$b" -ne 0 ]; do
    remainder=$((a % b))
    a=$b
    b=$remainder
done

# 計算結果の出力
echo "$a"
exit 0
