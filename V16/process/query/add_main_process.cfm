<cfquery name="add_main_process" datasource="#DSN#" result="MAX_ID">
	INSERT INTO
		PROCESS_MAIN
	(
		PROCESS_MAIN_HEADER,
		PROCESS_MAIN_DETAIL,
        PROJECT_ID,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_name#">,
		<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
        <cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">		
	)
</cfquery>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=process.general_processes&event=upd&process_id=#MAX_ID.IDENTITYCOL#</cfoutput>"
</script>
