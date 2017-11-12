//NAMEBYTAN - TYPEBYTAN
String NAMEBYTAN = ParamUtil.getString(request, "NAMEBYTAN").trim();
if (NAMEBYTAN.length() == 0 ) {
	SessionErrors.add(request, "NAMEBYTAN");
	valid = false;
}