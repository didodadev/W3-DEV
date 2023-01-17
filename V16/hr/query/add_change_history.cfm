<cfif isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfquery name="add_change_position" datasource="#dsn#">
	INSERT INTO
		EMPLOYEE_POSITIONS_CHANGE_HISTORY
		(
			EMPLOYEE_ID,
			DEPARTMENT_ID,
			POSITION_ID,
			POSITION_NAME,
			POSITION_CAT_ID,
			TITLE_ID,
			FUNC_ID,
			ORGANIZATION_STEP_ID,
			COLLAR_TYPE,
			UPPER_POSITION_CODE,
			UPPER_POSITION_CODE2,
			START_DATE,
			FINISH_DATE,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
            REASON_ID
		)
		VALUES
		(
			#attributes.employee_id#,
			#attributes.department_id#,
			0,
			<cfif isdefined("attributes.position_name")>'#attributes.position_name#'<cfelse>'#listlast(attributes.position_cat_id,';')#'</cfif>,
			#listfirst(attributes.position_cat_id,';')#,
			#attributes.title_id#,
			<cfif len(attributes.func_id)>#attributes.func_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.organization_step_id)>#attributes.organization_step_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.collar_type)>#attributes.collar_type#<cfelse>NULL</cfif>,
			<cfif len(attributes.upper_position_code) and len(attributes.upper_position)>#attributes.upper_position_code#<cfelse>NULL</cfif>,
			<cfif len(attributes.upper_position_code2) and len(attributes.upper_position2)>#attributes.upper_position_code2#<cfelse>NULL</cfif>,
			#attributes.start_date#,
			<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
			'#cgi.remote_addr#',
            <cfif len(attributes.reason_id)>#attributes.reason_id#<cfelse>NULL</cfif>
		)
</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>
