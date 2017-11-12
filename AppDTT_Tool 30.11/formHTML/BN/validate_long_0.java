//NAMEBYTAN - TYPEBYTAN
 long NAMEBYTAN = ParamUtil.getLong(request, "NAMEBYTAN");
 if(NAMEBYTAN <= 0){
 	SessionErrors.add(request, "NAMEBYTAN");
 	valid = false;
 }