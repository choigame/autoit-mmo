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
// tham so id tren url cua review.jsp
String idHoSo = ParamUtil.getString(request, "id");
long id = (new Long(idHoSo)).intValue();

ICitizenService service = WebserviceFactory.getCmonService();
Long userId = PortalUtil.getUserId(request);
HoSoTTHCCong hoSoTTHCCong = HoSoTTHCCongLocalServiceUtil.fetchHoSoTTHCCong(id);
ENTITYNAMEBYTAN hoSo = ENTITYNAMEBYTANLocalServiceUtil.fetchENTITYNAMEBYTAN(id);
%>

<body>
	<div class="egov-container" id="page_Container">
		 <table class="egov-table-form">
			<tr>
				<td colspan="6" align="center" style = "text-align: center;">
					<label class="egov-label"
						style="font-style: italic; text-align: center;margin-top: 5px;font-size: 14px !important;">
						(Ban hành kèm theo Thông tư liên tịch số 13/2014/TTLT-BLĐTBXH-BTC ngày 03/6/2014 của Bộ<br>Lao động - Thương binh và Xã hội, Bộ Tài chính)
					</label> 

					<br/><br>

					<label class="egov-label"
						style = "font-weight: bold;
						font-size : 17px;
						text-align: center;
						margin-bottom: 0px !important;
						padding-bottom: 0px;">
						CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM
					</label>

					<p class="egov-p-13"
							align="center"
						style = "margin-top : 0px;
						 padding-top : 0px;
						 font-weight: bold;
						  font-size: 16px;">
						 Độc lập - Tự do - Hạnh phúc
						<br>
						<span style="font-size: 12px;">_____________________</span>
					</p>

					<br>

					<div align="right" style="margin: 10px 0;">
						<p class="egov-p-13" style="font-style: italic;text-align: right;font-size: 13px;">
							Hải Phòng, <%=ActionUtils.getNgayThangNam(hoSoTTHCCong.getNgayNopHoSo()) %>
						</p>
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


			<tr>
				<td colspan="6" align="center" style = "text-align: center;">
					<label class="egov-label-bold" style = "font-size: 17px !important;font-weight: bold;">
							TITLE
						<div style="margin-top: 7px;font-size: 17px;"><p>
							TITLE</p>
						</div>
					</label>
				</td>
			</tr>

			<tr>
				<td colspan="6" style="text-align: center;">
					<span style="font-size: 12px;">__________________</span>
				</td>
			</tr>


			<tr>
				<td colspan="6" align="center" style = "text-align: center;">
				<label class="egov-label-bold">Kính gửi:</label>
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
					<!-- --------------------------------- here --------------------------------- -->





					<!-- --------------------------------- here --------------------------------- -->

			<tr>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
				<td width="16.67%">&nbsp;</td>
			</tr>

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
				<td colspan="3">
					<label class = "egov-label-note" style= "margin-left : 15px;">Hải Phòng, ngày ...... tháng ...... năm ...........</label><br>
					<label class = "egov-label-bold" style= "margin-left : 15px;">Xác nhận của UBND cấp xã nơi cư trú 
					</label><br/>
					 <label class = "egov-label-note" style= "margin-left : 45px;">(Ký, ghi rõ họ tên, đóng đấu) </label>
				</td>

				<td colspan="3" style = "text-align: right;">
					<label class = "egov-label-note" style= "margin-right : 35px;">Hải Phòng, ngày ...... tháng ...... năm ...........</label><br>
					<label class = "egov-label-bold" style= "margin-right : 95px;">Người viết đơn </label><br/>
					<label class = "egov-label-note" style= "margin-right : 95px;">(Ký, ghi rõ họ tên) </label>
				</td>
			</tr>

			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="4" style="text-align: center;">
					<label class="egov-label-note">
						Hải Phòng, ngày ....... tháng ....... năm .........    
					</label>				
				</td>
			</tr>
			
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="4" style="text-align: center;">
					<label class="egov-label-bold">CƠ QUAN, TỔ CHỨC, DOANH NGHIỆP<br>
					ĐĂNG KÝ THỰC HIỆN QUẢNG CÁO<br><br>
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
		</jsp:include>
	</div>
</body>