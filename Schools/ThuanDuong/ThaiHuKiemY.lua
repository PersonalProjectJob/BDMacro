-- Thái Hư Kiếm Ý (10014) - Nội công DPS Kiếm Thuần Dương v80
-- Khí trường: Toái Tinh Thần (tăng bạo kích ngoại công và sát thương bạo kích).
-- Tự hồi mana bằng Bão Nguyên Quy Nhất khi mana < 40% và Khí Điểm >= 8.
-- Chuỗi dồn sát thương: Bát Hoang Quy Nguyên + Vô Ngã Vô Kiếm (khi Khí Điểm >= 8).
-- Hồi khí điểm: Tam Hoàn Sáo Nguyệt (ID 364) chỉ đánh khi các chiêu khác không khả dụng.
-- Kẹp Ngưng Thần Tụ Khí trong GCD (卡凝神) đỉnh cao để tích thêm khí điểm.
xMacro.Schools.RegisterDamageScript("ThuanDuong", "ThaiHuKiemY", {[10014] = [[
#name ThuanDuong_ThaiHuKiemY_80
/skill [nobuff:Toái Tinh Thần] Toái Tinh Thần
/skill [mana<0.40,qidian>=8] Bão Nguyên Quy Nhất
/skill [tlife<0.40] Bát Hoang Quy Nguyên
/skill [qidian>=8] Vô Ngã Vô Kiếm
/skill Bát Hoang Quy Nguyên
/skill Thiên Địa Vô Cực
/skill Tam Hoàn Sáo Nguyệt
/skill [qidian<10] Ngưng Thần Tụ Khí
]]})
