-- Dịch Cân Kinh (10003) - Nội công DPS Thiếu Lâm v80
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
