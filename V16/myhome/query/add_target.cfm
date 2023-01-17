<cfif isDate(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
<cfif isDate(attributes.finishdate)><cf_date tarih='attributes.finishdate'></cfif>
<cfquery name="ADD_TARGET" datasource="#dsn#">
	INSERT INTO 
		TARGET
		(
			RECORD_EMP,
			RECORD_IP,
			POSITION_CODE,
			DEPARTMENT_ID,
			OUR_COMPANY_ID,
			TARGETCAT_ID,
			STARTDATE,
			FINISHDATE,
			TARGET_HEAD,
			TARGET_NUMBER,
			TARGET_DETAIL,
			TARGET_EMP,
			TARGET_WEIGHT
		)
		VALUES 
		(
			#attributes.record_emp#,
			'#attributes.record_ip#',
			NULL,
			<cfif len(attributes.dept_id)>#attributes.dept_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
			#attributes.targetcat_id#,
			#attributes.startdate#,
			#attributes.finishdate#,
			'#attributes.target_head#',
			<cfif len(attributes.target_number)>#attributes.target_number#<cfelse>NULL</cfif>,
			'#attributes.target_detail#',
			#attributes.target_emp_id#,
			<cfif isdefined('attributes.target_weight') and len(attributes.target_weight)>'#attributes.target_weight#'<cfelse>0</cfif>
		)
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
