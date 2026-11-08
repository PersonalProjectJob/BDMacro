-- Thiên La Quỹ Đạo (10225) - Nội công DPS Cơ quan Đường Môn v80
-- Kỹ năng: Tập Trung, Hóa Huyết Tiêu,
-- Bạo Vũ Lê Hoa Châm, Thực Cơ Đạn, Đoạt Phách Tiễn.
xMacro.Schools.RegisterDamageScript("DuongMon", "ThienLa", {[10225] = [[
#name DuongMon_ThienLa_80
/skill [energy<40] Tập Trung
/skill [distance<=25,energy>=20,xmtnobuff:Hóa Huyết Tiêu] Hóa Huyết Tiêu
/skill [distance<=25,energy>=30] Bạo Vũ Lê Hoa Châm
/skill [distance<=25,energy>=30] Thực Cơ Đạn
/skill [distance<=25,energy>=15] Đoạt Phách Tiễn
]]})
