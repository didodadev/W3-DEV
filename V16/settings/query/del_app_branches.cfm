<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="DEL_SETUP_APP_BRANCHES" datasource="#dsn#">
		DELETE FROM SETUP_APP_BRANCHES WHERE BRANCHES_ID=#branches_id#
	</cfquery>
	</cftransaction>
</cflock>
<script>
	window.location.href = '<cfoutput>index.cfm?fuseaction=settings.list_cv_branches</cfoutput>'
</script>
