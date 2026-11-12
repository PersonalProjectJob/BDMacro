-- Tử Hà Công (10015) - Nội công DPS Khí Thuần Dương v80
-- Kỹ năng: Tọa Vọng Vô Ngã, Bão Nguyên Thủ Khuyết,
-- Lưỡng Nghi Hóa Hình, Tứ Tượng Luân Hồi, Thái Cực Vô Cực.
-- Duy trì Phá Thương Khung, Hóa Tam Thanh và kẹp Ngưng Thần Tụ Khí.
xMacro.Schools.RegisterDamageScript("ThuanDuong", "TuHaCong", {[10015] = [[
#name ThuanDuong_TuHaCong_80
/skill [nobuff:Tọa Vọng Vô Ngã] Tọa Vọng Vô Ngã
/skill [nobuff:Phá Thương Khung] Phá Thương Khung
/skill [mana<0.40,nobuff:Hóa Tam Thanh] Hóa Tam Thanh
/skill [mana<0.60,qidian>=8] Bão Nguyên Thủ Khuyết
/skill [qidian>=8] Lưỡng Nghi Hóa Hình
/skill Tứ Tượng Luân Hồi
/skill Thái Cực Vô Cực
/skill [qidian<8] Ngưng Thần Tụ Khí
/skill [nofight,qidian<10] Ngưng Thần Tụ Khí
]]})
