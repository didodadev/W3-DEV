
<!--- <cfdump var="#attributes#" abort> --->
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="DEL_SETUP_APP_BRANCHES_ROWS" datasource="#dsn#">
		DELETE FROM SETUP_APP_BRANCHES_ROWS WHERE BRANCHES_ROW_ID=#branches_row_id#
	</cfquery>
	</cftransaction>
</cflock>
<script>
	window.location.href = '<cfoutput>index.cfm?fuseaction=settings.list_cv_branches</cfoutput>'
</script>
