//name2TabByTan - input *
String name2TabByTan = ParamUtil.getString(request, "name2TabByTan").trim();
if (name2TabByTan.length() == 0 ) {
	SessionErrors.add(request, "name2TabByTan");
	valid = false;
}

//name22TabByTan - input *
String name22TabByTan = ParamUtil.getString(request, "name22TabByTan").trim();
if (name22TabByTan.length() == 0 ) {
	SessionErrors.add(request, "name22TabByTan");
	valid = false;
}

