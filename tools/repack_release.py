# -*- coding: utf-8 -*-
import os
import zipfile
from pathlib import Path

ROOT = Path("g:/JXOnline3VN-v2.5.2+launcher/JXOnline3VN-v2.5.2+launcher")
SRC_ADDON = ROOT / "interface" / "xMacro"
OUT_ZIP = ROOT / "BDMacro-export" / "releases" / "xMacro-v80-HCNC-0.9.7-addon.zip"

print(f"Repacking {OUT_ZIP}...")
OUT_ZIP.parent.mkdir(parents=True, exist_ok=True)

with zipfile.ZipFile(OUT_ZIP, "w", compression=zipfile.ZIP_DEFLATED) as z:
    for base_root in [SRC_ADDON]:
        for root, dirs, files in os.walk(base_root):
            # Skip python cache or git
            if "__pycache__" in root or ".git" in root:
                continue
            for f in files:
                if f.endswith(".pyc"):
                    continue
                file_path = Path(root) / f
                rel_path = file_path.relative_to(ROOT)
                # Layout 1: interface/xMacro/...
                z.write(file_path, arcname=str(rel_path).replace("\\", "/"))
                # Layout 2: xMacro-v80-HCNC-0.9.7-addon/interface/xMacro/...
                z.write(file_path, arcname=f"xMacro-v80-HCNC-0.9.7-addon/{str(rel_path).replace('\\', '/')}")

print(f"Zip created successfully: {OUT_ZIP.stat().st_size} bytes.")
