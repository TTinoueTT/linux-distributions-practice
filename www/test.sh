#!/bin/bash

main_ip=12.13.14.2
# 元の配列
ip_array=("12.13.14.0/24")
# ip_array=("12.13.14.0/24" "22.23.24.0/22" "32.33.34.0/23" "42.43.44.0/24")


# $1 String - IPv4 アドレスのCIDR形式の文字列が渡される ex. 12.13.14.0/24
create_ips_from_range () {
    # '/'で文字列を分割
    cidr_ip=$1
    ip_base="${cidr_ip%/*}"
    subnet="${cidr_ip##*/}"
    echo "$ip_base , $subnet"

    # ホスト部の最大数を計算
    host_bits=$(( 32 - subnet ))
    host_count=$(( (2**host_bits) - 3 ))  # ネットワークアドレス, ゲートウェイアドレス, ブロードキャストアドレスを除外

    # ネットワークアドレス, ゲートウェイアドレス, ブロードキャストアドレスを計算
    IFS='.' read -r -a octets <<< "$ip_base"
    network_address="$ip_base"
    gateway_address="${octets[0]}.${octets[1]}.${octets[2]}.$((octets[3] + 1))"

    # ブロードキャストアドレスの計算
    broadcast_octet3=$((octets[2] + (host_count / 256)))
    broadcast_octet4=$((octets[3] + (host_count % 256) + 2))

    if [ $broadcast_octet4 -gt 255 ]; then
        broadcast_octet3=$((broadcast_octet3 + 1))
        broadcast_octet4=$((broadcast_octet4 - 256))
    fi
    broadcast_address="${octets[0]}.${octets[1]}.${broadcast_octet3}.${broadcast_octet4}"

    echo "Network Address: $network_address"
    echo "Gateway Address: $gateway_address"
    echo "Broadcast Address: $broadcast_address"
    echo "Host Count: $host_count"

    # IPアドレスの最後のオクテットをインクリメントして出力
    for i in $(seq 2 "$(( host_count + 1 ))")
    do
        ip_octet3=$((octets[2] + ((octets[3] + i) / 256)))
        ip_octet4=$(((octets[3] + i) % 256))
        new_ip="${octets[0]}.${octets[1]}.${ip_octet3}.${ip_octet4}"

        # main_ip と一致する場合はスキップ
        if [ "$new_ip" == "$main_ip" ]; then
            echo "Skipping main_ip: $new_ip"
            continue
        fi

        echo "new_ip: ${new_ip}"
    done
}

# create_ips_from_range "22.23.24.0/22"

for ip in "${ip_array[@]}"
do
    echo "================================"
    create_ips_from_range $ip
    # echo "$ip"
done

exit