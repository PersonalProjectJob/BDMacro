"""Build the two v80 load slots from the school sources and update their hashes."""

import argparse
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "manifest.json"
BOM = b"\xef\xbb\xbf"
XM05 = "Native/XM05_VanHoa.lua"
XM06 = "Native/XM06_NguDoc.lua"
VAN_HOA = "Schools/VanHoa/HoaGian.lua"
NGU_DOC = "Schools/NguDoc/DocKinh_BoThien.lua"
THAT_TU = "Schools/ThatTu/BangTam.lua"
PRIORITY = "Schools/Priority.lua"


def read_lua(path):
    data = (ROOT / path).read_bytes()
    if not data.startswith(BOM):
        raise ValueError(f"{path}: missing UTF-8 BOM")
    return data.decode("utf-8-sig").replace("\r\n", "\n")


def replace_body(path, module, body):
    text = read_lua(path)
    start = f"-- BEGIN {module}\ndo\nlocal function InitializeModule()\n"
    finish = f'\nend\nlocal ok, result = pcall(InitializeModule)\nruntimeStatus.modules["{module}"]'
    before, _, section = text.partition(start)
    _, marker, after = section.rpartition(finish)
    if not marker:
        raise ValueError(f"{path}: generated wrapper is missing or has changed")
    return (before + start + body + finish + after).encode("utf-8-sig")


def build(manifest):
    sources = {XM05: [], XM06: []}
    for profile, metadata in manifest["profiles"].items():
        slot = metadata["path"]
        source = metadata["sourcePath"]
        expected = NGU_DOC if profile.startswith("NguDoc/") else f"Schools/{profile}.lua"
        if source != expected or slot not in sources:
            raise ValueError(f"{profile}: invalid rotation source or slot")
        if source not in sources[slot]:
            sources[slot].append(source)

    if sources[XM05] != [VAN_HOA] or sources[XM06][:2] != [NGU_DOC, THAT_TU]:
        raise ValueError("Unexpected order for the original v80 profile modules")

    blocks = [read_lua(NGU_DOC).rstrip("\n"),
              "-- =====================================================================\n"
              "-- That Tu: Bang Tam Quyet (v80 PVE - Cap Khuc Tu Kich No - No Giang Hai)\n"
              "-- =====================================================================",
              read_lua(THAT_TU).rstrip("\n")]
    for source in [PRIORITY, *sources[XM06][2:]]:
        code = read_lua(source).rstrip("\n")
        blocks.append(f"-- {source}\ndo\n{code}\nend")

    return {
        XM05: replace_body(XM05, VAN_HOA, read_lua(VAN_HOA).rstrip("\n")),
        XM06: replace_body(XM06, "Schools/NguDoc/DocKinh.lua", "\n\n".join(blocks)),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Compare outputs without writing files")
    args = parser.parse_args()
    manifest = json.loads(MANIFEST.read_bytes())
    expected = build(manifest)
    changes = []
    for name, data in expected.items():
        digest = hashlib.sha256(data).hexdigest()
        file = ROOT / name
        if file.read_bytes() != data or manifest["files"][name]["sha256"] != digest:
            changes.append(name)
            if not args.check:
                file.write_bytes(data)
                manifest["files"][name]["sha256"] = digest
    if args.check and changes:
        parser.exit(1, "Rebuild Native and manifest for: " + ", ".join(changes) + "\n")
    if changes:
        MANIFEST.write_bytes((json.dumps(manifest, ensure_ascii=False, indent=2) + "\n").encode("utf-8"))
    print("Native and manifest match the school sources.")


if __name__ == "__main__":
    main()
