<cfquery name="add" datasource="#dsn2#">
	DELETE FROM FINANCIAL_AUDIT WHERE FINANCIAL_AUDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.audit_id#">
	DELETE FROM FINANCIAL_AUDIT_ROW WHERE FINANCIAL_AUDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.audit_id#">
</cfquery>
<script>
	window.location.href= "<cfoutput>#request.self#?fuseaction=account.financial_audit_table_definition</cfoutput>";
</script>

