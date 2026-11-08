-- Tử Hà Công (10015) - Nội công DPS Khí Thuần Dương v80
-- Kỹ năng: Tọa Vọng Vô Ngã (305), Bão Nguyên Thủ Khuyết (302),
-- Lưỡng Nghi Hóa Hình (301), Tứ Tượng Luân Hồi (367), Thái Cực Vô Cực (306).
xMacro.Schools.RegisterDamageScript("ThuanDuong", "TuHaCong", {[10015] = [[
#name ThuanDuong_TuHaCong_80
/skill [nobuff:305] 305
/skill [mana<0.60,qidian>=8] 302
/skill [distance<=20,qidian>=8] 301
/skill [distance<=20,qidian<=7] 367
/skill [distance<=20] 306
]]})
