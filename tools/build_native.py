"""Generate Native slots, Runtime.lua, and info.ini from the BDMacro sources."""

import argparse
import hashlib
import json
from pathlib import Path
import re
import tempfile


ROOT = Path(__file__).resolve().parents[1]
BOM = b"\xef\xbb\xbf"
LAYOUT = "ordered-v2"
CORE = (
    ("Config", ("Config.lua",)),
    ("Registry", ("Schools/Registry.lua", "Schools/CombatHelpers.lua", "Schools/Priority.lua")),
    ("Functions", ("Core/functions.lua",)),
    ("Core", ("Core/Macro.lua",)),
)
FINAL = (("Dispatch", ("Macro.lua",)), ("KeySpam", ("Features/KeySpam.lua",)))
REPORT = r'''local function ReportStartup(message)
    if OutputMessage then pcall(OutputMessage, "MSG_SYS", "[xMacro 0.9.7] " .. message .. "\n") end
end
'''


def read_lua(path):
    data = (ROOT / path).read_bytes()
    if not data.startswith(BOM):
        raise ValueError(f"{path}: missing UTF-8 BOM")
    return data.decode("utf-8-sig").replace("\r\n", "\n").rstrip("\n")


def profile_sources(profiles):
    schools, aliases, kungfu = {}, {}, {}
    for profile, entry in profiles.items():
        if not re.fullmatch(r"[A-Za-z][A-Za-z0-9]*/[A-Za-z][A-Za-z0-9]*", profile):
            raise ValueError(f"Invalid profile name: {profile}")
        school, name = profile.split("/")
        source = entry["sourcePath"]
        if not re.fullmatch(rf"Schools/{school}/[A-Za-z][A-Za-z0-9_]*\.lua", source):
            raise ValueError(f"{profile}: source file must be in Schools/{school}/")
        sources = schools.setdefault(school, [])
        if source not in sources:
            sources.append(source)
        if not entry["aliases"] or not entry["kungfuIds"]:
            raise ValueError(f"{profile}: missing alias or kungfu ID")
        for alias in entry["aliases"]:
            if not re.fullmatch(r"[A-Z0-9]+", alias) or alias in aliases:
                raise ValueError(f"{profile}: invalid or duplicate alias {alias}")
            aliases[alias] = (school, name)
        for skill_id in entry["kungfuIds"]:
            if type(skill_id) is not int or skill_id <= 0 or skill_id in kungfu:
                raise ValueError(f"{profile}: invalid or duplicate kungfu ID {skill_id}")
            kungfu[skill_id] = entry["aliases"][0]
    if list(schools)[:2] != ["VanHoa", "NguDoc"] or not schools:
        raise ValueError("VanHoa and NguDoc must retain slots XM05 and XM06")
    return schools, aliases, kungfu


def guard(slot):
    return f'''local runtimeStatus = type(xMacro) == "table" and xMacro.Runtime
if type(runtimeStatus) ~= "table" or runtimeStatus.nativeLayout ~= "{LAYOUT}" then
    macro = function() return false end
    if type(xMacro) == "table" then xMacro.Run = macro end
    error("xMacro native bootstrap missing; combo disabled")
end
if runtimeStatus.nextNative ~= {slot} then
    runtimeStatus.ready = false
    macro = function() return false end
    xMacro.Run = macro
    error("xMacro native load order invalid; combo disabled")
end
runtimeStatus.nextNative = {slot + 1}
'''


def wrapped_source(path, substitutions):
    body = read_lua(path)
    if path in substitutions:
        marker, value = substitutions[path]
        if body.count(marker) != 1:
            raise ValueError(f"{path}: expected one {marker} marker")
        body = body.replace(marker, value)
    return f'''-- BEGIN {path}
do
local function InitializeModule()
{body}
end
local ok, result = pcall(InitializeModule)
runtimeStatus.modules["{path}"] = ok
if not ok then
    runtimeStatus.errors["{path}"] = tostring(result)
    ReportStartup("LOAD_ERROR {path}: " .. tostring(result))
end
end
-- END {path}
'''


def bootstrap(slots):
    modules = ",\n".join(f'    ["{path}"] = false' for _, sources in slots for path in sources)
    return f'''xMacro = xMacro or {{}}
xMacro.Runtime = {{version = "0.9.7", ready = false, nativeLayout = "{LAYOUT}", nextNative = 1, errors = {{}}, modules = {{
{modules}
}}}}
local function UnavailableMacro() return false end
macro = UnavailableMacro
xMacro.Run = UnavailableMacro
{REPORT}ReportStartup("Loading native modules")
'''


def finalize():
    return '''for _, loaded in pairs(runtimeStatus.modules) do
    if not loaded then
        runtimeStatus.ready = false
        macro = function() return false end
        xMacro.Run = macro
        ReportStartup("NOT_READY; combo disabled; see LOAD_ERROR above")
        return
    end
end
runtimeStatus.ready = true
ReportStartup("MODULES_READY; use /script xMacro.Run()")
if xMacro.HoldKey and xMacro.HoldKey.uiError then
    ReportStartup("UI_ERROR: " .. xMacro.HoldKey.uiError)
end
'''


def build(manifest):
    schools, aliases, kungfu = profile_sources(manifest["profiles"])
    slots = [*CORE, *schools.items(), *FINAL]
    substitutions = {
        "Core/Macro.lua": ("-- @school-aliases", "\n".join(
            f'    ["{alias}"] = {{school = "{school}", profile = "{name}"}},'
            for alias, (school, name) in aliases.items()
        )),
        "Macro.lua": ("-- @kungfu-codes", "\n".join(
            f'    [{skill_id}] = "{alias}",' for skill_id, alias in sorted(kungfu.items())
        )),
    }

    native = {"Native/XM00_Bootstrap.lua": bootstrap(slots)}
    school_paths = {}
    for i, (label, sources) in enumerate(slots, 1):
        path = f"Native/XM{i:02d}_{label}.lua"
        native[path] = guard(i) + REPORT + "\n".join(wrapped_source(s, substitutions) for s in sources)
        if label in schools:
            school_paths[label] = path
    native[next(reversed(native))] += "\n" + finalize()

    result = {path: ("-- GENERATED by tools/build_native.py.\n" + source).encode("utf-8-sig")
              for path, source in native.items()}
    result["Runtime.lua"] = ("-- GENERATED by tools/build_native.py.\n" + "\n".join(
        "do\n" + source + "end\n" for source in native.values()
    )).encode("utf-8-sig")
    header = (
        "[xMacro]\nname=xMacro 0.9.7 Auto Dispel\ndesc=xMacro for PVE\nversion=0.8\n"
        "release=0.9.7\nbuild=20261107-school-slots\ndefault=1\npackage=AIO\n"
    )
    ini = header + "".join(f"lua_{i}=Interface\\xMacro\\{path.replace('/', chr(92))}\n"
                           for i, path in enumerate(native))
    result["info.ini"] = ini.replace("\n", "\r\n").encode("ascii")

    manifest["schemaVersion"] = 2
    manifest["nativeLayout"] = LAYOUT
    manifest["loadOrder"] = list(native)
    manifest["files"] = {path: {"sha256": hashlib.sha256(result[path]).hexdigest()} for path in native}
    for profile, entry in manifest["profiles"].items():
        entry["path"] = school_paths[profile.split("/")[0]]
    result["manifest.json"] = (json.dumps(manifest, ensure_ascii=False, indent=2) + "\n").encode("utf-8")
    return result


def write_outputs(outputs, root, check):
    changed = []
    for name, data in outputs.items():
        path = root / name
        if path.is_file() and path.read_bytes() == data:
            continue
        changed.append(name)
        if not check:
            path.parent.mkdir(parents=True, exist_ok=True)
            with tempfile.NamedTemporaryFile(dir=path.parent, delete=False) as temp:
                temp.write(data)
            temp_path = Path(temp.name)
            try:
                temp_path.replace(path)
            finally:
                temp_path.unlink(missing_ok=True)
    return changed


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Verify generated files without writing")
    parser.add_argument("--addon", type=Path, help="Also sync generated files to an installed xMacro folder")
    args = parser.parse_args()
    if args.addon and not (args.addon / "info.ini").is_file():
        parser.error("--addon must be an installed xMacro folder with info.ini")
    outputs = build(json.loads((ROOT / "manifest.json").read_bytes()))
    changes = write_outputs(outputs, ROOT, args.check)
    if args.addon:
        # The game consumes Native and info.ini. Runtime.lua is the combined developer build.
        installed = {name: data for name, data in outputs.items() if name != "manifest.json"}
        changes.extend(f"{args.addon}/{name}" for name in write_outputs(installed, args.addon, args.check))
    if args.check and changes:
        parser.exit(1, "Generated files differ: " + ", ".join(changes) + "\n")
    print("Native, Runtime, info.ini, and manifest match the school sources.")


if __name__ == "__main__":
    main()

