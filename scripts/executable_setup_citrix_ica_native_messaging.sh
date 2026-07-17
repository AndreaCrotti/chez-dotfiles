#!/usr/bin/env bash
set -euo pipefail

# Native messaging host for the Citrix ICA Launcher extension
# (~/.local/share/citrix-ica-launcher). background.js watches Network
# responses for Content-Type: application/x-ica, forces them into
# chrome.downloads (they'd otherwise never fire chrome.downloads.onCreated
# since they're fetched via page JS), then this host receives the resulting
# file path and execs wfica to launch the session.
#
# Unrelated to com.citrix.workspace.native (fix_citrix_chrome_beta_native_messaging.sh),
# which is Citrix's own manifest used only for "is Workspace installed" detection.

manifest_json="$HOME/.local/share/citrix-ica-launcher/manifest.json"

extension_id=$(python3 - "$manifest_json" <<'PYEOF'
import base64
import hashlib
import json
import sys

manifest = json.load(open(sys.argv[1]))
der = base64.b64decode(manifest["key"])
digest = hashlib.sha256(der).hexdigest()[:32]
print("".join(chr(int(c, 16) + ord("a")) for c in digest))
PYEOF
)

for profile in google-chrome google-chrome-beta; do
  manifest_dir="$HOME/.config/$profile/NativeMessagingHosts"
  manifest_path="$manifest_dir/com.andreacrotti.ica_launcher.json"

  mkdir -p "$manifest_dir"
  cat > "$manifest_path" <<EOF
{
  "name": "com.andreacrotti.ica_launcher",
  "description": "Launches Citrix wfica for ICA files captured from network responses",
  "path": "$HOME/.local/bin/citrix_ica_native_host",
  "type": "stdio",
  "allowed_origins": [ "chrome-extension://${extension_id}/" ]
}
EOF
  echo "Wrote $manifest_path (extension id: $extension_id)"
done
