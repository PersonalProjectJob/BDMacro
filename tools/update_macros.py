"""Update macros for all sects and both internal kungfus except buff/healers."""

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# 1. Update Core/Macro.lua: register fcast
macro_path = ROOT / "Core" / "Macro.lua"
macro_text = macro_path.read_text(encoding="utf-8-sig")
if 'AppendCommand("fcast", ExecuteSkillCommand)' not in macro_text:
    macro_text = macro_text.replace(
        'AppendCommand("cast", ExecuteSkillCommand)',
        'AppendCommand("cast", ExecuteSkillCommand)\nAppendCommand("fcast", ExecuteSkillCommand)'
    )
    macro_path.write_text(macro_text, encoding="utf-8-sig")
    print("Updated Core/Macro.lua with fcast")

# 2. Update Schools/Priority.lua
priority_content = r'''-- Shared guard for PvE damage scripts in the Hoang Cung Nam Chieu client.
function xMacro.Schools.RegisterDamageScript(school, profile, scriptsByMount)
    local factories = xMacro.SchoolFactories
    factories[school] = factories[school] or {}
    factories[school][profile] = function(deps)
        local function Run()
            local player = GetClientPlayer and GetClientPlayer()
            if not player or not player.GetKungfuMount or not player.GetSkillLevel or player.bDeathFlag then
                return false
            end
            local mount = player.GetKungfuMount()
            local script = mount and scriptsByMount[mount.dwSkillID]
            if not script then return false end

            local target = deps.GetCurrentTargetObject()
            if not target or not target.dwID or target.dwID == player.dwID or target.bDeathFlag then
                return false
            end
            if IsEnemy and not IsEnemy(player.dwID, target.dwID) then return false end
            if type(script) == "function" then script = script(player) end
            -- The generic numeric /skill or /cast handler accepts unknown IDs at level 1.
            -- Skip unlearned skills so the client can fall through to the next priority.
            script = script:gsub("(/[a-z]+%s+[^\r\n]+)", function(command)
                local cmd, body = command:match("^/([a-z]+)%s+(.*)$")
                if cmd == "skill" or cmd == "cast" or cmd == "fcast" then
                    local skillTarget = body:match("%]%s*(.-)%s*$") or body:match("^%s*(.-)%s*$")
                    if skillTarget and skillTarget ~= "" then
                        local skillID = tonumber(skillTarget)
                        if skillID and (player.GetSkillLevel(skillID) or 0) <= 0 then
                            return ""
                        end
                    end
                end
                return command
            end)
            -- A previous profile may have left its /config before filter active.
            return ExecuteMacroCommand("/config before:null\n" .. script)
        end
        return {run = Run}
    end
    if xMacro.SchoolProfiles[school] then xMacro.SchoolProfiles[school][profile] = nil end
end
'''
(ROOT / "Schools" / "Priority.lua").write_text(priority_content, encoding="utf-8-sig")
print("Updated Schools/Priority.lua")

# 3. Write school profiles
schools_files = {
    ROOT / "Schools/ThieuLam/TayTuyKinh.lua": r'''-- Tẩy Tủy Kinh (10002) - Nội công Tank Thiếu Lâm v80
-- Kỹ năng: Vô Tướng Quyết (245), Đoán Cốt Quyết (247), Cầm Long Quyết (246),
-- Vạn Phật Triều Tông (236 - Taunt), Lập Địa Thành Phật (241), Vi Đà Hiến Chử (233),
-- Ma Ha Vô Lượng (237), Hoành Tảo Lục Hợp (234), Phổ Độ Tứ Phương (232).
xMacro.Schools.RegisterDamageScript("ThieuLam", "TayTuyKinh", {[10002] = [[
#name ThieuLam_TayTuyKinh_80
/skill [life<0.35] 245
/skill [life<0.40] 247
/skill [qidian<1] 246
/skill [distance<=4] 236
/skill [distance<=4,qidian>=3] 241
/skill [distance<=4,qidian>=3] 233
/skill [distance<=4] 237
/skill [distance<=5] 234
/skill [distance<=4] 232
]]})
''',

    ROOT / "Schools/ThieuLam/DichCanKinh.lua": r'''-- Dịch Cân Kinh (10003) - Nội công DPS Thiếu Lâm v80
-- Kỹ năng: Vô Tướng Quyết (245), Diệc Khô Diệc Vinh (242), Cầm Long Quyết (246),
-- Nã Vân Thức (243), Kim Cương Nộ Mục (239), Vi Đà Hiến Chử (233),
-- Thủ Khuyết Thức (235), Đảo Hư Thức (2572), Hoành Tảo Lục Hợp (234), Phổ Độ Tứ Phương (232).
xMacro.Schools.RegisterDamageScript("ThieuLam", "DichCanKinh", {[10003] = [[
#name ThieuLam_DichCanKinh_80
/skill [life<0.35] 245
/skill [mana<0.40,qidian>=3] 242
/skill [qidian<1] 246
/skill [distance<=4,qidian>=3,tlife<0.30] 243
/skill [distance<=4,qidian>=3] 239
/skill [distance<=4,qidian>=3] 233
/skill [distance<=5] 235
/skill [distance<=8] 2572
/skill [distance<=5,qidian<3] 234
/skill [distance<=4] 232
]]})
''',

    ROOT / "Schools/ThienSach/ThietLao.lua": r'''-- Thiết Lao Luật (10062) - Nội công Tank Thiên Sách v80
-- Kỹ năng: Thủ Như Sơn (407), Ngự (424), Từ Như Lâm (405),
-- Định Quân (402 - Taunt cừu hận chính), Phá Phong (401 - duy trì debuff Lưu Huyết 3442),
-- Long Nha (415 - khi có Trí Tàn 540 tạo cừu hận lớn), Long Ngâm (403), Diệt (423), Xuyên Vân (400).
xMacro.Schools.RegisterDamageScript("ThienSach", "ThietLao", {[10062] = [[
#name ThienSach_ThietLao_80
/skill [life<0.35] 407
/skill [life<0.60] 424
/skill [mana<0.50] 405
/skill [distance<=4] 402
/skill [distance<=4,xmtnobuff:3442] 401
/skill [distance<=4,xmtbuff:540] 415
/skill [distance<=4] 403
/skill [distance<=4] 423
/skill [distance<=4] 400
]]})
''',

    ROOT / "Schools/ThienSach/DPS.lua": r'''-- Ngạo Huyết Chiến Ý (10026) - Nội công DPS Thiên Sách v80
-- Kỹ năng: Từ Như Lâm (405), Thủ Như Sơn (407), Phá Phong (401 - duy trì debuff Lưu Huyết 3442),
-- Long Nha (415 - khi có Trí Tàn 540), Diệt (423), Long Ngâm (403), Xuyên Vân (400).
xMacro.Schools.RegisterDamageScript("ThienSach", "DPS", {[10026] = [[
#name ThienSach_NgaoHuyet_80
/skill [mana<0.50] 405
/skill [life<0.30] 407
/skill [distance<=4,xmtnobuff:3442] 401
/skill [distance<=4,xmtbuff:540] 415
/skill [distance<=4,xmtbuff:540] 423
/skill [distance<=4] 403
/skill [distance<=4,tlife<0.30] 423
/skill [distance<=4] 400
]]})
''',

    ROOT / "Schools/MinhGiao/MinhTon.lua": r'''-- Minh Tôn Lưu Hỏa Thể (10243) - Nội công Tank Minh Giáo v80
-- Kỹ năng: Tham Ma Thể (3965), Thánh Minh Hựu (3966), Từ Bi Nguyện (3972 - Taunt cừu hận chính),
-- Giới Hỏa Trảm (3973), Hoàng Nhật Chiếu (3975), Tịnh Thế Phá Ma Kích (3967),
-- Liệt Nhật Trảm (3960), Ngân Nguyệt Trảm (3963), Xích Nhật Luân (3959), U Nguyệt Luân (3962).
xMacro.Schools.RegisterDamageScript("MinhGiao", "MinhTon", {[10243] = [[
#name MinhGiao_MinhTon_80
/skill [life<0.30] 3965
/skill [life<0.40,fullsun] 3966
/skill [distance<=5] 3972
/skill [distance<=8] 3973
/skill [distance<=5] 3975
/skill [distance<=5,fullsun] 3967
/skill [distance<=5,fullmoon] 3967
/skill [distance<=5,sun>=moon] 3960
/skill [distance<=5,moon>sun] 3963
/skill [distance<=5,sun>=moon] 3959
/skill [distance<=5] 3962
]]})
''',

    ROOT / "Schools/MinhGiao/PhanAnh.lua": r'''-- Phần Ảnh Thánh Quyết (10242) - Nội công DPS Minh Giáo v80
-- Kỹ năng: Tham Ma Thể (3965), Tịnh Thế Phá Ma Kích (3967), Khu Dạ Đoạn Sầu (3979),
-- Ngân Nguyệt Trảm (3963), Liệt Nhật Trảm (3960), U Nguyệt Luân (3962), Xích Nhật Luân (3959).
xMacro.Schools.RegisterDamageScript("MinhGiao", "PhanAnh", {[10242] = [[
#name MinhGiao_PhanAnh_80
/skill [life<0.30] 3965
/skill [distance<=5,fullsun] 3967
/skill [distance<=5,fullmoon] 3967
/skill [distance<=5,xmbuff:4052] 3979
/skill [distance<=5] 3963
/skill [distance<=5] 3960
/skill [distance<=5,sun>=moon] 3962
/skill [distance<=5] 3959
]]})
''',

    ROOT / "Schools/ThuanDuong/TuHaCong.lua": r'''-- Tử Hà Công (10014) - Nội công DPS Khí Thuần Dương v80
-- Kỹ năng: Tọa Vọng Vô Ngã (305), Bão Nguyên Thủ Khuyết (302),
-- Lưỡng Nghi Hóa Hình (301), Tứ Tượng Luân Hồi (367), Thái Cực Vô Cực (306).
xMacro.Schools.RegisterDamageScript("ThuanDuong", "TuHaCong", {[10014] = [[
#name ThuanDuong_TuHaCong_80
/skill [nobuff:305] 305
/skill [mana<0.60,qidian>=8] 302
/skill [distance<=20,qidian>=8] 301
/skill [distance<=20,qidian<=7] 367
/skill [distance<=20] 306
]]})
''',

    ROOT / "Schools/ThuanDuong/ThaiHuKiemY.lua": r'''-- Thái Hư Kiếm Ý (10015) - Nội công DPS Kiếm Thuần Dương v80
-- Kỹ năng: Tọa Vọng Vô Ngã (305), Vô Ngã Vô Kiếm (365),
-- Bát Hoang Quy Nguyên (2699), Tam Hoàn Sáo Nguyệt (364).
xMacro.Schools.RegisterDamageScript("ThuanDuong", "ThaiHuKiemY", {[10015] = [[
#name ThuanDuong_ThaiHuKiemY_80
/skill [nobuff:305] 305
/skill [distance<=4,qidian>=8] 365
/skill [distance<=4,tlife<0.40] 2699
/skill [distance<=4,qidian<=7] 2699
/skill [distance<=4] 364
]]})
''',

    ROOT / "Schools/DuongMon/KinhVu.lua": r'''-- Kinh Vũ Quyết (10224) - Nội công DPS Nỏ Đường Môn v80
-- Kỹ năng: Tập Trung (3100), Truy Mệnh Tiễn (3098), Hóa Huyết Tiêu (3087 - debuff 2237),
-- Bạo Vũ Lê Hoa Châm (3093), Trục Tinh Tiễn (3095), Đoạt Phách Tiễn (3088).
xMacro.Schools.RegisterDamageScript("DuongMon", "KinhVu", {[10224] = [[
#name DuongMon_KinhVu_80
/skill [energy<35] 3100
/skill [distance<=25,xmbuff:3317] 3098
/skill [distance<=25,energy>=20,xmtnobuff:2237] 3087
/skill [distance<=25,energy>=30] 3093
/skill [distance<=25,energy<=70] 3095
/skill [distance<=25,energy>=30] 3088
]]})
''',

    ROOT / "Schools/DuongMon/ThienLa.lua": r'''-- Thiên La Quỹ Đạo (10225) - Nội công DPS Cơ quan Đường Môn v80
-- Kỹ năng: Tập Trung (3100), Hóa Huyết Tiêu (3087 - debuff 2237),
-- Bạo Vũ Lê Hoa Châm (3093), Thực Cơ Đạn (3105), Đoạt Phách Tiễn (3088).
xMacro.Schools.RegisterDamageScript("DuongMon", "ThienLa", {[10225] = [[
#name DuongMon_ThienLa_80
/skill [energy<40] 3100
/skill [distance<=25,energy>=20,xmtnobuff:2237] 3087
/skill [distance<=25,energy>=30] 3093
/skill [distance<=25,energy>=30] 3105
/skill [distance<=25,energy>=15] 3088
]]})
''',

    ROOT / "Schools/TangKiem/DPS.lua": r'''-- Vấn Thủy Quyết (10144 - Khinh Kiếm tích kiếm khí) & Sơn Cư Kiếm Ý (10145 - Trọng Kiếm xả kiếm khí).
-- Kỹ năng: Mai Ẩn Hương (1649), Khiếu Nhật (1656), Tuyết Đoạn Kiều (1609),
-- Vân Phi Ngọc Hoàng (1593), Tịch Chiếu Lôi Phong (1592), Thính Lôi (1646),
-- Đoạn Triều (1600), Cửu Khê Di Yên (1579).
local light = [[
/skill [distance<=8,xmtnobuff:1649] 1649
/skill [distance<=4] 1600
/skill [distance<=4] 1646
/skill [distance<=8] 1579
]]
local heavy = [[
/skill [distance<=8,xmtnobuff:1649] 1649
/skill [distance<=8,rage<20] 1609
/skill [distance<=4] 1600
/skill [distance<=8,rage>=20] 1593
/skill [distance<=8,rage>=20] 1592
/skill [distance<=4] 1646
]]

local function LightSword(player)
    local energy = player.nCurrentRage or 0
    local maxEnergy = player.nMaxRage or 0
    if maxEnergy > 0 and energy >= maxEnergy * 0.90 then
        return "/skill [distance<=4] 1656\n" .. light
    end
    return light
end

local function HeavySword(player)
    if player.nCurrentRage and player.nCurrentRage < 15 then
        return "/skill [distance<=4] 1656\n" .. heavy
    end
    return heavy
end

xMacro.Schools.RegisterDamageScript("TangKiem", "DPS", {
    [10144] = LightSword,
    [10145] = HeavySword,
})
'''
}

for path, content in schools_files.items():
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8-sig")
    print(f"Wrote: {path.name}")

# 4. Update manifest.json
manifest_path = ROOT / "manifest.json"
manifest = json.loads(manifest_path.read_bytes())

# Reconstruct profiles with both internal kungfus
new_profiles = {
    "VanHoa/HoaGian": {
        "path": "Native/XM05_VanHoa.lua",
        "aliases": ["VH", "VHHG"],
        "kungfuIds": [10021],
        "sourcePath": "Schools/VanHoa/HoaGian.lua"
    },
    "NguDoc/DocKinh": {
        "path": "Native/XM06_NguDoc.lua",
        "aliases": ["ND", "NDDK"],
        "kungfuIds": [10175],
        "sourcePath": "Schools/NguDoc/DocKinh_BoThien.lua"
    },
    "NguDoc/BoThien": {
        "path": "Native/XM06_NguDoc.lua",
        "aliases": ["NDBT"],
        "kungfuIds": [10176],
        "sourcePath": "Schools/NguDoc/DocKinh_BoThien.lua"
    },
    "ThatTu/BangTam": {
        "path": "Native/XM07_ThatTu.lua",
        "aliases": ["7T", "TTBT"],
        "kungfuIds": [10081],
        "sourcePath": "Schools/ThatTu/BangTam.lua"
    },
    "ThienSach/DPS": {
        "path": "Native/XM08_ThienSach.lua",
        "aliases": ["TS", "TSNH"],
        "kungfuIds": [10026],
        "sourcePath": "Schools/ThienSach/DPS.lua"
    },
    "ThienSach/ThietLao": {
        "path": "Native/XM08_ThienSach.lua",
        "aliases": ["TSTL", "TSTANK"],
        "kungfuIds": [10062],
        "sourcePath": "Schools/ThienSach/ThietLao.lua"
    },
    "TangKiem/DPS": {
        "path": "Native/XM09_TangKiem.lua",
        "aliases": ["TK", "TKCJ"],
        "kungfuIds": [10144, 10145],
        "sourcePath": "Schools/TangKiem/DPS.lua"
    },
    "DuongMon/KinhVu": {
        "path": "Native/XM10_DuongMon.lua",
        "aliases": ["DMKV"],
        "kungfuIds": [10224],
        "sourcePath": "Schools/DuongMon/KinhVu.lua"
    },
    "DuongMon/ThienLa": {
        "path": "Native/XM10_DuongMon.lua",
        "aliases": ["DMTL"],
        "kungfuIds": [10225],
        "sourcePath": "Schools/DuongMon/ThienLa.lua"
    },
    "MinhGiao/PhanAnh": {
        "path": "Native/XM11_MinhGiao.lua",
        "aliases": ["MG", "MGPA"],
        "kungfuIds": [10242],
        "sourcePath": "Schools/MinhGiao/PhanAnh.lua"
    },
    "MinhGiao/MinhTon": {
        "path": "Native/XM11_MinhGiao.lua",
        "aliases": ["MGMT", "MGTANK"],
        "kungfuIds": [10243],
        "sourcePath": "Schools/MinhGiao/MinhTon.lua"
    },
    "ThieuLam/DichCanKinh": {
        "path": "Native/XM12_ThieuLam.lua",
        "aliases": ["TL", "TLDC"],
        "kungfuIds": [10003],
        "sourcePath": "Schools/ThieuLam/DichCanKinh.lua"
    },
    "ThieuLam/TayTuyKinh": {
        "path": "Native/XM12_ThieuLam.lua",
        "aliases": ["TLTT", "TLTANK"],
        "kungfuIds": [10002],
        "sourcePath": "Schools/ThieuLam/TayTuyKinh.lua"
    },
    "ThuanDuong/TuHaCong": {
        "path": "Native/XM13_ThuanDuong.lua",
        "aliases": ["TDTH", "QC"],
        "kungfuIds": [10014],
        "sourcePath": "Schools/ThuanDuong/TuHaCong.lua"
    },
    "ThuanDuong/ThaiHuKiemY": {
        "path": "Native/XM13_ThuanDuong.lua",
        "aliases": ["TDTK", "JC"],
        "kungfuIds": [10015],
        "sourcePath": "Schools/ThuanDuong/ThaiHuKiemY.lua"
    }
}

manifest["profiles"] = new_profiles
manifest_path.write_bytes(json.dumps(manifest, ensure_ascii=False, indent=2).encode("utf-8") + b"\n")
print("Updated manifest.json")
