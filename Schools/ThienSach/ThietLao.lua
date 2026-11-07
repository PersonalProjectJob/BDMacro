-- Thiết Lao Luật (10062) - Nội công Tank Thiên Sách v80
-- Kỹ năng: Thủ Như Sơn (407), Ngự (424), Từ Như Lâm (405),
-- Định Quân (402 - Taunt cừu hận chính), Phá Phong (401 - duy trì debuff Lưu Huyết 3442),
-- Long Nha (415 - khi có Trí Tàn 540 tạo cừu hận lớn), Long Ngâm (403), Diệt (423), Xuyên Vân (400).
xMacro.Schools.RegisterDamageScript("ThienSach", "ThietLao", {[10062] = [[
#name ThienSach_ThietLao_80
/skill [life<0.35] 407
/skill [life<0.60] 424
/skill [mana<0.50] 405
/skill [distance<=4] 402
/skill [distance<=4,xmtnobuff:3442] 401
/skill [distance<=4,xmtbuff:540] 415
/skill [distance<=4] 403
/skill [distance<=4] 423
/skill [distance<=4] 400
]]})
