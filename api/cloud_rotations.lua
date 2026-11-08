return {
    version = "20261108.2",
    timestamp = "2026-11-08 14:30:00",
    client = "JX3-v80",
    rotations = {
        [10002] = {
            school = "ThieuLam",
            profile = "TayTuyKinh",
            alias = "TLTT",
            name = "ThieuLam_TayTuyKinh_80",
            script = [[
#name ThieuLam_TayTuyKinh_80
/skill [life<0.35] Vô Tướng Quyết
/skill [life<0.40] Đoán Cốt Quyết
/skill [qidian<1] Cầm Long Quyết
/skill [distance<=4] Vạn Phật Triều Tông
/skill [distance<=4,qidian>=3] Lập Địa Thành Phật
/skill [distance<=4,qidian>=3] Vi Đà Hiến Chử
/skill [distance<=4] Ma Ha Vô Lượng
/skill [distance<=5] Hoành Tảo Lục Hợp
/skill [distance<=4] Phổ Độ Tứ Phương
]]
        },
        [10003] = {
            school = "ThieuLam",
            profile = "DichCanKinh",
            alias = "TL",
            name = "ThieuLam_DichCanKinh_80",
            script = [[
#name ThieuLam_DichCanKinh_80
/skill [life<0.35] Vô Tướng Quyết
/skill [mana<0.40,qidian>=3] Diệc Khô Diệc Vinh
/skill [qidian<1] Cầm Long Quyết
/skill [distance<=4,qidian>=3,tlife<0.30] Nã Vân Thức
/skill [distance<=4,qidian>=3] Kim Cương Nộ Mục
/skill [distance<=4,qidian>=3] Vi Đà Hiến Chử
/skill [distance<=5] Thủ Khuyết Thức
/skill [distance<=8] Đảo Hư Thức
/skill [distance<=5,qidian<3] Hoành Tảo Lục Hợp
/skill [distance<=4] Phổ Độ Tứ Phương
]]
        },
        [10014] = {
            school = "ThuanDuong",
            profile = "ThaiHuKiemY",
            alias = "TDTK",
            name = "ThuanDuong_ThaiHuKiemY_80",
            script = [[
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
]]
        },
        [10015] = {
            school = "ThuanDuong",
            profile = "TuHaCong",
            alias = "TDTH",
            name = "ThuanDuong_TuHaCong_80",
            script = [[
#name ThuanDuong_TuHaCong_80
/skill [nobuff:Tọa Vong Vô Ngã] Tọa Vong Vô Ngã
/skill [nobuff:Phá Thương Khung] Phá Thương Khung
/skill [mana<0.40,nobuff:Hóa Tam Thanh] Hóa Tam Thanh
/skill [mana<0.60,qidian>=8] Bão Nguyên Quy Nhất
/skill [distance<=20,qidian>=8] Lưỡng Nghi Hóa Hình
/skill [distance<=20,qidian<=7] Tứ Tượng Luân Hồi
/skill [distance<=20] Thái Cực Vô Cực
/skill [qidian<8] Ngưng Thần Tụ Khí
/skill [nofight,qidian<10] Ngưng Thần Tụ Khí
]]
        },
        [10021] = {
            school = "VanHoa",
            profile = "HoaGian",
            alias = "VH",
            name = "VanHoa_HoaGian_80",
            script = [[
#name VanHoa_HoaGian_80
/skill [life<0.4] Xuân Nê Hộ Hoa
/skill [mana<0.4] Bích Thủy Thao Thiên
/skill [tprepare] Quyết Âm Chỉ
/skill [nocd:Thủy Nguyệt Vô Gian,nombuff:Lan Thôi Ngọc Chiết] Thủy Nguyệt Vô Gian
/skill [buff:Thủy Nguyệt Vô Gian,nombuff:Lan Thôi Ngọc Chiết] Lan Thôi Ngọc Chiết
/skill [nombuff:Thương Dương Chỉ] Thương Dương Chỉ
/skill [nombuff:Chung Linh Dục Tú] Chung Linh Dục Tú
/skill [mbuff:Thương Dương Chỉ,mbuff:Chung Linh Dục Tú,cdtime:Ngọc Thạch Câu Phần>0] Loạn Tửu Thanh Hà
/skill [buff:Loạn Tửu Thanh Hà] Dương Minh Chỉ
/skill [mbuff:Lan Thôi Ngọc Chiết,mbuff:Thương Dương Chỉ,mbuff:Chung Linh Dục Tú] Ngọc Thạch Câu Phần
/skill [distance<=20] Dương Minh Chỉ
]]
        },
        [10026] = {
            school = "ThienSach",
            profile = "DPS",
            alias = "TS",
            name = "ThienSach_NgaoHuyet_80",
            script = [[
#name ThienSach_NgaoHuyet_80
/skill [mana<0.50] Từ Như Lâm
/skill [life<0.30] Thủ Như Sơn
/skill [distance<=4,xmtnobuff:Lưu Huyết] Phá Phong
/skill [distance<=4,xmtbuff:Trí Tàn] Long Nha
/skill [distance<=4,xmtbuff:Trí Tàn] Diệt
/skill [distance<=4] Long Ngâm
/skill [distance<=4,tlife<0.30] Diệt
/skill [distance<=4] Xuyên Vân
]]
        },
        [10062] = {
            school = "ThienSach",
            profile = "ThietLao",
            alias = "TSTL",
            name = "ThienSach_ThietLao_80",
            script = [[
#name ThienSach_ThietLao_80
/skill [life<0.35] Thủ Như Sơn
/skill [life<0.60] Ngự
/skill [mana<0.50] Từ Như Lâm
/skill [distance<=4] Định Quân
/skill [distance<=4,xmtnobuff:Lưu Huyết] Phá Phong
/skill [distance<=4,xmtbuff:Trí Tàn] Long Nha
/skill [distance<=4] Long Ngâm
/skill [distance<=4] Diệt
/skill [distance<=4] Xuyên Vân
]]
        },
        [10081] = {
            school = "ThatTu",
            profile = "BangTam",
            alias = "7T",
            name = "ThatTu_BangTam_80",
            script = [[
#name ThatTu_BangTam_80
/config channel-on
/skill [xmtbuffstack:Cấp Khúc>=3] Phồn Âm Cấp Tiết
/skill [mana<0.85] Long Trì Nhạc
/skill [qidian<=2] Mãn Đường Thế
/skill [qidian>0,mana>0.15,distance<10] Kiếm Thần Vô Ngã
/skill [qidian>=7] Kiếm Phá Hư Không
/skill [qidian>=4,xmtbuffstack:Cấp Khúc>=3] Kiếm Khí Trường Giang
/skill Đại Huyền Cấp Khúc
]]
        },
        [10144] = {
            school = "TangKiem",
            profile = "DPS",
            alias = "TK",
            name = "TangKiem_VanThuy_80",
            script = [[
#name TangKiem_VanThuy_80
/skill [distance<=8,xmtnobuff:Mai Ẩn Hương] Mai Ẩn Hương
/skill [rage>=95] Khiếu Nhật
/skill [rage<=30] Tuyết Đoạn Kiều
/skill [distance<=4] Vân Phi Ngọc Hoàng
/skill [distance<=4] Tịch Chiếu Lôi Phong
/skill [distance<=4] Thính Lôi
/skill [distance<=4] Đoạn Triều
/skill [distance<=4] Cửu Khê Di Yên
]]
        },
        [10145] = {
            school = "TangKiem",
            profile = "DPS",
            alias = "TK",
            name = "TangKiem_SonCu_80",
            script = [[
#name TangKiem_SonCu_80
/skill [distance<=8,xmtnobuff:Mai Ẩn Hương] Mai Ẩn Hương
/skill [rage<=15] Khiếu Nhật
/skill [distance<=4] Vân Phi Ngọc Hoàng
/skill [distance<=4] Tịch Chiếu Lôi Phong
/skill [distance<=4] Thính Lôi
/skill [distance<=4] Đoạn Triều
/skill [distance<=4] Cửu Khê Di Yên
]]
        },
        [10175] = {
            school = "NguDoc",
            profile = "DocKinh",
            alias = "ND",
            name = "NguDoc_DocKinh_80",
            script = [[
#name NguDoc_DocKinh_80
/skill [life<0.5,pet] Cổ Trùng Cuồng Bạo
/skill [pet:Linh Xà] Ảo Kích
/skill [pet] Tấn công
/skill [nopet,nocd:Linh Xà Dẫn] Linh Xà Dẫn
/skill [nopet,nocd:Ngọc Thiềm Dẫn] Ngọc Thiềm Dẫn
/skill [nopet,nocd:Thánh Hạt Dẫn] Thánh Hạt Dẫn
/skill [pet] Cổ Trùng Hiến Tế
/skill [nocd:Bách Túc] Bách Túc
/skill [nombuff:Xà Ảnh,nolastcast:Xà Ảnh] Xà Ảnh
/skill [nombuff:Thiềm Khiếu] Thiềm Khiếu
/skill [moving] Thiên Ti
/skill [cd:Bách Túc] Hạt Tâm
]]
        },
        [10176] = {
            school = "NguDoc",
            profile = "BoThien",
            alias = "NDBT",
            name = "NguDoc_BoThien_80",
            script = [[
#name NguDoc_BoThien_80
/skill [nopet] Bích Điệp Dẫn
/skill [life<0.35] Nữ Oa Vá Trời
/skill [life<0.3,pet] Cổ Trùng Hiến Tế
/skill [tlife<0.35] Thánh Thủ Chức Thiên
/skill [tlife<0.45] Thiên Điệp Thổ Thụy
/skill [tlife<0.85,tnobuff:Cổ Hoặc Chúng Sinh] Cổ Hoặc Chúng Sinh
/skill [tlife<0.6] Nữ Oa Vá Trời
/skill [moving,tlife<0.95] Túy Vũ Cửu Thiên
/skill [tlife<0.75] Băng Tàm Khiên Ti
/skill [tlife<0.95] Túy Vũ Cửu Thiên
/skill Băng Tàm Khiên Ti
]]
        },
        [10224] = {
            school = "DuongMon",
            profile = "KinhVu",
            alias = "DMKV",
            name = "DuongMon_KinhVu_80",
            script = [[
#name DuongMon_KinhVu_80
/skill [energy<35] Tập Trung
/skill [distance<=25,xmbuff:Truy Mệnh Vô Thanh] Truy Mệnh Tiễn
/skill [distance<=25,energy>=20,xmtnobuff:Hóa Huyết Tiêu] Hóa Huyết Tiêu
/skill [distance<=25,energy>=30] Bạo Vũ Lê Hoa Châm
/skill [distance<=25,energy<=70] Trục Tinh Tiễn
/skill [distance<=25,energy>=30] Đoạt Phách Tiễn
]]
        },
        [10225] = {
            school = "DuongMon",
            profile = "ThienLa",
            alias = "DMTL",
            name = "DuongMon_ThienLa_80",
            script = [[
#name DuongMon_ThienLa_80
/skill [energy<40] Tập Trung
/skill [distance<=25,energy>=20,xmtnobuff:Hóa Huyết Tiêu] Hóa Huyết Tiêu
/skill [distance<=25,energy>=30] Bạo Vũ Lê Hoa Châm
/skill [distance<=25,energy>=30] Thực Cơ Đạn
/skill [distance<=25,energy>=15] Đoạt Phách Tiễn
]]
        },
        [10242] = {
            school = "MinhGiao",
            profile = "PhanAnh",
            alias = "MG",
            name = "MinhGiao_PhanAnh_80",
            script = [[
#name MinhGiao_PhanAnh_80
/skill [life<0.30] Tham Ma Thể
/skill [distance<=5,fullsun] Tịnh Thế Phá Ma Kích
/skill [distance<=5,fullmoon] Tịnh Thế Phá Ma Kích
/skill [distance<=5,xmbuff:Ám Trần Di Sơn] Khu Dạ Đoạn Sầu
/skill [distance<=5] Ngân Nguyệt Trảm
/skill [distance<=5] Liệt Nhật Trảm
/skill [distance<=5,sun>=moon] U Nguyệt Luân
/skill [distance<=5] Xích Nhật Luân
]]
        },
        [10243] = {
            school = "MinhGiao",
            profile = "MinhTon",
            alias = "MGMT",
            name = "MinhGiao_MinhTon_80",
            script = [[
#name MinhGiao_MinhTon_80
/skill [life<0.30] Tham Ma Thể
/skill [life<0.40,fullsun] Thánh Minh Hựu
/skill [distance<=5] Từ Bi Nguyện
/skill [distance<=8] Giới Hỏa Trảm
/skill [distance<=5] Hoàng Nhật Chiếu
/skill [distance<=5,fullsun] Tịnh Thế Phá Ma Kích
/skill [distance<=5,fullmoon] Tịnh Thế Phá Ma Kích
/skill [distance<=5,sun>=moon] Liệt Nhật Trảm
/skill [distance<=5,moon>sun] Ngân Nguyệt Trảm
/skill [distance<=5,sun>=moon] Xích Nhật Luân
/skill [distance<=5] U Nguyệt Luân
]]
        },
    }
}
