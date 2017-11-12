//ten1Tab1TabByTan - input *
String ten1Tab1TabByTan = ParamUtil.getString(request, "ten1Tab1TabByTan").trim();
if (ten1Tab1TabByTan.length() == 0 ) {
	SessionErrors.add(request, "ten1Tab1TabByTan");
	valid = false;
}

//quocGia1Tab1TabByTan - nation *
 long quocGia1Tab1TabByTan = ParamUtil.getLong(request, "quocGia1Tab1TabByTan");
 if(quocGia1Tab1TabByTan <= 0){
 	SessionErrors.add(request, "quocGia1Tab1TabByTan");
 	valid = false;
 }

// tinh1TabByTan - address *
 long tinh1TabByTan = ParamUtil.getLong(request, "tinh1TabByTan");
 if(tinh1TabByTan <= 0){
	 SessionErrors.add(request, "tinh1TabByTan");
	 valid = false;
 }

// quan1TabByTan - address *
 long quan1TabByTan = ParamUtil.getLong(request, "quan1TabByTan");
 if(quan1TabByTan <= 0){
	 SessionErrors.add(request, "quan1TabByTan");
	 valid = false;
 }

// xa1TabByTan - address *
 long xa1TabByTan = ParamUtil.getLong(request, "xa1TabByTan");
 if(xa1TabByTan <= 0){
	 SessionErrors.add(request, "xa1TabByTan");
	 valid = false;
 }

// diaChi1TabByTan - address *
 String diaChi1TabByTan = ParamUtil.getString(request, "diaChi1TabByTan").trim();
 if(diaChi1TabByTan.length() == 0){
	 SessionErrors.add(request, "diaChi1TabByTan");
	 valid = false;
 }



//cmnd1Tab1TabByTan - cmnd *
String cmnd1Tab1TabByTan = ParamUtil.getString(request, "cmnd1Tab1TabByTan").trim();
if (cmnd1Tab1TabByTan.length() == 0) {
SessionErrors.add(request, "cmnd1Tab1TabByTan");
valid = false;
}else if (cmnd1Tab1TabByTan.length() > 0 && !ActionUtils.regexCmnd(cmnd1Tab1TabByTan)) {
	SessionErrors.add(request, "cmnd1Tab1TabByTan"+ "NhapSai");
	valid = false;
}

//ngayCapCmnd1Tab1TabByTan - Date *
String ngayCapCmnd1Tab1TabByTan = ParamUtil.getString(request, "ngayCapCmnd1Tab1TabByTan").trim();
if (ngayCapCmnd1Tab1TabByTan.length() == 0) {
SessionErrors.add(request, "ngayCapCmnd1Tab1TabByTan");
valid = false;
} else {
try {
if (ngayCapCmnd1Tab1TabByTan.length() > 0 && ActionUtils.compareTwoDates(ngayCapCmnd1Tab1TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapCmnd1Tab1TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//noiCapCmnd1Tab1TabByTan - cmnd *
 long noiCapCmnd1Tab1TabByTan = ParamUtil.getLong(request, "noiCapCmnd1Tab1TabByTan");
 if(noiCapCmnd1Tab1TabByTan <= 0){
 	SessionErrors.add(request, "noiCapCmnd1Tab1TabByTan");
 	valid = false;
 }

//hoChieu1Tab1TabByTan - input *
String hoChieu1Tab1TabByTan = ParamUtil.getString(request, "hoChieu1Tab1TabByTan").trim();
if (hoChieu1Tab1TabByTan.length() == 0 ) {
	SessionErrors.add(request, "hoChieu1Tab1TabByTan");
	valid = false;
}

//ngayCapHoChieu1Tab1TabByTan - Date *
String ngayCapHoChieu1Tab1TabByTan = ParamUtil.getString(request, "ngayCapHoChieu1Tab1TabByTan").trim();
if (ngayCapHoChieu1Tab1TabByTan.length() == 0) {
SessionErrors.add(request, "ngayCapHoChieu1Tab1TabByTan");
valid = false;
} else {
try {
if (ngayCapHoChieu1Tab1TabByTan.length() > 0 && ActionUtils.compareTwoDates(ngayCapHoChieu1Tab1TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapHoChieu1Tab1TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//noiCapHoChieu1Tab1TabByTan - input *
String noiCapHoChieu1Tab1TabByTan = ParamUtil.getString(request, "noiCapHoChieu1Tab1TabByTan").trim();
if (noiCapHoChieu1Tab1TabByTan.length() == 0 ) {
	SessionErrors.add(request, "noiCapHoChieu1Tab1TabByTan");
	valid = false;
}

//tenGTK1Tab1TabByTan - input *
String tenGTK1Tab1TabByTan = ParamUtil.getString(request, "tenGTK1Tab1TabByTan").trim();
if (tenGTK1Tab1TabByTan.length() == 0 ) {
	SessionErrors.add(request, "tenGTK1Tab1TabByTan");
	valid = false;
}

//soGTK1Tab1TabByTan - input *
String soGTK1Tab1TabByTan = ParamUtil.getString(request, "soGTK1Tab1TabByTan").trim();
if (soGTK1Tab1TabByTan.length() == 0 ) {
	SessionErrors.add(request, "soGTK1Tab1TabByTan");
	valid = false;
}

//noiCapGTK1Tab1TabByTan - input *
String noiCapGTK1Tab1TabByTan = ParamUtil.getString(request, "noiCapGTK1Tab1TabByTan").trim();
if (noiCapGTK1Tab1TabByTan.length() == 0 ) {
	SessionErrors.add(request, "noiCapGTK1Tab1TabByTan");
	valid = false;
}

//ngayCapGTK1Tab1TabByTan - Date *
String ngayCapGTK1Tab1TabByTan = ParamUtil.getString(request, "ngayCapGTK1Tab1TabByTan").trim();
if (ngayCapGTK1Tab1TabByTan.length() == 0) {
SessionErrors.add(request, "ngayCapGTK1Tab1TabByTan");
valid = false;
} else {
try {
if (ngayCapGTK1Tab1TabByTan.length() > 0 && ActionUtils.compareTwoDates(ngayCapGTK1Tab1TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapGTK1Tab1TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//quanHe1Tab1TabByTan - quanHe *
 long quanHe1Tab1TabByTan = ParamUtil.getLong(request, "quanHe1Tab1TabByTan");
 if(quanHe1Tab1TabByTan < 0){
 	SessionErrors.add(request, "quanHe1Tab1TabByTan");
 	valid = false;
 }

//ten2Tab1TabByTan - input *
String ten2Tab1TabByTan = ParamUtil.getString(request, "ten2Tab1TabByTan").trim();
if (ten2Tab1TabByTan.length() == 0 ) {
	SessionErrors.add(request, "ten2Tab1TabByTan");
	valid = false;
}

//sex1Tab1TabByTan - sex *
 long sex1Tab1TabByTan = ParamUtil.getLong(request, "sex1Tab1TabByTan");
 if(sex1Tab1TabByTan <= 0){
 	SessionErrors.add(request, "sex1Tab1TabByTan");
 	valid = false;
 }

//ngaySinh1Tab1TabByTan - Date *
String ngaySinh1Tab1TabByTan = ParamUtil.getString(request, "ngaySinh1Tab1TabByTan").trim();
if (ngaySinh1Tab1TabByTan.length() == 0) {
SessionErrors.add(request, "ngaySinh1Tab1TabByTan");
valid = false;
} else {
try {
if (ngaySinh1Tab1TabByTan.length() > 0 && ActionUtils.compareTwoDates(ngaySinh1Tab1TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngaySinh1Tab1TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//ngaySinhBangChu1Tab1TabByTan - input *
String ngaySinhBangChu1Tab1TabByTan = ParamUtil.getString(request, "ngaySinhBangChu1Tab1TabByTan").trim();
if (ngaySinhBangChu1Tab1TabByTan.length() == 0 ) {
	SessionErrors.add(request, "ngaySinhBangChu1Tab1TabByTan");
	valid = false;
}

//sex2Tab1TabByTan - sex *
 long sex2Tab1TabByTan = ParamUtil.getLong(request, "sex2Tab1TabByTan");
 if(sex2Tab1TabByTan <= 0){
 	SessionErrors.add(request, "sex2Tab1TabByTan");
 	valid = false;
 }

//birth2Tab1TabByTan - Date *
String birth2Tab1TabByTan = ParamUtil.getString(request, "birth2Tab1TabByTan").trim();
if (birth2Tab1TabByTan.length() == 0) {
SessionErrors.add(request, "birth2Tab1TabByTan");
valid = false;
} else {
try {
if (birth2Tab1TabByTan.length() > 0 && ActionUtils.compareTwoDates(birth2Tab1TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "birth2Tab1TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//birth2BangChuTab1TabByTan - input *
String birth2BangChuTab1TabByTan = ParamUtil.getString(request, "birth2BangChuTab1TabByTan").trim();
if (birth2BangChuTab1TabByTan.length() == 0 ) {
	SessionErrors.add(request, "birth2BangChuTab1TabByTan");
	valid = false;
}

//danToc2Tab1TabByTan - danToc *
 long danToc2Tab1TabByTan = ParamUtil.getLong(request, "danToc2Tab1TabByTan");
 if(danToc2Tab1TabByTan <= 0){
 	SessionErrors.add(request, "danToc2Tab1TabByTan");
 	valid = false;
 }

//quocTich2Tab1TabByTan - danToc *
 long quocTich2Tab1TabByTan = ParamUtil.getLong(request, "quocTich2Tab1TabByTan");
 if(quocTich2Tab1TabByTan <= 0){
 	SessionErrors.add(request, "quocTich2Tab1TabByTan");
 	valid = false;
 }

//quocGia2Tab1TabByTan - nation *
 long quocGia2Tab1TabByTan = ParamUtil.getLong(request, "quocGia2Tab1TabByTan");
 if(quocGia2Tab1TabByTan <= 0){
 	SessionErrors.add(request, "quocGia2Tab1TabByTan");
 	valid = false;
 }

// tinh2TabByTan - address *
 long tinh2TabByTan = ParamUtil.getLong(request, "tinh2TabByTan");
 if(tinh2TabByTan <= 0){
	 SessionErrors.add(request, "tinh2TabByTan");
	 valid = false;
 }

// quan2TabByTan - address *
 long quan2TabByTan = ParamUtil.getLong(request, "quan2TabByTan");
 if(quan2TabByTan <= 0){
	 SessionErrors.add(request, "quan2TabByTan");
	 valid = false;
 }

// xa2TabByTan - address *
 long xa2TabByTan = ParamUtil.getLong(request, "xa2TabByTan");
 if(xa2TabByTan <= 0){
	 SessionErrors.add(request, "xa2TabByTan");
	 valid = false;
 }

// diaChi2TabByTan - address *
 String diaChi2TabByTan = ParamUtil.getString(request, "diaChi2TabByTan").trim();
 if(diaChi2TabByTan.length() == 0){
	 SessionErrors.add(request, "diaChi2TabByTan");
	 valid = false;
 }



//birth3Tab1TabByTan - Date 
String birth3Tab1TabByTan = ParamUtil.getString(request, "birth3Tab1TabByTan").trim();
try {
if (birth3Tab1TabByTan.length() > 0 && ActionUtils.compareTwoDates(birth3Tab1TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "birth3Tab1TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}



//quocTich3Tab1TabByTan - nation *
 long quocTich3Tab1TabByTan = ParamUtil.getLong(request, "quocTich3Tab1TabByTan");
 if(quocTich3Tab1TabByTan <= 0){
 	SessionErrors.add(request, "quocTich3Tab1TabByTan");
 	valid = false;
 }

//quocGia3Tab1TabByTan - nation *
 long quocGia3Tab1TabByTan = ParamUtil.getLong(request, "quocGia3Tab1TabByTan");
 if(quocGia3Tab1TabByTan <= 0){
 	SessionErrors.add(request, "quocGia3Tab1TabByTan");
 	valid = false;
 }

// tinh3TabByTan - address *
 long tinh3TabByTan = ParamUtil.getLong(request, "tinh3TabByTan");
 if(tinh3TabByTan <= 0){
	 SessionErrors.add(request, "tinh3TabByTan");
	 valid = false;
 }

// quan3TabByTan - address *
 long quan3TabByTan = ParamUtil.getLong(request, "quan3TabByTan");
 if(quan3TabByTan <= 0){
	 SessionErrors.add(request, "quan3TabByTan");
	 valid = false;
 }

// xa3TabByTan - address *
 long xa3TabByTan = ParamUtil.getLong(request, "xa3TabByTan");
 if(xa3TabByTan <= 0){
	 SessionErrors.add(request, "xa3TabByTan");
	 valid = false;
 }

// diaChi3TabByTan - address *
 String diaChi3TabByTan = ParamUtil.getString(request, "diaChi3TabByTan").trim();
 if(diaChi3TabByTan.length() == 0){
	 SessionErrors.add(request, "diaChi3TabByTan");
	 valid = false;
 }



//birth4Tab1TabByTan - Date 
String birth4Tab1TabByTan = ParamUtil.getString(request, "birth4Tab1TabByTan").trim();
try {
if (birth4Tab1TabByTan.length() > 0 && ActionUtils.compareTwoDates(birth4Tab1TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "birth4Tab1TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}

//danToc4Tab1TabByTan - danToc *
 long danToc4Tab1TabByTan = ParamUtil.getLong(request, "danToc4Tab1TabByTan");
 if(danToc4Tab1TabByTan <= 0){
 	SessionErrors.add(request, "danToc4Tab1TabByTan");
 	valid = false;
 }





// tinh4TabByTan - address *
 long tinh4TabByTan = ParamUtil.getLong(request, "tinh4TabByTan");
 if(tinh4TabByTan <= 0){
	 SessionErrors.add(request, "tinh4TabByTan");
	 valid = false;
 }

// quan4TabByTan - address *
 long quan4TabByTan = ParamUtil.getLong(request, "quan4TabByTan");
 if(quan4TabByTan <= 0){
	 SessionErrors.add(request, "quan4TabByTan");
	 valid = false;
 }

// xa4TabByTan - address *
 long xa4TabByTan = ParamUtil.getLong(request, "xa4TabByTan");
 if(xa4TabByTan <= 0){
	 SessionErrors.add(request, "xa4TabByTan");
	 valid = false;
 }

// diaChi4TabByTan - address *
 String diaChi4TabByTan = ParamUtil.getString(request, "diaChi4TabByTan").trim();
 if(diaChi4TabByTan.length() == 0){
	 SessionErrors.add(request, "diaChi4TabByTan");
	 valid = false;
 }

//ten1Tab2TabByTan - input *
String ten1Tab2TabByTan = ParamUtil.getString(request, "ten1Tab2TabByTan").trim();
if (ten1Tab2TabByTan.length() == 0 ) {
	SessionErrors.add(request, "ten1Tab2TabByTan");
	valid = false;
}

//birth1Tab2TabByTan - Date *
String birth1Tab2TabByTan = ParamUtil.getString(request, "birth1Tab2TabByTan").trim();
if (birth1Tab2TabByTan.length() == 0) {
SessionErrors.add(request, "birth1Tab2TabByTan");
valid = false;
} else {
try {
if (birth1Tab2TabByTan.length() > 0 && ActionUtils.compareTwoDates(birth1Tab2TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "birth1Tab2TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//danToc1Tab2TabByTan - danToc *
 long danToc1Tab2TabByTan = ParamUtil.getLong(request, "danToc1Tab2TabByTan");
 if(danToc1Tab2TabByTan <= 0){
 	SessionErrors.add(request, "danToc1Tab2TabByTan");
 	valid = false;
 }

//quocTich1Tab2TabByTan - nation *
 long quocTich1Tab2TabByTan = ParamUtil.getLong(request, "quocTich1Tab2TabByTan");
 if(quocTich1Tab2TabByTan <= 0){
 	SessionErrors.add(request, "quocTich1Tab2TabByTan");
 	valid = false;
 }

// tinh5TabByTan - address *
 long tinh5TabByTan = ParamUtil.getLong(request, "tinh5TabByTan");
 if(tinh5TabByTan <= 0){
	 SessionErrors.add(request, "tinh5TabByTan");
	 valid = false;
 }

// quan5TabByTan - address *
 long quan5TabByTan = ParamUtil.getLong(request, "quan5TabByTan");
 if(quan5TabByTan <= 0){
	 SessionErrors.add(request, "quan5TabByTan");
	 valid = false;
 }

// xa5TabByTan - address *
 long xa5TabByTan = ParamUtil.getLong(request, "xa5TabByTan");
 if(xa5TabByTan <= 0){
	 SessionErrors.add(request, "xa5TabByTan");
	 valid = false;
 }

// diaChi5TabByTan - address *
 String diaChi5TabByTan = ParamUtil.getString(request, "diaChi5TabByTan").trim();
 if(diaChi5TabByTan.length() == 0){
	 SessionErrors.add(request, "diaChi5TabByTan");
	 valid = false;
 }



//cmnd1Tab2TabByTan - cmnd *
String cmnd1Tab2TabByTan = ParamUtil.getString(request, "cmnd1Tab2TabByTan").trim();
if (cmnd1Tab2TabByTan.length() == 0) {
SessionErrors.add(request, "cmnd1Tab2TabByTan");
valid = false;
}else if (cmnd1Tab2TabByTan.length() > 0 && !ActionUtils.regexCmnd(cmnd1Tab2TabByTan)) {
	SessionErrors.add(request, "cmnd1Tab2TabByTan"+ "NhapSai");
	valid = false;
}

//ngayCapCmnd1Tab2TabByTan - Date 
String ngayCapCmnd1Tab2TabByTan = ParamUtil.getString(request, "ngayCapCmnd1Tab2TabByTan").trim();
try {
if (ngayCapCmnd1Tab2TabByTan.length() > 0 && ActionUtils.compareTwoDates(ngayCapCmnd1Tab2TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapCmnd1Tab2TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}



//hoChieu1Tab2TabByTan - input *
String hoChieu1Tab2TabByTan = ParamUtil.getString(request, "hoChieu1Tab2TabByTan").trim();
if (hoChieu1Tab2TabByTan.length() == 0 ) {
	SessionErrors.add(request, "hoChieu1Tab2TabByTan");
	valid = false;
}



//ngayCapHoChieu1Tab2TabByTan - Date 
String ngayCapHoChieu1Tab2TabByTan = ParamUtil.getString(request, "ngayCapHoChieu1Tab2TabByTan").trim();
try {
if (ngayCapHoChieu1Tab2TabByTan.length() > 0 && ActionUtils.compareTwoDates(ngayCapHoChieu1Tab2TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapHoChieu1Tab2TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}

//tenGTK1Tab2TabByTan - input *
String tenGTK1Tab2TabByTan = ParamUtil.getString(request, "tenGTK1Tab2TabByTan").trim();
if (tenGTK1Tab2TabByTan.length() == 0 ) {
	SessionErrors.add(request, "tenGTK1Tab2TabByTan");
	valid = false;
}

//soGTK1Tab2TabByTan - input *
String soGTK1Tab2TabByTan = ParamUtil.getString(request, "soGTK1Tab2TabByTan").trim();
if (soGTK1Tab2TabByTan.length() == 0 ) {
	SessionErrors.add(request, "soGTK1Tab2TabByTan");
	valid = false;
}



//ngayCapGTK1Tab2TabByTan - Date 
String ngayCapGTK1Tab2TabByTan = ParamUtil.getString(request, "ngayCapGTK1Tab2TabByTan").trim();
try {
if (ngayCapGTK1Tab2TabByTan.length() > 0 && ActionUtils.compareTwoDates(ngayCapGTK1Tab2TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapGTK1Tab2TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}



//ten2Tab2TabByTan - input *
String ten2Tab2TabByTan = ParamUtil.getString(request, "ten2Tab2TabByTan").trim();
if (ten2Tab2TabByTan.length() == 0 ) {
	SessionErrors.add(request, "ten2Tab2TabByTan");
	valid = false;
}

//birth2Tab2TabByTan - Date *
String birth2Tab2TabByTan = ParamUtil.getString(request, "birth2Tab2TabByTan").trim();
if (birth2Tab2TabByTan.length() == 0) {
SessionErrors.add(request, "birth2Tab2TabByTan");
valid = false;
} else {
try {
if (birth2Tab2TabByTan.length() > 0 && ActionUtils.compareTwoDates(birth2Tab2TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "birth2Tab2TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//danToc2Tab2TabByTan - danToc *
 long danToc2Tab2TabByTan = ParamUtil.getLong(request, "danToc2Tab2TabByTan");
 if(danToc2Tab2TabByTan <= 0){
 	SessionErrors.add(request, "danToc2Tab2TabByTan");
 	valid = false;
 }

//quocTich2Tab2TabByTan - nation *
 long quocTich2Tab2TabByTan = ParamUtil.getLong(request, "quocTich2Tab2TabByTan");
 if(quocTich2Tab2TabByTan <= 0){
 	SessionErrors.add(request, "quocTich2Tab2TabByTan");
 	valid = false;
 }

// tinh6TabByTan - address *
 long tinh6TabByTan = ParamUtil.getLong(request, "tinh6TabByTan");
 if(tinh6TabByTan <= 0){
	 SessionErrors.add(request, "tinh6TabByTan");
	 valid = false;
 }

// quan6TabByTan - address *
 long quan6TabByTan = ParamUtil.getLong(request, "quan6TabByTan");
 if(quan6TabByTan <= 0){
	 SessionErrors.add(request, "quan6TabByTan");
	 valid = false;
 }

// xa6TabByTan - address *
 long xa6TabByTan = ParamUtil.getLong(request, "xa6TabByTan");
 if(xa6TabByTan <= 0){
	 SessionErrors.add(request, "xa6TabByTan");
	 valid = false;
 }

// diaChi6TabByTan - address *
 String diaChi6TabByTan = ParamUtil.getString(request, "diaChi6TabByTan").trim();
 if(diaChi6TabByTan.length() == 0){
	 SessionErrors.add(request, "diaChi6TabByTan");
	 valid = false;
 }



//cmnd2Tab2TabByTan - cmnd *
String cmnd2Tab2TabByTan = ParamUtil.getString(request, "cmnd2Tab2TabByTan").trim();
if (cmnd2Tab2TabByTan.length() == 0) {
SessionErrors.add(request, "cmnd2Tab2TabByTan");
valid = false;
}else if (cmnd2Tab2TabByTan.length() > 0 && !ActionUtils.regexCmnd(cmnd2Tab2TabByTan)) {
	SessionErrors.add(request, "cmnd2Tab2TabByTan"+ "NhapSai");
	valid = false;
}

//ngayCapCmnd2Tab2TabByTan - Date 
String ngayCapCmnd2Tab2TabByTan = ParamUtil.getString(request, "ngayCapCmnd2Tab2TabByTan").trim();
try {
if (ngayCapCmnd2Tab2TabByTan.length() > 0 && ActionUtils.compareTwoDates(ngayCapCmnd2Tab2TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapCmnd2Tab2TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}



//hoChieu2Tab2TabByTan - input *
String hoChieu2Tab2TabByTan = ParamUtil.getString(request, "hoChieu2Tab2TabByTan").trim();
if (hoChieu2Tab2TabByTan.length() == 0 ) {
	SessionErrors.add(request, "hoChieu2Tab2TabByTan");
	valid = false;
}



//ngayCapHoChieu2Tab2TabByTan - Date 
String ngayCapHoChieu2Tab2TabByTan = ParamUtil.getString(request, "ngayCapHoChieu2Tab2TabByTan").trim();
try {
if (ngayCapHoChieu2Tab2TabByTan.length() > 0 && ActionUtils.compareTwoDates(ngayCapHoChieu2Tab2TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapHoChieu2Tab2TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}

//tenGTK2Tab2TabByTan - input *
String tenGTK2Tab2TabByTan = ParamUtil.getString(request, "tenGTK2Tab2TabByTan").trim();
if (tenGTK2Tab2TabByTan.length() == 0 ) {
	SessionErrors.add(request, "tenGTK2Tab2TabByTan");
	valid = false;
}

//soGTK2Tab2TabByTan - input *
String soGTK2Tab2TabByTan = ParamUtil.getString(request, "soGTK2Tab2TabByTan").trim();
if (soGTK2Tab2TabByTan.length() == 0 ) {
	SessionErrors.add(request, "soGTK2Tab2TabByTan");
	valid = false;
}



//ngayCapGTK2Tab2TabByTan - Date 
String ngayCapGTK2Tab2TabByTan = ParamUtil.getString(request, "ngayCapGTK2Tab2TabByTan").trim();
try {
if (ngayCapGTK2Tab2TabByTan.length() > 0 && ActionUtils.compareTwoDates(ngayCapGTK2Tab2TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapGTK2Tab2TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}

//quanHe2Tab2TabByTan - quanHe *
 long quanHe2Tab2TabByTan = ParamUtil.getLong(request, "quanHe2Tab2TabByTan");
 if(quanHe2Tab2TabByTan < 0){
 	SessionErrors.add(request, "quanHe2Tab2TabByTan");
 	valid = false;
 }

//ten3Tab2TabByTan - input *
String ten3Tab2TabByTan = ParamUtil.getString(request, "ten3Tab2TabByTan").trim();
if (ten3Tab2TabByTan.length() == 0 ) {
	SessionErrors.add(request, "ten3Tab2TabByTan");
	valid = false;
}

//birth3Tab2TabByTan - Date *
String birth3Tab2TabByTan = ParamUtil.getString(request, "birth3Tab2TabByTan").trim();
if (birth3Tab2TabByTan.length() == 0) {
SessionErrors.add(request, "birth3Tab2TabByTan");
valid = false;
} else {
try {
if (birth3Tab2TabByTan.length() > 0 && ActionUtils.compareTwoDates(birth3Tab2TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "birth3Tab2TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//danToc3Tab2TabByTan - danToc *
 long danToc3Tab2TabByTan = ParamUtil.getLong(request, "danToc3Tab2TabByTan");
 if(danToc3Tab2TabByTan <= 0){
 	SessionErrors.add(request, "danToc3Tab2TabByTan");
 	valid = false;
 }

//quocTich3Tab2TabByTan - nation *
 long quocTich3Tab2TabByTan = ParamUtil.getLong(request, "quocTich3Tab2TabByTan");
 if(quocTich3Tab2TabByTan <= 0){
 	SessionErrors.add(request, "quocTich3Tab2TabByTan");
 	valid = false;
 }

// tinh7TabByTan - address *
 long tinh7TabByTan = ParamUtil.getLong(request, "tinh7TabByTan");
 if(tinh7TabByTan <= 0){
	 SessionErrors.add(request, "tinh7TabByTan");
	 valid = false;
 }

// quan7TabByTan - address *
 long quan7TabByTan = ParamUtil.getLong(request, "quan7TabByTan");
 if(quan7TabByTan <= 0){
	 SessionErrors.add(request, "quan7TabByTan");
	 valid = false;
 }

// xa7TabByTan - address *
 long xa7TabByTan = ParamUtil.getLong(request, "xa7TabByTan");
 if(xa7TabByTan <= 0){
	 SessionErrors.add(request, "xa7TabByTan");
	 valid = false;
 }

// diaChi7TabByTan - address *
 String diaChi7TabByTan = ParamUtil.getString(request, "diaChi7TabByTan").trim();
 if(diaChi7TabByTan.length() == 0){
	 SessionErrors.add(request, "diaChi7TabByTan");
	 valid = false;
 }



//cmnd3Tab2TabByTan - cmnd *
String cmnd3Tab2TabByTan = ParamUtil.getString(request, "cmnd3Tab2TabByTan").trim();
if (cmnd3Tab2TabByTan.length() == 0) {
SessionErrors.add(request, "cmnd3Tab2TabByTan");
valid = false;
}else if (cmnd3Tab2TabByTan.length() > 0 && !ActionUtils.regexCmnd(cmnd3Tab2TabByTan)) {
	SessionErrors.add(request, "cmnd3Tab2TabByTan"+ "NhapSai");
	valid = false;
}

//ngayCapCmnd3Tab2TabByTan - Date 
String ngayCapCmnd3Tab2TabByTan = ParamUtil.getString(request, "ngayCapCmnd3Tab2TabByTan").trim();
try {
if (ngayCapCmnd3Tab2TabByTan.length() > 0 && ActionUtils.compareTwoDates(ngayCapCmnd3Tab2TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapCmnd3Tab2TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}



//hoChieu3Tab2TabByTan - input *
String hoChieu3Tab2TabByTan = ParamUtil.getString(request, "hoChieu3Tab2TabByTan").trim();
if (hoChieu3Tab2TabByTan.length() == 0 ) {
	SessionErrors.add(request, "hoChieu3Tab2TabByTan");
	valid = false;
}



//ngayCapHoChieu3Tab2TabByTan - Date 
String ngayCapHoChieu3Tab2TabByTan = ParamUtil.getString(request, "ngayCapHoChieu3Tab2TabByTan").trim();
try {
if (ngayCapHoChieu3Tab2TabByTan.length() > 0 && ActionUtils.compareTwoDates(ngayCapHoChieu3Tab2TabByTan, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapHoChieu3Tab2TabByTan" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}





