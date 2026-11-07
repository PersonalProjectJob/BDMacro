# BDMacro cho JX3 v80 Hoàng Cung Nam Chiếu

Mở thư mục [Schools](Schools) để tìm mã theo môn phái. Mỗi file trong bảng chứa rotation đang phát hành. Ngũ Độc dùng chung một file cho Độc Kinh và Bổ Thiên vì hai nội công dùng chung hàm xử lý pet và kỹ năng.

| Môn phái | File nguồn |
| --- | --- |
| Vạn Hoa | [Hoa Gian](Schools/VanHoa/HoaGian.lua) |
| Ngũ Độc | [Độc Kinh và Bổ Thiên](Schools/NguDoc/DocKinh_BoThien.lua) |
| Thất Tú | [Băng Tâm](Schools/ThatTu/BangTam.lua) |
| Thiên Sách | [Ngạo Huyết](Schools/ThienSach/DPS.lua) |
| Tàng Kiếm | [Vấn Thủy và Sơn Cư](Schools/TangKiem/DPS.lua) |
| Đường Môn | [Kinh Vũ](Schools/DuongMon/KinhVu.lua), [Thiên La](Schools/DuongMon/ThienLa.lua) |
| Minh Giáo | [Phần Ảnh](Schools/MinhGiao/PhanAnh.lua) |
| Thiếu Lâm | [Dịch Cân Kinh](Schools/ThieuLam/DichCanKinh.lua) |
| Thuần Dương | [Tử Hà Công](Schools/ThuanDuong/TuHaCong.lua), [Thái Hư Kiếm Ý](Schools/ThuanDuong/ThaiHuKiemY.lua) |

## Sửa và phát hành

1. Sửa file trong `Schools/` và giữ UTF-8 BOM. `Schools/Priority.lua` chứa hàm dùng chung cho các rotation DPS.
2. Chạy `python tools/build_native.py` để ghép mã vào hai slot `Native/XM05_VanHoa.lua` và `Native/XM06_NguDoc.lua` rồi cập nhật SHA-256. `python tools/build_native.py --check` kiểm tra kết quả mà không ghi file.
3. Đồng bộ bộ xMacro nguồn, kiểm tra chuỗi Native và tạo lại ZIP trước khi phát hành bản rotation mới cho người chơi.

[Manifest](manifest.json) ghi `sourcePath` cho người bảo trì, `path` cho file Native mà client dùng, cùng alias và ID nội công. Người chơi cài [ZIP addon](releases/xMacro-v80-HCNC-0.9.7-addon.zip) để dùng trong game.
