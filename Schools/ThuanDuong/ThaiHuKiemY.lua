-- Thái Hư Kiếm Ý (10014) - Nội công DPS Kiếm Thuần Dương v80
-- Khí trường chính: Toái Tinh Thần (thả vào mục tiêu).
-- Bùng nổ sát thương: Thao Quang Dưỡng Hối (ID 313) khi áp sát mục tiêu (<=4m) và Khí <= 2 ô.
-- Combo kích nổ 3 khí trường trên sân (<=10m): Toái Tinh Thần (mục tiêu) + Hóa Tam Thanh (mục tiêu) + Lăng Thái Hư (bản thân).
-- Điều kiện kích nổ Nhân Kiếm Hợp Nhất (ID 588): Toái Tinh Thần không CD, không có buff Thao Quang Dưỡng Hối (hoặc đang di chuyển có thể nổ ngay).
-- Dự phòng hồi mana bằng Bão Nguyên Quy Nhất khi mana < 40% và Khí Điểm >= 8.
-- Chuỗi dồn sát thương: Bát Hoang Quy Nguyên + Vô Ngã Vô Kiếm (khi Khí Điểm >= 8).
-- Hồi khí điểm: Tam Hoàn Sáo Nguyệt (ID 364) + kẹp Ngưng Thần Tụ Khí trong GCD (卡凝神).
xMacro.Schools.RegisterDamageScript("ThuanDuong", "ThaiHuKiemY", {[10014] = [[
#name ThuanDuong_ThaiHuKiemY_80
/skill [tprepare,distance<=4] Kiếm Phi Kinh Thiên
/skill [nocd:Toái Tinh Thần,nobuff:Toái Tinh Thần;nocd:Toái Tinh Thần,noqichang:Toái Tinh Thần] Toái Tinh Thần
/skill [distance<=4,tnobuff:Vạn Kiếm Quy Tông] Vạn Kiếm Quy Tông
/skill [distance<=4,qidian<=2,nocd:Thao Quang Dưỡng Hối] Thao Quang Dưỡng Hối
/skill [distance<=4,qidian<9,nocd:Hóa Tam Thanh,noqichang:Hóa Tam Thanh] Hóa Tam Thanh
/skill [distance<=4,qidian<9,nocd:Sinh Thái Cực,cdtime:Nhân Kiếm Hợp Nhất>2,noqichang:Sinh Thái Cực] Sinh Thái Cực
/skill [distance<=4,nocd:Nhân Kiếm Hợp Nhất,cdtime:Toái Tinh Thần<=1.5,qichang:Toái Tinh Thần,qichang:Hóa Tam Thanh] Nhân Kiếm Hợp Nhất
/skill [moving,distance<=10,nocd:Nhân Kiếm Hợp Nhất,cdtime:Toái Tinh Thần<=1.5,qichang:Toái Tinh Thần,qichang:Hóa Tam Thanh] Nhân Kiếm Hợp Nhất
/skill [mana<0.40,qidian>8,nocd:Bão Nguyên Thủ Khuyết] Bão Nguyên Thủ Khuyết
/skill [qidian>=8] Vô Ngã Vô Kiếm
/skill Bát Hoang Quy Nguyên
/skill Thiên Địa Vô Cực
/skill Tam Hoàn Sáo Nguyệt
/skill [qidian<10] Ngưng Thần Tụ Khí
]]})
