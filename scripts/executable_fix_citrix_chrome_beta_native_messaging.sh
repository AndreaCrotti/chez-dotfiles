#!/usr/bin/env bash
set -euo pipefail

# Citrix's icaclient installer (util/hinst) points the native messaging
# manifest straight at NativeMessagingHost, and only wires it up for
# google-chrome and Edge, not google-chrome-beta. Without a manifest at
# all, the "Citrix Workspace" browser extension can't reach the native
# app, so StoreWeb login pages fail to detect an installed Workspace app
# and prompt to install it again. Session launching actually happens via
# the application/x-ica MIME association (wfica-5.desktop), not through
# this native messaging host — it's only used for the "is Workspace
# installed" detection ping.

for profile in google-chrome google-chrome-beta; do
  manifest_dir="$HOME/.config/$profile/NativeMessagingHosts"
  manifest_path="$manifest_dir/com.citrix.workspace.native.json"

  mkdir -p "$manifest_dir"
  cat > "$manifest_path" <<EOF
{
  "name": "com.citrix.workspace.native",
  "description": "Launch NMH",
  "path": "/opt/Citrix/ICAClient/NativeMessagingHost",
  "type": "stdio",
  "allowed_origins": [ "chrome-extension://dbdlmgpfijccjgnnpacnamgdfmljoeee/", "chrome-extension://pmdpflpcmcomdkocbehamllbfkdgnalf/" ]
}
EOF
  echo "Wrote $manifest_path"
done
