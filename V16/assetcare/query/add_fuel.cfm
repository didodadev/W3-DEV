<cf_date tarih='attributes.fuel_date'>
<cfquery name="ADD_FUEL" datasource="#dsn#" result="MAX_ID"> 
	INSERT INTO 
	ASSET_P_FUEL
	(
		ASSETP_ID,
		EMPLOYEE_ID,
		DEPARTMENT_ID,
		FUEL_DATE,
		FUEL_COMPANY_ID, 
		FUEL_TYPE_ID,
		FUEL_AMOUNT,
		DOCUMENT_TYPE_ID,
		DOCUMENT_NUM,
		TOTAL_AMOUNT,
		TOTAL_CURRENCY,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	) 
	VALUES 
	(
		<cfif len(attributes.assetp_id)>#attributes.assetp_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
		#attributes.fuel_date#,
		<cfif len(attributes.fuel_comp_id)>#attributes.fuel_comp_id#<cfelse>NULL</cfif>,
		#attributes.fuel_type_id#,
		<cfif len(attributes.fuel_amount)>#attributes.fuel_amount#<cfelse>NULL</cfif>,
		#attributes.document_type_id#,
		<cfif len(attributes.document_num)>'#attributes.document_num#'<cfelse>NULL</cfif>,
		<cfif len(attributes.total_amount)>#attributes.total_amount#<cfelse>0</cfif>,
		<cfif len(attributes.total_currency)>'#attributes.total_currency#'<cfelse>NULL</cfif>,
		#session.ep.userid#,
		'#cgi.remote_addr#',
		#now()#
	)
</cfquery>
<script type="text/javascript">
	 window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=upd_fuel&assetp_id=#attributes.assetp_id#&fuel_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>

