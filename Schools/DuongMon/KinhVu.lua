-- Kinh Vũ Quyết (10224) - Nội công DPS Nỏ Đường Môn v80
-- Kỹ năng: Tập Trung (3100), Truy Mệnh Tiễn (3098), Hóa Huyết Tiêu (3087 - debuff 2237),
-- Bạo Vũ Lê Hoa Châm (3093), Trục Tinh Tiễn (3095), Đoạt Phách Tiễn (3088).
xMacro.Schools.RegisterDamageScript("DuongMon", "KinhVu", {[10224] = [[
#name DuongMon_KinhVu_80
/skill [energy<35] 3100
/skill [distance<=25,xmbuff:3317] 3098
/skill [distance<=25,energy>=20,xmtnobuff:2237] 3087
/skill [distance<=25,energy>=30] 3093
/skill [distance<=25,energy<=70] 3095
/skill [distance<=25,energy>=30] 3088
]]})
