-- Minh Tôn Lưu Hỏa Thể (10243) - Nội công Tank Minh Giáo v80
-- Kỹ năng: Tham Ma Thể (3965), Thánh Minh Hựu (3966), Từ Bi Nguyện (3972 - Taunt cừu hận chính),
-- Giới Hỏa Trảm (3973), Hoàng Nhật Chiếu (3975), Tịnh Thế Phá Ma Kích (3967),
-- Liệt Nhật Trảm (3960), Ngân Nguyệt Trảm (3963), Xích Nhật Luân (3959), U Nguyệt Luân (3962).
xMacro.Schools.RegisterDamageScript("MinhGiao", "MinhTon", {[10243] = [[
#name MinhGiao_MinhTon_80
/skill [life<0.30] 3965
/skill [life<0.40,fullsun] 3966
/skill [distance<=5] 3972
/skill [distance<=8] 3973
/skill [distance<=5] 3975
/skill [distance<=5,fullsun] 3967
/skill [distance<=5,fullmoon] 3967
/skill [distance<=5,sun>=moon] 3960
/skill [distance<=5,moon>sun] 3963
/skill [distance<=5,sun>=moon] 3959
/skill [distance<=5] 3962
]]})
