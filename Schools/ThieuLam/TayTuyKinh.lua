-- Tẩy Tủy Kinh (10002) - Nội công Tank Thiếu Lâm v80
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
