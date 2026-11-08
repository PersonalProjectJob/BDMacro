-- Minh Tôn Lưu Hỏa Thể (10243) - Nội công Tank Minh Giáo v80
-- Kỹ năng: Tham Ma Thể, Thánh Minh Hựu, Từ Bi Nguyện (Taunt cừu hận chính),
-- Giới Hỏa Trảm, Hoàng Nhật Chiếu, Tịnh Thế Phá Ma Kích,
-- Liệt Nhật Trảm, Ngân Nguyệt Trảm, Xích Nhật Luân, U Nguyệt Luân.
xMacro.Schools.RegisterDamageScript("MinhGiao", "MinhTon", {[10243] = [[
#name MinhGiao_MinhTon_80
/skill [life<0.30] Tham Ma Thể
/skill [life<0.40,fullsun] Thánh Minh Hựu
/skill [distance<=5] Từ Bi Nguyện
/skill [distance<=8] Giới Hỏa Trảm
/skill [distance<=5] Hoàng Nhật Chiếu
/skill [distance<=5,fullsun] Tịnh Thế Phá Ma Kích
/skill [distance<=5,fullmoon] Tịnh Thế Phá Ma Kích
/skill [distance<=5,sun>=moon] Liệt Nhật Trảm
/skill [distance<=5,moon>sun] Ngân Nguyệt Trảm
/skill [distance<=5,sun>=moon] Xích Nhật Luân
/skill [distance<=5] U Nguyệt Luân
]]})
