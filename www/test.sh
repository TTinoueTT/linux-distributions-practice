#!/bin/bash

# 元の配列
validate_ip_count=253
ip_array=("12.13.14.0/24" "22.23.24.0/22" "32.33.34.0/23" "42.43.44.0/24")

# 新しい配列の初期化
ip_addresses=()
subnet_masks=()

# 関数の定義
create_ips_from_range () {
    echo "$1 , $2"
    # IPアドレスの最後のオクテットをインクリメント
    for i in {1..$2}
    do
      base_ip="${ip%.*}"
      new_ip="${base_ip}.${i}"
      echo "new_ip: ${new_ip}"
    done
}

# 配列を分割して新しい配列に値を格納
for ip in "${ip_array[@]}"
do
  # '/'で文字列を分割
  ip_base="${ip%/*}"
  subnet="${ip##*/}"

  # 新しい配列に値を追加
  ip_addresses+=("$ip_base")
  subnet_masks+=("$subnet")
done

# 結果を表示
# echo "ip_addresses: ${ip_addresses[@]}"
# echo "subnet_masks: ${subnet_masks[@]}"

# 第4オクテットをインクリメントして新しい配列を作成
new_array=()
counter=1
for ip in "${ip_addresses[@]}"
do
  # 関数の呼び出し
  create_ips_from_range ip $validate_ip_count
  # base_ip="${ip%.*}"
  # new_ip="${base_ip}.${counter}"
  # new_array+=("$new_ip")
  # ((counter++))
done
