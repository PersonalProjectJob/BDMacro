-- Tẩy Tủy Kinh (10002) - Nội công Tank Thiếu Lâm v80
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
