}else if (step1_param instanceof ENTITYNAMEBYTAN) {
result = saveENTITYNAMEBYTAN(resourceRequest,idDanhSachHoSo, 
	step1_param, step2_param, result,session);
}

private long saveENTITYNAMEBYTAN(ActionRequest resourceRequest,
long idDanhSachHoSo, Object step1_param, Object step2_param,
long result, HttpSession session) {
	log.info("----- BusinessUtils -----");
	try {
		ENTITYNAMEBYTAN hoSo = ENTITYNAMEBYTAN.class.cast(step1_param);
		HoSoTTHCCong hoSoTTHCCong = HoSoTTHCCong.class.cast(step2_param);
		if (hoSo.getId() == 0) {
			log.info("create ENTITYNAMEBYTAN to DB");
			hoSo.setId(idDanhSachHoSo);
			ENTITYNAMEBYTANLocalServiceUtil.addENTITYNAMEBYTAN(hoSo);
			hoSoTTHCCong.setId(hoSo.getId());
			HoSoTTHCCongLocalServiceUtil.addHoSoTTHCCong(hoSoTTHCCong);
		} else {
			log.info("update ENTITYNAMEBYTAN to DB");
			ENTITYNAMEBYTANLocalServiceUtil.updateENTITYNAMEBYTAN(hoSo);
			HoSoTTHCCongLocalServiceUtil.updateHoSoTTHCCong(hoSoTTHCCong);
		}
			resourceRequest.setAttribute(RTConstrants.ID_QUY_TRINH,
					hoSoTTHCCong.getThuTucHanhChinhId());
			result = hoSo.getId();
		} catch (Exception es) {

		}
	return result;
}