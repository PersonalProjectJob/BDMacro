-- Thái Hư Kiếm Ý (10014) - Nội công DPS Kiếm Thuần Dương v80
-- Tự động duy trì Khí Trường Toái Tinh Thần và Hóa Tam Thanh khi thiếu mana.
-- Kẹp Ngưng Thần Tụ Khí trong GCD (卡凝神) đỉnh cao:
-- Ngưng Thần Tụ Khí không tốn GCD, tự động kích hoạt trong khe hở GCD
-- để nhận thêm khí điểm miễn phí mà không làm trễ bất kỳ chiêu thức tấn công nào!
xMacro.Schools.RegisterDamageScript("ThuanDuong", "ThaiHuKiemY", {[10014] = [[
#name ThuanDuong_ThaiHuKiemY_80
/skill [nobuff:Tọa Vong Vô Ngã] Tọa Vong Vô Ngã
/skill [nobuff:Toái Tinh Thần] Toái Tinh Thần
/skill [mana<0.40,nobuff:Hóa Tam Thanh] Hóa Tam Thanh
/skill [mana<0.40,qidian>=8] Bão Nguyên Quy Nhất
/skill [distance<=4,tlife<0.40] Bát Hoang Quy Nguyên
/skill [distance<=4,qidian>=8] Vô Ngã Vô Kiếm
/skill [distance<=4,qidian<=7] Bát Hoang Quy Nguyên
/skill [distance<=4] Tam Hoàn Quy Nguyệt
/skill [distance<=4] Kiếm Phi Kinh Thiên
/skill [qidian<8] Ngưng Thần Tụ Khí
/skill [nofight,qidian<10] Ngưng Thần Tụ Khí
]]})
