-- Phần Ảnh Thánh Quyết. Base solar/lunar cycle, without level-90 talents.
-- IDs cross-checked against DKMacro/MinhGiao.lua.
xMacro.Schools.RegisterDamageScript("MinhGiao", "PhanAnh", {[10242] = [[
#name MinhGiao_PhanAnh_80
/skill [distance<=5,fullsun] 3967
/skill [distance<=5,fullmoon] 3967
/skill [distance<=5,xmbuff:4052] 3979
/skill [distance<=5] 3963
/skill [distance<=5] 3960
/skill [distance<=5,sun>=moon] 3962
/skill [distance<=5] 3959
]]})
