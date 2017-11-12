//cmndNAMEBYTAN - input *
String cmndNAMEBYTAN = ParamUtil.getString(request, "cmndNAMEBYTAN").trim();
if (cmndNAMEBYTAN.length() == 0 ) {
	SessionErrors.add(request, "cmndNAMEBYTAN");
	valid = false;
}

//ngayCapCmndNAMEBYTAN - Date *
String ngayCapCmndNAMEBYTAN = ParamUtil.getString(request, "ngayCapCmndNAMEBYTAN").trim();
if (ngayCapCmndNAMEBYTAN.length() == 0) {
	SessionErrors.add(request, "ngayCapCmndNAMEBYTAN");
	valid = false;
} else {
	try {
		if (ngayCapCmndNAMEBYTAN.length() > 0 && 
				ActionUtils.compareTwoDates(ngayCapCmndNAMEBYTAN, today, "dd/MM/yyyy") > 0) {
			SessionErrors.add(request, "ngayCapCmndNAMEBYTAN" + "lonHonHienTai");
			valid = false;
		}
	} catch (ParseException e) {
	}
}

//noiCapCmndNAMEBYTAN - cmnd *
long noiCapCmndNAMEBYTAN = ParamUtil.getLong(request, "noiCapCmndNAMEBYTAN");
 if(noiCapCmndNAMEBYTAN <= 0){
 	SessionErrors.add(request, "noiCapCmndNAMEBYTAN");
 	valid = false;
}