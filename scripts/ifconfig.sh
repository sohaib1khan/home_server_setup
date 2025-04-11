#!/bin/bash

# Function to format bytes in human-readable format
format_bytes() {
    local bytes=$1
    local sizes=("B" "KB" "MB" "GB" "TB")
    local i=0
    
    while ((bytes > 1024 && i < 4)); do
        bytes=$(echo "scale=2; $bytes/1024" | bc)
        ((i++))
    done
    
    printf "%.2f %s" $bytes "${sizes[$i]}"
}

# Function to print information for a specific interface
print_interface_info() {
    local ifname=$1
    
    # Check if interface exists
    if ! ip link show "$ifname" &>/dev/null; then
        echo "Interface $ifname does not exist"
        return 1
    fi
    
    # Get interface flags
    local flags=$(ip link show "$ifname" | grep -o "state [A-Z]* " | cut -d' ' -f2)
    local mtu=$(ip link show "$ifname" | grep -o "mtu [0-9]*" | cut -d' ' -f2)
    
    # Build flags string
    local flags_str=""
    if ip link show "$ifname" | grep -q "UP"; then
        flags_str="${flags_str}UP,"
    fi
    if ip link show "$ifname" | grep -q "BROADCAST"; then
        flags_str="${flags_str}BROADCAST,"
    fi
    if ip link show "$ifname" | grep -q "LOOPBACK"; then
        flags_str="${flags_str}LOOPBACK,"
    fi
    flags_str=${flags_str%,}  # Remove trailing comma
    
    # Print interface name and flags
    echo -n "$ifname: flags=<$flags_str>"
    if [[ -n "$mtu" ]]; then
        echo " mtu $mtu"
    else
        echo ""
    fi
    
    # Get and print IP address info
    local inet=$(ip -4 addr show "$ifname" 2>/dev/null | grep -w inet | awk '{print $2}' | cut -d/ -f1)
    local mask=$(ip -4 addr show "$ifname" 2>/dev/null | grep -w inet | awk '{print $2}' | cut -d/ -f2)
    local broadcast=$(ip -4 addr show "$ifname" 2>/dev/null | grep -w inet | grep -o "brd [0-9.]*" | cut -d' ' -f2)
    
    # Convert CIDR mask to dotted decimal if needed
    if [[ -n "$mask" ]]; then
        local full_mask=""
        local mask_num=$mask
        for i in {1..4}; do
            if (( mask_num >= 8 )); then
                full_mask="${full_mask}255."
                (( mask_num -= 8 ))
            elif (( mask_num > 0 )); then
                local val=$((256 - 2**(8-mask_num)))
                full_mask="${full_mask}${val}."
                mask_num=0
            else
                full_mask="${full_mask}0."
            fi
        done
        netmask=${full_mask%?}  # Remove trailing dot
    fi
    
    # Print IP address info
    if [[ -n "$inet" ]]; then
        echo -n "        inet $inet"
        if [[ -n "$netmask" ]]; then
            echo -n "  netmask $netmask"
        fi
        if [[ -n "$broadcast" ]]; then
            echo -n "  broadcast $broadcast"
        fi
        echo ""
    fi
    
    # Get and print MAC address
    local ether=$(ip link show "$ifname" | grep -o "link/ether [0-9a-f:]*" | cut -d' ' -f2)
    if [[ -n "$ether" ]]; then
        echo "        ether $ether"
    fi
    
    # Get and print RX/TX statistics
    if [[ -f "/sys/class/net/$ifname/statistics/rx_bytes" ]]; then
        local rx_bytes=$(cat "/sys/class/net/$ifname/statistics/rx_bytes")
        local rx_packets=$(cat "/sys/class/net/$ifname/statistics/rx_packets")
        local rx_bytes_human=$(format_bytes $rx_bytes)
        echo "        RX packets $rx_packets  bytes $rx_bytes_human"
    fi
    
    if [[ -f "/sys/class/net/$ifname/statistics/tx_bytes" ]]; then
        local tx_bytes=$(cat "/sys/class/net/$ifname/statistics/tx_bytes")
        local tx_packets=$(cat "/sys/class/net/$ifname/statistics/tx_packets")
        local tx_bytes_human=$(format_bytes $tx_bytes)
        echo "        TX packets $tx_packets  bytes $tx_bytes_human"
    fi
}

# Main function
main() {
    if [[ $# -eq 0 ]]; then
        # No arguments, print all interfaces
        local interfaces=$(ls /sys/class/net/)
        local first=true
        
        for ifname in $interfaces; do
            if [[ "$first" != true ]]; then
                echo ""
            fi
            print_interface_info "$ifname"
            first=false
        done
    else
        # Print only the specified interface
        print_interface_info "$1"
    fi
}

# Run the main function
main "$@"
