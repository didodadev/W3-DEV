<cf_date tarih="attributes.accident_date">
<cfquery name="UPD_ACCIDENT" datasource="#dsn#"> 
	UPDATE
		ASSET_P_ACCIDENT
	SET 
		ASSETP_ID = #attributes.assetp_id#,
		EMPLOYEE_ID = #attributes.employee_id#,
		DEPARTMENT_ID = #attributes.department_id#,
		ACCIDENT_DATE = #attributes.accident_date#,
		ACCIDENT_TYPE_ID = #accident_type_id#,
		DOCUMENT_TYPE_ID = <cfif len(attributes.document_type_id)>#attributes.document_type_id#<cfelse>NULL</cfif>,
		DOCUMENT_NUM = <cfif len(attributes.document_num)>'#attributes.document_num#'<cfelse>NULL</cfif>,
		FAULT_RATIO_ID = <cfif len(attributes.fault_ratio_id)>#attributes.fault_ratio_id#<cfelse>NULL</cfif>,
		INSURANCE_PAYMENT = <cfif isDefined("attributes.insurance_payment")>1<cfelse>0</cfif>,
		ACCIDENT_DETAIL = <cfif len(attributes.accident_detail)>'#attributes.accident_detail#'<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'				
	WHERE 
		ACCIDENT_ID = #attributes.accident_id#
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.is_detail")>
		wrk_opener_reload(); 
		self.close();
	<cfelse>
		// window.parent.frame_accident_list.location.reload();
		// window.parent.frame_accident.location.href='<cfoutput>#request.self#?fuseaction=assetcare.popup_add_accident</cfoutput>&iframe=1';
		location.href = document.referrer;
	window.close();
	</cfif>
</script>

