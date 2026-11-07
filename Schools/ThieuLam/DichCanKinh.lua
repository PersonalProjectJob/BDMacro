-- Dịch Cân Kinh, three-point damage spenders and classic point builders.
-- IDs cross-checked against DKMacro/ThieuLam.lua.
xMacro.Schools.RegisterDamageScript("ThieuLam", "DichCanKinh", {[10003] = [[
#name ThieuLam_DichCanKinh_80
/skill [distance<=4,qidian>=3,tlife<0.30] 243
/skill [distance<=4,qidian>=3] 233
/skill [distance<=5] 235
/skill [distance<=8] 2572
/skill [distance<=4] 232
]]})
