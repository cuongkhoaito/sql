---tạo database 
CREATE DATABASE NguyenDucCuong_2050531200110 -- tuan 7
go
USE NguyenDucCuong_2050531200110
go
---bắt đầu tạo bảng đâu tiên (khách hàng) 
CREATE TABLE KhachHang
(
	maKH int identity(1,1)  PRIMARY KEY ,
	tenKH nvarchar(20) not null,
	SDT varchar(11) not null,
	Email varchar(20),
	SoDuTaiKhoan money,
	diaChiKH nvarchar(100)
)  
go

---bảng đơn đặt hàng

CREATE TABLE DonDatHang_HoaDon
(
	maDH char(7)  not null primary key,
	ngayTaoDH date not null,
	diachiGiaoHang nvarchar(50),
	SDTGiaoHang integer not null,
	maHoaDonDienTu char(20) null,
	ngayThanhToan date  null,
	ngayGiaoHang date  null,
	trangThaiDonHang nvarchar(100) 
)
go 
---bang nhân viên
CREATE TABLE NhanVien
(
	maNV char(7)  not null primary key,
	tenNV nvarchar(20) not null,
	SDT char(11) not null,
	Email varchar(20),
	gioiTinh nvarchar(3) null,
	DoB datetime not null,
	Salary money not null,
	ngayThoiViec datetime
)


go
--- bảng chi tiết đơn hàng
CREATE TABLE ChiTietDonHang
(
	maDH char(7)  not null, 
	maSP char(7)  not null,
	soLuongDat int not null,
	donGia money not null,
	primary key (maDH,maSP)
)
go
---bảng sản phẩm
CREATE TABLE SanPham
(
	maSP char(7)  not null primary key,
	tenSP nvarchar(20) not null,
	donGiaBan money not null,
	soluongHienCon bigint not null,		-- số lượng hiện còn
	soluongCanDuoi smallint not null   -- số lượng cận dưới
)
go

---bảng phiếu nhập

CREATE TABLE PhieuNhap
(
	maPN char(7) not null primary key,
	ngayNhapHang date
)
go
---bảng chi tiết phiều nhập
CREATE TABLE ChiTietPhieuNhap 
(
	maPN char(7)  not null ,
	maSP char(7)  not null ,
	soLuongNhap int not null,
	giaNhap money not null,
	primary key( maPN, maSP)
--	sai FOREIGN KEY (maPN) REFERENCES PhieuNhap(maPN),
)
go
---bảng nhà cung cấp
CREATE TABLE NhaCungCap
(
	maNCC char(7) not null primary key,
	tenNCC nvarchar(20) not null,
	diaChiNCC nvarchar(50)  null,
	SDT integer not null,
	nhanVienLienHe nvarchar(20) not null
)
go


-- cau 6
-- tham chieu khoa ngoai toi bang KhachHang
alter table DonDatHang_HoaDon
	add maKH int identity(1,1)	

alter table DonDatHang_HoaDon
	add constraint FK_KH foreign key (maKH) references KhachHang(maKH)
--		on delete 
--			cascade
--		on update
--			cascade

-- tham chieu khoa ngoai toi bang NhanVien
alter table DonDatHang_HoaDon
	add maNV char(7)
alter table DonDatHang_HoaDon
	add constraint FK_NV foreign key (maNV) references NhanVien(maNV)
	on delete 
		cascade
	on update 
		cascade

-- tham chieu khoa ngoai toi bang SanPham
alter table ChiTietDonHang
	add constraint FK_DDHHD foreign key (maDh) references DonDatHang_HoaDon(maDH)
	on delete 
		cascade
	on update
		cascade
alter table ChiTietDonHang
	add constraint FK_SP foreign key (maSp) references SanPham(maSP)
	on delete
		cascade
	on update
		cascade

-- tham chieu toi bang SanPham
alter table ChiTietPhieuNhap
	add constraint FK_PN_SP foreign key (maSP) references SanPham(maSP)
	on delete
		cascade
	on update
		cascade
alter table ChiTietPhieuNhap
	add constraint FK_CTPN foreign key (maPN) references PhieuNhap(maPN)
	on delete
		cascade
	on update
		cascade

-- tham chieu toi bang NhaCungCap
alter table PhieuNhap
	add maNCC char(7)
alter table PhieuNhap
	add constraint FK_NCC foreign key (maNCC) references NhaCungCap(maNCC)
	on delete
		cascade
	on update
		cascade






-- câu 1 bổ sung bảng lưu những thông tin khuyến mãi 
create table KhuyenMai
(
	maKM char(7)  not null primary key,
	NoiDungKm nvarchar(100) not null
)

	alter table ChiTietDonHang
	add maKM char(7) constraint FK_KM foreign key (maKM) references KhuyenMai(maKM)
		on delete 
			cascade
		on update 
			cascade

-- câu 2.1 bổ sung table lưu giữ thông tin về position
create table ChucVu
(
	IdChucVu char(7) not null primary key,
	TenChucVu nvarchar(100) not null,
)
go
--  câu 2.2 Tạo table đảm nhiệm chức vụ của nhân viên
create table DamNhiem
(
	IdChucVu char(7)  not null foreign key references ChucVu(IdChucVu),
	maNV char(7)  not null foreign key references NhanVien(maNV),
	primary key(IdChucVu,maNV),
)

go

-- câu 3 tách Địa chỉ Khách Hàng
create table XaPhuong
(
	idQH char(7) not null,
	idXP char (7) not null ,
	tenXaPhuong nvarchar(100) not  null,
	primary key(  idXP)

)
create table QuanHuyen
(
	idTT char(7) not null,
	idQH char(7) not null,
	tenQuanHuyen nvarchar(100),
	 primary key( idQH)
)
create table TinhThanh
(
	idTT char(7) not null primary key,
	tenThanhPho nvarchar(100)
)


alter table QuanHuyen
	add constraint FK_TT foreign key (idTT) references TinhThanh(idTT)
		on delete 
			cascade
		on update
			cascade

 alter table XaPhuong
	add constraint FK_QH foreign key(idQH) references QuanHuyen(idQH)
		on delete 
			cascade
		on update
			cascade

alter table DonDatHang_HoaDon
	add idXP char(7) constraint FK_XPhuong foreign key(idXP) references XaPhuong(idXP)
		on delete
			cascade
		on update
			cascade

go
-- câu 4 bổ sung trạng thái đơn hàng
alter table DonDatHang_HoaDon							-- nhớ Nhập N để hiển thị tiếng Việt
	add constraint CK_DonHang check (trangThaiDonHang In(N'Đã duyệt - Đang đóng gói',N'Chờ duyệt',N'Đang giao',N'Đã giao'));

go
-- cau 5a mail co @ bắt đàu hoa ỏ thường,  thuộc 2 loại mail
alter table KhachHang
 add constraint UQ_GM_email_KH unique(Email),
	 constraint GM_email_KH check (Email like '[a-z]%@gmail%'
                         or Email like '[a-z]%@Yahoo%'
                         or Email like '[a-z]%@ute.udn.vn')
go
alter table NhanVien
 add constraint UQ_GM_email_NV unique(Email),
	 constraint GM_email_NV check (Email like '[a-z]%@gmail%'
                         or Email like '[a-z]%@Yahoo%'
                         or Email like '[a-z]%@ute.udn.vn')
go
-- cau 5b SDT gom  ràng buộc 10 -11 só từ 0-9
	alter table KhachHang
		add constraint CK_KhachHang_SDT unique(SDT), check(SDT like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
										or SDT like'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
	alter table NhanVien
	add constraint CK_NhanVien_SDT unique(SDT), check(SDT like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
									or SDT like'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
--	ALTER TABLE KhachHang
--	DROP CONSTRAINT CK_KhachHang_SDT;
-- cau  5 c đảm bảo đủ 18 tuổi trở lên
	 alter table NhanVien 
	 add constraint CK_Year18 check (datediff(year,'0:0',getdate()-DoB) >=18)
	 
go
-- cau 5d giới tính(‘F’ hoặc ‘M’) – mặc định ‘F’
	alter table NhanVien  
	alter column gioiTinh char(1) 

	alter table NhanVien
		add constraint CK_gioiTinh check (gioiTinh in ('M', 'F')) ,
			constraint DF_gioiTinh default 'M' for gioiTinh

	alter table ChucVu
	add constraint df_chucvu default N'Nhân viên bán hàng' for TenChucVu,
		constraint ck_chucvu check(TenChucVu like N'Nhân viên bán hàng'
								or TenChucVu like N'Nhân viên kho'
								or TenChucVu like N'Nhân viên giao hàng'
								or TenChucVu like N'Quản lý viên')
	

go
-- cau 5e ngày tạo đơn hàng nhỏ hơn ngày hiện tại
	alter table DonDatHang_HoaDon 
		add constraint CK_TaoDH CHECK(ngayTaoDH < GETDATE());
go
--cau 5f: ngày thanh toán: nhỏ hơn ngày hiện tại và lớn hơn ngày tạo đơn hàng
    alter table DonDatHang_HoaDon 
		add constraint CK_NgTT CHECK(ngayThanhToan > ngayTaoDH AND  ngayThanhToan  < GETDATE());

go  
--cau 5g DelDate: Ngày giao hàng nhỏ hơn ngày hiện tại và lớn hơn InvDate
	alter table DonDatHang_HoaDon 
		add constraint CK_NgGH CHECK(ngayGiaoHang < GETDATE() AND ngayGiaoHang > ngayThanhToan); 
go
---cau5h 
--thêm cột trangThaiGiaoHang vào table DonDatHang_HoaDon
--thêm ràng buộc check và giá trị mặc định cho cột trangThaiGiaoHang trong table DonDatHang_HoaDon
alter table DonDatHang_HoaDon
	add trangThaiGiaoHang char(2) null
		constraint DF_trangThaiGiaoHang default 'BT' ,
		constraint Check_trangThaiGiaoHang check(trangThaiGiaoHang in ('BT','ER','LL'))

go
-- cau 5.i Dia chi mac dinh cua bang KH va NCC
	alter table NhaCungCap 
		add constraint DF_diachiNCC default N'Đà Nẵng' for diaChiNCC 
	--	, constraint CK_diachiNCC check (diaChiNCC in(N'Đà Nẵng', N'TP.Hồ Chí Minh',N'Quang Nam'))

			
							 
	alter table KhachHang 
		add	constraint DF_diaChiKH default N'Đà Nẵng' for diaChiKH 
	--, constraint CK_diaChiKH check (diaChiKH in(N'Đà Nẵng', N'TP.Hồ Chí Minh',N'Quang Nam'))
		

--cau 5.j đảm bảo lớn hơn hoặc bằng 0
go
 alter table KhachHang add constraint CK_sdtk check (soDuTaiKhoan >= 0);
 alter table NhanVien add constraint CK_salary check (Salary >= 0);
 alter table ChiTietPhieuNhap add constraint  CK_gn check (giaNhap >= 0);
 alter table SanPham add constraint CK_gb check (donGiaBan >= 0);
 alter table ChiTietDonHang add constraint CK_dg check (donGia >= 0);

 /*
 -- cau 6 update/ xóa update
 alter  table ChiTietPhieuNhap
	add constraint FK_maPN_PN foreign key (maPN) references PhieuNhap(maPN)
		on delete
			cascade
		on update
			cascade

alter  table ChiTietPhieuNhap
    add constraint FK_maSPNhap foreign key (maSP) references SanPham(maSP)
        on delete
            cascade
        on update
            cascade

alter  table ChiTietDonHang
    add constraint FK_maSPDonHang foreign key (maSP) references SanPham(maSP)
        on delete
            cascade
        on update
            cascade

alter  table ChiTietDonHang
    add constraint FK_maDHDonHang foreign key (maDH) references DonDatHang_HoaDon(maDH)
        on delete
            cascade
        on update
            cascade
*/
/*
-- câu 7 identity tăng tự động cho bảng mới, vì các ID bảng củ đều là kiểu dl char
create table cau7
(
	idIdentity int identity(1,1) primary key,
	Fullname nvarchar(100) null
)
*/


-- tuần 8
go
-- tao view 
create view Product_StillBusiness
as
select *
from SanPham
where soluongHienCon >0 
-- chèn dữ liệu
go


-- set dateformat dmy     đặt ngày  trước tháng sau
insert into NhanVien
values('nv1', N'Nguyễn Đức Cường','0123456789','cuong1@gmail.com','M','2002-10-11',5000,2021-11-21),
	('nv2', N'Tô Vĩnh Hào','0123456787','cuong2@gmail.com','M','2002-10-12',7600,2021-11-28),
	('nv3', N'Võ Hữu Hưng','0123456786','cuong3@gmail.com','M','2002-10-12',900000,null),
	('nv4', N'Nguyễn Thị Hường','0123456785','cuong4@gmail.com','M','2002-10-12',1000000,null),
	('nv5', N'Nguyễn Đức Nam','0123456784','cuong5@gmail.com','M','2002-10-12',50000000,null),
	('nv6', N'Nguyễn Đức Huy','0123456783','cuong6@gmail.com','M','2002-10-12',8700,null),
	('nv7', N'Phạm Đức Hùng','0123456782','cuong7@gmail.com','M','2002-10-12',0,null),
	('nv8', N'Nguyễn Đức Hòa','0123456781','cuong8@gmail.com','M','2002-10-12',150000,null),
	('nv9', N'Nguyễn Thị Hoa','0123456791','cuong9@gmail.com','F','2002-10-12',1500,null),
	('nv10', N'Trần Hoa Hồng','0123456792','cuong10@gmail.com','F','2002-10-12',7800000,null)
go

INSERT INTO ChucVu
VALUES	('cv1',N'Nhân viên bán hàng'),
		('cv2',N'Nhân viên kho'),
		('cv3',N'Nhân viên giao hàng'),
		('cv4',N'Quản lý viên');
GO
---chèn dữ liệu bảng đảm nhiệm
INSERT DamNhiem
VALUES	('cv1','nv1'),
		('cv1','nv2'),
		('cv2','nv2'),
		('cv3','nv3'),
		('cv4','nv4'),
		('cv4','nv2'),
		('cv1','nv3'),
		('cv2','nv1'),
		('cv1','nv4'),
		('cv3','nv2');



insert into TinhThanh
values ('92',N'Quảng Nam'),
		('43',N'Đà Nẵng'),
		('93',N'Quảng Ngãi'),
		('75',N'Huế'),
		('1',N'Hà Nội'),
		('2',N'Hà Tây'),
		('3',N'Quảng Ninh'),
		('4',N'Phú Yên'),
		('5',N'Hà Tĩnh'),
		('6',N'Quảng Bình')

insert into QuanHuyen
values	('92','A',N'Duy Xuyên'),
		('92','H',N'Thăng Bình'),
		('75','B',N'Lăng Cô'),
		('43','C',N'Hải Châu'),
		('92','D',N'Hà Lam'),
		('1','E',N'Hà Đông'),
		('92','N',N'Tam Kỳ'),
		('92','K',N'Hội An'),
		('43','L',N'Ngũ Hành Sơn'),
		('43','M',N'Sơn Trà')

insert into XaPhuong
values ('A','DTr',N'Duy Trinh'),
		('B','DV',N'Duy Vinh'),
		('C','DP',N'Duy Phước'),
		('D','DN',N'Duy Nghĩa'),
		('A','Dha',N'Duy hải'),
		('E','DTan',N'Duy Tân'),
		('M','DA',N'Duy An'),
		('N','DH',N'Duy Hòa'),
		('K','DPh',N'Duy Phú'),
		('L','DT',N'Duy Tàu')

go
insert into KhachHang --(tenKH,SDT,Email,SoDuTaiKhoan,diaChiKH)  -- identity là bỏ bỏ khi cho nhập tự động
values (N'Hà Quyên','0987654321', 'haquyen@ute.udn.vn',5000000,N'Đà Nẵng'),
		(N'Nguyễn Hào','0987654312','nguyen2@ute.udn.vn',700000,N'Đà Nẵng'),
		(N'Nguyễn Huy','0987654313','nguyen3@ute.udn.vn',10000,N'Đà Nẵng'),
		(N'Trần Hùng','0987654314','nguyen4@ute.udn.vn',100,N'Quảng Nam'),
		(N'Nguyễn Văn Hảo','0987654315','nguyen5@ute.udn.vn',60000,N'Hà Nội'),
		(N'Trần Văn Hưng','0987654316','nguyen6@ute.udn.vn',6540000,N'Đà Nẵng'),
		(N'Nguyễn Thị Mỹ Dung','0987654317','nguyen7@ute.udn.vn',154000,N'Huế'),
		(N'Nguyễn Tấn Dũng','0987654318','nguyen8@ute.udn.vn',164000,N'Vinh'),
		(N'Phạm Thị Mi','0987654319','nguyen9@ute.udn.vn',7893000,N'Hồ Chí Minh'),
		(N'Nguyễn Hoa','0987654212','nguyen10@ute.udn.vn',3400000,N'Đà Nẵng')
go
--delete DonDatHang_HoaDon
set identity_insert DonDatHang_HoaDon on
go
insert into DonDatHang_HoaDon(maDH,ngayTaoDH,diachiGiaoHang,SDTGiaoHang,maHoaDonDienTu,ngayThanhToan,ngayGiaoHang,trangThaiDonHang,maKH,maNV,idXP,trangThaiGiaoHang)
values ('hd1','2021-11-4', N'Đà Nẵng','0997612345',NULL, '2021-11-5','2021-11-6',N'Chờ duyệt',1,'nv1','DV','BT'),
		('hd2','2021-3-5',N'Đà Nẵng','0998761235',NULL, '2021-10-5','2021-11-6',N'Đang giao',2,'nv2','DP','BT'),
		('hd3','2020-1-3',N'Quảng Nam' ,'0998761245',NULL, '2021-10-5','2021-10-6',N'Chờ duyệt',3,'nv2','DT','BT'),
		('hd4','2021-2-2',N'Hà Nội','0998761236','hdtt1', '2021-10-5','2021-10-6',N'Đã duyệt - Đang đóng gói',3,'nv3','DV','BT'),
		('hd5','2020-4-1', N'Đà Nẵng','0928761234','hdtt2', '2021-7-5','2021-9-6',N'Đã giao',5,'nv4','DH','BT'),
		('hd6','2021-3-3', N'Quảng Nam','0978761234','hdtt4', '2021-8-5','2021-10-6',N'Đã giao',6,'nv5','DA','BT'),
		('hd7','2021-6-2',N'Đà Nẵng','0998761234','hdtt5', '2021-9-5','2021-9-7',N'Đang giao',7,'nv6','Dha','BT'),
		('hd8','2021-9-1',N'Quảng Nam','0948761234','hdtt6', '2021-9-5','2021-9-10',N'Đang giao',8,'nv6','DV','BT'),
		('hd9','2021-1-1',N'Quảng Nam','0928761231','hdtt8', '2021-2-5','2021-11-5',N'Chờ duyệt',7,'nv7','DA','BT'),
		('hd10','2020-3-7', N'Quảng Nam','0698761234',NULL, '2020-12-5','2020-12-6',N'Đã giao',10,'nv10','Dtr','BT')

go	
insert into NhaCungCap(maNCC,tenNCC,diaChiNCC, SDT,nhanVienLienHe)
values	('ncc1',N'Sư phạm kỹ thuật',N'Đà Nẵng','0987651234',N'Quyên'),
		('ncc2',N'Bách khoa',N'Hà Nội','0987651235',N'ý'),
		('ncc3',N'Ngoại ngữ',N'Đà Nẵng','0987651236',N'Hùng'),
		('ncc4',N'Sư phạm ',N'Hà Nội','0987651237',N'Hường'),
		('ncc5',N'Kinh tế',N'Đà Nẵng','0987651238',N'Huy'),
		('ncc6',N'Việt hàn',N'Đà Nẵng','0987651239',N'Hảo'),
		('ncc7',N'Y dược',N'Đà Nẵng','0987651241',N'Hồng'),
		('ncc8',N'Giáo dục thể chất',N'Đà Nẵng','0987651242',N'Hoa'),
		('ncc9',N'Sư phạm kỹ thuật',N'Đà Nẵng','0987651243',N'Mỹ'),
		('ncc10',N'Sư phạm kỹ thuật',N'Đà Nẵng','0987651244',N'Tin')
go
INSERT INTO PhieuNhap
VALUES	('PN1','2021/02/02','NCC1'),
		('PN2','2020/03/12','NCC2'),
		('PN3','2020/04/12','NCC3'),
		('PN4','2020/06/02','NCC5'),
		('PN5',null,'NCC5'),
		('PN6',null,'NCC3'),
		('PN7','2020/04/05','NCC3'),
		('PN8','2020/01/12','NCC3'),
		('PN9','2020/09/12','NCC5'),
		('PN10','2020/02/12','NCC10');
GO
INSERT INTO SanPham
VALUES	('HN01',N'BÁNH TRÁNG','50000','500','30'),
		('HN02',N'BÚN TIÊU','60000','30','5'),
		('HN03',N'MÁY ẢNH','30000000','40','2'),
		('HN04',N'BÁNH MÌ','900000','1000','1'),
		('HN05',N'ĐẬU HỦ','500000','90','90'),
		('HN06',N'KẸO','100000','60','40'),
		('HN07',N'BÁNH XÈO','560000','20','0'),
		('HN08',N'BÁNH GẠO','320000','40','0'),
		('HN09',N'BÀN PHÍM CƠ','11000','60','50'),
		('HN10',N'MÀN HÌNH','2120000','240','60');
GO
INSERT INTO ChiTietPhieuNhap
VALUES	('PN1','HN01','20','10000'),
		('PN2','HN02','65','50000'),
		('PN3','HN03','56','30000'),
		('PN4','HN02','100','20000'),
		('PN4','HN01','200','10000'),
		('PN5','HN02','400','20000'),
		('PN5','HN05','300','30000'),
		('PN6','HN06','100','50000'),
		('PN7','HN02','110','40000'),
		('PN8','HN08','210','90000');
GO	
INSERT INTO KhuyenMai
values ('KM1',N'khuyến mãi tháng 1'),
		('KM2',N'khuyến mãi tháng 2'),
		('KM3',N'tặng kèm'),
		('KM4',N'khuyến mãi tháng 3'),
		('KM5',N'khuyến mãi tháng 4'),
		('KM6',N'khuyến mãi tháng 5'),
		('KM7',N'khuyến mãi tháng 6'),
		('KM8',N'khuyến mãi tháng 7'),
		('KM9',N'khuyến mãi tháng 8'),
		('KM10',N'khuyến mãi tháng 9')
go
INSERT INTO ChiTietDonHang
VALUES	('hd1','HN01','400','5000','KM1'),
		('hd2','HN04','20','500000','KM2'),
		('hd3','HN03','11','7990000','KM3'),
		('hd4','HN04','21','50000','KM1'),
		('hd5','HN01','23','102000','KM3'),
		('hd6','HN04','10','6000','KM5'),
		('hd7','HN02','50','500000','KM7'),
		('hd8','HN03','100','560000','KM8'),
		('hd9','HN04','1','90000','KM8'),
		('hd10','HN04','10','100000','KM9');







-- tuan 9 truy van du lieu
-- Hiển thị thông tin sản phẩm có mức giá bán ra thuộc Top3 muc gia cao nhat
			-- thêm with ties vd: nếu cả 3 sp đều bán được 2 sp thì lấy cả 3, chỉ lấy đúng 3 cái

SELECT *
FROM SanPham
WHERE donGiaBan IN	(
						select distinct top 3 donGiaBan 
						from SanPham
						order by donGiaBan desc  -- có hoặc không
					)
order by donGiaBan desc

go
--1a thong ke  nam trong 3 san pham ban chay nhat
-- in bang = any //
select tenSP,sum(soLuongDat) as soLuongdat
from ChiTietDonHang as c, SanPham as s
where c.maSP = s.maSP
group by tenSP
having sum(soLuongDat)  in  (
			select distinct top 3 sum(soLuongDat)
			from ChiTietDonHang
			group by maSP
			order by sum(soLuongDat) desc
)
order by sum(soLuongDat) desc

-----  thong ke KHONG nam trong 3 san pham ban chay nhat
select tenSP,sum(soLuongDat) as soLuongdat
from ChiTietDonHang as c, SanPham as s
where c.maSP = s.maSP
group by tenSP
having sum(soLuongDat)  not in  (
			select distinct top 3 sum(soLuongDat)
			from ChiTietDonHang
			group by maSP
			order by sum(soLuongDat) desc
)
order by sum(soLuongDat) desc


--1.b thong ke nhung san pham chua ban duoc cai nao
select maSP,tenSP
from SanPham
where maSP not in ( select maSP from ChiTietDonHang )

-- 1.c hiển thị những đơn hàng giao thành công và thông tin cụ thể của người giao hàng
select maDH,NV.maNV,tenNV,Email,SDT
from DonDatHang_HoaDon as DDH_HD, NhanVien as NV
where trangThaiDonHang = N'Đã giao' and DDH_HD.maNV = NV.maNV

--1.d. hiển thị những đơn hàng của khách hàng ở Đà Nẵng hoặc Quảng Nam
select maDH,maKH,diachiGiaoHang
from DonDatHang_HoaDon
where diachiGiaoHang in( N'Đà Nẵng', N'Quảng Nam')

--1.e. hiển thị những sản phẩm có giá từ 500k – 2.000k
select maSP,tenSP,donGiaBan
from SanPham
where donGiaBan between 500000 and 2000000


-- thiếu year, bổ sung sau
--1.f. những tháng có doanh thu trên 2000000 (có tham số là định mức tiền)
select MONTH( ngayThanhToan ) as Thg , format(sum(soLuongDat * donGia),'##,#\ VNĐ','es-ES') as DoanhThu
from DonDatHang_HoaDon as DDH_HD, ChiTietDonHang as CTDH
where DDH_HD.maDH = CTDH.maDH
group by MONTH( ngayThanhToan ),YEAR(ngayThanhToan)
having sum(soLuongDat * donGia) >2000000

--1g. thống kê số lượng khách theo từng tỉnh/thành phố (sắp xếp giảm dần) dựa trên việc bổ sung 3 thực thể: Phường_Xã, Quận_Huyện, Tỉnh_ThànhPhố
select  count(KH.maKH) as SLKhachHang, TT.tenThanhPho
from KhachHang as KH, DonDatHang_HoaDon as DDH_HD ,XaPhuong as XP, QuanHuyen as QH, TinhThanh as TT
where KH.maKH = DDH_HD.maKH and DDH_HD.idXP = xp.idXP and  XP.idQH= QH.idQH and TT.idTT =QH.idTT
group by TT.tenThanhPho
order by SLKhachHang desc


--1h. thống kê giá trung bình, giá max, giá min nhập hàng cho mỗi sản phẩm
select a.maSP as N'Mã sản phẩm', b.tenSP as N'Tên sản phẩm', 
		format(avg(distinct a.giaNhap),'##,#\ VNĐ','es-ES') as 'Giá nhập trung bình', 
		format(max(a.giaNhap),'##,#\ VNĐ','es-ES') as 'Giá nhập max', 
		format(min(a.giaNhap),'##,#\ VNĐ','es-ES') as 'Giá nhập min'
from ChiTietPhieuNhap as a, SanPham as b
where a.maSP = b.maSP 
group by a.maSP, b.tenSP


--1i. hiển thị giá trung bình, giá max, giá min bán ra cho mỗi sản phẩm
select a.maSP as N'Mã sản phẩm', b.tenSP as N'Tên sản phẩm', 
		format(avg(distinct a.donGia),'##,#\ VNĐ','es-ES') as 'Giá bán trung bình', 
		format(max(a.donGia),'##,#\ VNĐ','es-ES') as 'Giá bán max',
		format(min(a.donGia),'##,#\ VNĐ','es-ES') as 'Giá bán min'
from ChiTietDonHang as a, SanPham as b
where a.maSP = b.maSP
group by a.maSP, b.tenSP

--1j. thống kê số lần khách hàng mua hàng của từng khách hàng (sắp xếp giảm dần)
select DDH_HD.maKH, tenKH, COUNT(DDH_HD.maKH) as  SoLanMua
from DonDatHang_HoaDon as DDH_HD, KhachHang as KH
where DDH_HD.maKH = KH.maKH
group by DDH_HD.maKH,tenKH
order by SoLanMua desc


--1k. hiển thị thông tin chi tiết của các sản phẩm mà có số lần nhập hàng nhiều nhất
--cach 2 with ties  luu y phai co  và group đúng, thừa đơn giá là sai
select top 1 with ties CTPN.maSP, tenSP,count(CTPN.masp) as SLanNhap 
from ChiTietPhieuNhap as CTPN, SanPham as SP
where SP.maSP = CTPN.maSP
group by CTPN.maSP,tenSP
order by COUNT(CTPN.maSP) desc

-- cach 2  của CÔ 
select c.masp,s.tensp,count(c.masp) as SL
from ChiTietPhieuNhap as c, SanPham as s
where c.maSP=s.maSP --and
group by c.maSP,s.tenSP
having count(c.masp) >= (select top 1 count(masp) as NN
							from ChiTietPhieuNhap
							group by maSP
							order by NN desc --subquery count
						)
order by SL desc

--1.l. hiển thị thông tin chi tiết của các nhà cung cấp mà có số lần nhập hàng lớn hơn 3
select NCC.tenNCC, NCC.diaChiNCC,NCC.SDT, NCC.nhanVienLienHe,COUNT(PN.maNCC) AS N'Số lần nhập'
from NhaCungCap as NCC, PhieuNhap as PN
where PN.maNCC=NCC.maNCC
group by PN.maNCC, NCC.tenNCC,NCC.diaChiNCC,NCC.SDT ,NCC.nhanVienLienHe
having count(PN.maNCC) >3




-- 2a. Hiển thị những đơn hàng không cần được xuất hóa đơn
select * 
from DonDatHang_HoaDon 
where maHoaDonDienTu is NULL




--3. Tao view
--3a. Tách thành phần họ và tên thành 2 cột riêng/ Hoặc gộp 2 thành phần này thành một
go
create view TachHoTen
as
select tenKH, SUBSTRING(KhachHang.tenKH, 1, LEN(KhachHang.tenKH) - CHARINDEX (' ', REVERSE(KhachHang.tenKH))) as Ho,
				LTRIM(RIGHT(+ KhachHang.tenKH, CHARINDEX (' ', REVERSE(+ KhachHang.tenKH)))) as Ten
from KhachHang

--3b. Chỉ chứa tất cả thông tin những đơn hàng chưa được giao
   --3b.i DonDatHang_HoaDon
go 
create view TTDonChuaGiao
as
select *
from DonDatHang_HoaDon 
where trangThaiDonHang != N'Đã giao'
---cach khac in(N'Đã duyệt - Đang đóng gói',N'Chờ duyệt',N'Đang giao')


  --3b.ii thông tin ở bảng chi tiết đơn hàng
go

create view CTDH_ChuaDuocGiao
as
select ctdh.maDH,ctdh.maSP, soLuongDat, donGia
from DonDatHang_HoaDon as DDH, ChiTietDonHang as ctdh
where ctdh.maDH=DDH.maDH and DDH.trangThaiDonHang in (N'Đã duyệt – Đang đóng gói', N'Đang giao', N'Chờ duyệt')

--3c. tuong tu cho bang phieu nhap
go
create view NhungDonChuaNhap as
	select maPN, maNCC
	from PhieuNhap
	where ngayNhapHang is NULL

-- 3d Chi chua  nhung nhan vien dang lam viec , bo qua nhung nhan vien da nghi (nhung khong duoc xoa)
	-- chen them column ngayThoiViec
go
create view NhanVienDangLamViec
as
select *
from NhanVien as nv
where ngayThoiViec is not null
