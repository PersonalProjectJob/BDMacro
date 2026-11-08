-- Thái Hư Kiếm Ý (10014) - Nội công DPS Kiếm Thuần Dương v80
-- Khí trường: Toái Tinh Thần (tăng bạo kích ngoại công và sát thương bạo kích).
-- Tự hồi mana bằng Bão Nguyên Quy Nhất khi mana < 40% và Khí Điểm >= 8.
-- Chuỗi dồn sát thương: Bát Hoang Quy Nguyên + Vô Ngã Vô Kiếm (khi Khí Điểm >= 8).
-- Tích khí điểm: Tam Hoàn Sáo Nguyệt / Tam Hoàn Quy Nguyệt + Thiên Địa Vô Cực.
-- Kẹp Ngưng Thần Tụ Khí trong GCD (卡凝神) đỉnh cao để tích thêm khí điểm.
xMacro.Schools.RegisterDamageScript("ThuanDuong", "ThaiHuKiemY", {[10014] = [[
#name ThuanDuong_ThaiHuKiemY_80
/skill [nobuff:Toái Tinh Thần] Toái Tinh Thần
/skill [mana<0.40,qidian>=8] Bão Nguyên Quy Nhất
/skill [distance<=4,tlife<0.40] Bát Hoang Quy Nguyên
/skill [distance<=4,qidian>=8] Vô Ngã Vô Kiếm
/skill [distance<=4] Bát Hoang Quy Nguyên
/skill [distance<=4] Thiên Địa Vô Cực
/skill [distance<=4,qidian<8] Tam Hoàn Sáo Nguyệt
/skill [distance<=4,qidian<8] Tam Hoàn Quy Nguyệt
/skill [distance<=4] Tam Hoàn Sáo Nguyệt
/skill [qidian<10] Ngưng Thần Tụ Khí
]]})
