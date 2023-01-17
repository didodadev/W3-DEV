<cfquery name="UPD_SCENARIO" datasource="#DSN#">
	UPDATE
		SETUP_SCENARIO
	SET
		SCENARIO=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SCENARIO_HEAD#">,
		SCENARIO_DETAIL=<cfif len(attributes.DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DETAIL#">,<cfelse>NULL,</cfif>
		UPDATE_DATE=#NOW()#,
		RECORD_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		UPDATE_EMP=#SESSION.EP.USERID#
	WHERE
		SCENARIO_ID=#attributes.id#
</cfquery>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=budget.list_scenarios&event=upd&id=#attributes.id#</cfoutput>";
</script>
