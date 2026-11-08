-- Phần Ảnh Thánh Quyết (10242) - Nội công DPS Minh Giáo v80
-- Kỹ năng: Tham Ma Thể, Tịnh Thế Phá Ma Kích, Khu Dạ Đoạn Sầu,
-- Ngân Nguyệt Trảm, Liệt Nhật Trảm, U Nguyệt Luân, Xích Nhật Luân.
xMacro.Schools.RegisterDamageScript("MinhGiao", "PhanAnh", {[10242] = [[
#name MinhGiao_PhanAnh_80
/skill [life<0.30] Tham Ma Thể
/skill [distance<=5,fullsun] Tịnh Thế Phá Ma Kích
/skill [distance<=5,fullmoon] Tịnh Thế Phá Ma Kích
/skill [distance<=5,xmbuff:Ám Trần Di Sơn] Khu Dạ Đoạn Sầu
/skill [distance<=5] Ngân Nguyệt Trảm
/skill [distance<=5] Liệt Nhật Trảm
/skill [distance<=5,sun>=moon] U Nguyệt Luân
/skill [distance<=5] Xích Nhật Luân
]]})
