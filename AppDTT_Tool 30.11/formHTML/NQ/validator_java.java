package vn.dtt.portlet.GROUPBYTAN.utilsSUBFOLDERENTITYBYTAN;
import java.util.Enumeration;
import java.text.ParseException;
import javax.portlet.ActionRequest;
import java.util.Iterator;
import vn.dtt.portlet.utils.ActionUtils;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.ParamUtil;

public class UTILSNAMEBYTANValidators {
	public static boolean validate(ActionRequest request) {

		boolean valid = true;
		String today = ActionUtils.getToday();


		if (!valid) {
			setParams(request);
		}

		Iterator<String> itErrors = SessionErrors.iterator(request);
		while (itErrors.hasNext())
			System.out.println(" ======> UTILSNAMEBYTANValidators Key: "+  itErrors.next());
		
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