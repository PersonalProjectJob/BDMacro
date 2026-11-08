-- Thái Hư Kiếm Ý (10014) - Nội công DPS Kiếm Thuần Dương v80
-- Tự động duy trì Khí Trường Toái Tinh Thần (362, buff 378) và Hóa Tam Thanh (357, buff 373) khi thiếu mana.
-- Kẹp Ngưng Thần Tụ Khí trong GCD (卡凝神) đỉnh cao:
-- Ngưng Thần Tụ Khí (300) không tốn GCD, tự động kích hoạt trong khe hở GCD
-- để nhận thêm khí điểm miễn phí mà không làm trễ bất kỳ chiêu thức tấn công nào!
xMacro.Schools.RegisterDamageScript("ThuanDuong", "ThaiHuKiemY", {[10014] = [[
#name ThuanDuong_ThaiHuKiemY_80
/skill [nobuff:305] 305
/skill [nobuff:378] 362
/skill [mana<0.40,nobuff:373] 357
/skill [mana<0.40,qidian>=8] 302
/skill [distance<=4,tlife<0.40] 2699
/skill [distance<=4,qidian>=8] 365
/skill [distance<=4,qidian<=7] 2699
/skill [distance<=4] 309
/skill [distance<=4] 364
/skill [qidian<8] 300
/skill [nofight,qidian<10] 300
]]})
