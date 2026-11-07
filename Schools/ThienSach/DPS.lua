-- Ngạo Huyết Chiến Ý. IDs cross-checked against DKMacro/ThienSach.lua.
xMacro.Schools.RegisterDamageScript("ThienSach", "DPS", {[10026] = [[
#name ThienSach_NgaoHuyet_80
-- Phá Phong keeps Lưu Huyết active, then spend Trí Tàn on Long Nha.
/skill [distance<=4,xmtnobuff:3442] 401
/skill [distance<=4,xmtbuff:540] 415
/skill [distance<=4] 403
/skill [distance<=4,tlife<0.30] 423
/skill [distance<=4] 400
]]})
