<%@page import="vn.dtt.cmon.dao.dvc.service.ThuTucHanhChinhLocalServiceUtil"%>
<%@page import="vn.dtt.sharedservice.cmon.consumer.citizen.DonViHanhChinhSoap"%>
<%@page import="vn.dtt.GROUPBYTAN.FOLDERENTITYBYTAN.model.impl.ENTITYNAMEBYTANImpl"%>
<%@page import="vn.dtt.GROUPBYTAN.FOLDERENTITYBYTAN.model.ENTITYNAMEBYTANClp"%>
<%@page import="vn.dtt.portlet.GROUPBYTAN.GROUPCONSTANTBYTAN"%>
<%@page import="vn.dtt.portlet.utils.ActionUtils"%>
<%@page import="vn.dtt.GROUPBYTAN.FOLDERENTITYBYTAN.service.ENTITYNAMEBYTANLocalServiceUtil"%>
<%@page import="vn.dtt.GROUPBYTAN.FOLDERENTITYBYTAN.model.ENTITYNAMEBYTAN"%>

<%@page import="vn.dtt.cmon.dao.qlhc.model.CoQuanQuanLy"%>
<%@page import="java.util.List"%>
<%@page import="vn.dtt.cmon.dao.thamso.service.ThamSoLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>

<%@page import="com.liferay.portal.kernel.log.LogFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.log.Log"%>
<%@page import="vn.dtt.cmon.dao.cd.model.CongDan"%>
<%@page import="vn.dtt.cmon.dao.dn.model.DoanhNghiep"%>

<%@page import="vn.dtt.cmon.dao.cd.model.CongDanClp"%>
<%@page import="vn.dtt.cmon.dao.cd.service.CongDanLocalServiceUtil"%>
<%@page import="vn.dtt.cmon.dao.dn.service.DoanhNghiepLocalServiceUtil"%>
<%@page import="vn.dtt.portlet.utils.CommonValidatorAndDebug"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import="javax.portlet.PortletPreferences"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet"%>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util"%>
    
<%@ include file="/html/portlet/GROUPBYTAN/GROUPBYTANinit.jsp" %>
<!-- <%@ include file="/html/portlet/csms/csmsinit_non_brms.jsp"%> -->

<portlet:actionURL var="saveUTILSNAMEBYTAN" name="saveUTILSNAMEBYTAN">
		<portlet:param name="jspPage"
	value="/html/portlet/GROUPBYTAN/FOLDERJSPBYTAN/registry_HOSOBYTAN_step.jsp" />
</portlet:actionURL>

<html>
	<head>
	   	<script src="<%=request.getContextPath()%>/js/togglesubmit.js"
			type="text/javascript"></script>
		<script src="<%=request.getContextPath()%>/js/cmonHeader.js"
			type="text/javascript"></script>
		<script src="<%=request.getContextPath()%>/js/formatNumber.js"
	 		 type="text/javascript"></script>
	  	<script src="<%=request.getContextPath()%>/js/validationData.js"
		type="text/javascript"></script>
	  	<link type="text/css" rel="stylesheet" 
	  	href="<%=request.getContextPath()%>/css/customEgovTheme.css">	
	</head>
<%  
	Log log = LogFactoryUtil.getLog(this.getClass());
	ICitizenService service = WebserviceFactory.getCmonService();
	long thuTucHanhChinhId = CommonValidatorAndDebug.getThuTucId(request);
	long hoSoId = CommonValidatorAndDebug.getHoSoId(request);
	Long userId = PortalUtil.getUserId(request);

	String loaiDoiTuong = CommonValidatorAndDebug.getLoaiDoiTuongFromRequest(request);
	
	List<DonViHanhChinh> danhSachTinhThanh = DonViHanhChinhLocalServiceUtil.getDanhSachTinhThanh();
	List<CoQuanQuanLySoap> coQuanQuanLySoaps = service.getDSCoQuanQuanLyTheoTTHC(new Long(thuTucHanhChinhId));

	Long donViHanhChinhId =  Long.parseLong(ConfigUtils.getValue("egov.application.bacninh.id", "31"));
	List<DonViHanhChinhSoap> donViHanhChinhSoaps =  service.getDanhsachDVHC(donViHanhChinhId);

	ENTITYNAMEBYTAN hoSo = null;

	if(request.getAttribute("obj") != null){  
		 hoSo = (ENTITYNAMEBYTAN)request.getAttribute("obj"); 
 	}
 	$listVaribleInJsp
 	DoanhNghiep doanhNghiep = null;
	CongDan congDan = null;

	if(hoSo == null){
		if(hoSoId > 0) {
			hoSo = ENTITYNAMEBYTANLocalServiceUtil.fetchENTITYNAMEBYTAN(hoSoId);
		}
	}

	if(hoSo == null){
		hoSo = new ENTITYNAMEBYTANImpl();
		if(DoanhNghiepLocalServiceUtil.getDoanhNghiepByTaiKhoanNguoiDungId(userId) != null){
			doanhNghiep = DoanhNghiepLocalServiceUtil.getDoanhNghiepByTaiKhoanNguoiDungId(userId);
			loaiDoiTuong = "doanh nghiep";
			if (doanhNghiep.getNguoiDaiDienId() !=null){
			congDan = CongDanLocalServiceUtil.fetchCongDan(doanhNghiep.getNguoiDaiDienId());
			}else{
				congDan = new CongDanClp();
			}
			if(congDan.getTenDayDu() != null){
			}
			if(doanhNghiep.getTenChiNhanh() != null){
			}
			if(doanhNghiep.getDiaChiDoanhNghiepTinhId() != null){
				hoSo.setTinh1(doanhNghiep.getDiaChiDoanhNghiepTinhId());
			}
			if(doanhNghiep.getDiaChiDoanhNghiepHuyenId() != null){
				hoSo.setQuan1(doanhNghiep.getDiaChiDoanhNghiepHuyenId());
			}
			if(doanhNghiep.getDiaChiDoanhNghiepXaId() != null){
				hoSo.setXa1(doanhNghiep.getDiaChiDoanhNghiepXaId());
			}
			if(doanhNghiep.getDiaChiDoanhNghiep() != null){
				hoSo.setDiaChi1(doanhNghiep.getDiaChiDoanhNghiep());
			}
		}else if(CongDanLocalServiceUtil.getCongDanByLiferayUserId(userId) != null){
			congDan = CongDanLocalServiceUtil.getCongDanByLiferayUserId(userId);
			loaiDoiTuong = "cong dan";
			if(congDan.getTenDayDu() != null){
				hoSo.setTen(congDan.getTenDayDu());
			}
			if(congDan.getDiaChiThuongTruTinhId() != null){
				hoSo.setTinh1(congDan.getDiaChiThuongTruTinhId());
			}
			if(congDan.getDiaChiThuongTruHuyenId() != null){
				hoSo.setQuan1(congDan.getDiaChiThuongTruHuyenId());
			}
			if(congDan.getDiaChiThuongTruXaId() != null){
				hoSo.setXa1(congDan.getDiaChiThuongTruXaId());
			}
			if(congDan.getDiaChiThuongTru() != null){
				hoSo.setDiaChi1(congDan.getDiaChiThuongTru());
			}
			if(congDan.getSoCmnd() != null){
				hoSo.setCmnd(congDan.getSoCmnd()); 
			}
			if(congDan.getNgaySinh() != null){
			}
			if(congDan.getNgayCapCmnd() != null){
			}
			if(congDan.getNoiCapCmndId()!=null){
			}
		}
	}

	arrayValidateFormFromService
	String maQuyTrinh = CommonValidatorAndDebug.getMaQuyTrinh(request);
	String title = ThuTucHanhChinhLocalServiceUtil.fetchThuTucHanhChinh(thuTucHanhChinhId) !=null ?
			ThuTucHanhChinhLocalServiceUtil.fetchThuTucHanhChinh(thuTucHanhChinhId).getTen() : "";

%>


<body class="nav-md">
	<div class = 'egov-container'>
		<jsp:include page="/html/portlet/cmonHeaderNoJSNoHeader.jsp"/>
		<form action = "<%=saveUTILSNAMEBYTAN%>" id = "myForm" method = "post"> 
			<table  class = "egov-table-form">
				<tr>
					<td colspan="6">
						<p class="egov-p-20-no-margin" ><%="TITLE1".toUpperCase()%></p>
						<div style="margin-top:12px;">
						 	<p class="egov-p-20-no-margin"><%="TITLE2".toUpperCase()%></p>
						</div>
						<br>
					</td>
				</tr>
				
				<!-- ERROR -->
				<tr style="display: none;">
					<td colspan="6">
						<select style="display: none;" id="egov-form-errors">
						<%
							for (String elementId : danhSachRequired){
						 %>
							<option value="<%=elementId%>">
								 <liferay-ui:error key="<%=elementId%>">
					 				<%=ActionUtils.getMessageValidate()%>
								 </liferay-ui:error>
							 </option>
					 	<%
					 		}
					 	%>

						<%
							for (String elementId : danhSachDate){
								String key1 = elementId +"lonHonHienTai";
						 %>
							<option value="<%=elementId%>">
								<liferay-ui:error key="<%=key1%>"
									 message="Phải trước hoặc bằng ngày hiện tại.">
					 			</liferay-ui:error>
							</option>
						<%
							}
						%>

						<%
							for (String elementId : danhsachCMND){
								String key2 = elementId +"NhapSai";
						%>
							<option value="<%=elementId%>">
								<liferay-ui:error key="<%=key2%>"
									message="Số chứng minh chỉ có 9 hoặc 12 chữ số." />
							</option>
						<%
							}
						%>

						<%
							for (String elementId : danhsachURL){
								String key3 = elementId +"NhapSai";
						%>
							<option value="<%=elementId%>">
								<liferay-ui:error key="<%=key3%>"
									message="Giá trị nhập vào không hợp lệ."/>
							</option>
						<%
							}
						%>


						<%
							for (String elementId : danhsachPhone){
								String key4 = elementId +"NhapSai";
						%>
							<option value="<%=elementId%>">
								<liferay-ui:error key="<%=key4%>"
									message="Chỉ cho phép 0-9+()-_. và khoảng trắng."/>
							</option>
						<%
							}
						%>

						</select>
					</td>
				</tr>
				
				<tr>
					<td colspan ="6">
						<input  type ='hidden' 
							name = 'ID_QUY_TRINH'
							 id = 'ID_QUY_TRINH'
							value = '<%=thuTucHanhChinhId %>'
						/>
						<input  type ='hidden' 
							name = 'idQuyTrinh'
							 id = 'idQuyTrinh'
							value = '<%=thuTucHanhChinhId %>'
						/>
						<input  type ='hidden' 
							name = 'loaiDoiTuong'
							id = 'loaiDoiTuong'
							value = '<%=loaiDoiTuong %>'
						/>
						<input  type ='hidden' 
							name = 'ID_DANH_SACH_HO_SO'
							id = 'ID_DANH_SACH_HO_SO'
							value = '<%=hoSoId%>'
						/>
						<input  type ='hidden' 
							name = 'id' 
							id = 'id'
							value = '<%=hoSoId%>'
						/>

						<input type='hidden' 
						name='maQuyTrinh'
						 id='maQuyTrinh' 
						 value='<%=maQuyTrinh%>' />
					</td>
				</tr>
		        
				<tr>
					<td colspan="6">
						<label class="egov-label-header"><br>
							CƠ QUAN GIẢI QUYẾT HỒ SƠ
						</label>
						<label class="egov-label-red">*</label>
						<label style = "color :red; margin: 0px; padding: 0px; float: right;" >
										<liferay-ui:message
										key="vn.dtt.hms.luuybatbuocnhap" />
						</label>
						<br>
						 <select name="coQuanQuanLyId" id="coQuanQuanLyId" 
						class="egov-select" >
							
							<%
								for (CoQuanQuanLySoap cq : coQuanQuanLySoaps) {
							%>
							<option value="<%=cq.getId()%>"
								<%=ActionUtils.checkData(cq.getId(),
										hoSo.getCoQuanQuanLyId())%>><%=cq.getTen()%></option>
							<%
								}
							%>
						</select>
					</td>
				</tr>
			
				<tr>
					<td colspan="6">
						<label class="egov-label-header"><br>THÔNG TIN NGƯỜI YÊU CẦU</label>
					</td>
				</tr>
				<!-- ------------------- Form ------------------------------- -->
										formJspFromService
				<tr>
					<td colspan="6"><input type="checkbox" class="egov-checkbox"
					onclick="setCommit()" id="chk" name="chk" onchange="unchecked" />
						<label class="egov-label">Đồng ý</label><br><br>
						<div align="left" class="egov-terms">
						<label class="egov-label" style="text-align: justify;">
							Tôi cam đoan lời khai trên đây là đúng sự thật và chịu trách nhiệm trước pháp luật về cam đoan của mình.
						</label>
						</div>
					</td>
				</tr>

				<tr>
					<td colspan="6">
						<div align="left">
							<input name="" type="submit" id="sm" size="20"
							class="egov-button" disabled="disabled"
							value="Tiếp tục"
							onclick="saveSubmitInfoTan();"/>

							<input type="hidden" id="radioHidden"/>
						</div>
					</td>
				</tr>
			</table>
		</form>$includeListJspInJsp
	</div>
</body>

<portlet:actionURL var="getDVHCId"
					name="getDonViHanhChinhById">
	<portlet:param name="jspPage"
		value="/html/portlet/GROUPBYTAN/FOLDERJSPBYTAN/registry_FOLDERJSPBYTAN_step.jsp" />
</portlet:actionURL>

<script type="text/javascript">
	var url = '<%=getDVHCId.toString()%>';
	document.getElementById("sm").disabled = true;
	document.getElementById("chk").checked = false;
	$(document).ready(function() {
	
		//showGiayTo($('#radioHidden').val());
		//getTableWhenClickBackButton("loadHidden","tbl_thongTinSanPham",3);
		reloadQuanHuyenSubmit('tinh1','quan1','xa1','tinh2','quan2','xa2', 'tinh3','quan3','xa3');
	});

	function setCommit() {
		if (document.getElementById("sm").disabled) {
			document.getElementById("sm").disabled = false;
		} else {
			document.getElementById("sm").disabled = true;
		}
		chkValue = document.getElementById("chk").checked;
		submitButton = document.getElementById("sm");
		if (!chkValue) 
			submitButton.disabled = true;
		else 
			submitButton.disabled = false;
	}

	function saveSubmitInfoTan(){
		//saveTableWhenSubmit("loadHidden","tbl_thongTinSanPham");
		saveSubmitInfo('tinh1','quan1','xa1','tinh2','quan2','xa2', 'tinh3','quan3','xa3');
	 }
	 
	
	function checkDanToc(idQuocTichCon, idDanTocCon) { 
	       var quocTich = document.getElementById(idQuocTichCon).value;
	       var danTocSelectBox = document.getElementById(idDanTocCon);
	        if (quocTich != 1 && quocTich != 0) {
	                    danTocSelectBox.value = 55;        
	         } else if (quocTich == 1) {
	            danTocSelectBox.value = 1;        
	         } else {
	            danTocSelectBox.value = 0;       
	         }   
	  }

	function setDanToc(idQuocTichCon, idDanTocCon) {
	   var quocTich = document.getElementById(idQuocTichCon).value;
	   if (quocTich == -1) return;  
	   var danTocSelectBox = document.getElementById(idDanTocCon);
       if (quocTich != 1 && quocTich > 0) { 
          danTocSelectBox.value = 55;        
      }    
  	}

	function showGiayTo(nameSelected){
		if (nameSelected =='cmnd') {
			document.getElementById('byCmndArea').style.display = '';
			document.getElementById('byHoChieuArea').style.display = 'none';
			$('#radioGiayToHidden').val('cmnd');
		} else if (nameSelected =='hoChieu') {
			document.getElementById('byCmndArea').style.display = 'none';
			document.getElementById('byHoChieuArea').style.display = '';
			$('#radioGiayToHidden').val('hoChieu');
		}
	}
</script>