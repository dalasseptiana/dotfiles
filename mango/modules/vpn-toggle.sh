#!/bin/bash

INTERFACE="proton"

# Jika argumen "toggle" diberikan (saat modul diklik)
if [ "$1" == "toggle" ]; then
    if ip link show "$INTERFACE" &>/dev/null; then
        sudo wg-quick down "$INTERFACE"
    else
        sudo wg-quick up "$INTERFACE"
    fi
    # Kirim sinyal RTMIN+8 ke Waybar agar tampilan langsung diperbarui
    pkill -RTMIN+8 waybar
    exit 0
fi

# Cek status koneksi untuk ditampilkan di Waybar
if ip link show "$INTERFACE" &>/dev/null; then
    echo '{"text": "󰦝 ", "class": "connected", "tooltip": "Proton VPN Terhubung"}'
else
    echo '{"text": "󰦞 ", "class": "disconnected", "tooltip": "Proton VPN Terputus"}'
fi
