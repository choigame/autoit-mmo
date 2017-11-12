//NAMEBYTAN
String NAMEBYTAN = ParamUtil.getString(request, "NAMEBYTAN").trim();
REPLACEIFREQUIRED if (NAMEBYTAN.length() > 0 && !ActionUtils.regexCmnd(NAMEBYTAN)) {
	SessionErrors.add(request, "NAMEBYTAN"+ "NhapSai");
	valid = false;
}