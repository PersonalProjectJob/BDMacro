"""Verify the installed v80 addon and the BDMacro rotation sources."""

import argparse
import codecs
import json
from pathlib import Path
import re
import subprocess
import sys


ADDON = Path(__file__).resolve().parents[1]
EXPORT = ADDON.parents[1] / "BDMacro-export"
if not EXPORT.is_dir():
    EXPORT = ADDON.parents[1] / "scratch" / "BDMacro"
if not EXPORT.is_dir():
    EXPORT = ADDON


def verify(fix, addon):
    from lupa.lua51 import LuaRuntime

    for root in (addon, EXPORT / "Schools", EXPORT / "Core", EXPORT / "Features"):
        if not root.exists():
            continue
        for path in (*root.rglob("*.lua"), *root.rglob("*.txt")):
            if "Schools\\NguDoc\\interface" in str(path) or "Schools/NguDoc/interface" in str(path):
                continue
            data = path.read_bytes()
            data.decode("utf-8-sig")
            if not data.startswith(codecs.BOM_UTF8):
                if not fix:
                    raise ValueError(f"{path}: missing UTF-8 BOM")
                path.write_bytes(codecs.BOM_UTF8 + data)

    manifest = json.loads((EXPORT / "manifest.json").read_bytes())
    ini = (addon / "info.ini").read_text(encoding="utf-8-sig")
    slots = re.findall(r"(?im)^lua_(\d+)=Interface\\xMacro\\Native\\(XM\d{2}_\w+\.lua)$", ini)
    expected = [(str(i), Path(name).name) for i, name in enumerate(manifest["loadOrder"])]
    if slots != expected:
        raise ValueError("info.ini: Native slots do not match the manifest")

    mock = '''
        OutputMessage = function() end
        RegisterEvent = function() end
        playerReads = 0
        GetClientPlayer = function() playerReads = playerReads + 1 end
    '''
    def load_modules(paths):
        lua = LuaRuntime(register_eval=False, register_builtins=False)
        lua.execute(mock)
        for path in paths:
            lua.execute(path.read_text(encoding="utf-8-sig"), name=path.name)
        ready = lua.eval("function(n) return xMacro.Runtime.ready and xMacro.Runtime.nextNative == n end")
        if not ready(len(slots)):
            raise ValueError(f"Native load failed: {dict(lua.eval('xMacro.Runtime.errors').items())}")
        if lua.eval("playerReads"):
            raise ValueError("A module queried the player during startup")
        return lua

    load_modules([addon / "Runtime.lua"])
    lua = load_modules([addon / "Native" / name for _, name in slots])
    resolve = lua.eval("xMacro.Schools.Resolve")
    aliases = lua.eval("xMacro.Core.SchoolAliases")
    select = lua.eval("""function(id)
        local selection = xMacro.ActiveSelection({GetKungfuMount = function() return {dwSkillID=id} end})
        return selection
    end""")
    for profile, metadata in manifest["profiles"].items():
        school, name = profile.split("/", 1)
        implementation = resolve(school, name)
        if isinstance(implementation, tuple):
            implementation, reason = implementation
            if implementation is None:
                raise ValueError(f"{profile}: {reason}")
        if not implementation or not callable(implementation.run):
            raise ValueError(f"Profile missing: {profile}")
        for alias in metadata["aliases"]:
            selection = aliases[alias]
            if selection is None or (selection.school, selection.profile) != (school, name):
                raise ValueError(f"{alias}: expected {profile}")
        for kungfu_id in metadata["kungfuIds"]:
            selection = select(kungfu_id)
            if selection is None or (selection.school, selection.profile) != (school, name):
                raise ValueError(f"{kungfu_id}: expected {profile}")

    subprocess.run([sys.executable, str(EXPORT / "tools/build_native.py"), "--check", "--addon", str(addon)], check=True)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")
    sys.stderr.reconfigure(encoding="utf-8", errors="backslashreplace")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fix", action="store_true", help="Restore a missing UTF-8 BOM")
    parser.add_argument("--addon", type=Path, default=ADDON, help="Check a staged xMacro folder")
    try:
        args = parser.parse_args()
        verify(args.fix, args.addon.resolve())
    except Exception as error:
        parser.exit(1, f"[FAILED] {error}\n")
    print("[PASSED] TẤT CẢ ĐIỀU KIỆN CẦN ĐÃ ĐẠT!")
