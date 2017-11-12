// tinhNAMEBYTAN - TYPEBYTAN
 long tinhNAMEBYTAN = ParamUtil.getLong(request, "tinhNAMEBYTAN");
 if(tinhNAMEBYTAN <= 0){
	 SessionErrors.add(request, "tinhNAMEBYTAN");
	 valid = false;
 }

// quanNAMEBYTAN - TYPEBYTAN
 long quanNAMEBYTAN = ParamUtil.getLong(request, "quanNAMEBYTAN");
 if(quanNAMEBYTAN <= 0){
	 SessionErrors.add(request, "quanNAMEBYTAN");
	 valid = false;
 }

// xaNAMEBYTAN - TYPEBYTAN
 long xaNAMEBYTAN = ParamUtil.getLong(request, "xaNAMEBYTAN");
 if(xaNAMEBYTAN <= 0){
	 SessionErrors.add(request, "xaNAMEBYTAN");
	 valid = false;
 }

// diaChiNAMEBYTAN - TYPEBYTAN
 String diaChiNAMEBYTAN = ParamUtil.getString(request, "diaChiNAMEBYTAN").trim();
 if(diaChiNAMEBYTAN.length() == 0){
	 SessionErrors.add(request, "diaChiNAMEBYTAN");
	 valid = false;
 }