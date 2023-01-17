<cfset km_id = #attributes.km_control_id#>
<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cfquery name="UPD_KMS" datasource="#dsn#">
	UPDATE 
		ASSET_P_KM_CONTROL
	SET
		ASSETP_ID = #attributes.assetp_id#,
		EMPLOYEE_ID = #attributes.employee_id#,
		DEPARTMENT_ID = #attributes.department_id#,
		KM_START = <cfif len(attributes.pre_km)>#attributes.pre_km#<cfelse>0</cfif>,
		KM_FINISH = <cfif len(attributes.last_km)>#attributes.last_km#<cfelse>0</cfif>,
		START_DATE = <cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
		FINISH_DATE = <cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
		DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		IS_OFFTIME = <cfif isDefined("attributes.is_offtime")>#attributes.is_offtime#<cfelse>0</cfif>,
		UPDATE_EMP= #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		KM_CONTROL_ID = #km_id#
		
</cfquery>
<script type="text/javascript">
	 window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=upd_km&assetp_id=#attributes.assetp_id#&km_control_id=#attributes.km_control_id#</cfoutput>';
</script>

