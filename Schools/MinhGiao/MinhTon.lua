-- Minh Tôn Lưu Hỏa Thể (10243) - Nội công Tank Minh Giáo v80
-- Kỹ năng: Tham Ma Thể, Thánh Minh Hựu, Từ Bi Nguyện (Taunt cừu hận chính),
-- Giới Hỏa Trảm, Hoàng Nhật Chiếu, Tịnh Thế Phá Ma Kích,
-- Liệt Nhật Trảm, Ngân Nguyệt Trảm, Xích Nhật Luân, U Nguyệt Luân.
xMacro.Schools.RegisterDamageScript("MinhGiao", "MinhTon", {[10243] = [[
#name MinhGiao_MinhTon_80
/skill [life<0.3,nombuff:Xuân Nê Hộ Hoa] Tham Ma Thể
/skill [life<0.4,fullsun] Thánh Minh Hựu
/skill Giới Hỏa Trảm
/skill Quy Tịch Đạo
-- /skill [nearby_enemy>=3] Hoàng Nhật Chiếu
/skill [fullsun;fullmoon] Tịnh Thế Phá Ma Kích
/skill [sun>=moon] Liệt Nhật Trảm
/skill [moon>sun] Ngân Nguyệt Trảm
/skill [sun>=moon] Xích Nhật Luân
/skill U Nguyệt Luân
]]})
