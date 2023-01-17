<cfquery name="ADD_SCENARIO" datasource="#DSN#" result="MAX_ID">
	INSERT
		INTO SETUP_SCENARIO
		(
			SCENARIO,
			SCENARIO_DETAIL,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
		)
		VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SCENARIO_HEAD#">,
			<cfif len(attributes.DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DETAIL#">,<cfelse>NULL,</cfif>
			#NOW()#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			#SESSION.EP.USERID#
		)
</cfquery>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=budget.list_scenarios&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>

	
