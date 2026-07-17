#!/usr/bin/env bash

# reconnect the MX Master mouse if bluetooth drops/unpairs it

MAC="D7:FB:79:6D:88:AF"

bluetoothctl connect "$MAC" || bluetoothctl <<EOF
trust $MAC
pair $MAC
connect $MAC
EOF
