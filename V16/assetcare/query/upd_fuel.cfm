<cf_date tarih='attributes.fuel_date'>
<cfquery name="UPD_FUEL" datasource="#dsn#" result="MAX_ID">
	UPDATE 
		ASSET_P_FUEL
	SET
		ASSETP_ID = #attributes.assetp_id#,
		EMPLOYEE_ID = #attributes.employee_id#,
		DEPARTMENT_ID = <cfif len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
		FUEL_DATE = #attributes.fuel_date#,
		FUEL_COMPANY_ID = #fuel_comp_id#,
		FUEL_TYPE_ID = #attributes.fuel_type_id#,
		FUEL_AMOUNT = <cfif len(attributes.fuel_amount)>#attributes.fuel_amount#<cfelse>NULL</cfif>,
		DOCUMENT_TYPE_ID = #attributes.document_type_id#,
		DOCUMENT_NUM = <cfif len(attributes.document_num)>'#attributes.document_num#'<cfelse>NULL</cfif>,
		TOTAL_AMOUNT = <cfif len(attributes.total_amount)>#attributes.total_amount#<cfelse>0</cfif>,
		TOTAL_CURRENCY = <cfif len(attributes.total_currency)>'#attributes.total_currency#'<cfelse>NULL</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#
	WHERE
		FUEL_ID = #attributes.fuel_id#
</cfquery>
<script type="text/javascript">
	 window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=upd_fuel&assetp_id=#attributes.assetp_id#&fuel_id=#attributes.fuel_id#</cfoutput>';
	//  window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.form_search_fuel</cfoutput>';
</script>

