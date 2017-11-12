<%@page import="vn.dtt.portlet.utils.CommonValidatorAndDebug"%>
<%@page import="vn.dtt.GROUPBYTAN.FOLDERENTITYBYTAN.model.impl.ENTITYNAMEBYTANImpl"%>
<%@page import="vn.dtt.GROUPBYTAN.FOLDERENTITYBYTAN.service.ENTITYNAMEBYTANLocalServiceUtil"%>
<%@page import="vn.dtt.GROUPBYTAN.FOLDERENTITYBYTAN.model.ENTITYNAMEBYTAN"%>
<%@page import="vn.dtt.portlet.GROUPBYTAN.GROUPCONSTANTBYTAN"%>
<%@include file="/html/portlet/GROUPBYTAN/GROUPBYTANinit.jsp"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="vn.dtt.cmon.dao.cd.model.CongDanClp"%>
<%@page import="vn.dtt.cmon.dao.cd.service.CongDanLocalServiceUtil"%>
<%@page import="vn.dtt.cmon.dao.dn.service.DoanhNghiepLocalServiceUtil"%>
<%@page import="vn.dtt.cmon.dao.cd.model.CongDan"%>
<%@page import="vn.dtt.cmon.dao.dn.model.DoanhNghiep"%>
<%@page import="com.liferay.portal.kernel.log.LogFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.log.Log"%>

<head>
	<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/customEgovTheme.css"
	type="text/css" media="screen" />
	<script src="<%=request.getContextPath()%>/js/togglesubmit.js"
	type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/js/cmonHeader.js"
	type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/js/formatNumber.js"
	type="text/javascript"></script>
	<style>
		#tbl_thongtinThem,#tbl_thongtinThem tr,th,td,#tbl_thongtinThem .row td {
			border: solid 1px black !important;
		}
	</style>
</head>
<%
String idHoSo = ParamUtil.getString(request, "id");
long id = (new Long(idHoSo)).intValue();

ICitizenService service = WebserviceFactory.getCmonService();
Long userId = PortalUtil.getUserId(request);
HoSoTTHCCong hoSoTTHCCong = HoSoTTHCCongLocalServiceUtil.fetchHoSoTTHCCong(id);
ENTITYNAMEBYTAN hoSo = ENTITYNAMEBYTANLocalServiceUtil.fetchENTITYNAMEBYTAN(id);
String maQuyTrinh = CommonValidatorAndDebug.getMaQuyTrinh(request);
%>

<body>
	<div class="egov-container" id="page_Container">
		 <table class="egov-table-form">
			<tr>
				<td colspan="6" align="center" style = "text-align: center;  vertical-align: top">
					<label class="egov-label"
						style="font-style: italic; text-align: center;margin-top: 5px;font-size: 14px !important;">
						(Ban hành kèm theo Thông tư liên tịch số 13/2014/TTLT-BLĐTBXH-BTC ngày 03/6/2014 của Bộ<br>Lao động - Thương binh và Xã hội, Bộ Tài chính)
					</label> 

					<br/><br>

					<label class="egov-label"
						style = "font-weight: bold;
						font-size : 17px;
						text-align: center;">
						CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM
					</label>

					<div style="margin-top:5px;">
						<p class="egov-p-13"
								align="center"
							style = "font-weight: bold;
							  font-size: 17px;">
							 Độc lập - Tự do - Hạnh phúc
							<br>
							<span style="font-size: 12px;">________________</span>
						</p>
					</div>
					
					<div align="right" style="margin: 7px 0;">
						<p class="egov-p-13" style="font-style: italic;text-align: right;font-size: 13px;">
							Bắc Ninh, <%=ActionUtils.getNgayThangNam(hoSoTTHCCong.getNgayNopHoSo()) %>
						</p>
					</div>
				</td>
			</tr>

	
			<tr>
				<td colspan="6" align="center" style="text-align: center;">
					<p style="font-weight: bold; font-size: 18px;"> 
						<%="title".toUpperCase()%>
					</p>

					<div style="margin-top: 12px;">
						<p style="font-weight: bold; font-size: 18px;">
							<%="title".toUpperCase()%>
						</p>
					</div><br>
				</td>
			</tr>

			<tr>
				<td colspan="6" style="text-align: center;">
					<span style="font-size: 12px;">__________________</span>
				</td>
			</tr>


			<tr>
				<td colspan="6" align="center" style = "text-align: center;">
				<label class="egov-label">Kính gửi:</label>
				<label class="egov-label">
					 <%=ActionUtils.getKinhGui(hoSo.getCoQuanQuanLyId()) %>
				</label>
				</td>
			</tr>

			<tr>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
			</tr>
					<!-- -------------------------- here ------------------------------  -->
									reviewJspFormService
					<!-- -------------------------- here ------------------------------  -->
			<tr>
				<td colspan="6">
					<div style = "display: block; text-align :justify; font-size: 15px;">
						<label class="egov-label">
							Tôi cam đoan lời khai trên đây là đúng sự thật và chịu trách
							nhiệm trước pháp luật về cam đoan của mình. 
						</label>
					</div>
				</td>
			</tr>

			<tr>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
			</tr>

			<tr >
				<td colspan="3" style="text-align: center; vertical-align: top">
					<label class = "egov-label-note">Bắc Ninh, ngày ...... tháng ...... năm ...........</label><br>
					<label class = "egov-label-bold">Xác nhận của UBND cấp xã nơi cư trú 
					</label><br/>
					<label class = "egov-label-note" >(Ký, ghi rõ họ tên, đóng đấu) </label>
				</td>

				<td colspan="3" style="text-align: center; vertical-align: top"><label
					class="egov-label-note">
					Làm tại: ........... , ngày ..... tháng ..... năm ..........</label><br> <label
					class="egov-label-bold">
					Người yêu cầu </label><br /> <label class="egov-label-note">
					(Ký, ghi rõ họ, chữ đệm, tên) </label></td>
			</tr>

			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="4" style="text-align: center;">
					<label class="egov-label-note">
						Bắc Ninh, ngày ....... tháng ...... năm ...........    
					</label>				
				</td>
			</tr>
			
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="4" style="text-align: center;">
					<label class="egov-label-bold">CƠ QUAN, TỔ CHỨC, DOANH NGHIỆP<br>
					ĐĂNG KÝ THỰC HIỆN QUẢNG CÁO<br>
					</label>
					<label class="egov-label-note">(ký, họ tên, chức vụ và đóng dấu)</label>				
				</td>	
			</tr>	
		</table>
	</div>
	
	<div style="margin-left: 15px; margin-top: 10px;">
		<jsp:include page="/html/portlet/xuLyHoSoButtons.jsp">
			<jsp:param name="editJSP"
				value="/html/portlet/GROUPBYTAN/FOLDERJSPBYTAN/registry_HOSOBYTAN_step.jsp" />
			<jsp:param name="bacninh" value="bacninh" />
		</jsp:include>
	</div>
</body>