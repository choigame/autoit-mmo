<!-- TYPEBYTAN String REQUIREDBYTAN -->
<tr>
	<td colspan="6">
		<label class="egov-label" style="word-wrap: break-word;">
			UPPERFIRSTLETTER:
		</label> 
	</td>
</tr>

<tr>
	<td colspan="6">
<% 
	for (String UPPERFIRSTLETTER : hoSo.getUPPERFIRSTLETTER().split("[\\n\\r]+")) {
%>
		<label class="egov-label" style="word-wrap: break-word;">
			<%=UPPERFIRSTLETTER%><br>
		</label> 
<%		
	}
%>
	</td>
</tr>