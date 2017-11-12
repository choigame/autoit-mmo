public void saveUTILSNAMEBYTAN(ActionRequest request,
			ActionResponse response) throws Throwable {

	UTILSNAMEBYTANUtils util = new UTILSNAMEBYTANUtils();	
	if (UTILSNAMEBYTANValidators.validate(request)) {

		long hoSoId = ParamUtil.getLong(request, "id");
		if(hoSoId > 0){
			util.updateUTILSNAMEBYTAN(request, response);
		}else{
			util.saveUTILSNAMEBYTAN(request, response);
		}
		
	} else {
	
		request.setAttribute("idQuyTrinh",ParamUtil.getString(request, "idQuyTrinh"));
		request.setAttribute("obj",util.fillData2Form(request));
		request.setAttribute(GROUPCONSTANTBYTAN.LOAI_DOI_TUONG, ParamUtil
				.getString(request, GROUPCONSTANTBYTAN.LOAI_DOI_TUONG));
		request.setAttribute(GROUPCONSTANTBYTAN.ACTION,
				GROUPCONSTANTBYTAN.ACTION_STEP1);
		request.setAttribute(GROUPCONSTANTBYTAN.MODULE,"HOSOBYTAN.save");
	}
}