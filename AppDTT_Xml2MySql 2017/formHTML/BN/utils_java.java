package vn.dtt.portlet.GROUPBYTAN.utilsSUBFOLDERENTITYBYTAN;

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
import vn.dtt.portlet.GROUPBYTAN.GROUPCONSTANTBYTAN;
import vn.dtt.portlet.utils.ComUtils;
import vn.dtt.sharedservice.WebserviceFactory;
import vn.dtt.sharedservice.cmon.consumer.citizen.*;
import vn.dtt.GROUPBYTAN.FOLDERENTITYBYTAN.model.ENTITYNAMEBYTAN;
import vn.dtt.GROUPBYTAN.FOLDERENTITYBYTAN.model.impl.ENTITYNAMEBYTANImpl;
import vn.dtt.GROUPBYTAN.FOLDERENTITYBYTAN.model.impl.ENTITYNAMEBYTANModelImpl;
import vn.dtt.GROUPBYTAN.FOLDERENTITYBYTAN.service.ENTITYNAMEBYTANLocalServiceUtil;

public class UTILSNAMEBYTANUtils {
	private static final Log log = LogFactoryUtil.getLog(UTILSNAMEBYTANUtils.class);
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
		$sessionForList

		ENTITYNAMEBYTAN obj = fillData2Form(request);

		HoSoTTHCCong hoSoTTHCCong = ComUtils.createHoSoTTHCCong(request, citizen,ENTITYNAMEBYTANModelImpl.TABLE_NAME, loaiDoiTuong);

		session.setAttribute(GROUPCONSTANTBYTAN.OBJECT_DATA1,obj);
		session.setAttribute(GROUPCONSTANTBYTAN.OBJECT_DATA2,hoSoTTHCCong);
		request.setAttribute(GROUPCONSTANTBYTAN.ID_QUY_TRINH,ParamUtil.getString(request, "idQuyTrinh"));
		request.setAttribute(GROUPCONSTANTBYTAN.MA_CONG_DAN,user.getUserId());

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
		$sessionForList

		ENTITYNAMEBYTAN obj = fillData2Form(request);
		session.setAttribute(GROUPCONSTANTBYTAN.OBJECT_DATA1,obj);
		session.setAttribute(GROUPCONSTANTBYTAN.OBJECT_DATA2,hoSoTTHCCong);
		request.setAttribute(GROUPCONSTANTBYTAN.ID_QUY_TRINH,ParamUtil.getString(request, "idQuyTrinh"));
		request.setAttribute(GROUPCONSTANTBYTAN.ID_DANH_SACH_HO_SO,hoSoTTHCCong.getId());
		request.setAttribute(GROUPCONSTANTBYTAN.MA_CONG_DAN,user.getUserId());
		request.setAttribute(GROUPCONSTANTBYTAN.EMAIL_CONG_DAN,"test@liferay.com");

		respone.setRenderParameter("jspPage", "/html/portlet/uploadDocument_step2.jsp");
		SessionErrors.clear(request);
	}

	public ENTITYNAMEBYTAN fillData2Form(ActionRequest request) 
				throws SystemException, PortalException {
		User user = null;
		try {
			user = PortalUtil.getUser(request);
		} catch (SystemException e) {
		}
		Long idHoSo = ParamUtil.getLong(request, "id");
		ENTITYNAMEBYTAN hoSo = null;
		if (idHoSo != null && idHoSo > 0) {
			hoSo = ENTITYNAMEBYTANLocalServiceUtil.fetchENTITYNAMEBYTAN(idHoSo);
		} else {
			hoSo = new ENTITYNAMEBYTANImpl();
		}
		fillData2FormFormService
		return hoSo;
	}

	public boolean validate(ActionRequest request) {

		boolean valid = true;
		String today = ActionUtils.getToday();
		validateFormService
		if (!valid) {
			setParams(request);
		}

		Iterator<String> itErrors = SessionErrors.iterator(request);
		while (itErrors.hasNext())
			System.out.println(" ======> UTILSNAMEBYTAN Validators Key: "+  itErrors.next());
		
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