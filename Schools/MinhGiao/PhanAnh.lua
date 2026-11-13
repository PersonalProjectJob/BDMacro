-- Phần Ảnh Thánh Quyết (10242) - Nội công DPS Minh Giáo v80
-- Kỹ năng: Tham Ma Thể, Tịnh Thế Phá Ma Kích, Khu Dạ Đoạn Sầu,
-- Chỉ đánh Nhật: Tịnh Thế > Khu Dạ > Liệt Nhật > Ngân Nguyệt (khi chưa có DOT) > Xích Nhật Luân (cuối).
xMacro.Schools.RegisterDamageScript("MinhGiao", "PhanAnh", {[10242] = [[
#name MinhGiao_PhanAnh_Boss
/cast Khu Dạ Đoạn Sầu
/cast Tịnh Thế Phá Ma Kích
/cast Liệt Nhật Trảm
/cast Ngân Nguyệt Trảm
/cast [sun>=moon] U Nguyệt Luân
/cast Xích Nhật Luân
]]})
-- MGPB: Phần Ảnh làm Q ngày (đứng đâu cũng được), AOE Hoàng Nhật Chiếu khi >3 địch.
xMacro.Schools.RegisterDamageScript("MinhGiao", "PhanAnhQN", {[10242] = [[
#name MinhGiao_PhanAnh_QNgay
/cast Khu Dạ Đoạn Sầu
/cast Tịnh Thế Phá Ma Kích
/cast [nearby_enemy>3&sun>moon] Hoàng Nhật Chiếu
/cast Liệt Nhật Trảm
/cast Ngân Nguyệt Trảm
/cast [moon>=sun] U Nguyệt Luân
/cast Xích Nhật Luân
]]})
