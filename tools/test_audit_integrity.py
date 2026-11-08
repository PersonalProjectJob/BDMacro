# -*- coding: utf-8 -*-
"""
test_audit_integrity.py
Deep verification script to audit all macro profiles across the xMacro addon
for presence of any raw numeric skill or buff IDs, verify exact localized
Vietnamese names, verify load-time safety (no top-level GetClientPlayer calls),
verify 100% dictionary resolution of all skill/buff tokens, and verify execution
in Lua 5.1 runtime.
"""

import codecs
import re
import sys
from pathlib import Path
from lupa.lua51 import LuaRuntime

sys.stdout.reconfigure(encoding="utf-8")

ROOT = Path("g:/JXOnline3VN-v2.5.2+launcher/JXOnline3VN-v2.5.2+launcher")
ADDON = ROOT / "interface" / "xMacro"
EXPORT = ROOT / "BDMacro-export"
STAGING_ADDON = ROOT / "xMacro-v80-HCNC-0.9.7-addon" / "interface" / "xMacro"

# Regex patterns to detect raw numeric IDs in /skill commands and conditions
RE_NUMERIC_SKILL = re.compile(r"/(?:skill|cast|fcast)\s*(?:\[[^\]]*\])?\s*(\d+)\s*$", re.MULTILINE)
RE_NUMERIC_CONDITION = re.compile(
    r"\[[^\]]*?(?:buff|nobuff|tbuff|tnobuff|mbuff|nombuff|xmbuff|xmnobuff|xmtbuff|xmtnobuff|cd|nocd|cdtime|bufftime|tbufftime|mbufftime|ota|pet):(\d+)[^\]]*?\]",
    re.IGNORECASE
)

# Unlocalized ASCII skill / buff patterns that should never appear in /skill commands or conditions
UNLOCALIZED_ASCII_PATTERNS = [
    r"Xuan Ne Ho Hoa", r"Bich Thuy Thao Thien", r"Quyet Am Chi", r"Duong Minh Chi",
    r"Phe Cot", r"Loan Tuu Thanh Ha", r"Ngoc Thach Cau Phan", r"Thuy Nguyet Vo Gian",
    r"Lan Thoi Ngoc Chiet", r"Thuong Duong Chi", r"Chung Linh Duc Tu",
    r"Toa Vong Vo Nga", r"Toai Tinh Than", r"Hoa Tam Thanh", r"Bao Nguyen Quy Nhat",
    r"Bat Hoang Quy Nguyen", r"Vo Nga Vo Kiem", r"Tam Hoan Quy Nguyet", r"Kiem Phi Kinh Thien",
    r"Ngung Than Tu Khi", r"Pha Thuong Khung", r"Luong Nghi Hoa Hinh", r"Tu Tuong Luan Hoi",
    r"Thai Cuc Vo Cuc", r"Vo Tuong Quyet", r"Doan Cot Quyet", r"Cam Long Quyet",
    r"Diec Kho Diec Vinh", r"Na Van Thuc", r"Kim Cuong No Muc", r"Vi Da Hien Chu",
    r"Thu Khuyet Thuc", r"Dao Hu Thuc", r"Hoanh Tao Luc Hop", r"Pho Do Tu Phuong",
    r"Van Phat Trieu Tong", r"Lap Dia Thanh Phat", r"Ma Ha Vo Luong", r"Tu Nhu Lam",
    r"Thu Nhu Son", r"Dinh Quan", r"Pha Phong", r"Mai An Huong", r"Khieu Nhat",
    r"Tuyet Doan Kieu", r"Doan Trieu", r"Thinh Loi", r"Cuu Khe Di Yen",
    r"Van Phi Ngoc Hoang", r"Tich Chieu Loi Phong", r"Tap Trung", r"Truy Menh Tien",
    r"Hoa Huyet Tieu", r"Bao Vu Le Hoa Cham", r"Truc Tinh Tien", r"Doat Phach Tien",
    r"Thuc Co Dan", r"Tham Ma The", r"Thanh Minh Huu", r"Tu Bi Nguyen",
    r"Gioi Hoa Tram", r"Hoang Nhat Chieu", r"Tinh The Pha Ma Kich", r"Khu Da Doan Sau",
    r"Liet Nhat Tram", r"Ngan Nguyet Tram", r"Xich Nhat Luan", r"U Nguyet Luan",
    r"Kiem Than Vo Nga", r"Kiem Pha Hu Khong", r"Dai Huyen Cap Khuc", r"Phon Am Cap Tiet",
    r"Long Tri Nhac", r"Man Duong The", r"Hat Tam", r"Bach Tuc", r"Xa Anh",
    r"Thiem Khieu", r"Thien Ti", r"Doat Menh Co", r"Me Tam Co", r"Kho Tan Co",
    r"Nu Oa Va Troi", r"Bang Tam Khien Ti", r"Tuy Vu Cuu Thien", r"Thanh Thu Chuc Thien",
    r"Bich Diep Dan"
]

def check_file_bom(path: Path):
    data = path.read_bytes()
    if not data.startswith(codecs.BOM_UTF8):
        return False, "Missing UTF-8 BOM"
    try:
        data.decode("utf-8-sig")
    except Exception as e:
        return False, f"UTF-8 decode failed: {e}"
    return True, "OK"

def audit_macro_script(name: str, content: str):
    issues = []
    for m in RE_NUMERIC_SKILL.finditer(content):
        issues.append(f"Numeric skill ID found: '{m.group(0)}' (ID: {m.group(1)})")

    for m in RE_NUMERIC_CONDITION.finditer(content):
        issues.append(f"Numeric buff/skill condition check found: '{m.group(0)}' (ID: {m.group(1)})")

    for line in content.splitlines():
        line_clean = line.strip()
        if line_clean.startswith("--"):
            continue
        if line_clean.startswith(("/skill", "/cast", "/fcast")):
            for pat in UNLOCALIZED_ASCII_PATTERNS:
                if re.search(r"\b" + pat + r"\b", line_clean, re.IGNORECASE):
                    issues.append(f"Unlocalized ASCII skill/buff name found: '{line_clean}' (matches '{pat}')")

    return issues

def extract_school_macro_scripts(schools_dir: Path):
    scripts = {}
    for p in sorted(schools_dir.rglob("*.lua")):
        text = p.read_text(encoding="utf-8-sig")
        # Direct RegisterDamageScript mount maps
        for m in re.finditer(r'\[(\d{5})\]\s*=\s*\[\[(.*?)\]\]', text, re.DOTALL):
            kf_id = int(m.group(1))
            scripts[kf_id] = (p.name, m.group(2).strip())
        # Custom defaultScripts
        m_vh = re.search(r'DEFAULT_VANHOA_MACRO = \[\[(.*?)\]\]', text, re.DOTALL)
        if m_vh:
            scripts[10021] = (p.name, m_vh.group(1).strip())
        m_dk = re.search(r'DEFAULT_NGUDOC_DOCKINH_MACRO = \[\[(.*?)\]\]', text, re.DOTALL)
        if m_dk:
            scripts[10175] = (p.name, m_dk.group(1).strip())
        m_bt = re.search(r'DEFAULT_NGUDOC_BOTHIEN_MACRO = \[\[(.*?)\]\]', text, re.DOTALL)
        if m_bt:
            scripts[10176] = (p.name, m_bt.group(1).strip())
        m_tt = re.search(r'DEFAULT_THATTU_BANGTAM_MACRO = \[\[(.*?)\]\]', text, re.DOTALL)
        if m_tt:
            scripts[10081] = (p.name, m_tt.group(1).strip())
        m_light = re.search(r'local light = \[\[(.*?)\]\]', text, re.DOTALL)
        if m_light:
            scripts[10144] = (p.name, m_light.group(1).strip())
        m_heavy = re.search(r'local heavy = \[\[(.*?)\]\]', text, re.DOTALL)
        if m_heavy:
            scripts[10145] = (p.name, m_heavy.group(1).strip())
    return scripts

def extract_static_dictionaries(core_path: Path):
    core_text = core_path.read_text(encoding="utf-8-sig")
    m_static = re.search(r'local tStatic = \{(.*?)\n\t\}', core_text, re.DOTALL)
    static_skills = {}
    if m_static:
        for m in re.finditer(r'\["([^"]+)"\]\s*=\s*(\d+)', m_static.group(1)):
            static_skills[m.group(1)] = int(m.group(2))

    m_buff = re.search(r'local tStaticBuffNames = \{(.*?)\n\}', core_text, re.DOTALL)
    static_buffs = {}
    if m_buff:
        for m in re.finditer(r'\["([^"]+)"\]\s*=\s*(\d+)', m_buff.group(1)):
            static_buffs[m.group(1)] = int(m.group(2))

    m_pet = re.search(r'local tStaticPetSkill = \{(.*?)\n\}', core_text, re.DOTALL)
    static_pets = {}
    if m_pet:
        for m in re.finditer(r'\["([^"]+)"\]\s*=\s*\{(\d+)', m_pet.group(1)):
            static_pets[m.group(1)] = int(m.group(2))

    m_canon = re.search(r'local tCanonicalSkillNames = \{(.*?)\n\}', core_text, re.DOTALL)
    canon_skills = {}
    if m_canon:
        for m in re.finditer(r'\["([^"]+)"\]\s*=\s*"([^"]+)"', m_canon.group(1)):
            canon_skills[m.group(1)] = m.group(2)

    return static_skills, static_buffs, static_pets, canon_skills

def main():
    print("=== STARTING DEEP AUDIT OF ALL MACRO PROFILES ===")
    total_files = 0
    total_issues = 0

    roots = [
        ("ADDON Schools", ADDON / "Schools"),
        ("EXPORT Schools", EXPORT / "Schools"),
        ("STAGING Schools", STAGING_ADDON / "Schools"),
    ]

    for label, root in roots:
        print(f"\n--- Checking {label} ({root}) ---")
        for p in sorted(root.rglob("*.lua")):
            total_files += 1
            bom_ok, bom_msg = check_file_bom(p)
            if not bom_ok:
                print(f"[FAIL BOM] {p.relative_to(ROOT)}: {bom_msg}")
                total_issues += 1

            text = p.read_text(encoding="utf-8-sig")
            issues = audit_macro_script(p.name, text)
            if issues:
                print(f"[FAIL AUDIT] {p.relative_to(ROOT)}:")
                for iss in issues:
                    print(f"    - {iss}")
                    total_issues += 1
            else:
                print(f"[PASS] {p.relative_to(ROOT)}")

    print("\n--- Checking cloud_rotations.lua & api ---")
    for api_file in [EXPORT / "api/cloud_rotations.lua", ADDON / "api/cloud_rotations.lua"]:
        if api_file.is_file():
            total_files += 1
            text = api_file.read_text(encoding="utf-8-sig")
            issues = audit_macro_script(api_file.name, text)
            if issues:
                print(f"[FAIL AUDIT] {api_file.relative_to(ROOT)}:")
                for iss in issues:
                    print(f"    - {iss}")
                    total_issues += 1
            else:
                print(f"[PASS] {api_file.relative_to(ROOT)}")

    print("\n--- Checking Load-Time Safety (No Top-Level Client Calls) ---")
    lua_safety = LuaRuntime(register_eval=False, register_builtins=False)
    poison_mock = '''
        OutputMessage = function(...) end
        RegisterEvent = function(...) end
        GetLogicFrameCount = function() return 1000 end
        Table_GetSkillName = function(id, lvl) return "TestSkill" end
        Table_GetBuffName = function(id, lvl) return "TestBuff" end
        OnAddOnUseSkill = function(...) return true end
        GetNpc = function(...) return {} end
        GetClientPlayer = function() error("ILLEGAL_TOP_LEVEL_CALL: GetClientPlayer") end
        GetKungfuMount = function() error("ILLEGAL_TOP_LEVEL_CALL: GetKungfuMount") end
    '''
    lua_safety.execute(poison_mock)
    try:
        lua_safety.execute((ADDON / "Runtime.lua").read_text(encoding="utf-8-sig"))
        print("[PASS] Runtime.lua has zero illegal top-level calls to GetClientPlayer or GetKungfuMount")
    except Exception as e:
        print(f"[FAIL] Top-level call detected during load: {e}")
        total_issues += 1

    print("\n--- Checking Static Dictionary Token Resolution ---")
    core_file = ADDON / "Native" / "XM04_Core.lua"
    if not core_file.is_file():
        core_file = EXPORT / "Native" / "XM04_Core.lua"
    static_skills, static_buffs, static_pets, canon_skills = extract_static_dictionaries(core_file)

    def resolve_skill(name):
        if name in static_skills or name.lower() in static_skills:
            return True
        if name in static_pets or name.lower() in static_pets:
            return True
        if name in canon_skills or name.lower() in canon_skills:
            tgt = canon_skills.get(name) or canon_skills.get(name.lower())
            if tgt in static_skills or tgt.lower() in static_skills:
                return True
        return False

    def resolve_buff(name):
        return name in static_buffs or name.lower() in static_buffs

    school_scripts = extract_school_macro_scripts(ADDON / "Schools")
    re_cmd = re.compile(r"/(?:skill|cast|fcast)\s*(?:\[(.*?)\])?\s*(.*?)$", re.MULTILINE)
    token_issues = 0

    for kf, (fn, sc) in school_scripts.items():
        for line in sc.splitlines():
            line = line.strip()
            if not line or line.startswith("--") or line.startswith("#"):
                continue
            m = re_cmd.match(line)
            if m:
                conds_str, skill_target = m.group(1), m.group(2)
                if skill_target and skill_target not in ("stopota", "dừng", "Nhảy lùi", "Rút lui", "Ngồi thiền", "Điều tức"):
                    for sk in skill_target.split(","):
                        sk = sk.strip()
                        if not resolve_skill(sk):
                            print(f"[FAIL TOKEN] Script {kf} ({fn}): Unresolved skill '{sk}' in '{line}'")
                            token_issues += 1
                if conds_str:
                    for cond in conds_str.replace(";", ",").replace("&", ",").split(","):
                        cond = cond.strip()
                        if not cond: continue
                        parts = re.split(r"[:<>=]+", cond, maxsplit=1)
                        opt = parts[0].strip().lower()
                        val = parts[1].strip() if len(parts) > 1 else None
                        if opt in ("buff", "nobuff", "tbuff", "tnobuff", "mbuff", "nombuff",
                                   "xmbuff", "xmnobuff", "xmtbuff", "xmtnobuff",
                                   "bufftime", "tbufftime", "mbufftime",
                                   "xmbufftime", "xmtbufftime", "xmtbuffstack"):
                            if val:
                                for b in val.split("|"):
                                    b_clean = re.split(r"[@<>=]", b.strip())[0].strip()
                                    if not resolve_buff(b_clean):
                                        print(f"[FAIL TOKEN] Script {kf} ({fn}): Unmapped buff '{b_clean}' in '{line}'")
                                        token_issues += 1
                        elif opt in ("cd", "nocd", "cdtime", "ota", "noota"):
                            if val:
                                for sk in val.split("|"):
                                    sk_clean = re.split(r"[@<>=]", sk.strip())[0].strip()
                                    if not resolve_skill(sk_clean):
                                        print(f"[FAIL TOKEN] Script {kf} ({fn}): Unmapped skill condition '{sk_clean}' in '{line}'")
                                        token_issues += 1

    if token_issues == 0:
        print("[PASS] 100% of skill targets, buff conditions, and skill conditions resolve to valid IDs")
    else:
        total_issues += token_issues

    print("\n--- Checking Native Modules Execution in Lua 5.1 Runtime ---")
    lua = LuaRuntime(register_eval=False, register_builtins=False)
    mock = '''
        OutputMessage = function(...) end
        RegisterEvent = function(...) end
        GetLogicFrameCount = function() return 1000 end
        Table_GetSkillName = function(id, lvl) return "TestSkill" end
        Table_GetBuffName = function(id, lvl) return "TestBuff" end
        OnAddOnUseSkill = function(id, lvl) last_cast_id = id; return true end
        GetNpc = function(id) return {dwID=id, nCurrentLife=500, nMaxLife=1000, nX=64, nY=0, nZ=0, GetBuffList = function() return {} end} end
        GetClientPlayer = function()
            return {
                dwID = 100,
                dwForceID = 1,
                bDeathFlag = false,
                nCurrentLife = 1000, nMaxLife = 1000,
                nCurrentMana = 1000, nMaxMana = 1000,
                nCurrentRage = 50, nMaxRage = 100,
                nCurrentEnergy = 50, nMaxEnergy = 100,
                nAccumulateValue = 10,
                nCurrentSunEnergy = 100, nCurrentMoonEnergy = 100,
                nSunPowerValue = 0, nMoonPowerValue = 0,
                bFightState = true,
                bOnHorse = false,
                nMoveState = 0,
                nX = 0, nY = 0, nZ = 0,
                GetKungfuMount = function() return {dwSkillID=10014} end,
                GetSkillLevel = function(id) return 1 end,
                GetAllSkillList = function() return {[305]=1, [362]=1, [2699]=1, [365]=1} end,
                GetBuffList = function() return {} end,
                GetSkillPrepareState = function() return false end,
                GetOTActionState = function() return 0 end,
                GetSkillCDProgress = function(id, lvl) return false, 0, 0 end,
                GetTarget = function() return 1, 200 end,
            }
        end
    '''
    lua.execute(mock)
    
    # Load Runtime.lua
    runtime_path = ADDON / "Runtime.lua"
    try:
        lua.execute(runtime_path.read_text(encoding="utf-8-sig"), name="Runtime.lua")
        print(f"[PASS] Runtime.lua executed cleanly in Lua 5.1")
    except Exception as e:
        print(f"[FAIL] Runtime.lua execution failed: {e}")
        total_issues += 1

    # Test /xmacro command parsing with localized Vietnamese names
    test_macro_cmd = lua.eval("""function()
        last_cast_id = nil
        local script = [[
#name TestThaiHu
/skill [nobuff:Tọa Vong Vô Ngã] Tọa Vong Vô Ngã
/skill [nobuff:Toái Tinh Thần] Toái Tinh Thần
/skill [distance<=4,tlife<0.40] Bát Hoang Quy Nguyên
/skill [distance<=4,qidian>=8] Vô Ngã Vô Kiếm
/skill [distance<=4] Tam Hoàn Quy Nguyệt
/skill [distance<=4] Kiếm Phi Kinh Thiên
/skill [qidian<8] Ngưng Thần Tụ Khí
]]
        local ret = ExecuteMacroCommand(script)
        return ret, last_cast_id
    end""")
    
    try:
        res, cast_id = test_macro_cmd()
        if res is True and cast_id == 305:
            print(f"[PASS] ExecuteMacroCommand parsed localized Vietnamese macro and fired cast_id={cast_id}")
        else:
            print(f"[FAIL] ExecuteMacroCommand returned res={res}, cast_id={cast_id} (expected True and 305)")
            total_issues += 1
    except Exception as e:
        print(f"[FAIL] ExecuteMacroCommand error: {e}")
        total_issues += 1

    exec_macro = lua.eval("ExecuteMacroCommand")

    # Test all 16 school rotations from cloud_rotations.lua
    print("\n--- Verifying All 16 Rotations from cloud_rotations.lua ---")
    rotations_lua = (EXPORT / "api/cloud_rotations.lua").read_text(encoding="utf-8-sig")
    rotations = lua.execute(rotations_lua)["rotations"]
    
    for kf in sorted(rotations.keys()):
        r = rotations[kf]
        script = r["script"]
        school = r["school"]
        profile = r["profile"]
        lua.execute("last_cast_id = nil")
        try:
            ret = exec_macro(script)
            cast_id = lua.eval("last_cast_id")
            if ret and cast_id is not None:
                print(f"[PASS] Cloud Rotation {kf} {school}/{profile}: successfully fired cast_id={cast_id}")
            else:
                print(f"[FAIL] Cloud Rotation {kf} {school}/{profile}: ret={ret}, cast_id={cast_id}")
                total_issues += 1
        except Exception as e:
            print(f"[FAIL] Cloud Rotation {kf} {school}/{profile} error: {e}")
            total_issues += 1

    # Test all 16 school profile macro scripts directly extracted from Schools/
    print("\n--- Verifying All 16 Rotations Directly From Schools/ Sources ---")
    school_scripts = extract_school_macro_scripts(ADDON / "Schools")
    for kf in sorted(school_scripts.keys()):
        fn, script = school_scripts[kf]
        lua.execute("last_cast_id = nil")
        try:
            ret = exec_macro(script)
            cast_id = lua.eval("last_cast_id")
            if ret and cast_id is not None:
                print(f"[PASS] School Profile Script {kf} ({fn}): successfully fired cast_id={cast_id}")
            else:
                print(f"[FAIL] School Profile Script {kf} ({fn}): ret={ret}, cast_id={cast_id}")
                total_issues += 1
        except Exception as e:
            print(f"[FAIL] School Profile Script {kf} ({fn}) error: {e}")
            total_issues += 1

    print(f"\nAudit complete: checked {total_files} files, {total_issues} issues found.")
    if total_issues > 0:
        sys.exit(1)
    else:
        print("ALL CRITERIA VERIFIED AND PASSED!")

if __name__ == "__main__":
    main()
