public void saveKhaiSinhKetHopChaMeConNN(ActionRequest request,
			ActionResponse response) throws Throwable {

	KhaiSinhKetHopChaMeConNNUtils util = new KhaiSinhKetHopChaMeConNNUtils();	
	if (util.validate(request)) {
		long hoSoId = ParamUtil.getLong(request, "id");
		if(hoSoId > 0){
			util.update(request, response);
		}else{
			util.save(request, response);
		}	
	} else {	
		request.setAttribute("idQuyTrinh",ParamUtil.getString(request, "idQuyTrinh"));
		request.setAttribute("obj",util.fillData2Form(request));
		request.setAttribute(CSMConstrants.LOAI_DOI_TUONG, ParamUtil
				.getString(request, CSMConstrants.LOAI_DOI_TUONG));
		request.setAttribute(CSMConstrants.ACTION,
				CSMConstrants.ACTION_STEP1);
		request.setAttribute(CSMConstrants.MODULE,"khaisinhkethopchameconnn.save");
	}
}