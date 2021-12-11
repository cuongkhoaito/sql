--1.Hãy xuất dạng Text giá tiền của những sản phẩm có giá tiền lớn nhất

begin
	declare @dongiaban money
	select @dongiaban = (select distinct top 1 with ties DonGiaBan
							from SanPham
							order by DonGiaBan desc)
	print  convert(text,convert(varchar, @dongiaban))
end

 
--2.Hãy viết đoạn lệnh để tìm giá trị id tiếp theo của bảng sản phẩm, và chèn dữ liệu vào bảng sản phẩm
begin
		declare @idmax int
		set @idmax= (select max (right (maSP, 5))
		from SanPham)
		declare @spnext char(7)
		set @spnext = CONCAT ('SP', format (@idmax+1, 'D2'))
		print N'id tiep theo cua bang san pham la: ' +@SPnext
		insert into SanPham
		VALUES	(@SPnext,N'BÀN PHÍM','20000','3','5')
end


-- 3.Hãy viết đoạn lệnh để đếm số lần mua hàng của từng khách hàng, nếu số lần mua lớn hơn hoặc 
   --bằng 10 thì ghi ‘Khách hàng thân thiết’, ngược lại ghi ‘Khách hàng tiềm năng

begin
	select count(maKH) as SoLanMua, maKh,
		case 
			when count(maKH) >= 10 then N'Khách hàng thân thiết'
		else
			N'Khách hàng tiềm năng'
		end as N'Thong bao'
	from DonDatHang_HoaDon
	group by maKH
end



--4.Hãy viết đoạn lệnh để tính tiền cho đơn hàng mới nhất (đơn hàng vừa được mua).
	--4.1.Nếu tổng tiền lớn hơn 1.000.000 thì áp dụng giảm 10% và cập nhật lại tổng tiền mới cần trả;
	--Nếu tổng tiền từ 400.000 đến dưới 1.000.000 thì tổng tiền không cần cộng phí ship;
	--Nếu tổng tiền nhỏ hơn 400.000 thì tổng tiền gồm tổng tiền hàng và phí ship (giả sử phí ship là 40.000)


select c.maDH, sum(soluongDat*donGia) as N'Tổng tiền ban đầu',
	case
		when sum(soluongDat*donGia)>1000000+40000 then sum(soluongDat*donGia)*0.9
		when sum(soluongDat*donGia)>=400000 and sum(soluongDat*donGia)<1000000 then sum(soluongDat*donGia)
		else sum(soluongDat*donGia)+40000
	end as N'TỔNG TIỀN THANH TOÁN'
from ChiTietDonHang as c
join DonDatHang_HoaDon as d
on  c.maDH = d.maDH
where ngayTaoDH in (select top 1 max(ngayTaoDH)
							from DonDatHang_HoaDon)
group by c.maDH

--Hãy viết đoạn lệnh để thực hiện yêu cầu: kiểm tra xem có đơn hàng nào mà tồn tại số lượng mua lớn hơn 
--số lượng hiện có -> nếu có thì cập nhật số lượng hiện còn của các sản phẩm nằm trong giỏ hàng mà có số 
--lượng đặt lớn hơn số lượng hiện còn  bằng cách gán về số lượng đặt là 0


UPDATE ChiTietDonHang
SET soluongDat=0
WHERE maDH in ( select maDH
               from ChiTietDonHang as ctdh
               join SanPham as sp
                  on ctdh.maSP = sp.maSP 
               where soluongDat > soluongHienCon);


-- cach khac
select maDH,c.maSP,soluongHienCon,
	case
		when c.soluongDat>s.soluongHienCon then soluongDat*0
		else soluongDat
		end as N'Số lượng đặt'
from SanPham as s
join ChiTietDonHang as c
on s.maSP= c.maSP
	