#!/bin/bash

GCD_SCRIPT="./gcd.sh"
error_count=0

# 正常系テスト用関数（出力を検証）
assert_success() {
    local n1=$1
    local n2=$2
    local expected=$3
    
    output=$($GCD_SCRIPT "$n1" "$n2" 2>/dev/null)
    exit_code=$?
    
    if [ "$exit_code" -ne 0 ] || [ "$output" != "$expected" ]; then
        echo "【失敗】正常系: 引数($n1, $n2) -> 期待値: $expected, 実際: $output (終了コード: $exit_code)" >&2
        error_count=$((error_count + 1))
    else
        echo "【成功】正常系: 引数($n1, $n2) -> $output で一致"
    fi
}

# 異常系テスト用関数（エラー終了するか検証）
assert_error() {
    local title=$1
    shift # タイトルを引数から除外、残りをスクリプトに渡す
    
    output=$($GCD_SCRIPT "$@" 2>&1)
    exit_code=$?
    
    if [ "$exit_code" -eq 0 ]; then
        echo "【失敗】異常系 [ $title ]: エラー終了(非0)を期待しましたが、正常終了(0)しました。" >&2
        error_count=$((error_count + 1))
    else
        echo "【成功】異常系 [ $title ]: 正しくエラーを検知 (終了コード: $exit_code)"
    fi
}

echo "=== 最大公約数スクリプト テスト開始 ==="

# 評価項目：最大公約数の動作確認（正常系）
assert_success "2" "4" "2"
assert_success "12" "18" "6"
assert_success "101" "101" "101"
assert_success "1000" "5" "5"

# 評価項目：正しい入出力チェックの動作確認（異常系）
assert_error "引数が1つのみ" "3"
assert_error "引数がない"
assert_error "引数が3つ以上" "2" "4" "6"
assert_error "文字が含まれる" "2" "abc"
assert_error "負の数" "-5" "10"
assert_error "ゼロが含まれる" "0" "5"
assert_error "小数が含まれる" "2.5" "5"

echo "=== テスト終了 ==="

# 総合判定（GitHub Actionsの成否に直結）
if [ "$error_count" -gt 0 ]; then
    echo "【総合結果】$error_count 件のテストが失敗しました。" >&2
    exit 1
else
    echo "【総合結果】すべてのテストケースに合格しました！"
    exit 0
fi
