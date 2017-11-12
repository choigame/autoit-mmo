}else if (step1_param instanceof KhaiSinhKetHopChaMeConNN) {
result = BusinessUtilsVer2.saveKhaiSinhKetHopChaMeConNN(resourceRequest,idDanhSachHoSo, 
	step1_param, step2_param, result,session);
}

public static long saveKhaiSinhKetHopChaMeConNN(ActionRequest resourceRequest,
long idDanhSachHoSo, Object step1_param, Object step2_param,
long result, HttpSession session) {
	log.info("----- BusinessUtils -----");
	try {
		KhaiSinhKetHopChaMeConNN hoSo = KhaiSinhKetHopChaMeConNN.class.cast(step1_param);
		HoSoTTHCCong hoSoTTHCCong = HoSoTTHCCong.class.cast(step2_param);
		if (hoSo.getId() == 0) {
			log.info("create KhaiSinhKetHopChaMeConNN to DB");
			hoSo.setId(idDanhSachHoSo);
			KhaiSinhKetHopChaMeConNNLocalServiceUtil.addKhaiSinhKetHopChaMeConNN(hoSo);
			hoSoTTHCCong.setId(hoSo.getId());
			HoSoTTHCCongLocalServiceUtil.addHoSoTTHCCong(hoSoTTHCCong);
		} else {
			log.info("update KhaiSinhKetHopChaMeConNN to DB");
			KhaiSinhKetHopChaMeConNNLocalServiceUtil.updateKhaiSinhKetHopChaMeConNN(hoSo);
			HoSoTTHCCongLocalServiceUtil.updateHoSoTTHCCong(hoSoTTHCCong);
		}
			resourceRequest.setAttribute(RTConstrants.ID_QUY_TRINH,
					hoSoTTHCCong.getThuTucHanhChinhId());
			result = hoSo.getId();
		} catch (Exception es) {

		}
	return result;
}