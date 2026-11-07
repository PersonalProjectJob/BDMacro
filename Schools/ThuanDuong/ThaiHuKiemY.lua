-- Thái Hư Kiếm Ý, direct melee priority with classical khí điểm thresholds.
-- IDs cross-checked against DKMacro/ThuanDuong.lua.
xMacro.Schools.RegisterDamageScript("ThuanDuong", "ThaiHuKiemY", {[10015] = [[
#name ThuanDuong_ThaiHuKiemY_80
/skill [distance<=4,qidian>=8] 365
/skill [distance<=4,qidian<=7] 2699
/skill [distance<=4] 364
]]})
