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
    
<%@ include file="/html/portlet/GROUPBYTAN/GROUPBYTANinit.jsp" %>


<portlet:actionURL var="saveUTILSNAMEBYTAN" name="saveUTILSNAMEBYTAN">
	<portlet:param name="<%=GROUPCONSTANTBYTAN.ACTION%>"
		value="HOSOBYTAN.save" />
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
	  	<link type="text/css" rel="stylesheet" 
	  	href="<%=request.getContextPath()%>/css/customEgovTheme.css" charset="utf-8">	
	</head>
<%  
	Log log = LogFactoryUtil.getLog(this.getClass());
	ICitizenService service = WebserviceFactory.getCmonService();
	long thuTucHanhChinhId = CommonValidatorAndDebug.getThuTucId(request);
	long hoSoId = CommonValidatorAndDebug.getHoSoId(request);
	Long userId = PortalUtil.getUserId(request);
	String doiTuong = CommonValidatorAndDebug.getLoaiDoiTuongFromRequest(request);
	List<CoQuanQuanLy> danhSachCoQuanNhanHoSo = 
			CommonValidatorAndDebug.getDanhSachCoQuanQuanLyByThuTuc(thuTucHanhChinhId);
	
	log.info("=================1: " + thuTucHanhChinhId);

	List<DonViHanhChinh> danhSachTinhThanh = DonViHanhChinhLocalServiceUtil.getDanhSachTinhThanh();
	List<CoQuanQuanLySoap> coQuanQuanLySoaps = service.getDSCoQuanQuanLyTheoTTHC(new Long(thuTucHanhChinhId));
	long donViHanhChinhId = Long.parseLong(ConfigUtils.getValue("egov.application.provin.id", "31"));
	List<DonViHanhChinhSoap> donViHanhChinhSoaps =  service.getDanhsachDVHC(donViHanhChinhId);

	ENTITYNAMEBYTAN hoSo= null;

	if(request.getAttribute("obj") != null){  
		 hoSo = (ENTITYNAMEBYTAN)request.getAttribute("obj"); 
 	}

 	DoanhNghiep doanhNghiep = null;
	CongDan congDan = null;
	String loaiDoiTuong = "";

	if(hoSo == null){
		if(hoSoId > 0) hoSo = ENTITYNAMEBYTANLocalServiceUtil.fetchENTITYNAMEBYTAN(hoSoId);
	}


	if(hoSo == null){
		hoSo = new ENTITYNAMEBYTANImpl();
		if(DoanhNghiepLocalServiceUtil.getDoanhNghiepByTaiKhoanNguoiDungId(userId) !=null){
			doanhNghiep = DoanhNghiepLocalServiceUtil.getDoanhNghiepByTaiKhoanNguoiDungId(userId);
			loaiDoiTuong = "doanh nghiep";
			if (doanhNghiep.getNguoiDaiDienId() !=null){
			congDan = CongDanLocalServiceUtil.fetchCongDan(doanhNghiep.getNguoiDaiDienId());
			}else{
				congDan = new CongDanClp();
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
			}
			if(congDan.getNgaySinh() != null){
			}
			if(congDan.getNgayCapCmnd() != null){
			}
			if(congDan.getNoiCapCmndId()!=null){
			}
		}
	}
	String []danhSachIdRequired={""};
	String []danhSachIdDate={""};
	String []danhsachCMND = {""};
%>


<body class="nav-md">
	<div class = 'egov-container'>
		<jsp:include page="/html/portlet/cmonHeaderNoJSNoHeader.jsp"/>
		<form action = "<%=saveUTILSNAMEBYTAN%>" id = "myForm" method = "post"> 
			<table  class = "egov-table-form" border = "0">
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
							for (String elementId : danhSachIdRequired){
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
							for (String elementId : danhSachIdDate){
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
								String key3 = elementId +"NhapSai";
						%>
							<option value="<%=elementId%>">
								<liferay-ui:error key="<%=key3%>"
									message="Số chứng minh chỉ có 9 hoặc 12 chữ số." />
							</option>
						<%
							}
						%>

							<option value="phone">
								<liferay-ui:error key="phoneNhapSai"
									message="Số điện thoại có quá ít chữ số.">
								</liferay-ui:error>
							</option>

							<option value="phone">
								<liferay-ui:error key="phoneNhapSai2"
									message="Số điện thoại không hợp lệ.">
								</liferay-ui:error>
							</option>

							<option value="email">
								<liferay-ui:error key="emailNhapSai"
									message="Email không hợp lệ.">
								</liferay-ui:error>
							</option>
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
					</td>
				</tr>
		        
				<tr>
					<td colspan="6">
						<label class="egov-label-header"><br>
							CƠ QUAN GIẢI QUYẾT HỒ SƠ: 
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
							onclick="saveSubmitInfoTan('tinh1','quan1','xa1','tinh2','quan2','xa2');"/>
							<input type="hidden" id="tinh1Hidden">
							<input type="hidden" id="quan1Hidden">
							<input type="hidden" id="xa1Hidden">
							<input type="hidden" id="tinh2Hidden">
							<input type="hidden" id="quan2Hidden">
							<input type="hidden" id="xa2Hidden">
						</div>
					</td>
				</tr>
			</table>
		</form>
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
		$("#cmnd").on("input",function(){
			onlyNumeric(this);
		});
		//showGiayChungNhan($('#radioHidden').val());
		//getTableWhenClickBackButton("loadHidden","tbl_thongTinSanPham",3);
		reloadQuanHuyenTan('tinh1','quan1','xa1','tinh2','quan2','xa2');
	});

	function setCommit() {
		if (document.getElementById("sm").disabled) {
			document.getElementById("sm").disabled = false;
		} else {
			document.getElementById("sm").disabled = true;
		}
		chkValue = document.getElementById("chk").checked;
		submitButton = document.getElementById("sm");
		if (!chkValue) {
			submitButton.disabled = true;
		} else {
			submitButton.disabled = false;
		}
	}

	function saveSubmitInfoTan(a1,a2,a3,b1,b2,b3,c1,c2,c3){
	//saveTableWhenSubmit("loadHidden","tbl_thongTinSanPham");
		document.getElementById(a1 + "Hidden").value = getSelectedValueById(a1);
		document.getElementById(a2 + "Hidden").value = getSelectedValueById(a2);
		document.getElementById(a3 + "Hidden").value = getSelectedValueById(a3);
		document.getElementById(b1 + "Hidden").value = getSelectedValueById(b1);
		document.getElementById(b2 + "Hidden").value = getSelectedValueById(b2);
		document.getElementById(b3 + "Hidden").value = getSelectedValueById(b3);
		document.getElementById(c1 + "Hidden").value = getSelectedValueById(c1);
		document.getElementById(c2 + "Hidden").value = getSelectedValueById(c2);
		document.getElementById(c3 + "Hidden").value = getSelectedValueById(c3);
	 }
	function reloadQuanHuyenTan(a1,a2,a3,b1,b2,b3,c1,c2,c3){
		var tinhThuongTruId1=document.getElementById(a1 + "Hidden").value;
		if(tinhThuongTruId1 != null && tinhThuongTruId1 != "" ){
			reDrawSelectBoxWithId($('#' + a2 + 'Hidden').val(),tinhThuongTruId1,a2);
			reDrawSelectBoxWithId($('#' + a3 + 'Hidden').val(),$('#' + a2 + 'Hidden').val(),a3);
		}
	}
</script>