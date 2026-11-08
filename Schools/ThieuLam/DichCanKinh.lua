-- Dịch Cân Kinh (10003) - Nội công DPS Thiếu Lâm v80
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
