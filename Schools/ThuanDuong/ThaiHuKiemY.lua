-- Thái Hư Kiếm Ý (10014), rotation AIO 14 dòng.
xMacro.Schools.RegisterDamageScript("ThuanDuong", "ThaiHuKiemY", {[10014] = [[
#name ThuanDuong_ThaiHuKiemY_80
/fcast [mana<0.40 & qidian>8] Bão Nguyên Thủ Khuyết
/fcast [buff:Toái Tinh Thần & buff:Sinh Thái Cực] Nhân Kiếm Hợp Nhất
/fcast [tcast & distance<=20] Kiếm Phi Kinh Thiên
/fcast [distance<=5 & qidian<8 & nobuff:Thao Quang Dưỡng Hối] Thao Quang Dưỡng Hối
/fcast [distance<=5 & tnobuff:Vạn Kiếm Quy Tông] Vạn Kiếm Quy Tông
/fcast [qidian<9 & nobuff:Toái Tinh Thần] Toái Tinh Thần
/fcast [qidian>8] Vô Ngã Vô Kiếm
/fcast Bát Hoang Quy Nguyên
/fcast Thiên Địa Vô Cực
/fcast [qidian<9 & nobuff:Hóa Tam Thanh] Hóa Tam Thanh
/fcast [distance<=5 & qidian<10] Vạn Kiếm Quy Tông
/fcast [qidian<9 & nobuff:Sinh Thái Cực] Sinh Thái Cực
/fcast Tam Hoàn Sáo Nguyệt
/cast [qidian<10] Ngưng Thần Tụ Khí
]]})
