# -*- coding: utf-8 -*-
from pathlib import Path

# Extract exact vetted scripts from Schools/
scripts = {
    10002: {
        "school": "ThieuLam",
        "profile": "TayTuyKinh",
        "alias": "TLTT",
        "name": "ThieuLam_TayTuyKinh_80",
        "script": """#name ThieuLam_TayTuyKinh_80
/skill [life<0.35] 245
/skill [life<0.40] 247
/skill [qidian<1] 246
/skill [distance<=4] 236
/skill [distance<=4,qidian>=3] 241
/skill [distance<=4,qidian>=3] 233
/skill [distance<=4] 237
/skill [distance<=5] 234
/skill [distance<=4] 232"""
    },
    10003: {
        "school": "ThieuLam",
        "profile": "DichCanKinh",
        "alias": "TL",
        "name": "ThieuLam_DichCanKinh_80",
        "script": """#name ThieuLam_DichCanKinh_80
/skill [life<0.35] 245
/skill [mana<0.40,qidian>=3] 242
/skill [qidian<1] 246
/skill [distance<=4,qidian>=3,tlife<0.30] 243
/skill [distance<=4,qidian>=3] 239
/skill [distance<=4,qidian>=3] 233
/skill [distance<=5] 235
/skill [distance<=8] 2572
/skill [distance<=5,qidian<3] 234
/skill [distance<=4] 232"""
    },
    10014: {
        "school": "ThuanDuong",
        "profile": "ThaiHuKiemY",
        "alias": "TDTK",
        "name": "ThuanDuong_ThaiHuKiemY_80",
        "script": """#name ThuanDuong_ThaiHuKiemY_80
/skill [nobuff:305] 305
/skill [mana<0.40,qidian>=8] 302
/skill [distance<=4,tlife<0.40] 2699
/skill [distance<=4,qidian>=8] 365
/skill [distance<=4,qidian<=7] 2699
/skill [distance<=4] 309
/skill [distance<=4] 364
/skill [nofight,qidian<10] 300
/skill [distance>4,qidian<8] 300"""
    },
    10015: {
        "school": "ThuanDuong",
        "profile": "TuHaCong",
        "alias": "TDTH",
        "name": "ThuanDuong_TuHaCong_80",
        "script": """#name ThuanDuong_TuHaCong_80
/skill [nobuff:305] 305
/skill [mana<0.60,qidian>=8] 302
/skill [distance<=20,qidian>=8] 301
/skill [distance<=20,qidian<=7] 367
/skill [distance<=20] 306"""
    },
    10021: {
        "school": "VanHoa",
        "profile": "HoaGian",
        "alias": "VH",
        "name": "VanHoa_HoaGian_80",
        "script": """#name VanHoa_HoaGian_80
/skill [life<0.4] Xuan Ne Ho
/skill [nobuff:Thinh Bang] Thinh Bang
/skill [qidian>=9] 2645
/skill [tnobuff:Thuong Duong Kiem] Thuong Duong Kiem
/skill [tnobuff:Lan Thoi] Lan Thoi
/skill [tnobuff:Chung Lam] Chung Lam
/skill [distance<=20] Duong Minh Chi"""
    },
    10026: {
        "school": "ThienSach",
        "profile": "DPS",
        "alias": "TS",
        "name": "ThienSach_NgaoHuyet_80",
        "script": """#name ThienSach_NgaoHuyet_80
/skill [mana<0.50] 405
/skill [life<0.30] 407
/skill [distance<=4,xmtnobuff:3442] 401
/skill [distance<=4,xmtbuff:540] 415
/skill [distance<=4,xmtbuff:540] 423
/skill [distance<=4] 403
/skill [distance<=4,tlife<0.30] 423
/skill [distance<=4] 400"""
    },
    10062: {
        "school": "ThienSach",
        "profile": "ThietLao",
        "alias": "TSTL",
        "name": "ThienSach_ThietLao_80",
        "script": """#name ThienSach_ThietLao_80
/skill [life<0.35] 407
/skill [life<0.60] 424
/skill [mana<0.50] 405
/skill [distance<=4] 402
/skill [distance<=4,xmtnobuff:3442] 401
/skill [distance<=4,xmtbuff:540] 415
/skill [distance<=4] 403
/skill [distance<=4] 423
/skill [distance<=4] 400"""
    },
    10081: {
        "school": "ThatTu",
        "profile": "BangTam",
        "alias": "7T",
        "name": "ThatTu_BangTam_80",
        "script": """#name ThatTu_BangTam_80
/skill [life<0.35] 552
/skill [buff:559<4] 559
/skill [tnobuff:557] 557
/skill [tbuff:557] 554
/skill [distance<=20] 553"""
    },
    10144: {
        "school": "TangKiem",
        "profile": "DPS",
        "alias": "TK",
        "name": "TangKiem_VanThuy_80",
        "script": """#name TangKiem_VanThuy_80
/skill [distance<=8,xmtnobuff:2260] 1649
/skill [rage>=95] 1656
/skill [rage<=30] 1609
/skill [distance<=4] 1593
/skill [distance<=4] 1592
/skill [distance<=4] 1646
/skill [distance<=4] 1600
/skill [distance<=4] 1579"""
    },
    10145: {
        "school": "TangKiem",
        "profile": "DPS",
        "alias": "TK",
        "name": "TangKiem_SonCu_80",
        "script": """#name TangKiem_SonCu_80
/skill [distance<=8,xmtnobuff:2260] 1649
/skill [rage<=15] 1656
/skill [distance<=4] 1593
/skill [distance<=4] 1592
/skill [distance<=4] 1646
/skill [distance<=4] 1600
/skill [distance<=4] 1579"""
    },
    10175: {
        "school": "NguDoc",
        "profile": "DocKinh",
        "alias": "ND",
        "name": "NguDoc_DocKinh_80",
        "script": """#name NguDoc_DocKinh_80
/skill [pet] 2214
/skill [life<0.35] 2226
/skill [tnobuff:2246] 2216
/skill [tnobuff:2247] 2217
/skill [tnobuff:2248] 2218
/skill [tbuff:2246,tbuff:2247,tbuff:2248] 2219
/skill [distance<=20] 2215"""
    },
    10176: {
        "school": "NguDoc",
        "profile": "BoThien",
        "alias": "NDBT",
        "name": "NguDoc_BoThien_80",
        "script": """#name NguDoc_BoThien_80
/skill [pet] 2214
/skill [life<0.35] 2226
/skill [distance<=20] 2221
/skill [distance<=20] 2222"""
    },
    10224: {
        "school": "DuongMon",
        "profile": "KinhVu",
        "alias": "DMKV",
        "name": "DuongMon_KinhVu_80",
        "script": """#name DuongMon_KinhVu_80
/skill [energy<35] 3100
/skill [distance<=25,xmbuff:3317] 3098
/skill [distance<=25,energy>=20,xmtnobuff:2237] 3087
/skill [distance<=25,energy>=30] 3093
/skill [distance<=25,energy<=70] 3095
/skill [distance<=25,energy>=30] 3088"""
    },
    10225: {
        "school": "DuongMon",
        "profile": "ThienLa",
        "alias": "DMTL",
        "name": "DuongMon_ThienLa_80",
        "script": """#name DuongMon_ThienLa_80
/skill [energy<40] 3100
/skill [distance<=25,energy>=20,xmtnobuff:2237] 3087
/skill [distance<=25,energy>=30] 3093
/skill [distance<=25,energy>=30] 3105
/skill [distance<=25,energy>=15] 3088"""
    },
    10242: {
        "school": "MinhGiao",
        "profile": "PhanAnh",
        "alias": "MG",
        "name": "MinhGiao_PhanAnh_80",
        "script": """#name MinhGiao_PhanAnh_80
/skill [life<0.30] 3965
/skill [distance<=5,fullsun] 3967
/skill [distance<=5,fullmoon] 3967
/skill [distance<=5,xmbuff:4052] 3979
/skill [distance<=5] 3963
/skill [distance<=5] 3960
/skill [distance<=5,sun>=moon] 3962
/skill [distance<=5] 3959"""
    },
    10243: {
        "school": "MinhGiao",
        "profile": "MinhTon",
        "alias": "MGMT",
        "name": "MinhGiao_MinhTon_80",
        "script": """#name MinhGiao_MinhTon_80
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
/skill [distance<=5] 3962"""
    }
}

lua_lines = [
    'return {',
    '    version = "20261108.2",',
    '    timestamp = "2026-11-08 14:30:00",',
    '    client = "JX3-v80",',
    '    rotations = {'
]

for kf, data in sorted(scripts.items()):
    lua_lines.append(f'        [{kf}] = {{')
    lua_lines.append(f'            school = "{data["school"]}",')
    lua_lines.append(f'            profile = "{data["profile"]}",')
    lua_lines.append(f'            alias = "{data["alias"]}",')
    lua_lines.append(f'            name = "{data["name"]}",')
    lua_lines.append('            script = [[\n' + data["script"] + '\n]]')
    lua_lines.append('        },')

lua_lines.append('    }')
lua_lines.append('}\n')

lua_content = "\n".join(lua_lines)

html_content = f'''<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>xMacro Cloud API v80</title>
</head>
<body>
<pre id="data">
{lua_content.strip()}
</pre>
</body>
</html>
'''

# Write to all destinations
for target_dir in ["BDMacro-export", "interface/xMacro", "xMacro-v80-HCNC-0.9.7-addon/interface/xMacro", ""]:
    base = Path(target_dir) if target_dir else Path(".")
    api_dir = base / "api"
    api_dir.mkdir(parents=True, exist_ok=True)
    (api_dir / "cloud_rotations.lua").write_text(lua_content, encoding="utf-8-sig")
    (api_dir / "cloud_rotations.html").write_text(html_content, encoding="utf-8")

print(f"Successfully synced all 16 rotations into cloud_rotations.lua and cloud_rotations.html (v20261108.2)!")
