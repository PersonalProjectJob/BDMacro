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

1. Sửa file trong `Schools/` và giữ UTF-8 BOM. `Schools/CombatHelpers.lua` chứa hàm dùng chung cho Ngũ Độc và Thất Tú. `Schools/Priority.lua` chứa hàm đăng ký các rotation DPS.
2. Chạy `python tools/build_native.py`. Lệnh đọc `profiles` và `sourcePath` trong `manifest.json`, gom nguồn theo phái, rồi sinh Native, `Runtime.lua`, `info.ini`, alias, ID nội công và SHA-256. Dùng `python tools/build_native.py --check` để kiểm tra kết quả.
3. Để đồng bộ vào thư mục game, thoát game rồi chạy `python tools/build_native.py --addon "<thư mục game>/interface/xMacro"`. Chạy `python interface/xMacro/Tools/verify_macro.py --fix` từ workspace game trước khi đóng ZIP mới.

## Chuỗi nạp trong game

Client đọc `info.ini` và tự nạp theo `loadOrder` đã sinh. `XM05_VanHoa.lua` chỉ chứa Vạn Hoa, `XM06_NguDoc.lua` chỉ chứa Ngũ Độc, các phái khác có file riêng từ `XM07` đến `XM13`. Sau đó `XM14_Dispatch.lua` chọn profile và `XM15_KeySpam.lua` khởi tạo bảng điều khiển helper.

[Manifest](manifest.json) phân biệt `sourcePath` là mã để sửa và `path` là file Native cho game. Layout `ordered-v2` đi theo cả bộ addon. Người chơi giải nén [ZIP addon](releases/xMacro-v80-HCNC-0.9.7-addon.zip) vào thư mục game rồi mở launcher gốc. Python chỉ dùng khi bảo trì và build.
