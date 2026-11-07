-- Thiên La Quỹ Đạo (10225) - Nội công DPS Cơ quan Đường Môn v80
-- Kỹ năng: Tập Trung (3100), Hóa Huyết Tiêu (3087 - debuff 2237),
-- Bạo Vũ Lê Hoa Châm (3093), Thực Cơ Đạn (3105), Đoạt Phách Tiễn (3088).
xMacro.Schools.RegisterDamageScript("DuongMon", "ThienLa", {[10225] = [[
#name DuongMon_ThienLa_80
/skill [energy<40] 3100
/skill [distance<=25,energy>=20,xmtnobuff:2237] 3087
/skill [distance<=25,energy>=30] 3093
/skill [distance<=25,energy>=30] 3105
/skill [distance<=25,energy>=15] 3088
]]})
