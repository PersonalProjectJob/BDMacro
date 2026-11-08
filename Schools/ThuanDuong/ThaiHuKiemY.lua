-- Thái Hư Kiếm Ý (10014) - Nội công DPS Kiếm Thuần Dương v80
-- Kỹ năng: Tọa Vọng Vô Ngã (305), Bão Nguyên Thủ Khuyết (302),
-- Vô Ngã Vô Kiếm (365), Bát Hoang Quy Nguyên (2699),
-- Thiên Địa Vô Cực (309), Tam Hoàn Sáo Nguyệt (364).
xMacro.Schools.RegisterDamageScript("ThuanDuong", "ThaiHuKiemY", {[10014] = [[
#name ThuanDuong_ThaiHuKiemY_80
/skill [nobuff:305] 305
/skill [mana<0.40,qidian>=8] 302
/skill [distance<=4,tlife<0.40] 2699
/skill [distance<=4,qidian>=8] 365
/skill [distance<=4,qidian<=7] 2699
/skill [distance<=4] 309
/skill [distance<=4] 364
]]})
