//coQuanQuanLyId - long
long coQuanQuanLyId = ParamUtil.getLong(request,"coQuanQuanLyId2");
hoSo.setCoQuanQuanLyId(coQuanQuanLyId);

// ten1Tab1TabByTan - String 
String ten1Tab1 = ParamUtil.getString(request,"ten1Tab1TabByTan").trim();
hoSo.setTen1Tab1(ten1Tab1);

// quocGia1Tab1 - long
long quocGia1Tab1 = ParamUtil.getLong(request,"quocGia1Tab1TabByTan");
hoSo.setQuocGia1Tab1(quocGia1Tab1);

// tinh1TabByTan - long
long tinh1 = ParamUtil.getLong(request,"tinh1TabByTan");
hoSo.setTinh1(tinh1);

//  quan1TabByTan - long
long quan1 = ParamUtil.getLong(request,"quan1TabByTan");
hoSo.setQuan1(quan1);

// xa1TabByTan - long
long xa1 = ParamUtil.getLong(request,"xa1TabByTan");
hoSo.setXa1(xa1);

// diaChi1TabByTan - long
String diaChi1 = ParamUtil.getString(request,"diaChi1TabByTan").trim();
hoSo.setDiaChi1(diaChi1);

// radio1Tab1TabByTan - String 
String radio1Tab1 = ParamUtil.getString(request,"radio1Tab1TabByTan").trim();
hoSo.setRadio1Tab1(radio1Tab1);

// cmnd1Tab1TabByTan - String 
String cmnd1Tab1 = ParamUtil.getString(request,"cmnd1Tab1TabByTan").trim();
hoSo.setCmnd1Tab1(cmnd1Tab1);

// ngayCapCmnd1Tab1TabByTan - Date
String ngayCapCmnd1Tab1 = ParamUtil.getString(request,"ngayCapCmnd1Tab1TabByTan");
if(ngayCapCmnd1Tab1.length()>0)
hoSo.setNgayCapCmnd1Tab1(ActionUtils.parseStringToDate(ngayCapCmnd1Tab1));

// noiCapCmnd1Tab1 - long
long noiCapCmnd1Tab1 = ParamUtil.getLong(request,"noiCapCmnd1Tab1TabByTan");
hoSo.setNoiCapCmnd1Tab1(noiCapCmnd1Tab1);

// hoChieu1Tab1TabByTan - String 
String hoChieu1Tab1 = ParamUtil.getString(request,"hoChieu1Tab1TabByTan").trim();
hoSo.setHoChieu1Tab1(hoChieu1Tab1);

// ngayCapHoChieu1Tab1TabByTan - Date
String ngayCapHoChieu1Tab1 = ParamUtil.getString(request,"ngayCapHoChieu1Tab1TabByTan");
if(ngayCapHoChieu1Tab1.length()>0)
hoSo.setNgayCapHoChieu1Tab1(ActionUtils.parseStringToDate(ngayCapHoChieu1Tab1));

// noiCapHoChieu1Tab1TabByTan - String 
String noiCapHoChieu1Tab1 = ParamUtil.getString(request,"noiCapHoChieu1Tab1TabByTan").trim();
hoSo.setNoiCapHoChieu1Tab1(noiCapHoChieu1Tab1);

// tenGTK1Tab1TabByTan - String 
String tenGTK1Tab1 = ParamUtil.getString(request,"tenGTK1Tab1TabByTan").trim();
hoSo.setTenGTK1Tab1(tenGTK1Tab1);

// soGTK1Tab1TabByTan - String 
String soGTK1Tab1 = ParamUtil.getString(request,"soGTK1Tab1TabByTan").trim();
hoSo.setSoGTK1Tab1(soGTK1Tab1);

// noiCapGTK1Tab1TabByTan - String 
String noiCapGTK1Tab1 = ParamUtil.getString(request,"noiCapGTK1Tab1TabByTan").trim();
hoSo.setNoiCapGTK1Tab1(noiCapGTK1Tab1);

// ngayCapGTK1Tab1TabByTan - Date
String ngayCapGTK1Tab1 = ParamUtil.getString(request,"ngayCapGTK1Tab1TabByTan");
if(ngayCapGTK1Tab1.length()>0)
hoSo.setNgayCapGTK1Tab1(ActionUtils.parseStringToDate(ngayCapGTK1Tab1));

// quanHe1Tab1 - long
long quanHe1Tab1 = ParamUtil.getLong(request,"quanHe1Tab1TabByTan");
hoSo.setQuanHe1Tab1(quanHe1Tab1);

// ten2Tab1TabByTan - String 
String ten2Tab1 = ParamUtil.getString(request,"ten2Tab1TabByTan").trim();
hoSo.setTen2Tab1(ten2Tab1);

// sex1Tab1 - long
long sex1Tab1 = ParamUtil.getLong(request,"sex1Tab1TabByTan");
hoSo.setSex1Tab1(sex1Tab1);

// ngaySinh1Tab1TabByTan - Date
String ngaySinh1Tab1 = ParamUtil.getString(request,"ngaySinh1Tab1TabByTan");
if(ngaySinh1Tab1.length()>0)
hoSo.setNgaySinh1Tab1(ActionUtils.parseStringToDate(ngaySinh1Tab1));

// ngaySinhBangChu1Tab1TabByTan - String 
String ngaySinhBangChu1Tab1 = ParamUtil.getString(request,"ngaySinhBangChu1Tab1TabByTan").trim();
hoSo.setNgaySinhBangChu1Tab1(ngaySinhBangChu1Tab1);

// sex2Tab1 - long
long sex2Tab1 = ParamUtil.getLong(request,"sex2Tab1TabByTan");
hoSo.setSex2Tab1(sex2Tab1);

// birth2Tab1TabByTan - Date
String birth2Tab1 = ParamUtil.getString(request,"birth2Tab1TabByTan");
if(birth2Tab1.length()>0)
hoSo.setBirth2Tab1(ActionUtils.parseStringToDate(birth2Tab1));

// birth2BangChuTab1TabByTan - String 
String birth2BangChuTab1 = ParamUtil.getString(request,"birth2BangChuTab1TabByTan").trim();
hoSo.setBirth2BangChuTab1(birth2BangChuTab1);

// danToc2Tab1 - long
long danToc2Tab1 = ParamUtil.getLong(request,"danToc2Tab1TabByTan");
hoSo.setDanToc2Tab1(danToc2Tab1);

// quocTich2Tab1 - long
long quocTich2Tab1 = ParamUtil.getLong(request,"quocTich2Tab1TabByTan");
hoSo.setQuocTich2Tab1(quocTich2Tab1);

// quocGia2Tab1 - long
long quocGia2Tab1 = ParamUtil.getLong(request,"quocGia2Tab1TabByTan");
hoSo.setQuocGia2Tab1(quocGia2Tab1);

// tinh2TabByTan - long
long tinh2 = ParamUtil.getLong(request,"tinh2TabByTan");
hoSo.setTinh2(tinh2);

//  quan2TabByTan - long
long quan2 = ParamUtil.getLong(request,"quan2TabByTan");
hoSo.setQuan2(quan2);

// xa2TabByTan - long
long xa2 = ParamUtil.getLong(request,"xa2TabByTan");
hoSo.setXa2(xa2);

// diaChi2TabByTan - long
String diaChi2 = ParamUtil.getString(request,"diaChi2TabByTan").trim();
hoSo.setDiaChi2(diaChi2);

// ten3Tab1TabByTan - String 
String ten3Tab1 = ParamUtil.getString(request,"ten3Tab1TabByTan").trim();
hoSo.setTen3Tab1(ten3Tab1);

// birth3Tab1TabByTan - Date
String birth3Tab1 = ParamUtil.getString(request,"birth3Tab1TabByTan");
if(birth3Tab1.length()>0)
hoSo.setBirth3Tab1(ActionUtils.parseStringToDate(birth3Tab1));

// danToc3Tab1 - long
long danToc3Tab1 = ParamUtil.getLong(request,"danToc3Tab1TabByTan");
hoSo.setDanToc3Tab1(danToc3Tab1);

// quocTich3Tab1 - long
long quocTich3Tab1 = ParamUtil.getLong(request,"quocTich3Tab1TabByTan");
hoSo.setQuocTich3Tab1(quocTich3Tab1);

// quocGia3Tab1 - long
long quocGia3Tab1 = ParamUtil.getLong(request,"quocGia3Tab1TabByTan");
hoSo.setQuocGia3Tab1(quocGia3Tab1);

// tinh3TabByTan - long
long tinh3 = ParamUtil.getLong(request,"tinh3TabByTan");
hoSo.setTinh3(tinh3);

//  quan3TabByTan - long
long quan3 = ParamUtil.getLong(request,"quan3TabByTan");
hoSo.setQuan3(quan3);

// xa3TabByTan - long
long xa3 = ParamUtil.getLong(request,"xa3TabByTan");
hoSo.setXa3(xa3);

// diaChi3TabByTan - long
String diaChi3 = ParamUtil.getString(request,"diaChi3TabByTan").trim();
hoSo.setDiaChi3(diaChi3);

// ten4Tab1TabByTan - String 
String ten4Tab1 = ParamUtil.getString(request,"ten4Tab1TabByTan").trim();
hoSo.setTen4Tab1(ten4Tab1);

// birth4Tab1TabByTan - Date
String birth4Tab1 = ParamUtil.getString(request,"birth4Tab1TabByTan");
if(birth4Tab1.length()>0)
hoSo.setBirth4Tab1(ActionUtils.parseStringToDate(birth4Tab1));

// danToc4Tab1 - long
long danToc4Tab1 = ParamUtil.getLong(request,"danToc4Tab1TabByTan");
hoSo.setDanToc4Tab1(danToc4Tab1);

// quocTich4Tab1 - long
long quocTich4Tab1 = ParamUtil.getLong(request,"quocTich4Tab1TabByTan");
hoSo.setQuocTich4Tab1(quocTich4Tab1);

// quocGia4Tab1 - long
long quocGia4Tab1 = ParamUtil.getLong(request,"quocGia4Tab1TabByTan");
hoSo.setQuocGia4Tab1(quocGia4Tab1);

// tinh4TabByTan - long
long tinh4 = ParamUtil.getLong(request,"tinh4TabByTan");
hoSo.setTinh4(tinh4);

//  quan4TabByTan - long
long quan4 = ParamUtil.getLong(request,"quan4TabByTan");
hoSo.setQuan4(quan4);

// xa4TabByTan - long
long xa4 = ParamUtil.getLong(request,"xa4TabByTan");
hoSo.setXa4(xa4);

// diaChi4TabByTan - long
String diaChi4 = ParamUtil.getString(request,"diaChi4TabByTan").trim();
hoSo.setDiaChi4(diaChi4);

// ten1Tab2TabByTan - String 
String ten1Tab2 = ParamUtil.getString(request,"ten1Tab2TabByTan").trim();
hoSo.setTen1Tab2(ten1Tab2);

// birth1Tab2TabByTan - Date
String birth1Tab2 = ParamUtil.getString(request,"birth1Tab2TabByTan");
if(birth1Tab2.length()>0)
hoSo.setBirth1Tab2(ActionUtils.parseStringToDate(birth1Tab2));

// danToc1Tab2 - long
long danToc1Tab2 = ParamUtil.getLong(request,"danToc1Tab2TabByTan");
hoSo.setDanToc1Tab2(danToc1Tab2);

// quocTich1Tab2 - long
long quocTich1Tab2 = ParamUtil.getLong(request,"quocTich1Tab2TabByTan");
hoSo.setQuocTich1Tab2(quocTich1Tab2);

// tinh5TabByTan - long
long tinh5 = ParamUtil.getLong(request,"tinh5TabByTan");
hoSo.setTinh5(tinh5);

//  quan5TabByTan - long
long quan5 = ParamUtil.getLong(request,"quan5TabByTan");
hoSo.setQuan5(quan5);

// xa5TabByTan - long
long xa5 = ParamUtil.getLong(request,"xa5TabByTan");
hoSo.setXa5(xa5);

// diaChi5TabByTan - long
String diaChi5 = ParamUtil.getString(request,"diaChi5TabByTan").trim();
hoSo.setDiaChi5(diaChi5);

// radio1Tab2TabByTan - String 
String radio1Tab2 = ParamUtil.getString(request,"radio1Tab2TabByTan").trim();
hoSo.setRadio1Tab2(radio1Tab2);

// cmnd1Tab2TabByTan - String 
String cmnd1Tab2 = ParamUtil.getString(request,"cmnd1Tab2TabByTan").trim();
hoSo.setCmnd1Tab2(cmnd1Tab2);

// ngayCapCmnd1Tab2TabByTan - Date
String ngayCapCmnd1Tab2 = ParamUtil.getString(request,"ngayCapCmnd1Tab2TabByTan");
if(ngayCapCmnd1Tab2.length()>0)
hoSo.setNgayCapCmnd1Tab2(ActionUtils.parseStringToDate(ngayCapCmnd1Tab2));

// noiCapCmnd1Tab2 - long
long noiCapCmnd1Tab2 = ParamUtil.getLong(request,"noiCapCmnd1Tab2TabByTan");
hoSo.setNoiCapCmnd1Tab2(noiCapCmnd1Tab2);

// hoChieu1Tab2TabByTan - String 
String hoChieu1Tab2 = ParamUtil.getString(request,"hoChieu1Tab2TabByTan").trim();
hoSo.setHoChieu1Tab2(hoChieu1Tab2);

// noiCapHoChieu1Tab2 - long
long noiCapHoChieu1Tab2 = ParamUtil.getLong(request,"noiCapHoChieu1Tab2TabByTan");
hoSo.setNoiCapHoChieu1Tab2(noiCapHoChieu1Tab2);

// ngayCapHoChieu1Tab2TabByTan - Date
String ngayCapHoChieu1Tab2 = ParamUtil.getString(request,"ngayCapHoChieu1Tab2TabByTan");
if(ngayCapHoChieu1Tab2.length()>0)
hoSo.setNgayCapHoChieu1Tab2(ActionUtils.parseStringToDate(ngayCapHoChieu1Tab2));

// tenGTK1Tab2TabByTan - String 
String tenGTK1Tab2 = ParamUtil.getString(request,"tenGTK1Tab2TabByTan").trim();
hoSo.setTenGTK1Tab2(tenGTK1Tab2);

// soGTK1Tab2TabByTan - String 
String soGTK1Tab2 = ParamUtil.getString(request,"soGTK1Tab2TabByTan").trim();
hoSo.setSoGTK1Tab2(soGTK1Tab2);

// noiCapGTK1Tab2TabByTan - String 
String noiCapGTK1Tab2 = ParamUtil.getString(request,"noiCapGTK1Tab2TabByTan").trim();
hoSo.setNoiCapGTK1Tab2(noiCapGTK1Tab2);

// ngayCapGTK1Tab2TabByTan - Date
String ngayCapGTK1Tab2 = ParamUtil.getString(request,"ngayCapGTK1Tab2TabByTan");
if(ngayCapGTK1Tab2.length()>0)
hoSo.setNgayCapGTK1Tab2(ActionUtils.parseStringToDate(ngayCapGTK1Tab2));

// quanHe1 - long
long quanHe1 = ParamUtil.getLong(request,"quanHe1TabByTan");
hoSo.setQuanHe1(quanHe1);

// ten2Tab2TabByTan - String 
String ten2Tab2 = ParamUtil.getString(request,"ten2Tab2TabByTan").trim();
hoSo.setTen2Tab2(ten2Tab2);

// birth2Tab2TabByTan - Date
String birth2Tab2 = ParamUtil.getString(request,"birth2Tab2TabByTan");
if(birth2Tab2.length()>0)
hoSo.setBirth2Tab2(ActionUtils.parseStringToDate(birth2Tab2));

// danToc2Tab2 - long
long danToc2Tab2 = ParamUtil.getLong(request,"danToc2Tab2TabByTan");
hoSo.setDanToc2Tab2(danToc2Tab2);

// quocTich2Tab2 - long
long quocTich2Tab2 = ParamUtil.getLong(request,"quocTich2Tab2TabByTan");
hoSo.setQuocTich2Tab2(quocTich2Tab2);

// tinh6TabByTan - long
long tinh6 = ParamUtil.getLong(request,"tinh6TabByTan");
hoSo.setTinh6(tinh6);

//  quan6TabByTan - long
long quan6 = ParamUtil.getLong(request,"quan6TabByTan");
hoSo.setQuan6(quan6);

// xa6TabByTan - long
long xa6 = ParamUtil.getLong(request,"xa6TabByTan");
hoSo.setXa6(xa6);

// diaChi6TabByTan - long
String diaChi6 = ParamUtil.getString(request,"diaChi6TabByTan").trim();
hoSo.setDiaChi6(diaChi6);

// radio2Tab2TabByTan - String 
String radio2Tab2 = ParamUtil.getString(request,"radio2Tab2TabByTan").trim();
hoSo.setRadio2Tab2(radio2Tab2);

// cmnd2Tab2TabByTan - String 
String cmnd2Tab2 = ParamUtil.getString(request,"cmnd2Tab2TabByTan").trim();
hoSo.setCmnd2Tab2(cmnd2Tab2);

// ngayCapCmnd2Tab2TabByTan - Date
String ngayCapCmnd2Tab2 = ParamUtil.getString(request,"ngayCapCmnd2Tab2TabByTan");
if(ngayCapCmnd2Tab2.length()>0)
hoSo.setNgayCapCmnd2Tab2(ActionUtils.parseStringToDate(ngayCapCmnd2Tab2));

// noiCapCmnd2Tab2 - long
long noiCapCmnd2Tab2 = ParamUtil.getLong(request,"noiCapCmnd2Tab2TabByTan");
hoSo.setNoiCapCmnd2Tab2(noiCapCmnd2Tab2);

// hoChieu2Tab2TabByTan - String 
String hoChieu2Tab2 = ParamUtil.getString(request,"hoChieu2Tab2TabByTan").trim();
hoSo.setHoChieu2Tab2(hoChieu2Tab2);

// noiCapHoChieu2Tab2 - long
long noiCapHoChieu2Tab2 = ParamUtil.getLong(request,"noiCapHoChieu2Tab2TabByTan");
hoSo.setNoiCapHoChieu2Tab2(noiCapHoChieu2Tab2);

// ngayCapHoChieu2Tab2TabByTan - Date
String ngayCapHoChieu2Tab2 = ParamUtil.getString(request,"ngayCapHoChieu2Tab2TabByTan");
if(ngayCapHoChieu2Tab2.length()>0)
hoSo.setNgayCapHoChieu2Tab2(ActionUtils.parseStringToDate(ngayCapHoChieu2Tab2));

// tenGTK2Tab2TabByTan - String 
String tenGTK2Tab2 = ParamUtil.getString(request,"tenGTK2Tab2TabByTan").trim();
hoSo.setTenGTK2Tab2(tenGTK2Tab2);

// soGTK2Tab2TabByTan - String 
String soGTK2Tab2 = ParamUtil.getString(request,"soGTK2Tab2TabByTan").trim();
hoSo.setSoGTK2Tab2(soGTK2Tab2);

// noiCapGTK2Tab2TabByTan - String 
String noiCapGTK2Tab2 = ParamUtil.getString(request,"noiCapGTK2Tab2TabByTan").trim();
hoSo.setNoiCapGTK2Tab2(noiCapGTK2Tab2);

// ngayCapGTK2Tab2TabByTan - Date
String ngayCapGTK2Tab2 = ParamUtil.getString(request,"ngayCapGTK2Tab2TabByTan");
if(ngayCapGTK2Tab2.length()>0)
hoSo.setNgayCapGTK2Tab2(ActionUtils.parseStringToDate(ngayCapGTK2Tab2));

// quanHe2Tab2 - long
long quanHe2Tab2 = ParamUtil.getLong(request,"quanHe2Tab2TabByTan");
hoSo.setQuanHe2Tab2(quanHe2Tab2);

// ten3Tab2TabByTan - String 
String ten3Tab2 = ParamUtil.getString(request,"ten3Tab2TabByTan").trim();
hoSo.setTen3Tab2(ten3Tab2);

// birth3Tab2TabByTan - Date
String birth3Tab2 = ParamUtil.getString(request,"birth3Tab2TabByTan");
if(birth3Tab2.length()>0)
hoSo.setBirth3Tab2(ActionUtils.parseStringToDate(birth3Tab2));

// danToc3Tab2 - long
long danToc3Tab2 = ParamUtil.getLong(request,"danToc3Tab2TabByTan");
hoSo.setDanToc3Tab2(danToc3Tab2);

// quocTich3Tab2 - long
long quocTich3Tab2 = ParamUtil.getLong(request,"quocTich3Tab2TabByTan");
hoSo.setQuocTich3Tab2(quocTich3Tab2);

// tinh7TabByTan - long
long tinh7 = ParamUtil.getLong(request,"tinh7TabByTan");
hoSo.setTinh7(tinh7);

//  quan7TabByTan - long
long quan7 = ParamUtil.getLong(request,"quan7TabByTan");
hoSo.setQuan7(quan7);

// xa7TabByTan - long
long xa7 = ParamUtil.getLong(request,"xa7TabByTan");
hoSo.setXa7(xa7);

// diaChi7TabByTan - long
String diaChi7 = ParamUtil.getString(request,"diaChi7TabByTan").trim();
hoSo.setDiaChi7(diaChi7);

// radio3Tab2TabByTan - String 
String radio3Tab2 = ParamUtil.getString(request,"radio3Tab2TabByTan").trim();
hoSo.setRadio3Tab2(radio3Tab2);

// cmnd3Tab2TabByTan - String 
String cmnd3Tab2 = ParamUtil.getString(request,"cmnd3Tab2TabByTan").trim();
hoSo.setCmnd3Tab2(cmnd3Tab2);

// ngayCapCmnd3Tab2TabByTan - Date
String ngayCapCmnd3Tab2 = ParamUtil.getString(request,"ngayCapCmnd3Tab2TabByTan");
if(ngayCapCmnd3Tab2.length()>0)
hoSo.setNgayCapCmnd3Tab2(ActionUtils.parseStringToDate(ngayCapCmnd3Tab2));

// noiCapCmnd3Tab2 - long
long noiCapCmnd3Tab2 = ParamUtil.getLong(request,"noiCapCmnd3Tab2TabByTan");
hoSo.setNoiCapCmnd3Tab2(noiCapCmnd3Tab2);

// hoChieu3Tab2TabByTan - String 
String hoChieu3Tab2 = ParamUtil.getString(request,"hoChieu3Tab2TabByTan").trim();
hoSo.setHoChieu3Tab2(hoChieu3Tab2);

// noiCapHoChieu3Tab2 - long
long noiCapHoChieu3Tab2 = ParamUtil.getLong(request,"noiCapHoChieu3Tab2TabByTan");
hoSo.setNoiCapHoChieu3Tab2(noiCapHoChieu3Tab2);

// ngayCapHoChieu3Tab2TabByTan - Date
String ngayCapHoChieu3Tab2 = ParamUtil.getString(request,"ngayCapHoChieu3Tab2TabByTan");
if(ngayCapHoChieu3Tab2.length()>0)
hoSo.setNgayCapHoChieu3Tab2(ActionUtils.parseStringToDate(ngayCapHoChieu3Tab2));

// yKien1TabByTan - String 
String yKien1 = ParamUtil.getString(request,"yKien1TabByTan").trim();
hoSo.setYKien1(yKien1);

// yKien2TabByTan - String 
String yKien2 = ParamUtil.getString(request,"yKien2TabByTan").trim();
hoSo.setYKien2(yKien2);

