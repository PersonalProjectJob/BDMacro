-- Thái Hư Kiếm Ý (10014) - Nội công DPS Kiếm Thuần Dương v80
-- Khí trường chính: Toái Tinh Thần (thả vào mục tiêu).
-- Bùng nổ sát thương: Thao Quang Dưỡng Hối khi vào chiến đấu, áp sát mục tiêu và Khí Điểm <= 4.
-- Combo kích nổ 3 khí trường: Toái Tinh Thần (mục tiêu) + Hóa Tam Thanh (mục tiêu) + Lăng Thái Hư (bản thân).
-- Điều kiện kích nổ: Toái Tinh Thần không CD, không có buff Thao Quang Dưỡng Hối (hoặc đang di chuyển có thể nổ ngay).
-- Dự phòng hồi mana bằng Bão Nguyên Quy Nhất khi mana < 40% và Khí Điểm >= 8.
-- Chuỗi dồn sát thương: Bát Hoang Quy Nguyên + Vô Ngã Vô Kiếm (khi Khí Điểm >= 8).
-- Hồi khí điểm: Tam Hoàn Sáo Nguyệt (ID 364) + kẹp Ngưng Thần Tụ Khí trong GCD (卡凝神).
xMacro.Schools.RegisterDamageScript("ThuanDuong", "ThaiHuKiemY", {[10014] = [[
#name ThuanDuong_ThaiHuKiemY_80
/skill [tprepare,distance<=4] Kiếm Phi Kinh Thiên
/skill [nobuff:Toái Tinh Thần] Toái Tinh Thần
/skill [distance<=4,tnobuff:Vạn Kiếm Quy Tông] Vạn Kiếm Quy Tông
/skill [fight,distance<=4,qidian<=4] Thao Quang Dưỡng Hối
/skill [mana<0.40,qidian>=8] Bão Nguyên Quy Nhất
/skill [tlife<0.40] Bát Hoang Quy Nguyên
/skill [qidian>=8] Vô Ngã Vô Kiếm
/skill [fight,distance<=4,nocd:Toái Tinh Thần,nobuff:Thao Quang Dưỡng Hối,qidian<8,buff:Toái Tinh Thần,buff:Hóa Tam Thanh,buff:Lăng Thái Hư] Nhân Kiếm Hợp Nhất
/skill [fight,moving,nocd:Toái Tinh Thần,nobuff:Thao Quang Dưỡng Hối,qidian<8,buff:Toái Tinh Thần|Hóa Tam Thanh|Lăng Thái Hư] Nhân Kiếm Hợp Nhất
/skill [fight,distance<=4,nocd:Toái Tinh Thần,nobuff:Thao Quang Dưỡng Hối,cdtime:Nhân Kiếm Hợp Nhất<=3,buff:Toái Tinh Thần,nobuff:Hóa Tam Thanh] Hóa Tam Thanh
/skill [fight,distance<=4,nocd:Toái Tinh Thần,nobuff:Thao Quang Dưỡng Hối,cdtime:Nhân Kiếm Hợp Nhất<=3,buff:Toái Tinh Thần,buff:Hóa Tam Thanh,nobuff:Lăng Thái Hư] Lăng Thái Hư
/skill Bát Hoang Quy Nguyên
/skill Thiên Địa Vô Cực
/skill Tam Hoàn Sáo Nguyệt
/skill [qidian<10] Ngưng Thần Tụ Khí
]]})
