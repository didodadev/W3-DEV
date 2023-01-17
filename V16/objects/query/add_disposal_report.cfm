<!---<cfdump var="#attributes#"> ekleme sayfası --->
<cfquery name="control" datasource="#DSN#">
	SELECT * FROM WASTE_DISPOSAL_RESULT WHERE DISPOSAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.disposal_id#">
</cfquery>
<cfif not control.recordcount>
	<cfquery name="add_disposal" datasource="#dsn#">
		INSERT INTO
			WASTE_DISPOSAL_RESULT
		(
			DISPOSAL_ID,
			DISPOSAL_RESULT,
			DISPOSAL_RESULT_EMP,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		VALUES
		(
			#attributes.disposal_id#,
			'#attributes.result#',
			<cfif isdefined("attributes.to_emp_ids") and len(#attributes.to_emp_ids#)>'#attributes.to_emp_ids#'<cfelse>NULL</cfif>,
			#NOW()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#'
		)
	</cfquery>
<cfelse>
	<!--- <cfset to_emp_ids = control.disposal_result_emp> --->
	<cfif isdefined("attributes.emp_id") and len(attributes.emp_id)>
		<cfset to_emp_ids = ListDeleteDuplicates(LISTAPPEND(attributes.emp_id,','))>
	<cfelse>
		<cfset to_emp_ids = ''>
	</cfif>
	<cfif isdefined("attributes.to_emp_ids") and len(attributes.to_emp_ids)>
		<cfset to_emp_ids = ListDeleteDuplicates(LISTAPPEND(to_emp_ids,attributes.to_emp_ids,','))>
	</cfif>
	<cfquery name="upd_disposal" datasource="#dsn#">
		UPDATE
			WASTE_DISPOSAL_RESULT
		SET
			DISPOSAL_RESULT = <cfif isdefined("attributes.result") and len(attributes.result)>'#attributes.result#'<cfelse>NULL</cfif>,
			DISPOSAL_RESULT_EMP = <cfif isdefined("to_emp_ids") and len(to_emp_ids)>'#to_emp_ids#'<cfelse>NULL</cfif>,
			UPDATE_DATE = #NOW()#,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#'
		WHERE
			DISPOSAL_ID = #attributes.disposal_id#
	</cfquery>
</cfif>
<script type="text/javascript">
	window.close();
</script>

