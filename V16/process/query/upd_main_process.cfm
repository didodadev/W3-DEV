<cfif isdefined('attributes.action_type') and attributes.action_type eq 1>
	<cfquery name="del_main_process" datasource="#dsn#">
		DELETE FROM PROCESS_MAIN WHERE PROCESS_MAIN_ID = #attributes.process_id#
	</cfquery>
	<cflocation url="#request.self#?fuseaction=process.general_processes&is_submitted=1" addtoken="no">
<cfelse>
	<cfquery name="upd_main_process" datasource="#DSN#">
		UPDATE
			PROCESS_MAIN
		SET
			PROCESS_MAIN_HEADER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_main_header#">,
			PROCESS_MAIN_DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
            PROJECT_ID = <cfif len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id# <cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE
			PROCESS_MAIN_ID = #attributes.process_id#
	</cfquery>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=process.general_processes&event=upd&process_id=#attributes.process_id#</cfoutput>"
	</script>
	
</cfif>
