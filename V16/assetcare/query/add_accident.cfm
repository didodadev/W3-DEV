<cf_date tarih='attributes.accident_date'>
<cfquery name="ADD_ACCIDENT" datasource="#dsn#"> 
	INSERT INTO 
            ASSET_P_ACCIDENT
            (
                ASSETP_ID,
                EMPLOYEE_ID,
                DEPARTMENT_ID,
                ACCIDENT_DATE,
                ACCIDENT_TYPE_ID,
                DOCUMENT_TYPE_ID,
                DOCUMENT_NUM,
                FAULT_RATIO_ID,
                ACCIDENT_DETAIL,
                INSURANCE_PAYMENT,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP			
            ) 
            VALUES 
            (
                #attributes.assetp_id#,
                #attributes.employee_id#,
                #attributes.department_id#,
                #attributes.accident_date#,
                #accident_type_id#,
                <cfif len(attributes.document_type_id)>#attributes.document_type_id#<cfelse>NULL</cfif>,
                <cfif len(attributes.document_num)>'#attributes.document_num#'<cfelse>NULL</cfif>,
                <cfif len(attributes.fault_ratio_id)>#attributes.fault_ratio_id#<cfelse>NULL</cfif>,
                <cfif len(attributes.accident_detail)>'#attributes.accident_detail#'<cfelse>NULL</cfif>,
                0,
                #now()#,
                #session.ep.userid#,
                '#cgi.remote_addr#'			
            )
</cfquery>
<script type="text/javascript">
	<cfif attributes.is_detail neq 1>
      window.close();
        location.href = document.referrer;
     window.parent.frame_accident_list.location.reload();
	 window.parent.frame_accident.location.href='<cfoutput>#request.self#?fuseaction=assetcare.popup_add_accident</cfoutput>&iframe=1';
	<cfelse>
		wrk_opener_reload(); 
		self.close();
        location.href = document.referrer;
	</cfif>
</script>
