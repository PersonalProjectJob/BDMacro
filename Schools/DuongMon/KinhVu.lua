-- Kinh Vũ Quyết, damage priority for one selected target.
-- Hóa Huyết Tiêu (3087) applies debuff 2237. DKMacro/DuongMon.lua.
xMacro.Schools.RegisterDamageScript("DuongMon", "KinhVu", {[10224] = [[
#name DuongMon_KinhVu_80
/skill [distance<=25,energy>=20,xmtnobuff:2237] 3087
/skill [distance<=25,energy>=30] 3098
/skill [distance<=25,energy>=30] 3093
/skill [distance<=25,energy>=30] 3095
/skill [distance<=25,energy>=15] 3088
/skill [energy<30] 3100
]]})
