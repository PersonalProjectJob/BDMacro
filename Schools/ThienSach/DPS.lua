-- Ngạo Huyết Chiến Ý (10026) - Nội công DPS Thiên Sách v80
-- Kỹ năng: Từ Như Lâm (405), Thủ Như Sơn (407), Phá Phong (401 - duy trì debuff Lưu Huyết 3442),
-- Long Nha (415 - khi có Trí Tàn 540), Diệt (423), Long Ngâm (403), Xuyên Vân (400).
xMacro.Schools.RegisterDamageScript("ThienSach", "DPS", {[10026] = [[
#name ThienSach_NgaoHuyet_80
/skill [mana<0.50] 405
/skill [life<0.30] 407
/skill [distance<=4,xmtnobuff:3442] 401
/skill [distance<=4,xmtbuff:540] 415
/skill [distance<=4,xmtbuff:540] 423
/skill [distance<=4] 403
/skill [distance<=4,tlife<0.30] 423
/skill [distance<=4] 400
]]})
