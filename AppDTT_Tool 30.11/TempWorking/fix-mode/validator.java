//name2 - input *
String name2 = ParamUtil.getString(request, "name2").trim();
if (name2.length() == 0 ) {
	SessionErrors.add(request, "name2");
	valid = false;
}

//name22 - input *
String name22 = ParamUtil.getString(request, "name22").trim();
if (name22.length() == 0 ) {
	SessionErrors.add(request, "name22");
	valid = false;
}

