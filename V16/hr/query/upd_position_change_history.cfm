<cfif isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfquery name="upd_change_history" datasource="#dsn#">
	UPDATE	
		EMPLOYEE_POSITIONS_CHANGE_HISTORY
	SET	
		DEPARTMENT_ID = #attributes.department_id#,
		POSITION_NAME =<cfif isdefined("attributes.position_name")> '#attributes.position_name#'<cfelse>'#listlast(attributes.position_cat_id,';')#'</cfif>,
		POSITION_CAT_ID = #listfirst(attributes.position_cat_id,';')#,
		START_DATE = <cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
		FINISH_DATE = <cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
		TITLE_ID = #attributes.title_id#,
		FUNC_ID = <cfif len(attributes.func_id)>#attributes.func_id#<cfelse>NULL</cfif>,
		ORGANIZATION_STEP_ID = <cfif len(attributes.organization_step_id)>#attributes.organization_step_id#<cfelse>NULL</cfif>,
		COLLAR_TYPE = <cfif len(attributes.collar_type)>#attributes.collar_type#<cfelse>NULL</cfif>,
		UPPER_POSITION_CODE = <cfif len(attributes.upper_position_code)>#attributes.upper_position_code#<cfelse>NULL</cfif>,
		UPPER_POSITION_CODE2 = <cfif len(attributes.upper_position_code2)>#attributes.upper_position_code2#<cfelse>NULL</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#',
        REASON_ID = <cfif len(attributes.reason_id)>#attributes.reason_id#<cfelse>NULL</cfif>
	WHERE
		ID = #attributes.id#
</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>
