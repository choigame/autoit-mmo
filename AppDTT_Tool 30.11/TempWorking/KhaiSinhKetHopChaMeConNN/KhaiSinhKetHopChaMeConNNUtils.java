package vn.dtt.portlet.csms.utils;

import java.text.ParseException;
import java.util.Enumeration;
import java.util.Iterator;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.servlet.http.HttpSession;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.*;
import vn.dtt.portlet.utils.ActionUtils;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.*;
import com.liferay.portal.model.User;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import vn.dtt.cmon.dao.qlhc.model.CoQuanQuanLy;
import vn.dtt.cmon.dao.qlhc.service.CoQuanQuanLyLocalServiceUtil;
import vn.dtt.common.dao.hstthcc.model.HoSoTTHCCong;
import vn.dtt.common.dao.hstthcc.service.HoSoTTHCCongLocalServiceUtil;
import vn.dtt.portlet.csms.CSMConstrants;
import vn.dtt.portlet.utils.ComUtils;
import vn.dtt.sharedservice.WebserviceFactory;
import vn.dtt.sharedservice.cmon.consumer.citizen.*;
import vn.dtt.csms.khaisinhkethopchameconnn.model.KhaiSinhKetHopChaMeConNN;
import vn.dtt.csms.khaisinhkethopchameconnn.model.impl.KhaiSinhKetHopChaMeConNNImpl;
import vn.dtt.csms.khaisinhkethopchameconnn.model.impl.KhaiSinhKetHopChaMeConNNModelImpl;
import vn.dtt.csms.khaisinhkethopchameconnn.service.KhaiSinhKetHopChaMeConNNLocalServiceUtil;

public class KhaiSinhKetHopChaMeConNNUtils {
	private static final Log log = LogFactoryUtil.getLog(KhaiSinhKetHopChaMeConNNUtils.class);
	private User getUser(ActionRequest resourceRequest, ActionResponse httpReq) {
		ThemeDisplay themeDisplay = (ThemeDisplay) 
				resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
		return themeDisplay.getUser();
	}

	public void save(ActionRequest request, ActionResponse respone) 
												throws Throwable {
		User user = getUser(request, respone);
		String loaiDoiTuong = ParamUtil.getString(request,"loaiDoiTuong");
		Citizen citizen_ = null;
		long userId = PortalUtil.getUserId(request);
		ICitizenService service = WebserviceFactory.getCmonService();
		citizen_ = service.getCitizenByUser(userId);
		CongDanSoap citizen = null;
		if(citizen_ != null) citizen = citizen_.getCongDan();

		HttpSession session = ActionUtils.getSession(request);

		KhaiSinhKetHopChaMeConNN obj = fillData2Form(request);

		HoSoTTHCCong hoSoTTHCCong = ComUtils.createHoSoTTHCCong(request, citizen,KhaiSinhKetHopChaMeConNNModelImpl.TABLE_NAME, loaiDoiTuong);

		session.setAttribute(CSMConstrants.OBJECT_DATA1,obj);
		session.setAttribute(CSMConstrants.OBJECT_DATA2,hoSoTTHCCong);
		request.setAttribute(CSMConstrants.ID_QUY_TRINH,ParamUtil.getString(request, "idQuyTrinh"));
		request.setAttribute(CSMConstrants.MA_CONG_DAN,user.getUserId());

		respone.setRenderParameter("jspPage", "/html/portlet/uploadDocument_step2.jsp");
		SessionErrors.clear(request);
	}

	public void update(ActionRequest request, ActionResponse respone) 
				throws SystemException, PortalException {
		User user = getUser(request, respone);
		long idHoSo = ParamUtil.getLong(request, "id");
		HoSoTTHCCong hoSoTTHCCong = HoSoTTHCCongLocalServiceUtil.fetchHoSoTTHCCong(idHoSo);
		Long coQuanQuanLyId = ParamUtil.getLong(request, "coQuanQuanLyId");
		if(coQuanQuanLyId != null && coQuanQuanLyId>0){
			hoSoTTHCCong.setCoQuanTiepNhanId(coQuanQuanLyId);
			CoQuanQuanLy cqql = CoQuanQuanLyLocalServiceUtil.fetchCoQuanQuanLy(coQuanQuanLyId);
			hoSoTTHCCong.setTenCoQuanTiepNhan(cqql.getTen());
		}
		HttpSession session = ActionUtils.getSession(request);
		KhaiSinhKetHopChaMeConNN obj = fillData2Form(request);
		session.setAttribute(CSMConstrants.OBJECT_DATA1,obj);
		session.setAttribute(CSMConstrants.OBJECT_DATA2,hoSoTTHCCong);
		request.setAttribute(CSMConstrants.ID_QUY_TRINH,ParamUtil.getString(request, "idQuyTrinh"));
		request.setAttribute(CSMConstrants.ID_DANH_SACH_HO_SO,hoSoTTHCCong.getId());
		request.setAttribute(CSMConstrants.MA_CONG_DAN,user.getUserId());
		request.setAttribute(CSMConstrants.EMAIL_CONG_DAN,"test@liferay.com");

		respone.setRenderParameter("jspPage", "/html/portlet/uploadDocument_step2.jsp");
		SessionErrors.clear(request);
	}

	public KhaiSinhKetHopChaMeConNN fillData2Form(ActionRequest request) 
				throws SystemException, PortalException {
		User user = null;
		try {
			user = PortalUtil.getUser(request);
		} catch (SystemException e) {
		}
		Long idHoSo = ParamUtil.getLong(request, "id");
		KhaiSinhKetHopChaMeConNN hoSo = null;
		if (idHoSo != null && idHoSo > 0) {
			hoSo = KhaiSinhKetHopChaMeConNNLocalServiceUtil.fetchKhaiSinhKetHopChaMeConNN(idHoSo);
		} else {
			hoSo = new KhaiSinhKetHopChaMeConNNImpl();
		}

		//coQuanQuanLyId - long
long coQuanQuanLyId = ParamUtil.getLong(request,"coQuanQuanLyId");
hoSo.setCoQuanQuanLyId(coQuanQuanLyId);

// ten1Tab1 - String 
String ten1Tab1 = ParamUtil.getString(request,"ten1Tab1").trim();
hoSo.setTen1Tab1(ten1Tab1);

// quocGia1Tab1 - long
long quocGia1Tab1 = ParamUtil.getLong(request,"quocGia1Tab1");
hoSo.setQuocGia1Tab1(quocGia1Tab1);

// tinh1 - long
long tinh1 = ParamUtil.getLong(request,"tinh1");
hoSo.setTinh1(tinh1);

//  quan1 - long
long quan1 = ParamUtil.getLong(request,"quan1");
hoSo.setQuan1(quan1);

// xa1 - long
long xa1 = ParamUtil.getLong(request,"xa1");
hoSo.setXa1(xa1);

// diaChi1 - long
String diaChi1 = ParamUtil.getString(request,"diaChi1").trim();
hoSo.setDiaChi1(diaChi1);

// radio1Tab1 - String 
String radio1Tab1 = ParamUtil.getString(request,"radio1Tab1").trim();
hoSo.setRadio1Tab1(radio1Tab1);

// cmnd1Tab1 - String 
String cmnd1Tab1 = ParamUtil.getString(request,"cmnd1Tab1").trim();
hoSo.setCmnd1Tab1(cmnd1Tab1);

// ngayCapCmnd1Tab1 - Date
String ngayCapCmnd1Tab1 = ParamUtil.getString(request,"ngayCapCmnd1Tab1");
if(ngayCapCmnd1Tab1.length()>0)
hoSo.setNgayCapCmnd1Tab1(ActionUtils.parseStringToDate(ngayCapCmnd1Tab1));

// noiCapCmnd1Tab1 - long
long noiCapCmnd1Tab1 = ParamUtil.getLong(request,"noiCapCmnd1Tab1");
hoSo.setNoiCapCmnd1Tab1(noiCapCmnd1Tab1);

// hoChieu1Tab1 - String 
String hoChieu1Tab1 = ParamUtil.getString(request,"hoChieu1Tab1").trim();
hoSo.setHoChieu1Tab1(hoChieu1Tab1);

// ngayCapHoChieu1Tab1 - Date
String ngayCapHoChieu1Tab1 = ParamUtil.getString(request,"ngayCapHoChieu1Tab1");
if(ngayCapHoChieu1Tab1.length()>0)
hoSo.setNgayCapHoChieu1Tab1(ActionUtils.parseStringToDate(ngayCapHoChieu1Tab1));

// noiCapHoChieu1Tab1 - String 
String noiCapHoChieu1Tab1 = ParamUtil.getString(request,"noiCapHoChieu1Tab1").trim();
hoSo.setNoiCapHoChieu1Tab1(noiCapHoChieu1Tab1);

// tenGTK1Tab1 - String 
String tenGTK1Tab1 = ParamUtil.getString(request,"tenGTK1Tab1").trim();
hoSo.setTenGTK1Tab1(tenGTK1Tab1);

// soGTK1Tab1 - String 
String soGTK1Tab1 = ParamUtil.getString(request,"soGTK1Tab1").trim();
hoSo.setSoGTK1Tab1(soGTK1Tab1);

// noiCapGTK1Tab1 - String 
String noiCapGTK1Tab1 = ParamUtil.getString(request,"noiCapGTK1Tab1").trim();
hoSo.setNoiCapGTK1Tab1(noiCapGTK1Tab1);

// ngayCapGTK1Tab1 - Date
String ngayCapGTK1Tab1 = ParamUtil.getString(request,"ngayCapGTK1Tab1");
if(ngayCapGTK1Tab1.length()>0)
hoSo.setNgayCapGTK1Tab1(ActionUtils.parseStringToDate(ngayCapGTK1Tab1));

// quanHe1Tab1 - long
long quanHe1Tab1 = ParamUtil.getLong(request,"quanHe1Tab1");
hoSo.setQuanHe1Tab1(quanHe1Tab1);

// ten2Tab1 - String 
String ten2Tab1 = ParamUtil.getString(request,"ten2Tab1").trim();
hoSo.setTen2Tab1(ten2Tab1);

// sex2Tab1 - long
long sex2Tab1 = ParamUtil.getLong(request,"sex2Tab1");
hoSo.setSex2Tab1(sex2Tab1);

// birth2Tab1 - Date
String birth2Tab1 = ParamUtil.getString(request,"birth2Tab1");
if(birth2Tab1.length()>0)
hoSo.setBirth2Tab1(ActionUtils.parseStringToDate(birth2Tab1));

// birth2BangChuTab1 - String 
String birth2BangChuTab1 = ParamUtil.getString(request,"birth2BangChuTab1").trim();
hoSo.setBirth2BangChuTab1(birth2BangChuTab1);

// danToc2Tab1 - long
long danToc2Tab1 = ParamUtil.getLong(request,"danToc2Tab1");
hoSo.setDanToc2Tab1(danToc2Tab1);

// quocTich2Tab1 - long
long quocTich2Tab1 = ParamUtil.getLong(request,"quocTich2Tab1");
hoSo.setQuocTich2Tab1(quocTich2Tab1);

// quocGia2Tab1 - long
long quocGia2Tab1 = ParamUtil.getLong(request,"quocGia2Tab1");
hoSo.setQuocGia2Tab1(quocGia2Tab1);

// tinh2 - long
long tinh2 = ParamUtil.getLong(request,"tinh2");
hoSo.setTinh2(tinh2);

//  quan2 - long
long quan2 = ParamUtil.getLong(request,"quan2");
hoSo.setQuan2(quan2);

// xa2 - long
long xa2 = ParamUtil.getLong(request,"xa2");
hoSo.setXa2(xa2);

// diaChi2 - long
String diaChi2 = ParamUtil.getString(request,"diaChi2").trim();
hoSo.setDiaChi2(diaChi2);

// ten3Tab1 - String 
String ten3Tab1 = ParamUtil.getString(request,"ten3Tab1").trim();
hoSo.setTen3Tab1(ten3Tab1);

// birth3Tab1 - Date
String birth3Tab1 = ParamUtil.getString(request,"birth3Tab1");
if(birth3Tab1.length()>0)
hoSo.setBirth3Tab1(ActionUtils.parseStringToDate(birth3Tab1));

// danToc3Tab1 - long
long danToc3Tab1 = ParamUtil.getLong(request,"danToc3Tab1");
hoSo.setDanToc3Tab1(danToc3Tab1);

// quocTich3Tab1 - long
long quocTich3Tab1 = ParamUtil.getLong(request,"quocTich3Tab1");
hoSo.setQuocTich3Tab1(quocTich3Tab1);

// quocGia3Tab1 - long
long quocGia3Tab1 = ParamUtil.getLong(request,"quocGia3Tab1");
hoSo.setQuocGia3Tab1(quocGia3Tab1);

// tinh3 - long
long tinh3 = ParamUtil.getLong(request,"tinh3");
hoSo.setTinh3(tinh3);

//  quan3 - long
long quan3 = ParamUtil.getLong(request,"quan3");
hoSo.setQuan3(quan3);

// xa3 - long
long xa3 = ParamUtil.getLong(request,"xa3");
hoSo.setXa3(xa3);

// diaChi3 - long
String diaChi3 = ParamUtil.getString(request,"diaChi3").trim();
hoSo.setDiaChi3(diaChi3);

// ten4Tab1 - String 
String ten4Tab1 = ParamUtil.getString(request,"ten4Tab1").trim();
hoSo.setTen4Tab1(ten4Tab1);

// birth4Tab1 - Date
String birth4Tab1 = ParamUtil.getString(request,"birth4Tab1");
if(birth4Tab1.length()>0)
hoSo.setBirth4Tab1(ActionUtils.parseStringToDate(birth4Tab1));

// danToc4Tab1 - long
long danToc4Tab1 = ParamUtil.getLong(request,"danToc4Tab1");
hoSo.setDanToc4Tab1(danToc4Tab1);

// quocTich4Tab1 - long
long quocTich4Tab1 = ParamUtil.getLong(request,"quocTich4Tab1");
hoSo.setQuocTich4Tab1(quocTich4Tab1);

// quocGia4Tab1 - long
long quocGia4Tab1 = ParamUtil.getLong(request,"quocGia4Tab1");
hoSo.setQuocGia4Tab1(quocGia4Tab1);

// tinh4 - long
long tinh4 = ParamUtil.getLong(request,"tinh4");
hoSo.setTinh4(tinh4);

//  quan4 - long
long quan4 = ParamUtil.getLong(request,"quan4");
hoSo.setQuan4(quan4);

// xa4 - long
long xa4 = ParamUtil.getLong(request,"xa4");
hoSo.setXa4(xa4);

// diaChi4 - long
String diaChi4 = ParamUtil.getString(request,"diaChi4").trim();
hoSo.setDiaChi4(diaChi4);

// ten1Tab2 - String 
String ten1Tab2 = ParamUtil.getString(request,"ten1Tab2").trim();
hoSo.setTen1Tab2(ten1Tab2);

// birth1Tab2 - Date
String birth1Tab2 = ParamUtil.getString(request,"birth1Tab2");
if(birth1Tab2.length()>0)
hoSo.setBirth1Tab2(ActionUtils.parseStringToDate(birth1Tab2));

// danToc1Tab2 - long
long danToc1Tab2 = ParamUtil.getLong(request,"danToc1Tab2");
hoSo.setDanToc1Tab2(danToc1Tab2);

// quocTich1Tab2 - long
long quocTich1Tab2 = ParamUtil.getLong(request,"quocTich1Tab2");
hoSo.setQuocTich1Tab2(quocTich1Tab2);

// tinh5 - long
long tinh5 = ParamUtil.getLong(request,"tinh5");
hoSo.setTinh5(tinh5);

//  quan5 - long
long quan5 = ParamUtil.getLong(request,"quan5");
hoSo.setQuan5(quan5);

// xa5 - long
long xa5 = ParamUtil.getLong(request,"xa5");
hoSo.setXa5(xa5);

// diaChi5 - long
String diaChi5 = ParamUtil.getString(request,"diaChi5").trim();
hoSo.setDiaChi5(diaChi5);

// radio1Tab2 - String 
String radio1Tab2 = ParamUtil.getString(request,"radio1Tab2").trim();
hoSo.setRadio1Tab2(radio1Tab2);

// cmnd1Tab2 - String 
String cmnd1Tab2 = ParamUtil.getString(request,"cmnd1Tab2").trim();
hoSo.setCmnd1Tab2(cmnd1Tab2);

// ngayCapCmnd1Tab2 - Date
String ngayCapCmnd1Tab2 = ParamUtil.getString(request,"ngayCapCmnd1Tab2");
if(ngayCapCmnd1Tab2.length()>0)
hoSo.setNgayCapCmnd1Tab2(ActionUtils.parseStringToDate(ngayCapCmnd1Tab2));

// noiCapCmnd1Tab2 - long
long noiCapCmnd1Tab2 = ParamUtil.getLong(request,"noiCapCmnd1Tab2");
hoSo.setNoiCapCmnd1Tab2(noiCapCmnd1Tab2);

// hoChieu1Tab2 - String 
String hoChieu1Tab2 = ParamUtil.getString(request,"hoChieu1Tab2").trim();
hoSo.setHoChieu1Tab2(hoChieu1Tab2);

// noiCapHoChieu1Tab2 - long
long noiCapHoChieu1Tab2 = ParamUtil.getLong(request,"noiCapHoChieu1Tab2");
hoSo.setNoiCapHoChieu1Tab2(noiCapHoChieu1Tab2);

// ngayCapHoChieu1Tab2 - Date
String ngayCapHoChieu1Tab2 = ParamUtil.getString(request,"ngayCapHoChieu1Tab2");
if(ngayCapHoChieu1Tab2.length()>0)
hoSo.setNgayCapHoChieu1Tab2(ActionUtils.parseStringToDate(ngayCapHoChieu1Tab2));

// tenGTK1Tab2 - String 
String tenGTK1Tab2 = ParamUtil.getString(request,"tenGTK1Tab2").trim();
hoSo.setTenGTK1Tab2(tenGTK1Tab2);

// soGTK1Tab2 - String 
String soGTK1Tab2 = ParamUtil.getString(request,"soGTK1Tab2").trim();
hoSo.setSoGTK1Tab2(soGTK1Tab2);

// noiCapGTK1Tab2 - String 
String noiCapGTK1Tab2 = ParamUtil.getString(request,"noiCapGTK1Tab2").trim();
hoSo.setNoiCapGTK1Tab2(noiCapGTK1Tab2);

// ngayCapGTK1Tab2 - Date
String ngayCapGTK1Tab2 = ParamUtil.getString(request,"ngayCapGTK1Tab2");
if(ngayCapGTK1Tab2.length()>0)
hoSo.setNgayCapGTK1Tab2(ActionUtils.parseStringToDate(ngayCapGTK1Tab2));

// quanHe1 - long
long quanHe1 = ParamUtil.getLong(request,"quanHe1");
hoSo.setQuanHe1(quanHe1);

// ten2Tab2 - String 
String ten2Tab2 = ParamUtil.getString(request,"ten2Tab2").trim();
hoSo.setTen2Tab2(ten2Tab2);

// birth2Tab2 - Date
String birth2Tab2 = ParamUtil.getString(request,"birth2Tab2");
if(birth2Tab2.length()>0)
hoSo.setBirth2Tab2(ActionUtils.parseStringToDate(birth2Tab2));

// danToc2Tab2 - long
long danToc2Tab2 = ParamUtil.getLong(request,"danToc2Tab2");
hoSo.setDanToc2Tab2(danToc2Tab2);

// quocTich2Tab2 - long
long quocTich2Tab2 = ParamUtil.getLong(request,"quocTich2Tab2");
hoSo.setQuocTich2Tab2(quocTich2Tab2);

// tinh6 - long
long tinh6 = ParamUtil.getLong(request,"tinh6");
hoSo.setTinh6(tinh6);

//  quan6 - long
long quan6 = ParamUtil.getLong(request,"quan6");
hoSo.setQuan6(quan6);

// xa6 - long
long xa6 = ParamUtil.getLong(request,"xa6");
hoSo.setXa6(xa6);

// diaChi6 - long
String diaChi6 = ParamUtil.getString(request,"diaChi6").trim();
hoSo.setDiaChi6(diaChi6);

// radio2Tab2 - String 
String radio2Tab2 = ParamUtil.getString(request,"radio2Tab2").trim();
hoSo.setRadio2Tab2(radio2Tab2);

// cmnd2Tab2 - String 
String cmnd2Tab2 = ParamUtil.getString(request,"cmnd2Tab2").trim();
hoSo.setCmnd2Tab2(cmnd2Tab2);

// ngayCapCmnd2Tab2 - Date
String ngayCapCmnd2Tab2 = ParamUtil.getString(request,"ngayCapCmnd2Tab2");
if(ngayCapCmnd2Tab2.length()>0)
hoSo.setNgayCapCmnd2Tab2(ActionUtils.parseStringToDate(ngayCapCmnd2Tab2));

// noiCapCmnd2Tab2 - long
long noiCapCmnd2Tab2 = ParamUtil.getLong(request,"noiCapCmnd2Tab2");
hoSo.setNoiCapCmnd2Tab2(noiCapCmnd2Tab2);

// hoChieu2Tab2 - String 
String hoChieu2Tab2 = ParamUtil.getString(request,"hoChieu2Tab2").trim();
hoSo.setHoChieu2Tab2(hoChieu2Tab2);

// noiCapHoChieu2Tab2 - long
long noiCapHoChieu2Tab2 = ParamUtil.getLong(request,"noiCapHoChieu2Tab2");
hoSo.setNoiCapHoChieu2Tab2(noiCapHoChieu2Tab2);

// ngayCapHoChieu2Tab2 - Date
String ngayCapHoChieu2Tab2 = ParamUtil.getString(request,"ngayCapHoChieu2Tab2");
if(ngayCapHoChieu2Tab2.length()>0)
hoSo.setNgayCapHoChieu2Tab2(ActionUtils.parseStringToDate(ngayCapHoChieu2Tab2));

// tenGTK2Tab2 - String 
String tenGTK2Tab2 = ParamUtil.getString(request,"tenGTK2Tab2").trim();
hoSo.setTenGTK2Tab2(tenGTK2Tab2);

// soGTK2Tab2 - String 
String soGTK2Tab2 = ParamUtil.getString(request,"soGTK2Tab2").trim();
hoSo.setSoGTK2Tab2(soGTK2Tab2);

// noiCapGTK2Tab2 - String 
String noiCapGTK2Tab2 = ParamUtil.getString(request,"noiCapGTK2Tab2").trim();
hoSo.setNoiCapGTK2Tab2(noiCapGTK2Tab2);

// ngayCapGTK2Tab2 - Date
String ngayCapGTK2Tab2 = ParamUtil.getString(request,"ngayCapGTK2Tab2");
if(ngayCapGTK2Tab2.length()>0)
hoSo.setNgayCapGTK2Tab2(ActionUtils.parseStringToDate(ngayCapGTK2Tab2));

// quanHe2Tab2 - long
long quanHe2Tab2 = ParamUtil.getLong(request,"quanHe2Tab2");
hoSo.setQuanHe2Tab2(quanHe2Tab2);

// ten3Tab2 - String 
String ten3Tab2 = ParamUtil.getString(request,"ten3Tab2").trim();
hoSo.setTen3Tab2(ten3Tab2);

// birth3Tab2 - Date
String birth3Tab2 = ParamUtil.getString(request,"birth3Tab2");
if(birth3Tab2.length()>0)
hoSo.setBirth3Tab2(ActionUtils.parseStringToDate(birth3Tab2));

// danToc3Tab2 - long
long danToc3Tab2 = ParamUtil.getLong(request,"danToc3Tab2");
hoSo.setDanToc3Tab2(danToc3Tab2);

// quocTich3Tab2 - long
long quocTich3Tab2 = ParamUtil.getLong(request,"quocTich3Tab2");
hoSo.setQuocTich3Tab2(quocTich3Tab2);

// tinh7 - long
long tinh7 = ParamUtil.getLong(request,"tinh7");
hoSo.setTinh7(tinh7);

//  quan7 - long
long quan7 = ParamUtil.getLong(request,"quan7");
hoSo.setQuan7(quan7);

// xa7 - long
long xa7 = ParamUtil.getLong(request,"xa7");
hoSo.setXa7(xa7);

// diaChi7 - long
String diaChi7 = ParamUtil.getString(request,"diaChi7").trim();
hoSo.setDiaChi7(diaChi7);

// radio3Tab2 - String 
String radio3Tab2 = ParamUtil.getString(request,"radio3Tab2").trim();
hoSo.setRadio3Tab2(radio3Tab2);

// cmnd3Tab2 - String 
String cmnd3Tab2 = ParamUtil.getString(request,"cmnd3Tab2").trim();
hoSo.setCmnd3Tab2(cmnd3Tab2);

// ngayCapCmnd3Tab2 - Date
String ngayCapCmnd3Tab2 = ParamUtil.getString(request,"ngayCapCmnd3Tab2");
if(ngayCapCmnd3Tab2.length()>0)
hoSo.setNgayCapCmnd3Tab2(ActionUtils.parseStringToDate(ngayCapCmnd3Tab2));

// noiCapCmnd3Tab2 - long
long noiCapCmnd3Tab2 = ParamUtil.getLong(request,"noiCapCmnd3Tab2");
hoSo.setNoiCapCmnd3Tab2(noiCapCmnd3Tab2);

// hoChieu3Tab2 - String 
String hoChieu3Tab2 = ParamUtil.getString(request,"hoChieu3Tab2").trim();
hoSo.setHoChieu3Tab2(hoChieu3Tab2);

// noiCapHoChieu3Tab2 - long
long noiCapHoChieu3Tab2 = ParamUtil.getLong(request,"noiCapHoChieu3Tab2");
hoSo.setNoiCapHoChieu3Tab2(noiCapHoChieu3Tab2);

// ngayCapHoChieu3Tab2 - Date
String ngayCapHoChieu3Tab2 = ParamUtil.getString(request,"ngayCapHoChieu3Tab2");
if(ngayCapHoChieu3Tab2.length()>0)
hoSo.setNgayCapHoChieu3Tab2(ActionUtils.parseStringToDate(ngayCapHoChieu3Tab2));

// yKien1 - String 
String yKien1 = ParamUtil.getString(request,"yKien1").trim();
hoSo.setYKien1(yKien1);

// yKien2 - String 
String yKien2 = ParamUtil.getString(request,"yKien2").trim();
hoSo.setYKien2(yKien2);


		return hoSo;
	}

	public boolean validate(ActionRequest request) {

		boolean valid = true;
		String today = ActionUtils.getToday();

		//ten1Tab1 - input *
String ten1Tab1 = ParamUtil.getString(request, "ten1Tab1").trim();
if (ten1Tab1.length() == 0 ) {
	SessionErrors.add(request, "ten1Tab1");
	valid = false;
}

//quocGia1Tab1 - nation *
 long quocGia1Tab1 = ParamUtil.getLong(request, "quocGia1Tab1");
 if(quocGia1Tab1 <= 0){
 	SessionErrors.add(request, "quocGia1Tab1");
 	valid = false;
 }

// tinh1 - address *
 long tinh1 = ParamUtil.getLong(request, "tinh1");
 if(tinh1 <= 0){
	 SessionErrors.add(request, "tinh1");
	 valid = false;
 }

// quan1 - address *
 long quan1 = ParamUtil.getLong(request, "quan1");
 if(quan1 <= 0){
	 SessionErrors.add(request, "quan1");
	 valid = false;
 }

// xa1 - address *
 long xa1 = ParamUtil.getLong(request, "xa1");
 if(xa1 <= 0){
	 SessionErrors.add(request, "xa1");
	 valid = false;
 }

// diaChi1 - address *
 String diaChi1 = ParamUtil.getString(request, "diaChi1").trim();
 if(diaChi1.length() == 0){
	 SessionErrors.add(request, "diaChi1");
	 valid = false;
 }



//cmnd1Tab1 - cmnd *
String cmnd1Tab1 = ParamUtil.getString(request, "cmnd1Tab1").trim();
if (cmnd1Tab1.length() == 0) {
SessionErrors.add(request, "cmnd1Tab1");
valid = false;
}else if (cmnd1Tab1.length() > 0 && !ActionUtils.regexCmnd(cmnd1Tab1)) {
	SessionErrors.add(request, "cmnd1Tab1"+ "NhapSai");
	valid = false;
}

//ngayCapCmnd1Tab1 - Date *
String ngayCapCmnd1Tab1 = ParamUtil.getString(request, "ngayCapCmnd1Tab1").trim();
if (ngayCapCmnd1Tab1.length() == 0) {
SessionErrors.add(request, "ngayCapCmnd1Tab1");
valid = false;
} else {
try {
if (ngayCapCmnd1Tab1.length() > 0 && ActionUtils.compareTwoDates(ngayCapCmnd1Tab1, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapCmnd1Tab1" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//noiCapCmnd1Tab1 - cmnd *
 long noiCapCmnd1Tab1 = ParamUtil.getLong(request, "noiCapCmnd1Tab1");
 if(noiCapCmnd1Tab1 <= 0){
 	SessionErrors.add(request, "noiCapCmnd1Tab1");
 	valid = false;
 }

//hoChieu1Tab1 - input *
String hoChieu1Tab1 = ParamUtil.getString(request, "hoChieu1Tab1").trim();
if (hoChieu1Tab1.length() == 0 ) {
	SessionErrors.add(request, "hoChieu1Tab1");
	valid = false;
}

//ngayCapHoChieu1Tab1 - Date *
String ngayCapHoChieu1Tab1 = ParamUtil.getString(request, "ngayCapHoChieu1Tab1").trim();
if (ngayCapHoChieu1Tab1.length() == 0) {
SessionErrors.add(request, "ngayCapHoChieu1Tab1");
valid = false;
} else {
try {
if (ngayCapHoChieu1Tab1.length() > 0 && ActionUtils.compareTwoDates(ngayCapHoChieu1Tab1, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapHoChieu1Tab1" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//noiCapHoChieu1Tab1 - input *
String noiCapHoChieu1Tab1 = ParamUtil.getString(request, "noiCapHoChieu1Tab1").trim();
if (noiCapHoChieu1Tab1.length() == 0 ) {
	SessionErrors.add(request, "noiCapHoChieu1Tab1");
	valid = false;
}

//tenGTK1Tab1 - input *
String tenGTK1Tab1 = ParamUtil.getString(request, "tenGTK1Tab1").trim();
if (tenGTK1Tab1.length() == 0 ) {
	SessionErrors.add(request, "tenGTK1Tab1");
	valid = false;
}

//soGTK1Tab1 - input *
String soGTK1Tab1 = ParamUtil.getString(request, "soGTK1Tab1").trim();
if (soGTK1Tab1.length() == 0 ) {
	SessionErrors.add(request, "soGTK1Tab1");
	valid = false;
}

//noiCapGTK1Tab1 - input *
String noiCapGTK1Tab1 = ParamUtil.getString(request, "noiCapGTK1Tab1").trim();
if (noiCapGTK1Tab1.length() == 0 ) {
	SessionErrors.add(request, "noiCapGTK1Tab1");
	valid = false;
}

//ngayCapGTK1Tab1 - Date *
String ngayCapGTK1Tab1 = ParamUtil.getString(request, "ngayCapGTK1Tab1").trim();
if (ngayCapGTK1Tab1.length() == 0) {
SessionErrors.add(request, "ngayCapGTK1Tab1");
valid = false;
} else {
try {
if (ngayCapGTK1Tab1.length() > 0 && ActionUtils.compareTwoDates(ngayCapGTK1Tab1, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapGTK1Tab1" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//quanHe1Tab1 - quanHe *
 long quanHe1Tab1 = ParamUtil.getLong(request, "quanHe1Tab1");
 if(quanHe1Tab1 < 0){
 	SessionErrors.add(request, "quanHe1Tab1");
 	valid = false;
 }

//ten2Tab1 - input *
String ten2Tab1 = ParamUtil.getString(request, "ten2Tab1").trim();
if (ten2Tab1.length() == 0 ) {
	SessionErrors.add(request, "ten2Tab1");
	valid = false;
}

//sex2Tab1 - sex *
 long sex2Tab1 = ParamUtil.getLong(request, "sex2Tab1");
 if(sex2Tab1 <= 0){
 	SessionErrors.add(request, "sex2Tab1");
 	valid = false;
 }

//birth2Tab1 - Date *
String birth2Tab1 = ParamUtil.getString(request, "birth2Tab1").trim();
if (birth2Tab1.length() == 0) {
SessionErrors.add(request, "birth2Tab1");
valid = false;
} else {
try {
if (birth2Tab1.length() > 0 && ActionUtils.compareTwoDates(birth2Tab1, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "birth2Tab1" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//birth2BangChuTab1 - input *
String birth2BangChuTab1 = ParamUtil.getString(request, "birth2BangChuTab1").trim();
if (birth2BangChuTab1.length() == 0 ) {
	SessionErrors.add(request, "birth2BangChuTab1");
	valid = false;
}

//danToc2Tab1 - danToc *
 long danToc2Tab1 = ParamUtil.getLong(request, "danToc2Tab1");
 if(danToc2Tab1 <= 0){
 	SessionErrors.add(request, "danToc2Tab1");
 	valid = false;
 }

//quocTich2Tab1 - danToc *
 long quocTich2Tab1 = ParamUtil.getLong(request, "quocTich2Tab1");
 if(quocTich2Tab1 <= 0){
 	SessionErrors.add(request, "quocTich2Tab1");
 	valid = false;
 }

//quocGia2Tab1 - nation *
 long quocGia2Tab1 = ParamUtil.getLong(request, "quocGia2Tab1");
 if(quocGia2Tab1 <= 0){
 	SessionErrors.add(request, "quocGia2Tab1");
 	valid = false;
 }

// tinh2 - address *
 long tinh2 = ParamUtil.getLong(request, "tinh2");
 if(tinh2 <= 0){
	 SessionErrors.add(request, "tinh2");
	 valid = false;
 }

// quan2 - address *
 long quan2 = ParamUtil.getLong(request, "quan2");
 if(quan2 <= 0){
	 SessionErrors.add(request, "quan2");
	 valid = false;
 }

// xa2 - address *
 long xa2 = ParamUtil.getLong(request, "xa2");
 if(xa2 <= 0){
	 SessionErrors.add(request, "xa2");
	 valid = false;
 }

// diaChi2 - address *
 String diaChi2 = ParamUtil.getString(request, "diaChi2").trim();
 if(diaChi2.length() == 0){
	 SessionErrors.add(request, "diaChi2");
	 valid = false;
 }



//birth3Tab1 - Date 
String birth3Tab1 = ParamUtil.getString(request, "birth3Tab1").trim();
try {
if (birth3Tab1.length() > 0 && ActionUtils.compareTwoDates(birth3Tab1, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "birth3Tab1" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}



//quocTich3Tab1 - nation *
 long quocTich3Tab1 = ParamUtil.getLong(request, "quocTich3Tab1");
 if(quocTich3Tab1 <= 0){
 	SessionErrors.add(request, "quocTich3Tab1");
 	valid = false;
 }

//quocGia3Tab1 - nation *
 long quocGia3Tab1 = ParamUtil.getLong(request, "quocGia3Tab1");
 if(quocGia3Tab1 <= 0){
 	SessionErrors.add(request, "quocGia3Tab1");
 	valid = false;
 }

// tinh3 - address *
 long tinh3 = ParamUtil.getLong(request, "tinh3");
 if(tinh3 <= 0){
	 SessionErrors.add(request, "tinh3");
	 valid = false;
 }

// quan3 - address *
 long quan3 = ParamUtil.getLong(request, "quan3");
 if(quan3 <= 0){
	 SessionErrors.add(request, "quan3");
	 valid = false;
 }

// xa3 - address *
 long xa3 = ParamUtil.getLong(request, "xa3");
 if(xa3 <= 0){
	 SessionErrors.add(request, "xa3");
	 valid = false;
 }

// diaChi3 - address *
 String diaChi3 = ParamUtil.getString(request, "diaChi3").trim();
 if(diaChi3.length() == 0){
	 SessionErrors.add(request, "diaChi3");
	 valid = false;
 }



//birth4Tab1 - Date 
String birth4Tab1 = ParamUtil.getString(request, "birth4Tab1").trim();
try {
if (birth4Tab1.length() > 0 && ActionUtils.compareTwoDates(birth4Tab1, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "birth4Tab1" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}

//danToc4Tab1 - danToc *
 long danToc4Tab1 = ParamUtil.getLong(request, "danToc4Tab1");
 if(danToc4Tab1 <= 0){
 	SessionErrors.add(request, "danToc4Tab1");
 	valid = false;
 }





// tinh4 - address *
 long tinh4 = ParamUtil.getLong(request, "tinh4");
 if(tinh4 <= 0){
	 SessionErrors.add(request, "tinh4");
	 valid = false;
 }

// quan4 - address *
 long quan4 = ParamUtil.getLong(request, "quan4");
 if(quan4 <= 0){
	 SessionErrors.add(request, "quan4");
	 valid = false;
 }

// xa4 - address *
 long xa4 = ParamUtil.getLong(request, "xa4");
 if(xa4 <= 0){
	 SessionErrors.add(request, "xa4");
	 valid = false;
 }

// diaChi4 - address *
 String diaChi4 = ParamUtil.getString(request, "diaChi4").trim();
 if(diaChi4.length() == 0){
	 SessionErrors.add(request, "diaChi4");
	 valid = false;
 }

//ten1Tab2 - input *
String ten1Tab2 = ParamUtil.getString(request, "ten1Tab2").trim();
if (ten1Tab2.length() == 0 ) {
	SessionErrors.add(request, "ten1Tab2");
	valid = false;
}

//birth1Tab2 - Date *
String birth1Tab2 = ParamUtil.getString(request, "birth1Tab2").trim();
if (birth1Tab2.length() == 0) {
SessionErrors.add(request, "birth1Tab2");
valid = false;
} else {
try {
if (birth1Tab2.length() > 0 && ActionUtils.compareTwoDates(birth1Tab2, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "birth1Tab2" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//danToc1Tab2 - danToc *
 long danToc1Tab2 = ParamUtil.getLong(request, "danToc1Tab2");
 if(danToc1Tab2 <= 0){
 	SessionErrors.add(request, "danToc1Tab2");
 	valid = false;
 }

//quocTich1Tab2 - nation *
 long quocTich1Tab2 = ParamUtil.getLong(request, "quocTich1Tab2");
 if(quocTich1Tab2 <= 0){
 	SessionErrors.add(request, "quocTich1Tab2");
 	valid = false;
 }

// tinh5 - address *
 long tinh5 = ParamUtil.getLong(request, "tinh5");
 if(tinh5 <= 0){
	 SessionErrors.add(request, "tinh5");
	 valid = false;
 }

// quan5 - address *
 long quan5 = ParamUtil.getLong(request, "quan5");
 if(quan5 <= 0){
	 SessionErrors.add(request, "quan5");
	 valid = false;
 }

// xa5 - address *
 long xa5 = ParamUtil.getLong(request, "xa5");
 if(xa5 <= 0){
	 SessionErrors.add(request, "xa5");
	 valid = false;
 }

// diaChi5 - address *
 String diaChi5 = ParamUtil.getString(request, "diaChi5").trim();
 if(diaChi5.length() == 0){
	 SessionErrors.add(request, "diaChi5");
	 valid = false;
 }



//cmnd1Tab2 - cmnd *
String cmnd1Tab2 = ParamUtil.getString(request, "cmnd1Tab2").trim();
if (cmnd1Tab2.length() == 0) {
SessionErrors.add(request, "cmnd1Tab2");
valid = false;
}else if (cmnd1Tab2.length() > 0 && !ActionUtils.regexCmnd(cmnd1Tab2)) {
	SessionErrors.add(request, "cmnd1Tab2"+ "NhapSai");
	valid = false;
}

//ngayCapCmnd1Tab2 - Date 
String ngayCapCmnd1Tab2 = ParamUtil.getString(request, "ngayCapCmnd1Tab2").trim();
try {
if (ngayCapCmnd1Tab2.length() > 0 && ActionUtils.compareTwoDates(ngayCapCmnd1Tab2, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapCmnd1Tab2" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}



//hoChieu1Tab2 - input *
String hoChieu1Tab2 = ParamUtil.getString(request, "hoChieu1Tab2").trim();
if (hoChieu1Tab2.length() == 0 ) {
	SessionErrors.add(request, "hoChieu1Tab2");
	valid = false;
}



//ngayCapHoChieu1Tab2 - Date 
String ngayCapHoChieu1Tab2 = ParamUtil.getString(request, "ngayCapHoChieu1Tab2").trim();
try {
if (ngayCapHoChieu1Tab2.length() > 0 && ActionUtils.compareTwoDates(ngayCapHoChieu1Tab2, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapHoChieu1Tab2" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}

//tenGTK1Tab2 - input *
String tenGTK1Tab2 = ParamUtil.getString(request, "tenGTK1Tab2").trim();
if (tenGTK1Tab2.length() == 0 ) {
	SessionErrors.add(request, "tenGTK1Tab2");
	valid = false;
}

//soGTK1Tab2 - input *
String soGTK1Tab2 = ParamUtil.getString(request, "soGTK1Tab2").trim();
if (soGTK1Tab2.length() == 0 ) {
	SessionErrors.add(request, "soGTK1Tab2");
	valid = false;
}



//ngayCapGTK1Tab2 - Date 
String ngayCapGTK1Tab2 = ParamUtil.getString(request, "ngayCapGTK1Tab2").trim();
try {
if (ngayCapGTK1Tab2.length() > 0 && ActionUtils.compareTwoDates(ngayCapGTK1Tab2, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapGTK1Tab2" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}



//ten2Tab2 - input *
String ten2Tab2 = ParamUtil.getString(request, "ten2Tab2").trim();
if (ten2Tab2.length() == 0 ) {
	SessionErrors.add(request, "ten2Tab2");
	valid = false;
}

//birth2Tab2 - Date *
String birth2Tab2 = ParamUtil.getString(request, "birth2Tab2").trim();
if (birth2Tab2.length() == 0) {
SessionErrors.add(request, "birth2Tab2");
valid = false;
} else {
try {
if (birth2Tab2.length() > 0 && ActionUtils.compareTwoDates(birth2Tab2, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "birth2Tab2" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//danToc2Tab2 - danToc *
 long danToc2Tab2 = ParamUtil.getLong(request, "danToc2Tab2");
 if(danToc2Tab2 <= 0){
 	SessionErrors.add(request, "danToc2Tab2");
 	valid = false;
 }

//quocTich2Tab2 - nation *
 long quocTich2Tab2 = ParamUtil.getLong(request, "quocTich2Tab2");
 if(quocTich2Tab2 <= 0){
 	SessionErrors.add(request, "quocTich2Tab2");
 	valid = false;
 }

// tinh6 - address *
 long tinh6 = ParamUtil.getLong(request, "tinh6");
 if(tinh6 <= 0){
	 SessionErrors.add(request, "tinh6");
	 valid = false;
 }

// quan6 - address *
 long quan6 = ParamUtil.getLong(request, "quan6");
 if(quan6 <= 0){
	 SessionErrors.add(request, "quan6");
	 valid = false;
 }

// xa6 - address *
 long xa6 = ParamUtil.getLong(request, "xa6");
 if(xa6 <= 0){
	 SessionErrors.add(request, "xa6");
	 valid = false;
 }

// diaChi6 - address *
 String diaChi6 = ParamUtil.getString(request, "diaChi6").trim();
 if(diaChi6.length() == 0){
	 SessionErrors.add(request, "diaChi6");
	 valid = false;
 }



//cmnd2Tab2 - cmnd *
String cmnd2Tab2 = ParamUtil.getString(request, "cmnd2Tab2").trim();
if (cmnd2Tab2.length() == 0) {
SessionErrors.add(request, "cmnd2Tab2");
valid = false;
}else if (cmnd2Tab2.length() > 0 && !ActionUtils.regexCmnd(cmnd2Tab2)) {
	SessionErrors.add(request, "cmnd2Tab2"+ "NhapSai");
	valid = false;
}

//ngayCapCmnd2Tab2 - Date 
String ngayCapCmnd2Tab2 = ParamUtil.getString(request, "ngayCapCmnd2Tab2").trim();
try {
if (ngayCapCmnd2Tab2.length() > 0 && ActionUtils.compareTwoDates(ngayCapCmnd2Tab2, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapCmnd2Tab2" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}



//hoChieu2Tab2 - input *
String hoChieu2Tab2 = ParamUtil.getString(request, "hoChieu2Tab2").trim();
if (hoChieu2Tab2.length() == 0 ) {
	SessionErrors.add(request, "hoChieu2Tab2");
	valid = false;
}



//ngayCapHoChieu2Tab2 - Date 
String ngayCapHoChieu2Tab2 = ParamUtil.getString(request, "ngayCapHoChieu2Tab2").trim();
try {
if (ngayCapHoChieu2Tab2.length() > 0 && ActionUtils.compareTwoDates(ngayCapHoChieu2Tab2, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapHoChieu2Tab2" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}

//tenGTK2Tab2 - input *
String tenGTK2Tab2 = ParamUtil.getString(request, "tenGTK2Tab2").trim();
if (tenGTK2Tab2.length() == 0 ) {
	SessionErrors.add(request, "tenGTK2Tab2");
	valid = false;
}

//soGTK2Tab2 - input *
String soGTK2Tab2 = ParamUtil.getString(request, "soGTK2Tab2").trim();
if (soGTK2Tab2.length() == 0 ) {
	SessionErrors.add(request, "soGTK2Tab2");
	valid = false;
}



//ngayCapGTK2Tab2 - Date 
String ngayCapGTK2Tab2 = ParamUtil.getString(request, "ngayCapGTK2Tab2").trim();
try {
if (ngayCapGTK2Tab2.length() > 0 && ActionUtils.compareTwoDates(ngayCapGTK2Tab2, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapGTK2Tab2" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}

//quanHe2Tab2 - quanHe *
 long quanHe2Tab2 = ParamUtil.getLong(request, "quanHe2Tab2");
 if(quanHe2Tab2 < 0){
 	SessionErrors.add(request, "quanHe2Tab2");
 	valid = false;
 }

//ten3Tab2 - input *
String ten3Tab2 = ParamUtil.getString(request, "ten3Tab2").trim();
if (ten3Tab2.length() == 0 ) {
	SessionErrors.add(request, "ten3Tab2");
	valid = false;
}

//birth3Tab2 - Date *
String birth3Tab2 = ParamUtil.getString(request, "birth3Tab2").trim();
if (birth3Tab2.length() == 0) {
SessionErrors.add(request, "birth3Tab2");
valid = false;
} else {
try {
if (birth3Tab2.length() > 0 && ActionUtils.compareTwoDates(birth3Tab2, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "birth3Tab2" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}}

//danToc3Tab2 - danToc *
 long danToc3Tab2 = ParamUtil.getLong(request, "danToc3Tab2");
 if(danToc3Tab2 <= 0){
 	SessionErrors.add(request, "danToc3Tab2");
 	valid = false;
 }

//quocTich3Tab2 - nation *
 long quocTich3Tab2 = ParamUtil.getLong(request, "quocTich3Tab2");
 if(quocTich3Tab2 <= 0){
 	SessionErrors.add(request, "quocTich3Tab2");
 	valid = false;
 }

// tinh7 - address *
 long tinh7 = ParamUtil.getLong(request, "tinh7");
 if(tinh7 <= 0){
	 SessionErrors.add(request, "tinh7");
	 valid = false;
 }

// quan7 - address *
 long quan7 = ParamUtil.getLong(request, "quan7");
 if(quan7 <= 0){
	 SessionErrors.add(request, "quan7");
	 valid = false;
 }

// xa7 - address *
 long xa7 = ParamUtil.getLong(request, "xa7");
 if(xa7 <= 0){
	 SessionErrors.add(request, "xa7");
	 valid = false;
 }

// diaChi7 - address *
 String diaChi7 = ParamUtil.getString(request, "diaChi7").trim();
 if(diaChi7.length() == 0){
	 SessionErrors.add(request, "diaChi7");
	 valid = false;
 }



//cmnd3Tab2 - cmnd *
String cmnd3Tab2 = ParamUtil.getString(request, "cmnd3Tab2").trim();
if (cmnd3Tab2.length() == 0) {
SessionErrors.add(request, "cmnd3Tab2");
valid = false;
}else if (cmnd3Tab2.length() > 0 && !ActionUtils.regexCmnd(cmnd3Tab2)) {
	SessionErrors.add(request, "cmnd3Tab2"+ "NhapSai");
	valid = false;
}

//ngayCapCmnd3Tab2 - Date 
String ngayCapCmnd3Tab2 = ParamUtil.getString(request, "ngayCapCmnd3Tab2").trim();
try {
if (ngayCapCmnd3Tab2.length() > 0 && ActionUtils.compareTwoDates(ngayCapCmnd3Tab2, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapCmnd3Tab2" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}



//hoChieu3Tab2 - input *
String hoChieu3Tab2 = ParamUtil.getString(request, "hoChieu3Tab2").trim();
if (hoChieu3Tab2.length() == 0 ) {
	SessionErrors.add(request, "hoChieu3Tab2");
	valid = false;
}



//ngayCapHoChieu3Tab2 - Date 
String ngayCapHoChieu3Tab2 = ParamUtil.getString(request, "ngayCapHoChieu3Tab2").trim();
try {
if (ngayCapHoChieu3Tab2.length() > 0 && ActionUtils.compareTwoDates(ngayCapHoChieu3Tab2, today, "dd/MM/yyyy") > 0) {
SessionErrors.add(request, "ngayCapHoChieu3Tab2" + "lonHonHienTai");
valid = false;
}
} catch (ParseException e) {
}






		if (!valid) {
			setParams(request);
		}

		Iterator<String> itErrors = SessionErrors.iterator(request);
		while (itErrors.hasNext())
			System.out.println(" ======> KhaiSinhKetHopChaMeConNNValidators Key: "+  itErrors.next());
		
		return valid;
	}

	public static void setParams(ActionRequest resourceRequest) {
		Enumeration<String> listName = resourceRequest.getParameterNames();
		String maTaiLieu = "";
		while (listName.hasMoreElements()) {
			maTaiLieu = listName.nextElement();
			resourceRequest.setAttribute(maTaiLieu,
			ParamUtil.getString(resourceRequest, maTaiLieu));
		}
	}
}