-- Thiên La Quỷ Đạo, direct-target damage. Place traps and the turret manually.
-- Classic skill IDs from DKMacro/DuongMon.lua.
xMacro.Schools.RegisterDamageScript("DuongMon", "ThienLa", {[10225] = [[
#name DuongMon_ThienLa_80
/skill [distance<=25,energy>=20,xmtnobuff:2237] 3087
/skill [distance<=25,energy>=30] 3093
/skill [distance<=25,energy>=30] 3105
/skill [distance<=25,energy>=15] 3088
/skill [energy<30] 3100
]]})
