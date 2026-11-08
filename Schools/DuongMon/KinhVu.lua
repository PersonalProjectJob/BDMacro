-- Kinh Vũ Quyết (10224) - Nội công DPS Nỏ Đường Môn v80
-- Kỹ năng: Tập Trung, Truy Mệnh Tiễn, Hóa Huyết Tiêu,
-- Bạo Vũ Lê Hoa Châm, Trục Tinh Tiễn, Đoạt Phách Tiễn.
xMacro.Schools.RegisterDamageScript("DuongMon", "KinhVu", {[10224] = [[
#name DuongMon_KinhVu_80
/skill [energy<35] Tập Trung
/skill [distance<=25,xmbuff:Truy Mệnh Vô Thanh] Truy Mệnh Tiễn
/skill [distance<=25,energy>=20,xmtnobuff:Hóa Huyết Tiêu] Hóa Huyết Tiêu
/skill [distance<=25,energy>=30] Bạo Vũ Lê Hoa Châm
/skill [distance<=25,energy<=70] Trục Tinh Tiễn
/skill [distance<=25,energy>=30] Đoạt Phách Tiễn
]]})
