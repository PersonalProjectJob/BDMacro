-- Ngạo Huyết Chiến Ý (10026) - Nội công DPS Thiên Sách v80
-- Kỹ năng: Từ Như Lâm, Thủ Như Sơn, Phá Phong (duy trì debuff Lưu Huyết),
-- Long Nha (khi có Trí Tàn), Diệt, Long Ngâm, Xuyên Vân.
xMacro.Schools.RegisterDamageScript("ThienSach", "DPS", {[10026] = [[
#name ThienSach_NgaoHuyet_80
/skill [mana<0.50] Từ Như Lâm
/skill [life<0.30] Thủ Như Sơn
/skill [distance<=4,xmtnobuff:Lưu Huyết] Phá Phong
/skill [distance<=4,xmtbuff:Trí Tàn] Long Nha
/skill [distance<=4,xmtbuff:Trí Tàn] Diệt
/skill [distance<=4] Long Ngâm
/skill [distance<=4,tlife<0.30] Diệt
/skill [distance<=4] Xuyên Vân
]]})
