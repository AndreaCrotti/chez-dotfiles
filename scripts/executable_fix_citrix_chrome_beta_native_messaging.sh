#!/usr/bin/env bash
set -euo pipefail

# Citrix's icaclient installer (util/hinst) only wires up the native
# messaging manifest for `google-chrome` and Edge, not google-chrome-beta.
# Without it, the "Citrix Workspace" browser extension can't reach the
# native app, so StoreWeb login pages fail to detect an installed Workspace
# app and prompt to install it again.

manifest_dir="$HOME/.config/google-chrome-beta/NativeMessagingHosts"
manifest_path="$manifest_dir/com.citrix.workspace.native.json"

mkdir -p "$manifest_dir"
cat > "$manifest_path" <<EOF
{
  "name": "com.citrix.workspace.native",
  "description": "Launch NMH",
  "path": "$HOME/.local/bin/citrix-nmh-wrapper",
  "type": "stdio",
  "allowed_origins": [ "chrome-extension://dbdlmgpfijccjgnnpacnamgdfmljoeee/", "chrome-extension://pmdpflpcmcomdkocbehamllbfkdgnalf/" ]
}
EOF
echo "Wrote $manifest_path"
