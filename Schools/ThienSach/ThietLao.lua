-- Thiết Lao Luật (10062) - Nội công Tank Thiên Sách v80
-- Kỹ năng: Thủ Như Sơn, Ngự, Từ Như Lâm,
-- Định Quân (Taunt cừu hận chính), Phá Phong (duy trì debuff Lưu Huyết),
-- Long Nha (khi có Trí Tàn tạo cừu hận lớn), Long Ngâm, Diệt, Xuyên Vân.
xMacro.Schools.RegisterDamageScript("ThienSach", "ThietLao", {[10062] = [[
#name ThienSach_ThietLao_80
/skill [life<0.35] Thủ Như Sơn
/skill [life<0.60] Ngự
/skill [mana<0.50] Từ Như Lâm
/skill [distance<=4] Định Quân
/skill [distance<=4,xmtnobuff:Lưu Huyết] Phá Phong
/skill [distance<=4,xmtbuff:Trí Tàn] Long Nha
/skill [distance<=4] Long Ngâm
/skill [distance<=4] Diệt
/skill [distance<=4] Xuyên Vân
]]})
