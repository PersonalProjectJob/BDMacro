-- Tử Hà Công, build khí điểm then use Lưỡng Nghi Hóa Hình.
-- IDs cross-checked against DKMacro/ThuanDuong.lua.
xMacro.Schools.RegisterDamageScript("ThuanDuong", "TuHaCong", {[10014] = [[
#name ThuanDuong_TuHaCong_80
/skill [distance<=20,qidian>=9] 301
/skill [distance<=20,qidian<=8] 367
/skill [distance<=20] 306
]]})
