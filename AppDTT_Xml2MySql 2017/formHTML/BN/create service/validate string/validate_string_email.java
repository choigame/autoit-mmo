//NAMEBYTAN
String NAMEBYTAN = ParamUtil.getString(request, "NAMEBYTAN").trim();
REPLACEIFREQUIRED if (NAMEBYTAN.length() > 0 && !Validator.isEmailAddress(NAMEBYTAN)) {
 	SessionErrors.add(request, "NAMEBYTAN" + "NhapSai");
valid = false;
}