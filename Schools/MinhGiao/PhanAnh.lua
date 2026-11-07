-- Phần Ảnh Thánh Quyết (10242) - Nội công DPS Minh Giáo v80
-- Kỹ năng: Tham Ma Thể (3965), Tịnh Thế Phá Ma Kích (3967), Khu Dạ Đoạn Sầu (3979),
-- Ngân Nguyệt Trảm (3963), Liệt Nhật Trảm (3960), U Nguyệt Luân (3962), Xích Nhật Luân (3959).
xMacro.Schools.RegisterDamageScript("MinhGiao", "PhanAnh", {[10242] = [[
#name MinhGiao_PhanAnh_80
/skill [life<0.30] 3965
/skill [distance<=5,fullsun] 3967
/skill [distance<=5,fullmoon] 3967
/skill [distance<=5,xmbuff:4052] 3979
/skill [distance<=5] 3963
/skill [distance<=5] 3960
/skill [distance<=5,sun>=moon] 3962
/skill [distance<=5] 3959
]]})
