-- Minh Tôn Lưu Hỏa Thể (10243) - Nội công Tank Minh Giáo v80
-- Kỹ năng: Tính Mệnh Hải / Tham Ma Thể, Quang Minh Tướng, Thánh Minh Hựu,
-- Tịnh Thế Phá Ma Kích, Hoàng Nhật Chiếu, Liệt Nhật Trảm, Ngân Nguyệt Trảm,
-- Giới Hỏa Trảm, Quy Tịch Đạo, Xích Nhật Luân.
xMacro.Schools.RegisterDamageScript("MinhGiao", "MinhTon", {[10243] = [[
#name MinhGiao_MinhTon_80
/skill [life<=0.3] Tính Mệnh Hải
/skill [life<=0.3] Tham Ma Thể
/skill [life<=0.5,sun_power] Quang Minh Tướng
/skill [life<=0.5,sun_power|moon_power] Thánh Minh Hựu
/skill Tịnh Thế Phá Ma Kích
/skill [nearby_enemy>3] Hoàng Nhật Chiếu
/skill Liệt Nhật Trảm
/skill Ngân Nguyệt Trảm
/skill Giới Hỏa Trảm
/skill Quy Tịch Đạo
/skill Xích Nhật Luân
]]})
