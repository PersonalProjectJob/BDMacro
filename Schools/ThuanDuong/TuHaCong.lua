-- Tử Hà Công (10015) - Nội công DPS Khí Thuần Dương v80
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
