//NAMEBYTAN - TYPEBYTAN
String NAMEBYTAN = ParamUtil.getString(request, "NAMEBYTAN").trim();
REPLACEIFREQUIRED if (NAMEBYTAN.length() > 0 && !ActionUtils.validPhone(NAMEBYTAN)) {
 SessionErrors.add(request, "NAMEBYTAN" + "NhapSai");
valid = false;
} else if (NAMEBYTAN.length() > 0 && !ActionUtils.regexPhoneVersion2(NAMEBYTAN)) {
  SessionErrors.add(request, "NAMEBYTAN" + "NhapSai2");
valid = false;
 }