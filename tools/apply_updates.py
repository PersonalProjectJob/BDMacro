# -*- coding: utf-8 -*-
"""
apply_updates.py
Audits and replaces raw numeric skill and buff IDs across all xMacro profiles
with exact localized Vietnamese skill and buff names for JX3 v80 VNG client.
Maintains Triple-Sync consistency and UTF-8 BOM encoding.
"""

import sys
import subprocess
from pathlib import Path

ROOT = Path("g:/JXOnline3VN-v2.5.2+launcher/JXOnline3VN-v2.5.2+launcher")
EXPORT = ROOT / "BDMacro-export"
ADDON = ROOT / "interface" / "xMacro"
STAGING_ADDON = ROOT / "xMacro-v80-HCNC-0.9.7-addon" / "interface" / "xMacro"
BOM = b"\xef\xbb\xbf"

def write_bom_file(path: Path, content: str):
    path.parent.mkdir(parents=True, exist_ok=True)
    data = content.encode("utf-8")
    if not data.startswith(BOM):
        data = BOM + data
    path.write_bytes(data)
    print(f"Wrote BOM file: {path.relative_to(ROOT)}")

# 1. Update School Profile Lua files in BDMacro-export/Schools/
PROFILES = {
    EXPORT / "Schools/ThuanDuong/ThaiHuKiemY.lua": r'''-- Thái Hư Kiếm Ý (10014) - Nội công DPS Kiếm Thuần Dương v80
-- Tự động duy trì Khí Trường Toái Tinh Thần và Hóa Tam Thanh khi thiếu mana.
-- Kẹp Ngưng Thần Tụ Khí trong GCD (卡凝神) đỉnh cao:
-- Ngưng Thần Tụ Khí không tốn GCD, tự động kích hoạt trong khe hở GCD
-- để nhận thêm khí điểm miễn phí mà không làm trễ bất kỳ chiêu thức tấn công nào!
xMacro.Schools.RegisterDamageScript("ThuanDuong", "ThaiHuKiemY", {[10014] = [[
#name ThuanDuong_ThaiHuKiemY_80
/skill [nobuff:Tọa Vong Vô Ngã] Tọa Vong Vô Ngã
/skill [nobuff:Toái Tinh Thần] Toái Tinh Thần
/skill [mana<0.40,nobuff:Hóa Tam Thanh] Hóa Tam Thanh
/skill [mana<0.40,qidian>=8] Bão Nguyên Quy Nhất
/skill [distance<=4,tlife<0.40] Bát Hoang Quy Nguyên
/skill [distance<=4,qidian>=8] Vô Ngã Vô Kiếm
/skill [distance<=4,qidian<=7] Bát Hoang Quy Nguyên
/skill [distance<=4] Tam Hoàn Quy Nguyệt
/skill [distance<=4] Kiếm Phi Kinh Thiên
/skill [qidian<8] Ngưng Thần Tụ Khí
/skill [nofight,qidian<10] Ngưng Thần Tụ Khí
]]})
''',

    EXPORT / "Schools/ThuanDuong/TuHaCong.lua": r'''-- Tử Hà Công (10015) - Nội công DPS Khí Thuần Dương v80
-- Kỹ năng: Tọa Vong Vô Ngã, Bão Nguyên Quy Nhất,
-- Lưỡng Nghi Hóa Hình, Tứ Tượng Luân Hồi, Thái Cực Vô Cực.
-- Duy trì Phá Thương Khung, Hóa Tam Thanh và kẹp Ngưng Thần Tụ Khí.
xMacro.Schools.RegisterDamageScript("ThuanDuong", "TuHaCong", {[10015] = [[
#name ThuanDuong_TuHaCong_80
/skill [nobuff:Tọa Vong Vô Ngã] Tọa Vong Vô Ngã
/skill [nobuff:Phá Thương Khung] Phá Thương Khung
/skill [mana<0.40,nobuff:Hóa Tam Thanh] Hóa Tam Thanh
/skill [mana<0.60,qidian>=8] Bão Nguyên Quy Nhất
/skill [distance<=20,qidian>=8] Lưỡng Nghi Hóa Hình
/skill [distance<=20,qidian<=7] Tứ Tượng Luân Hồi
/skill [distance<=20] Thái Cực Vô Cực
/skill [qidian<8] Ngưng Thần Tụ Khí
/skill [nofight,qidian<10] Ngưng Thần Tụ Khí
]]})
''',

    EXPORT / "Schools/ThieuLam/DichCanKinh.lua": r'''-- Dịch Cân Kinh (10003) - Nội công DPS Thiếu Lâm v80
-- Kỹ năng: Vô Tướng Quyết, Diệc Khô Diệc Vinh, Cầm Long Quyết,
-- Nã Vân Thức, Kim Cương Nộ Mục, Vi Đà Hiến Chử,
-- Thủ Khuyết Thức, Đảo Hư Thức, Hoành Tảo Lục Hợp, Phổ Độ Tứ Phương.
xMacro.Schools.RegisterDamageScript("ThieuLam", "DichCanKinh", {[10003] = [[
#name ThieuLam_DichCanKinh_80
/skill [life<0.35] Vô Tướng Quyết
/skill [mana<0.40,qidian>=3] Diệc Khô Diệc Vinh
/skill [qidian<1] Cầm Long Quyết
/skill [distance<=4,qidian>=3,tlife<0.30] Nã Vân Thức
/skill [distance<=4,qidian>=3] Kim Cương Nộ Mục
/skill [distance<=4,qidian>=3] Vi Đà Hiến Chử
/skill [distance<=5] Thủ Khuyết Thức
/skill [distance<=8] Đảo Hư Thức
/skill [distance<=5,qidian<3] Hoành Tảo Lục Hợp
/skill [distance<=4] Phổ Độ Tứ Phương
]]})
''',

    EXPORT / "Schools/ThieuLam/TayTuyKinh.lua": r'''-- Tẩy Tủy Kinh (10002) - Nội công Tank Thiếu Lâm v80
-- Kỹ năng: Vô Tướng Quyết, Đoán Cốt Quyết, Cầm Long Quyết,
-- Vạn Phật Triều Tông (Taunt), Lập Địa Thành Phật, Vi Đà Hiến Chử,
-- Ma Ha Vô Lượng, Hoành Tảo Lục Hợp, Phổ Độ Tứ Phương.
xMacro.Schools.RegisterDamageScript("ThieuLam", "TayTuyKinh", {[10002] = [[
#name ThieuLam_TayTuyKinh_80
/skill [life<0.35] Vô Tướng Quyết
/skill [life<0.40] Đoán Cốt Quyết
/skill [qidian<1] Cầm Long Quyết
/skill [distance<=4] Vạn Phật Triều Tông
/skill [distance<=4,qidian>=3] Lập Địa Thành Phật
/skill [distance<=4,qidian>=3] Vi Đà Hiến Chử
/skill [distance<=4] Ma Ha Vô Lượng
/skill [distance<=5] Hoành Tảo Lục Hợp
/skill [distance<=4] Phổ Độ Tứ Phương
]]})
''',

    EXPORT / "Schools/ThienSach/DPS.lua": r'''-- Ngạo Huyết Chiến Ý (10026) - Nội công DPS Thiên Sách v80
-- Kỹ năng: Từ Như Lâm, Thủ Như Sơn, Phá Phong (duy trì debuff Lưu Huyết),
-- Long Nha (khi có Trí Tàn), Diệt, Long Ngâm, Xuyên Vân.
xMacro.Schools.RegisterDamageScript("ThienSach", "DPS", {[10026] = [[
#name ThienSach_NgaoHuyet_80
/skill [mana<0.50] Từ Như Lâm
/skill [life<0.30] Thủ Như Sơn
/skill [distance<=4,xmtnobuff:Lưu Huyết] Phá Phong
/skill [distance<=4,xmtbuff:Trí Tàn] Long Nha
/skill [distance<=4,xmtbuff:Trí Tàn] Diệt
/skill [distance<=4] Long Ngâm
/skill [distance<=4,tlife<0.30] Diệt
/skill [distance<=4] Xuyên Vân
]]})
''',

    EXPORT / "Schools/ThienSach/ThietLao.lua": r'''-- Thiết Lao Luật (10062) - Nội công Tank Thiên Sách v80
-- Kỹ năng: Thủ Như Sơn, Ngự, Từ Như Lâm,
-- Định Quân (Taunt cừu hận chính), Phá Phong (duy trì debuff Lưu Huyết),
-- Long Nha (khi có Trí Tàn tạo cừu hận lớn), Long Ngâm, Diệt, Xuyên Vân.
xMacro.Schools.RegisterDamageScript("ThienSach", "ThietLao", {[10062] = [[
#name ThienSach_ThietLao_80
/skill [life<0.35] Thủ Như Sơn
/skill [life<0.60] Ngự
/skill [mana<0.50] Từ Như Lâm
/skill [distance<=4] Định Quân
/skill [distance<=4,xmtnobuff:Lưu Huyết] Phá Phong
/skill [distance<=4,xmtbuff:Trí Tàn] Long Nha
/skill [distance<=4] Long Ngâm
/skill [distance<=4] Diệt
/skill [distance<=4] Xuyên Vân
]]})
''',

    EXPORT / "Schools/TangKiem/DPS.lua": r'''-- Vấn Thủy Quyết (10144 - Khinh Kiếm tích kiếm khí) & Sơn Cư Kiếm Ý (10145 - Trọng Kiếm xả kiếm khí).
-- Kỹ năng: Mai Ẩn Hương, Khiếu Nhật, Tuyết Đoạn Kiều,
-- Vân Phi Ngọc Hoàng, Tịch Chiếu Lôi Phong, Thính Lôi,
-- Đoạn Triều, Cửu Khê Di Yên.
local light = [[
/skill [distance<=8,xmtnobuff:Mai Ẩn Hương] Mai Ẩn Hương
/skill [distance<=4] Đoạn Triều
/skill [distance<=4] Thính Lôi
/skill [distance<=8] Cửu Khê Di Yên
]]
local heavy = [[
/skill [distance<=8,xmtnobuff:Mai Ẩn Hương] Mai Ẩn Hương
/skill [distance<=8,rage<20] Tuyết Đoạn Kiều
/skill [distance<=4] Đoạn Triều
/skill [distance<=8,rage>=20] Vân Phi Ngọc Hoàng
/skill [distance<=8,rage>=20] Tịch Chiếu Lôi Phong
/skill [distance<=4] Thính Lôi
]]

local function LightSword(player)
    local energy = player.nCurrentRage or 0
    local maxEnergy = player.nMaxRage or 0
    if maxEnergy > 0 and energy >= maxEnergy * 0.90 then
        return "/skill [distance<=4] Khiếu Nhật\n" .. light
    end
    return light
end

local function HeavySword(player)
    if player.nCurrentRage and player.nCurrentRage < 15 then
        return "/skill [distance<=4] Khiếu Nhật\n" .. heavy
    end
    return heavy
end

xMacro.Schools.RegisterDamageScript("TangKiem", "DPS", {
    [10144] = LightSword,
    [10145] = HeavySword,
})
''',

    EXPORT / "Schools/DuongMon/KinhVu.lua": r'''-- Kinh Vũ Quyết (10224) - Nội công DPS Nỏ Đường Môn v80
-- Kỹ năng: Tập Trung, Truy Mệnh Tiễn, Hóa Huyết Tiêu,
-- Bạo Vũ Lê Hoa Châm, Trục Tinh Tiễn, Đoạt Phách Tiễn.
xMacro.Schools.RegisterDamageScript("DuongMon", "KinhVu", {[10224] = [[
#name DuongMon_KinhVu_80
/skill [energy<35] Tập Trung
/skill [distance<=25,xmbuff:Truy Mệnh Vô Thanh] Truy Mệnh Tiễn
/skill [distance<=25,energy>=20,xmtnobuff:Hóa Huyết Tiêu] Hóa Huyết Tiêu
/skill [distance<=25,energy>=30] Bạo Vũ Lê Hoa Châm
/skill [distance<=25,energy<=70] Trục Tinh Tiễn
/skill [distance<=25,energy>=30] Đoạt Phách Tiễn
]]})
''',

    EXPORT / "Schools/DuongMon/ThienLa.lua": r'''-- Thiên La Quỹ Đạo (10225) - Nội công DPS Cơ quan Đường Môn v80
-- Kỹ năng: Tập Trung, Hóa Huyết Tiêu,
-- Bạo Vũ Lê Hoa Châm, Thực Cơ Đạn, Đoạt Phách Tiễn.
xMacro.Schools.RegisterDamageScript("DuongMon", "ThienLa", {[10225] = [[
#name DuongMon_ThienLa_80
/skill [energy<40] Tập Trung
/skill [distance<=25,energy>=20,xmtnobuff:Hóa Huyết Tiêu] Hóa Huyết Tiêu
/skill [distance<=25,energy>=30] Bạo Vũ Lê Hoa Châm
/skill [distance<=25,energy>=30] Thực Cơ Đạn
/skill [distance<=25,energy>=15] Đoạt Phách Tiễn
]]})
''',

    EXPORT / "Schools/MinhGiao/PhanAnh.lua": r'''-- Phần Ảnh Thánh Quyết (10242) - Nội công DPS Minh Giáo v80
-- Kỹ năng: Tham Ma Thể, Tịnh Thế Phá Ma Kích, Khu Dạ Đoạn Sầu,
-- Ngân Nguyệt Trảm, Liệt Nhật Trảm, U Nguyệt Luân, Xích Nhật Luân.
xMacro.Schools.RegisterDamageScript("MinhGiao", "PhanAnh", {[10242] = [[
#name MinhGiao_PhanAnh_80
/skill [life<0.30] Tham Ma Thể
/skill [distance<=5,fullsun] Tịnh Thế Phá Ma Kích
/skill [distance<=5,fullmoon] Tịnh Thế Phá Ma Kích
/skill [distance<=5,xmbuff:Ám Trần Di Sơn] Khu Dạ Đoạn Sầu
/skill [distance<=5] Ngân Nguyệt Trảm
/skill [distance<=5] Liệt Nhật Trảm
/skill [distance<=5,sun>=moon] U Nguyệt Luân
/skill [distance<=5] Xích Nhật Luân
]]})
''',

    EXPORT / "Schools/MinhGiao/MinhTon.lua": r'''-- Minh Tôn Lưu Hỏa Thể (10243) - Nội công Tank Minh Giáo v80
-- Kỹ năng: Tham Ma Thể, Thánh Minh Hựu, Từ Bi Nguyện (Taunt cừu hận chính),
-- Giới Hỏa Trảm, Hoàng Nhật Chiếu, Tịnh Thế Phá Ma Kích,
-- Liệt Nhật Trảm, Ngân Nguyệt Trảm, Xích Nhật Luân, U Nguyệt Luân.
xMacro.Schools.RegisterDamageScript("MinhGiao", "MinhTon", {[10243] = [[
#name MinhGiao_MinhTon_80
/skill [life<0.30] Tham Ma Thể
/skill [life<0.40,fullsun] Thánh Minh Hựu
/skill [distance<=5] Từ Bi Nguyện
/skill [distance<=8] Giới Hỏa Trảm
/skill [distance<=5] Hoàng Nhật Chiếu
/skill [distance<=5,fullsun] Tịnh Thế Phá Ma Kích
/skill [distance<=5,fullmoon] Tịnh Thế Phá Ma Kích
/skill [distance<=5,sun>=moon] Liệt Nhật Trảm
/skill [distance<=5,moon>sun] Ngân Nguyệt Trảm
/skill [distance<=5,sun>=moon] Xích Nhật Luân
/skill [distance<=5] U Nguyệt Luân
]]})
''',

    # Also make sure Van Hoa Hoa Gian has no numeric nocd:136
    EXPORT / "Schools/VanHoa/HoaGian.lua": (EXPORT / "Schools/VanHoa/HoaGian.lua").read_text(encoding="utf-8-sig").replace(
        "/skill [nocd:136,nombuff:Lan Thoi Ngoc Chiet] Thuy Nguyet Vo Gian",
        "/skill [nocd:Thủy Nguyệt Vô Gian,nombuff:Lan Thoi Ngoc Chiet] Thủy Nguyệt Vô Gian"
    )
}

print("1. Writing updated school profiles to BDMacro-export/Schools/...")
for path, content in PROFILES.items():
    write_bom_file(path, content)

# 2. Update Core/Macro.lua: expand tStatic and tStaticBuffNames and XMCore_FindBuff
print("2. Updating Core/Macro.lua...")
core_macro_path = EXPORT / "Core" / "Macro.lua"
core_text = core_macro_path.read_text(encoding="utf-8-sig")

# Check if new static skills already added
if '["Tọa Vong Vô Ngã"]=305' not in core_text:
    target_needle = '["Dương Minh Chỉ"]=179, ["Duong Minh Chi"]=179, ["duong minh"]=179, ["阳明指"]=179,'
    new_static_skills = '''-- Thuần Dương
\t\t["Tọa Vong Vô Ngã"]=305, ["Toa Vong Vo Nga"]=305, ["Tọa Vọng Vô Ngã"]=305, ["Toa Vong"]=305, ["坐忘无我"]=305,
\t\t["Toái Tinh Thần"]=362, ["Toai Tinh Than"]=362, ["toai tinh than"]=362, ["碎星辰"]=362,
\t\t["Phá Thương Khung"]=359, ["Pha Thuong Khung"]=359, ["pha thuong khung"]=359, ["破苍穹"]=359,
\t\t["Hóa Tam Thanh"]=357, ["Hoa Tam Thanh"]=357, ["hoa tam thanh"]=357, ["化三清"]=357,
\t\t["Bão Nguyên Quy Nhất"]=302, ["Bao Nguyen Quy Nhat"]=302, ["Bão Nguyên Thủ Khuyết"]=302, ["Bao Nguyen Thu Khuyet"]=302, ["抱元守缺"]=302,
\t\t["Bát Hoang Quy Nguyên"]=2699, ["Bat Hoang Quy Nguyen"]=2699, ["bat hoang quy nguyen"]=2699, ["八荒归元"]=2699,
\t\t["Vô Ngã Vô Kiếm"]=365, ["Vo Nga Vo Kiem"]=365, ["vo nga vo kiem"]=365, ["无我无剑"]=365,
\t\t["Tam Hoàn Quy Nguyệt"]=309, ["Tam Hoan Quy Nguyet"]=309, ["Tam Hoàn Sáo Nguyệt"]=309, ["Tam Hoan Sao Nguyet"]=309, ["三环套月"]=309,
\t\t["Kiếm Phi Kinh Thiên"]=364, ["Kiem Phi Kinh Thien"]=364, ["kiem phi kinh thien"]=364, ["剑飞惊天"]=364,
\t\t["Lưỡng Nghi Hóa Hình"]=301, ["Luong Nghi Hoa Hinh"]=301, ["luong nghi hoa hinh"]=301, ["两仪化形"]=301,
\t\t["Tứ Tượng Luân Hồi"]=367, ["Tu Tuong Luan Hoi"]=367, ["tu tuong luan hoi"]=367, ["四象轮回"]=367,
\t\t["Thái Cực Vô Cực"]=306, ["Thai Cuc Vo Cuc"]=306, ["thai cuc vo cuc"]=306, ["太极无极"]=306,
\t\t["Ngưng Thần Tụ Khí"]=300, ["Ngung Than Tu Khi"]=300, ["ngung than tu khi"]=300, ["凝神聚气"]=300,

\t\t-- Thiếu Lâm
\t\t["Vô Tướng Quyết"]=245, ["Vo Tuong Quyet"]=245, ["vo tuong quyet"]=245, ["无相诀"]=245,
\t\t["Đoán Cốt Quyết"]=247, ["Doan Cot Quyet"]=247, ["doan cot quyet"]=247, ["锻骨诀"]=247,
\t\t["Cầm Long Quyết"]=246, ["Cam Long Quyet"]=246, ["cam long quyet"]=246, ["擒龙诀"]=246,
\t\t["Diệc Khô Diệc Vinh"]=242, ["Diec Kho Diec Vinh"]=242, ["diec kho diec vinh"]=242, ["亦枯亦荣"]=242,
\t\t["Nã Vân Thức"]=243, ["Na Van Thuc"]=243, ["na van thuc"]=243, ["拿云式"]=243,
\t\t["Kim Cương Nộ Mục"]=239, ["Kim Cuong No Muc"]=239, ["kim cuong no muc"]=239, ["金刚怒目"]=239,
\t\t["Vi Đà Hiến Chử"]=233, ["Vi Da Hien Chu"]=233, ["vi da hien chu"]=233, ["韦陀献杵"]=233,
\t\t["Thủ Khuyết Thức"]=235, ["Thu Khuyet Thuc"]=235, ["thu khuyet thuc"]=235, ["守缺式"]=235,
\t\t["Đảo Hư Thức"]=2572, ["Dao Hu Thuc"]=2572, ["dao hu thuc"]=2572, ["捣虚式"]=2572,
\t\t["Hoành Tảo Lục Hợp"]=234, ["Hoanh Tao Luc Hop"]=234, ["hoanh tao luc hop"]=234, ["横扫六合"]=234,
\t\t["Phổ Độ Tứ Phương"]=232, ["Pho Do Tu Phuong"]=232, ["pho do tu phuong"]=232, ["普渡四方"]=232,
\t\t["Vạn Phật Triều Tông"]=236, ["Van Phat Trieu Tong"]=236, ["van phat trieu tong"]=236, ["万佛朝宗"]=236,
\t\t["Lập Địa Thành Phật"]=241, ["Lap Dia Thanh Phat"]=241, ["lap dia thanh phat"]=241, ["立地成佛"]=241,
\t\t["Ma Ha Vô Lượng"]=237, ["Ma Ha Vo Luong"]=237, ["ma ha vo luong"]=237, ["摩诃无量"]=237,

\t\t-- Thiên Sách
\t\t["Từ Như Lâm"]=405, ["Tu Nhu Lam"]=405, ["tu nhu lam"]=405, ["徐如林"]=405,
\t\t["Thủ Như Sơn"]=407, ["Thu Nhu Son"]=407, ["thu nhu son"]=407, ["守如山"]=407,
\t\t["Ngự"]=424, ["Ngu"]=424, ["ngu"]=424, ["御"]=424,
\t\t["Định Quân"]=402, ["Dinh Quan"]=402, ["dinh quan"]=402, ["定军"]=402,
\t\t["Phá Phong"]=401, ["Pha Phong"]=401, ["pha phong"]=401, ["破风"]=401,
\t\t["Long Nha"]=415, ["long nha"]=415, ["龙牙"]=415,
\t\t["Long Ngâm"]=403, ["Long Ngam"]=403, ["long ngam"]=403, ["龙吟"]=403,
\t\t["Diệt"]=423, ["Diet"]=423, ["diet"]=423, ["灭"]=423,
\t\t["Xuyên Vân"]=400, ["Xuyen Van"]=400, ["xuyen van"]=400, ["穿云"]=400,

\t\t-- Tàng Kiếm
\t\t["Mai Ẩn Hương"]=1649, ["Mai An Huong"]=1649, ["mai an huong"]=1649, ["梅隐香"]=1649,
\t\t["Khiếu Nhật"]=1656, ["Khieu Nhat"]=1656, ["khieu nhat"]=1656, ["啸日"]=1656,
\t\t["Tuyết Đoạn Kiều"]=1609, ["Tuyet Doan Kieu"]=1609, ["tuyet doan kieu"]=1609, ["雪断桥"]=1609,
\t\t["Đoạn Triều"]=1600, ["Doan Trieu"]=1600, ["doan trieu"]=1600, ["断潮"]=1600,
\t\t["Thính Lôi"]=1646, ["Thinh Loi"]=1646, ["thinh loi"]=1646, ["听雷"]=1646,
\t\t["Cửu Khê Di Yên"]=1579, ["Cuu Khe Di Yen"]=1579, ["cuu khe di yen"]=1579, ["九溪弥烟"]=1579,
\t\t["Vân Phi Ngọc Hoàng"]=1593, ["Van Phi Ngoc Hoang"]=1593, ["van phi ngoc hoang"]=1593, ["云飞玉皇"]=1593,
\t\t["Tịch Chiếu Lôi Phong"]=1592, ["Tich Chieu Loi Phong"]=1592, ["tich chieu loi phong"]=1592, ["夕照雷峰"]=1592,

\t\t-- Đường Môn
\t\t["Tập Trung"]=3100, ["Tap Trung"]=3100, ["tap trung"]=3100, ["集中"]=3100,
\t\t["Truy Mệnh Tiễn"]=3098, ["Truy Menh Tien"]=3098, ["truy menh tien"]=3098, ["追命箭"]=3098,
\t\t["Hóa Huyết Tiêu"]=3087, ["Hoa Huyet Tieu"]=3087, ["hoa huyet tieu"]=3087, ["化血镖"]=3087,
\t\t["Bạo Vũ Lê Hoa Châm"]=3093, ["Bao Vu Le Hoa Cham"]=3093, ["bao vu le hoa cham"]=3093, ["暴雨梨花针"]=3093,
\t\t["Trục Tinh Tiễn"]=3095, ["Truc Tinh Tien"]=3095, ["truc tinh tien"]=3095, ["逐星箭"]=3095,
\t\t["Đoạt Phách Tiễn"]=3088, ["Doat Phach Tien"]=3088, ["doat phach tien"]=3088, ["夺魄箭"]=3088,
\t\t["Thực Cơ Đạn"]=3105, ["Thuc Co Dan"]=3105, ["thuc co dan"]=3105, ["蚀肌弹"]=3105,

\t\t-- Minh Giáo
\t\t["Tham Ma Thể"]=3965, ["Tham Ma The"]=3965, ["tham ma the"]=3965, ["贪魔体"]=3965,
\t\t["Thánh Minh Hựu"]=3966, ["Thanh Minh Huu"]=3966, ["thanh minh huu"]=3966, ["圣明佑"]=3966,
\t\t["Từ Bi Nguyện"]=3972, ["Tu Bi Nguyen"]=3972, ["tu bi nguyen"]=3972, ["慈悲愿"]=3972,
\t\t["Giới Hỏa Trảm"]=3973, ["Gioi Hoa Tram"]=3973, ["gioi hoa tram"]=3973, ["戒火斩"]=3973,
\t\t["Hoàng Nhật Chiếu"]=3975, ["Hoang Nhat Chieu"]=3975, ["hoang nhat chieu"]=3975, ["极乐引"]=3975,
\t\t["Tịnh Thế Phá Ma Kích"]=3967, ["Tinh The Pha Ma Kich"]=3967, ["tinh the pha ma kich"]=3967, ["净世破魔击"]=3967,
\t\t["Khu Dạ Đoạn Sầu"]=3979, ["Khu Da Doan Sau"]=3979, ["khu da doan sau"]=3979, ["驱夜断愁"]=3979,
\t\t["Liệt Nhật Trảm"]=3960, ["Liet Nhat Tram"]=3960, ["liet nhat tram"]=3960, ["烈日斩"]=3960,
\t\t["Ngân Nguyệt Trảm"]=3963, ["Ngan Nguyet Tram"]=3963, ["ngan nguyet tram"]=3963, ["银月斩"]=3963,
\t\t["Xích Nhật Luân"]=3959, ["Xich Nhat Luan"]=3959, ["xich nhat luan"]=3959, ["赤日轮"]=3959,
\t\t["U Nguyệt Luân"]=3962, ["U Nguyet Luan"]=3962, ["u nguyet luan"]=3962, ["幽月轮"]=3962,
\t\t''' + target_needle
    core_text = core_text.replace(target_needle, new_static_skills, 1)

# Check if new static buffs already added
if '["Toái Tinh Thần"] = 378' not in core_text:
    target_buff_needle = '["Thương Dương Chỉ"] = 666,'
    new_static_buffs = '''-- Thuần Dương
\t["Tọa Vong Vô Ngã"] = 305, ["Toa Vong Vo Nga"] = 305, ["Tọa Vọng Vô Ngã"] = 305, ["Toa Vong"] = 305, ["坐忘无我"] = 305,
\t["Toái Tinh Thần"] = 378, ["Toai Tinh Than"] = 378, ["toai tinh than"] = 378, ["碎星辰"] = 378,
\t["Phá Thương Khung"] = 375, ["Pha Thuong Khung"] = 375, ["pha thuong khung"] = 375, ["破苍穹"] = 375,
\t["Hóa Tam Thanh"] = 373, ["Hoa Tam Thanh"] = 373, ["hoa tam thanh"] = 373, ["化三清"] = 373,

\t-- Thiên Sách
\t["Lưu Huyết"] = 3442, ["Luu Huyet"] = 3442, ["luu huyet"] = 3442, ["流血"] = 3442,
\t["Trí Tàn"] = 540, ["Tri Tan"] = 540, ["tri tan"] = 540, ["致残"] = 540,

\t-- Tàng Kiếm
\t["Mai Ẩn Hương"] = 1649, ["Mai An Huong"] = 1649, ["mai an huong"] = 1649, ["梅隐香"] = 1649,

\t-- Đường Môn
\t["Truy Mệnh Vô Thanh"] = 3317, ["Truy Menh Vo Thanh"] = 3317, ["truy menh vo thanh"] = 3317, ["追命无声"] = 3317,
\t["Hóa Huyết Tiêu"] = 2237, ["Hoa Huyet Tieu"] = 2237, ["hoa huyet tieu"] = 2237, ["化血镖"] = 2237,

\t-- Minh Giáo
\t["Ám Trần Di Sơn"] = 4052, ["Am Tran Di Son"] = 4052, ["am tran di son"] = 4052, ["暗尘弥散"] = 4052,

\t''' + target_buff_needle
    core_text = core_text.replace(target_buff_needle, new_static_buffs, 1)

# Ensure XMCore_FindBuff checks tStaticBuffNames
find_buff_target = '''    local raw, id, needLv = XMCore_ParseBuffToken(token)
    local list = MyGetBuffList(obj) or {}
    local myID = UI_GetClientPlayerID and UI_GetClientPlayerID() or nil'''

find_buff_replacement = '''    local raw, id, needLv = XMCore_ParseBuffToken(token)
    local list = MyGetBuffList(obj) or {}
    local myID = UI_GetClientPlayerID and UI_GetClientPlayerID() or nil

    if not id and tStaticBuffNames and token then
        id = tStaticBuffNames[token] or tStaticBuffNames[string.lower(tostring(token))]
    end'''

if 'if not id and tStaticBuffNames and token then' not in core_text:
    core_text = core_text.replace(find_buff_target, find_buff_replacement, 1)

# Also ensure XMCore_FindBuff checks both id and Table_GetBuffName
find_buff_cmp_target = '''        if sourceOK and (not needLv or lv == needLv) then
            if id and tonumber(v.dwID) == id then
                return v
            elseif not id then
                local name = Table_GetBuffName(v.dwID, lv)
                if XMCore_SameName(name, raw) then return v end
            end
        end'''

find_buff_cmp_replacement = '''        if sourceOK and (not needLv or lv == needLv) then
            if id and tonumber(v.dwID) == id then
                return v
            else
                local name = Table_GetBuffName and Table_GetBuffName(v.dwID, lv)
                if name and XMCore_SameName(name, raw) then return v end
            end
        end'''

if find_buff_cmp_target in core_text:
    core_text = core_text.replace(find_buff_cmp_target, find_buff_cmp_replacement, 1)

write_bom_file(core_macro_path, core_text)

# 3. Update sync_api_rotations.py
print("3. Updating BDMacro-export/tools/sync_api_rotations.py...")
sync_api_path = EXPORT / "tools" / "sync_api_rotations.py"
sync_lines = []
with open(sync_api_path, "r", encoding="utf-8-sig") as f:
    orig_code = f.read()

# Replace scripts dictionary in sync_api_rotations.py
start_idx = orig_code.find("scripts = {")
end_idx = orig_code.find("lua_lines = [")
if start_idx != -1 and end_idx != -1:
    new_scripts_code = '''scripts = {
    10002: {
        "school": "ThieuLam",
        "profile": "TayTuyKinh",
        "alias": "TLTT",
        "name": "ThieuLam_TayTuyKinh_80",
        "script": """#name ThieuLam_TayTuyKinh_80
/skill [life<0.35] Vô Tướng Quyết
/skill [life<0.40] Đoán Cốt Quyết
/skill [qidian<1] Cầm Long Quyết
/skill [distance<=4] Vạn Phật Triều Tông
/skill [distance<=4,qidian>=3] Lập Địa Thành Phật
/skill [distance<=4,qidian>=3] Vi Đà Hiến Chử
/skill [distance<=4] Ma Ha Vô Lượng
/skill [distance<=5] Hoành Tảo Lục Hợp
/skill [distance<=4] Phổ Độ Tứ Phương"""
    },
    10003: {
        "school": "ThieuLam",
        "profile": "DichCanKinh",
        "alias": "TL",
        "name": "ThieuLam_DichCanKinh_80",
        "script": """#name ThieuLam_DichCanKinh_80
/skill [life<0.35] Vô Tướng Quyết
/skill [mana<0.40,qidian>=3] Diệc Khô Diệc Vinh
/skill [qidian<1] Cầm Long Quyết
/skill [distance<=4,qidian>=3,tlife<0.30] Nã Vân Thức
/skill [distance<=4,qidian>=3] Kim Cương Nộ Mục
/skill [distance<=4,qidian>=3] Vi Đà Hiến Chử
/skill [distance<=5] Thủ Khuyết Thức
/skill [distance<=8] Đảo Hư Thức
/skill [distance<=5,qidian<3] Hoành Tảo Lục Hợp
/skill [distance<=4] Phổ Độ Tứ Phương"""
    },
    10014: {
        "school": "ThuanDuong",
        "profile": "ThaiHuKiemY",
        "alias": "TDTK",
        "name": "ThuanDuong_ThaiHuKiemY_80",
        "script": """#name ThuanDuong_ThaiHuKiemY_80
/skill [nobuff:Tọa Vong Vô Ngã] Tọa Vong Vô Ngã
/skill [nobuff:Toái Tinh Thần] Toái Tinh Thần
/skill [mana<0.40,nobuff:Hóa Tam Thanh] Hóa Tam Thanh
/skill [mana<0.40,qidian>=8] Bão Nguyên Quy Nhất
/skill [distance<=4,tlife<0.40] Bát Hoang Quy Nguyên
/skill [distance<=4,qidian>=8] Vô Ngã Vô Kiếm
/skill [distance<=4,qidian<=7] Bát Hoang Quy Nguyên
/skill [distance<=4] Tam Hoàn Quy Nguyệt
/skill [distance<=4] Kiếm Phi Kinh Thiên
/skill [qidian<8] Ngưng Thần Tụ Khí
/skill [nofight,qidian<10] Ngưng Thần Tụ Khí"""
    },
    10015: {
        "school": "ThuanDuong",
        "profile": "TuHaCong",
        "alias": "TDTH",
        "name": "ThuanDuong_TuHaCong_80",
        "script": """#name ThuanDuong_TuHaCong_80
/skill [nobuff:Tọa Vong Vô Ngã] Tọa Vong Vô Ngã
/skill [nobuff:Phá Thương Khung] Phá Thương Khung
/skill [mana<0.40,nobuff:Hóa Tam Thanh] Hóa Tam Thanh
/skill [mana<0.60,qidian>=8] Bão Nguyên Quy Nhất
/skill [distance<=20,qidian>=8] Lưỡng Nghi Hóa Hình
/skill [distance<=20,qidian<=7] Tứ Tượng Luân Hồi
/skill [distance<=20] Thái Cực Vô Cực
/skill [qidian<8] Ngưng Thần Tụ Khí
/skill [nofight,qidian<10] Ngưng Thần Tụ Khí"""
    },
    10021: {
        "school": "VanHoa",
        "profile": "HoaGian",
        "alias": "VH",
        "name": "VanHoa_HoaGian_80",
        "script": """#name VanHoa_HoaGian_80
/skill [life<0.4] Xuân Nê Hộ Hoa
/skill [mana<0.4] Bích Thủy Thao Thiên
/skill [tprepare] Quyết Âm Chỉ
/skill [nocd:Thủy Nguyệt Vô Gian,nombuff:Lan Thôi Ngọc Chiết] Thủy Nguyệt Vô Gian
/skill [buff:Thủy Nguyệt Vô Gian,nombuff:Lan Thôi Ngọc Chiết] Lan Thôi Ngọc Chiết
/skill [nombuff:Thương Dương Chỉ] Thương Dương Chỉ
/skill [nombuff:Chung Linh Dục Tú] Chung Linh Dục Tú
/skill [mbuff:Thương Dương Chỉ,mbuff:Chung Linh Dục Tú,cdtime:Ngọc Thạch Câu Phần>0] Loạn Tửu Thanh Hà
/skill [buff:Loạn Tửu Thanh Hà] Dương Minh Chỉ
/skill [mbuff:Lan Thôi Ngọc Chiết,mbuff:Thương Dương Chỉ,mbuff:Chung Linh Dục Tú] Ngọc Thạch Câu Phần
/skill [distance<=20] Dương Minh Chỉ"""
    },
    10026: {
        "school": "ThienSach",
        "profile": "DPS",
        "alias": "TS",
        "name": "ThienSach_NgaoHuyet_80",
        "script": """#name ThienSach_NgaoHuyet_80
/skill [mana<0.50] Từ Như Lâm
/skill [life<0.30] Thủ Như Sơn
/skill [distance<=4,xmtnobuff:Lưu Huyết] Phá Phong
/skill [distance<=4,xmtbuff:Trí Tàn] Long Nha
/skill [distance<=4,xmtbuff:Trí Tàn] Diệt
/skill [distance<=4] Long Ngâm
/skill [distance<=4,tlife<0.30] Diệt
/skill [distance<=4] Xuyên Vân"""
    },
    10062: {
        "school": "ThienSach",
        "profile": "ThietLao",
        "alias": "TSTL",
        "name": "ThienSach_ThietLao_80",
        "script": """#name ThienSach_ThietLao_80
/skill [life<0.35] Thủ Như Sơn
/skill [life<0.60] Ngự
/skill [mana<0.50] Từ Như Lâm
/skill [distance<=4] Định Quân
/skill [distance<=4,xmtnobuff:Lưu Huyết] Phá Phong
/skill [distance<=4,xmtbuff:Trí Tàn] Long Nha
/skill [distance<=4] Long Ngâm
/skill [distance<=4] Diệt
/skill [distance<=4] Xuyên Vân"""
    },
    10081: {
        "school": "ThatTu",
        "profile": "BangTam",
        "alias": "7T",
        "name": "ThatTu_BangTam_80",
        "script": """#name ThatTu_BangTam_80
/config channel-on
/skill [xmtbuffstack:Cấp Khúc>=3] Phồn Âm Cấp Tiết
/skill [mana<0.85] Long Trì Nhạc
/skill [qidian<=2] Mãn Đường Thế
/skill [qidian>0,mana>0.15,distance<10] Kiếm Thần Vô Ngã
/skill [qidian>=7] Kiếm Phá Hư Không
/skill [qidian>=4,xmtbuffstack:Cấp Khúc>=3] Kiếm Khí Trường Giang
/skill Đại Huyền Cấp Khúc"""
    },
    10144: {
        "school": "TangKiem",
        "profile": "DPS",
        "alias": "TK",
        "name": "TangKiem_VanThuy_80",
        "script": """#name TangKiem_VanThuy_80
/skill [distance<=8,xmtnobuff:Mai Ẩn Hương] Mai Ẩn Hương
/skill [rage>=95] Khiếu Nhật
/skill [rage<=30] Tuyết Đoạn Kiều
/skill [distance<=4] Vân Phi Ngọc Hoàng
/skill [distance<=4] Tịch Chiếu Lôi Phong
/skill [distance<=4] Thính Lôi
/skill [distance<=4] Đoạn Triều
/skill [distance<=4] Cửu Khê Di Yên"""
    },
    10145: {
        "school": "TangKiem",
        "profile": "DPS",
        "alias": "TK",
        "name": "TangKiem_SonCu_80",
        "script": """#name TangKiem_SonCu_80
/skill [distance<=8,xmtnobuff:Mai Ẩn Hương] Mai Ẩn Hương
/skill [rage<=15] Khiếu Nhật
/skill [distance<=4] Vân Phi Ngọc Hoàng
/skill [distance<=4] Tịch Chiếu Lôi Phong
/skill [distance<=4] Thính Lôi
/skill [distance<=4] Đoạn Triều
/skill [distance<=4] Cửu Khê Di Yên"""
    },
    10175: {
        "school": "NguDoc",
        "profile": "DocKinh",
        "alias": "ND",
        "name": "NguDoc_DocKinh_80",
        "script": """#name NguDoc_DocKinh_80
/skill [life<0.5,pet] Cổ Trùng Cuồng Bạo
/skill [pet:Linh Xà] Ảo Kích
/skill [pet] Tấn công
/skill [nopet,nocd:Linh Xà Dẫn] Linh Xà Dẫn
/skill [nopet,nocd:Ngọc Thiềm Dẫn] Ngọc Thiềm Dẫn
/skill [nopet,nocd:Thánh Hạt Dẫn] Thánh Hạt Dẫn
/skill [pet] Cổ Trùng Hiến Tế
/skill [nocd:Bách Túc] Bách Túc
/skill [nombuff:Xà Ảnh,nolastcast:Xà Ảnh] Xà Ảnh
/skill [nombuff:Thiềm Khiếu] Thiềm Khiếu
/skill [moving] Thiên Ti
/skill [cd:Bách Túc] Hạt Tâm"""
    },
    10176: {
        "school": "NguDoc",
        "profile": "BoThien",
        "alias": "NDBT",
        "name": "NguDoc_BoThien_80",
        "script": """#name NguDoc_BoThien_80
/skill [nopet] Bích Điệp Dẫn
/skill [life<0.35] Nữ Oa Vá Trời
/skill [life<0.3,pet] Cổ Trùng Hiến Tế
/skill [tlife<0.35] Thánh Thủ Chức Thiên
/skill [tlife<0.45] Thiên Điệp Thổ Thụy
/skill [tlife<0.85,tnobuff:Cổ Hoặc Chúng Sinh] Cổ Hoặc Chúng Sinh
/skill [tlife<0.6] Nữ Oa Vá Trời
/skill [moving,tlife<0.95] Túy Vũ Cửu Thiên
/skill [tlife<0.75] Băng Tàm Khiên Ti
/skill [tlife<0.95] Túy Vũ Cửu Thiên
/skill Băng Tàm Khiên Ti"""
    },
    10224: {
        "school": "DuongMon",
        "profile": "KinhVu",
        "alias": "DMKV",
        "name": "DuongMon_KinhVu_80",
        "script": """#name DuongMon_KinhVu_80
/skill [energy<35] Tập Trung
/skill [distance<=25,xmbuff:Truy Mệnh Vô Thanh] Truy Mệnh Tiễn
/skill [distance<=25,energy>=20,xmtnobuff:Hóa Huyết Tiêu] Hóa Huyết Tiêu
/skill [distance<=25,energy>=30] Bạo Vũ Lê Hoa Châm
/skill [distance<=25,energy<=70] Trục Tinh Tiễn
/skill [distance<=25,energy>=30] Đoạt Phách Tiễn"""
    },
    10225: {
        "school": "DuongMon",
        "profile": "ThienLa",
        "alias": "DMTL",
        "name": "DuongMon_ThienLa_80",
        "script": """#name DuongMon_ThienLa_80
/skill [energy<40] Tập Trung
/skill [distance<=25,energy>=20,xmtnobuff:Hóa Huyết Tiêu] Hóa Huyết Tiêu
/skill [distance<=25,energy>=30] Bạo Vũ Lê Hoa Châm
/skill [distance<=25,energy>=30] Thực Cơ Đạn
/skill [distance<=25,energy>=15] Đoạt Phách Tiễn"""
    },
    10242: {
        "school": "MinhGiao",
        "profile": "PhanAnh",
        "alias": "MG",
        "name": "MinhGiao_PhanAnh_80",
        "script": """#name MinhGiao_PhanAnh_80
/skill [life<0.30] Tham Ma Thể
/skill [distance<=5,fullsun] Tịnh Thế Phá Ma Kích
/skill [distance<=5,fullmoon] Tịnh Thế Phá Ma Kích
/skill [distance<=5,xmbuff:Ám Trần Di Sơn] Khu Dạ Đoạn Sầu
/skill [distance<=5] Ngân Nguyệt Trảm
/skill [distance<=5] Liệt Nhật Trảm
/skill [distance<=5,sun>=moon] U Nguyệt Luân
/skill [distance<=5] Xích Nhật Luân"""
    },
    10243: {
        "school": "MinhGiao",
        "profile": "MinhTon",
        "alias": "MGMT",
        "name": "MinhGiao_MinhTon_80",
        "script": """#name MinhGiao_MinhTon_80
/skill [life<0.30] Tham Ma Thể
/skill [life<0.40,fullsun] Thánh Minh Hựu
/skill [distance<=5] Từ Bi Nguyện
/skill [distance<=8] Giới Hỏa Trảm
/skill [distance<=5] Hoàng Nhật Chiếu
/skill [distance<=5,fullsun] Tịnh Thế Phá Ma Kích
/skill [distance<=5,fullmoon] Tịnh Thế Phá Ma Kích
/skill [distance<=5,sun>=moon] Liệt Nhật Trảm
/skill [distance<=5,moon>sun] Ngân Nguyệt Trảm
/skill [distance<=5,sun>=moon] Xích Nhật Luân
/skill [distance<=5] U Nguyệt Luân"""
    }
}
'''
    updated_sync_api = orig_code[:start_idx] + new_scripts_code + orig_code[end_idx:]
    write_bom_file(sync_api_path, updated_sync_api)

# 4. Run build_native.py --addon interface/xMacro
print("4. Running build_native.py --addon interface/xMacro...")
subprocess.run([sys.executable, str(EXPORT / "tools" / "build_native.py"), "--addon", str(ADDON)], check=True)

# 5. Mirror all School files from BDMacro-export/Schools/ to interface/xMacro/Schools/
print("5. Mirroring all School profiles to interface/xMacro/Schools/...")
for path in (EXPORT / "Schools").rglob("*.lua"):
    rel = path.relative_to(EXPORT / "Schools")
    dest = ADDON / "Schools" / rel
    write_bom_file(dest, path.read_text(encoding="utf-8-sig"))

# Also update the root KinhVu.lua and ThienLa.lua in interface/xMacro/Schools/
write_bom_file(ADDON / "Schools" / "KinhVu.lua", (EXPORT / "Schools/DuongMon/KinhVu.lua").read_text(encoding="utf-8-sig"))
write_bom_file(ADDON / "Schools" / "ThienLa.lua", (EXPORT / "Schools/DuongMon/ThienLa.lua").read_text(encoding="utf-8-sig"))

# Also mirror to xMacro-v80-HCNC-0.9.7-addon
print("6. Mirroring to xMacro-v80-HCNC-0.9.7-addon...")
for path in (EXPORT / "Schools").rglob("*.lua"):
    rel = path.relative_to(EXPORT / "Schools")
    dest = STAGING_ADDON / "Schools" / rel
    write_bom_file(dest, path.read_text(encoding="utf-8-sig"))
write_bom_file(STAGING_ADDON / "Schools" / "KinhVu.lua", (EXPORT / "Schools/DuongMon/KinhVu.lua").read_text(encoding="utf-8-sig"))
write_bom_file(STAGING_ADDON / "Schools" / "ThienLa.lua", (EXPORT / "Schools/DuongMon/ThienLa.lua").read_text(encoding="utf-8-sig"))

# Sync Native to STAGING_ADDON
for native_file in (ADDON / "Native").glob("*.lua"):
    write_bom_file(STAGING_ADDON / "Native" / native_file.name, native_file.read_text(encoding="utf-8-sig"))
write_bom_file(STAGING_ADDON / "Runtime.lua", (ADDON / "Runtime.lua").read_text(encoding="utf-8-sig"))
write_bom_file(STAGING_ADDON / "info.ini", (ADDON / "info.ini").read_text(encoding="utf-8-sig"))

# 7. Run sync_api_rotations.py
print("7. Running sync_api_rotations.py...")
subprocess.run([sys.executable, str(EXPORT / "tools" / "sync_api_rotations.py")], check=True)

# 8. Run repack_release.py
print("8. Running repack_release.py...")
subprocess.run([sys.executable, str(EXPORT / "tools" / "repack_release.py")], check=True)

# 9. Run verify_macro.py --fix
print("9. Running verify_macro.py --fix...")
subprocess.run([sys.executable, str(ADDON / "Tools" / "verify_macro.py"), "--fix"], check=True)

print("\nAll tasks completed successfully!")
